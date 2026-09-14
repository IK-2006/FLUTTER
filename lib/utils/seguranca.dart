import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Função simples para transformar a senha em um "hash".
/// Assim não guardamos a senha original no banco, o que é mais seguro.
class Seguranca {
  Seguranca._();

  static String gerarHash(String senha) {
    final bytes = utf8.encode(senha); // transforma o texto em bytes
    final digest = sha256.convert(bytes); // aplica o algoritmo SHA-256
    return digest.toString();
  }
}
