import 'aula.dart';

/// Modelo que representa um curso publicado na plataforma.
class Curso {
  final int? id;
  final String titulo;
  final String descricao;
  final double preco;
  final String categoria;
  final String thumbnail; // pode ser uma URL (http...) ou o caminho de uma imagem local
  final int instrutorId; // id do usuário que publicou o curso
  final String nomeInstrutor;

  /// Lista de aulas do curso. Nem sempre é carregada (às vezes só queremos o card),
  /// por isso ela começa vazia por padrão.
  final List<Aula> aulas;

  Curso({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.preco,
    required this.categoria,
    required this.thumbnail,
    required this.instrutorId,
    required this.nomeInstrutor,
    this.aulas = const [],
  });

  /// Curso gratuito quando o preço é zero.
  bool get ehGratuito => preco == 0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'preco': preco,
      'categoria': categoria,
      'thumbnail': thumbnail,
      'instrutor_id': instrutorId,
      'nome_instrutor': nomeInstrutor,
    };
  }

  factory Curso.fromMap(Map<String, dynamic> map, {List<Aula> aulas = const []}) {
    return Curso(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      preco: (map['preco'] as num).toDouble(),
      categoria: map['categoria'] as String,
      thumbnail: map['thumbnail'] as String,
      instrutorId: map['instrutor_id'] as int,
      nomeInstrutor: map['nome_instrutor'] as String,
      aulas: aulas,
    );
  }

  Curso copyWith({List<Aula>? aulas}) {
    return Curso(
      id: id,
      titulo: titulo,
      descricao: descricao,
      preco: preco,
      categoria: categoria,
      thumbnail: thumbnail,
      instrutorId: instrutorId,
      nomeInstrutor: nomeInstrutor,
      aulas: aulas ?? this.aulas,
    );
  }
}
