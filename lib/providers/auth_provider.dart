import 'package:flutter/foundation.dart';

import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

/// Provider (gerenciamento de estado) responsável pelo usuário logado.
///
/// Qualquer tela pode "ouvir" este provider para saber quem está logado
/// e reagir quando o usuário entra ou sai da conta.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final DatabaseService _db = DatabaseService.instancia;

  Usuario? _usuarioAtual;
  bool _carregando = false;

  Usuario? get usuarioAtual => _usuarioAtual;
  bool get carregando => _carregando;
  bool get estaLogado => _usuarioAtual != null;

  /// Chamado quando o app abre, para ver se já tinha alguém logado.
  Future<void> recuperarSessao() async {
    _usuarioAtual = await _authService.usuarioDaSessao();
    notifyListeners();
  }

  Future<ResultadoAuth> login(String email, String senha) async {
    _setCarregando(true);
    final resultado = await _authService.login(email: email, senha: senha);
    if (resultado.sucesso) {
      _usuarioAtual = resultado.usuario;
    }
    _setCarregando(false);
    return resultado;
  }

  Future<ResultadoAuth> registrar({
    required String nome,
    required String email,
    required String senha,
    required bool ehInstrutor,
  }) async {
    _setCarregando(true);
    final resultado = await _authService.registrar(
      nome: nome,
      email: email,
      senha: senha,
      ehInstrutor: ehInstrutor,
    );
    if (resultado.sucesso) {
      _usuarioAtual = resultado.usuario;
    }
    _setCarregando(false);
    return resultado;
  }

  Future<void> logout() async {
    await _authService.logout();
    _usuarioAtual = null;
    notifyListeners();
  }

  /// Atualiza o nome e/ou a foto de perfil do usuário logado.
  Future<void> atualizarPerfil({String? nome, String? fotoPath}) async {
    if (_usuarioAtual == null) return;

    final atualizado = _usuarioAtual!.copyWith(nome: nome, fotoPath: fotoPath);
    await _db.atualizarUsuario(atualizado);
    _usuarioAtual = atualizado;
    notifyListeners();
  }

  void _setCarregando(bool valor) {
    _carregando = valor;
    notifyListeners();
  }
}
