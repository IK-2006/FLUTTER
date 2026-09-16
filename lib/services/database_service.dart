import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../models/usuario.dart';
import '../models/curso.dart';
import '../models/aula.dart';
import 'seed_dados.dart';

/// Serviço responsável por TODO o acesso ao banco de dados local (SQLite).
///
/// Usei o padrão "singleton": existe apenas uma instância dessa classe no app
/// inteiro (DatabaseService.instancia). Assim o banco é aberto uma vez só.
class DatabaseService {
  DatabaseService._privado();
  static final DatabaseService instancia = DatabaseService._privado();

  Database? _db;

  /// Retorna o banco já aberto. Se ainda não estiver aberto, abre.
  Future<Database> get database async {
    _db ??= await _abrirBanco();
    return _db!;
  }

  Future<Database> _abrirBanco() async {
    final caminhoPasta = await getDatabasesPath();
    final caminho = p.join(caminhoPasta, 'curso_stream.db');

    return openDatabase(
      caminho,
      version: 2,
      onCreate: _criarTabelas,
      onUpgrade: _aoAtualizar,
    );
  }

  /// Roda quando a versão do banco aumenta. Aqui recriamos as tabelas para
  /// aplicar correções nos dados iniciais (por exemplo, novos links de vídeo).
  Future<void> _aoAtualizar(Database db, int versaoAntiga, int versaoNova) async {
    await db.execute('DROP TABLE IF EXISTS matriculas');
    await db.execute('DROP TABLE IF EXISTS aulas');
    await db.execute('DROP TABLE IF EXISTS cursos');
    await db.execute('DROP TABLE IF EXISTS usuarios');
    await _criarTabelas(db, versaoNova);
  }

