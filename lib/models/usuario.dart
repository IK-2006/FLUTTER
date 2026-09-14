/// Modelo que representa um usuário do aplicativo.
/// Cada usuário pode assistir cursos e também publicar os seus.
class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String senhaHash; // guardamos o hash da senha, nunca a senha pura
  final bool ehInstrutor;
  final String? fotoPath; // caminho da foto de perfil (pode ser null)

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senhaHash,
    this.ehInstrutor = false,
    this.fotoPath,
  });

  /// Converte o objeto em um Map para salvar no banco (SQLite).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha_hash': senhaHash,
      'eh_instrutor': ehInstrutor ? 1 : 0, // SQLite não tem boolean, usamos 0/1
      'foto_path': fotoPath,
    };
  }

  /// Cria um objeto Usuario a partir de um Map vindo do banco.
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      email: map['email'] as String,
      senhaHash: map['senha_hash'] as String,
      ehInstrutor: (map['eh_instrutor'] as int) == 1,
      fotoPath: map['foto_path'] as String?,
    );
  }

  /// Cria uma cópia do usuário alterando alguns campos.
  /// Útil, por exemplo, para atualizar só a foto de perfil.
  Usuario copyWith({String? nome, String? fotoPath}) {
    return Usuario(
      id: id,
      nome: nome ?? this.nome,
      email: email,
      senhaHash: senhaHash,
      ehInstrutor: ehInstrutor,
      fotoPath: fotoPath ?? this.fotoPath,
    );
  }
}
