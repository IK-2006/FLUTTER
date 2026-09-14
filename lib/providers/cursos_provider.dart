import 'package:flutter/foundation.dart';

import '../models/curso.dart';
import '../models/aula.dart';
import '../services/database_service.dart';

/// Provider responsável pela lista de cursos:
/// carregar o catálogo, buscar, publicar um novo curso e matricular o usuário.
class CursosProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService.instancia;

  List<Curso> _catalogo = [];
  List<Curso> _meusCursos = [];
  bool _carregando = false;

  List<Curso> get catalogo => _catalogo;
  List<Curso> get meusCursos => _meusCursos;
  bool get carregando => _carregando;

  /// Carrega o catálogo de cursos (opcionalmente filtrando por [busca]).
  Future<void> carregarCatalogo({String? busca}) async {
    _carregando = true;
    notifyListeners();

    _catalogo = await _db.listarCursos(busca: busca);

    _carregando = false;
    notifyListeners();
  }

  /// Carrega os cursos em que o usuário está matriculado.
  Future<void> carregarMeusCursos(int usuarioId) async {
    _meusCursos = await _db.listarCursosMatriculados(usuarioId);
    notifyListeners();
  }

  /// Busca os detalhes de um curso (com as aulas).
  Future<Curso?> detalhesDoCurso(int cursoId) {
    return _db.buscarCursoPorId(cursoId);
  }

  Future<bool> estaMatriculado(int usuarioId, int cursoId) {
    return _db.estaMatriculado(usuarioId, cursoId);
  }

  /// Matricula o usuário em um curso e atualiza a lista "Meus Cursos".
  Future<void> matricular(int usuarioId, int cursoId) async {
    await _db.matricular(usuarioId, cursoId);
    await carregarMeusCursos(usuarioId);
  }

  /// Publica um novo curso na plataforma e recarrega o catálogo.
  Future<void> publicarCurso({
    required String titulo,
    required String descricao,
    required double preco,
    required String categoria,
    required String thumbnail,
    required int instrutorId,
    required String nomeInstrutor,
    required List<Aula> aulas,
  }) async {
    final curso = Curso(
      titulo: titulo,
      descricao: descricao,
      preco: preco,
      categoria: categoria,
      thumbnail: thumbnail,
      instrutorId: instrutorId,
      nomeInstrutor: nomeInstrutor,
    );

    await _db.inserirCurso(curso, aulas);
    await carregarCatalogo();
  }

  /// Lista os cursos que o próprio usuário publicou (usado na tela de perfil).
  Future<List<Curso>> minhasPublicacoes(int instrutorId) {
    return _db.listarCursosDoInstrutor(instrutorId);
  }
}
