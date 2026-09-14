import 'package:flutter/material.dart';
import 'app_cores.dart';

/// Tema visual do aplicativo (cores, fontes, estilo dos botões...).
/// Usei um tema escuro porque combina com a ideia de streaming.
class AppTema {
  AppTema._();

  static ThemeData get temaEscuro {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppCores.fundo,
      colorScheme: const ColorScheme.dark(
        primary: AppCores.primaria,
        secondary: AppCores.secundaria,
        surface: AppCores.card,
        error: AppCores.erro,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppCores.fundo,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppCores.texto,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppCores.card,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppCores.primaria,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppCores.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: AppCores.textoSuave),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppCores.card,
        selectedItemColor: AppCores.primaria,
        unselectedItemColor: AppCores.textoSuave,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
