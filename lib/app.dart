import 'package:flutter/material.dart';

import 'views/splash_screen.dart';
import 'utils/app_tema.dart';

/// Widget principal do aplicativo.
/// Define o título, o tema e a primeira tela (Splash).
class CursoStreamApp extends StatelessWidget {
  const CursoStreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CursoStream',
      debugShowCheckedModeBanner: false, // esconde a faixa "debug" no canto
      theme: AppTema.temaEscuro,
      home: const SplashScreen(),
    );
  }
}
