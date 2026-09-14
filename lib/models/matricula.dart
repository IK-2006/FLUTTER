/// Modelo que representa uma matrícula (quando um usuário compra/adquire um curso).
/// É isso que libera o usuário para assistir as aulas.
class Matricula {
  final int? id;
  final int usuarioId;
  final int cursoId;
  final DateTime dataCompra;

  Matricula({
    this.id,
    required this.usuarioId,
    required this.cursoId,
    required this.dataCompra,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'curso_id': cursoId,
      // guardamos a data como texto no padrão ISO para não ter problema no banco
      'data_compra': dataCompra.toIso8601String(),
    };
  }

  factory Matricula.fromMap(Map<String, dynamic> map) {
    return Matricula(
      id: map['id'] as int?,
      usuarioId: map['usuario_id'] as int,
      cursoId: map['curso_id'] as int,
      dataCompra: DateTime.parse(map['data_compra'] as String),
    );
  }
}
