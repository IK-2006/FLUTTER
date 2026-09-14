import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/cursos_provider.dart';

/// Ponto de partida do aplicativo.
void main() {
  // Garante que o Flutter está pronto antes de rodar código assíncrono.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // MultiProvider disponibiliza os "providers" (estado) para o app todo.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CursosProvider()),
      ],
      child: const CursoStreamApp(),
    ),
  );
}
