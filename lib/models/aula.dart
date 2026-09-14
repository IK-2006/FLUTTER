/// Modelo que representa uma aula (um vídeo) dentro de um curso.
class Aula {
  final int? id;
  final int cursoId; // a qual curso essa aula pertence
  final String titulo;
  final String videoUrl; // link do vídeo que será transmitido (streaming)
  final int ordem; // posição da aula na lista (1, 2, 3...)

  Aula({
    this.id,
    required this.cursoId,
    required this.titulo,
    required this.videoUrl,
    required this.ordem,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'curso_id': cursoId,
      'titulo': titulo,
      'video_url': videoUrl,
      'ordem': ordem,
    };
  }

  factory Aula.fromMap(Map<String, dynamic> map) {
    return Aula(
      id: map['id'] as int?,
      cursoId: map['curso_id'] as int,
      titulo: map['titulo'] as String,
      videoUrl: map['video_url'] as String,
      ordem: map['ordem'] as int,
    );
  }
}