  /// Cria as tabelas na primeira vez e insere os dados iniciais (seed).
  Future<void> _criarTabelas(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        senha_hash TEXT NOT NULL,
        eh_instrutor INTEGER NOT NULL DEFAULT 0,
        foto_path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cursos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        preco REAL NOT NULL,
        categoria TEXT NOT NULL,
        thumbnail TEXT NOT NULL,
        instrutor_id INTEGER NOT NULL,
        nome_instrutor TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE aulas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        curso_id INTEGER NOT NULL,
        titulo TEXT NOT NULL,
        video_url TEXT NOT NULL,
        ordem INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE matriculas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        curso_id INTEGER NOT NULL,
        data_compra TEXT NOT NULL
      )
    ''');

    await _inserirDadosIniciais(db);
  }

  /// Insere o instrutor de exemplo e os cursos de demonstração.
  Future<void> _inserirDadosIniciais(Database db) async {
    final instrutorId = await db.insert('usuarios', SeedDados.instrutorDemo());

    for (final curso in SeedDados.cursosDemo(instrutorId)) {
      // separamos as aulas do resto dos dados do curso.
      // usamos "as List" (sem tipar o Map) para evitar erro de conversão.
      final aulas = curso['aulas'] as List;
      final dadosCurso = Map<String, dynamic>.from(curso)..remove('aulas');

      final cursoId = await db.insert('cursos', dadosCurso);

      // insere cada aula do curso, guardando a ordem (1, 2, 3...)
      for (int i = 0; i < aulas.length; i++) {
        final aula = aulas[i] as Map;
        await db.insert('aulas', {
          'curso_id': cursoId,
          'titulo': aula['titulo'],
          'video_url': aula['video_url'],
          'ordem': i + 1,
        });
      }
    }
  }

  // ==================== USUÁRIOS ====================

  Future<int> inserirUsuario(Usuario usuario) async {
    final db = await database;
    return db.insert('usuarios', usuario.toMap());
  }

  Future<Usuario?> buscarUsuarioPorEmail(String email) async {
    final db = await database;
    final resultado = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (resultado.isEmpty) return null;
    return Usuario.fromMap(resultado.first);
  }

  Future<Usuario?> buscarUsuarioPorId(int id) async {
    final db = await database;
    final resultado = await db.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (resultado.isEmpty) return null;
    return Usuario.fromMap(resultado.first);
  }

  Future<void> atualizarUsuario(Usuario usuario) async {
    final db = await database;
    await db.update(
      'usuarios',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  // ==================== CURSOS ====================

  /// Insere um curso e depois todas as suas aulas. Retorna o id do curso.
  Future<int> inserirCurso(Curso curso, List<Aula> aulas) async {
    final db = await database;
    final cursoId = await db.insert('cursos', curso.toMap());

    for (int i = 0; i < aulas.length; i++) {
      final aula = aulas[i];
      await db.insert('aulas', {
        'curso_id': cursoId,
        'titulo': aula.titulo,
        'video_url': aula.videoUrl,
        'ordem': i + 1,
      });
    }
    return cursoId;
  }

  /// Lista todos os cursos. Se [busca] for informado, filtra pelo título.
  Future<List<Curso>> listarCursos({String? busca}) async {
    final db = await database;
    final List<Map<String, dynamic>> resultado;

    if (busca != null && busca.trim().isNotEmpty) {
      resultado = await db.query(
        'cursos',
        where: 'titulo LIKE ?',
        whereArgs: ['%${busca.trim()}%'],
        orderBy: 'id DESC',
      );
    } else {
      resultado = await db.query('cursos', orderBy: 'id DESC');
    }

    return resultado.map((linha) => Curso.fromMap(linha)).toList();
  }

  /// Lista os cursos publicados por um instrutor específico.
  Future<List<Curso>> listarCursosDoInstrutor(int instrutorId) async {
    final db = await database;
    final resultado = await db.query(
      'cursos',
      where: 'instrutor_id = ?',
      whereArgs: [instrutorId],
      orderBy: 'id DESC',
    );
    return resultado.map((linha) => Curso.fromMap(linha)).toList();
  }

  /// Busca um curso pelo id, já trazendo a lista de aulas.
  Future<Curso?> buscarCursoPorId(int id) async {
    final db = await database;
    final resultado = await db.query(
      'cursos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (resultado.isEmpty) return null;

    final aulas = await listarAulasDoCurso(id);
    return Curso.fromMap(resultado.first, aulas: aulas);
  }

  // ==================== AULAS ====================

  Future<List<Aula>> listarAulasDoCurso(int cursoId) async {
    final db = await database;
    final resultado = await db.query(
      'aulas',
      where: 'curso_id = ?',
      whereArgs: [cursoId],
      orderBy: 'ordem ASC',
    );
    return resultado.map((linha) => Aula.fromMap(linha)).toList();
  }

  // ==================== MATRÍCULAS ====================

  Future<void> matricular(int usuarioId, int cursoId) async {
    final db = await database;
    await db.insert('matriculas', {
      'usuario_id': usuarioId,
      'curso_id': cursoId,
      'data_compra': DateTime.now().toIso8601String(),
    });
  }

  /// Verifica se o usuário já está matriculado em um curso.
  Future<bool> estaMatriculado(int usuarioId, int cursoId) async {
    final db = await database;
    final resultado = await db.query(
      'matriculas',
      where: 'usuario_id = ? AND curso_id = ?',
      whereArgs: [usuarioId, cursoId],
      limit: 1,
    );
    return resultado.isNotEmpty;
  }

  /// Retorna a lista de cursos em que o usuário está matriculado.
  Future<List<Curso>> listarCursosMatriculados(int usuarioId) async {
    final db = await database;
    // usamos um INNER JOIN para pegar os cursos ligados às matrículas do usuário
    final resultado = await db.rawQuery('''
      SELECT c.* FROM cursos c
      INNER JOIN matriculas m ON m.curso_id = c.id
      WHERE m.usuario_id = ?
      ORDER BY m.id DESC
    ''', [usuarioId]);

    return resultado.map((linha) => Curso.fromMap(linha)).toList();
  }
}
