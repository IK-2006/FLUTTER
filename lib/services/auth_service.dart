import 'package:shared_preferences/shared_preferences.dart';

import '../models/usuario.dart';
import '../utils/seguranca.dart';
import 'database_service.dart';

/// Resultado de uma tentativa de login/cadastro.
/// Serve para avisar a tela se deu certo e, se não, qual foi o erro.
class ResultadoAuth {
  final bool sucesso;
  final String? mensagemErro;
  final Usuario? usuario;

  ResultadoAuth.ok(this.usuario) : sucesso = true, mensagemErro = null;
  ResultadoAuth.erro(this.mensagemErro) : sucesso = false, usuario = null;
}

/// Serviço de autenticação: cuida de cadastrar, logar, deslogar
/// e lembrar quem está logado (mesmo depois de fechar o app).
class AuthService {
  final DatabaseService _db = DatabaseService.instancia;

  // chave usada no SharedPreferences para guardar o id do usuário logado
  static const String _chaveUsuarioLogado = 'usuario_logado_id';

  /// Cadastra um novo usuário.
  Future<ResultadoAuth> registrar({
    required String nome,
    required String email,
    required String senha,
    required bool ehInstrutor,
  }) async {
    final emailLimpo = email.trim().toLowerCase();

    // verifica se já existe alguém com esse e-mail
    final existente = await _db.buscarUsuarioPorEmail(emailLimpo);
    if (existente != null) {
      return ResultadoAuth.erro('Já existe uma conta com esse e-mail.');
    }

    final novo = Usuario(
      nome: nome.trim(),
      email: emailLimpo,
      senhaHash: Seguranca.gerarHash(senha),
      ehInstrutor: ehInstrutor,
    );

    final id = await _db.inserirUsuario(novo);
    final usuarioCriado = await _db.buscarUsuarioPorId(id);

    await _salvarSessao(id);
    return ResultadoAuth.ok(usuarioCriado);
  }

  /// Faz login conferindo o e-mail e o hash da senha.
  Future<ResultadoAuth> login({
    required String email,
    required String senha,
  }) async {
    final usuario = await _db.buscarUsuarioPorEmail(email.trim().toLowerCase());
    if (usuario == null) {
      return ResultadoAuth.erro('E-mail não encontrado.');
    }

    if (usuario.senhaHash != Seguranca.gerarHash(senha)) {
      return ResultadoAuth.erro('Senha incorreta.');
    }

    await _salvarSessao(usuario.id!);
    return ResultadoAuth.ok(usuario);
  }

  /// Tenta recuperar o usuário que estava logado antes de fechar o app.
  /// Retorna null se ninguém estava logado.
  Future<Usuario?> usuarioDaSessao() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_chaveUsuarioLogado);
    if (id == null) return null;
    return _db.buscarUsuarioPorId(id);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveUsuarioLogado);
  }

  Future<void> _salvarSessao(int usuarioId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_chaveUsuarioLogado, usuarioId);
  }
}
