import 'package:flutter/material.dart';

/// Cores usadas no aplicativo inteiro.
/// Deixar as cores em um só lugar facilita mudar o visual depois.
class AppCores {
  AppCores._(); // impede criar objeto dessa classe

  static const Color primaria = Color(0xFF6C4DF6); // roxo
  static const Color secundaria = Color(0xFF00C2A8); // verde água
  static const Color fundo = Color(0xFF0F0F1A); // fundo escuro (estilo streaming)
  static const Color card = Color(0xFF1B1B2B);
  static const Color texto = Color(0xFFF2F2F7);
  static const Color textoSuave = Color(0xFF9E9EB3);
  static const Color erro = Color(0xFFFF5A5F);
  static const Color sucesso = Color(0xFF2ECC71);
}
