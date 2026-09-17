import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'controllers/auth_controller.dart';
import 'controllers/cursos_controller.dart';
import 'services/database_config.dart';

/// Ponto de partida do aplicativo.
void main() {
  // Garante que o Flutter está pronto antes de rodar código assíncrono.
  WidgetsFlutterBinding.ensureInitialized();

  // Configura o banco para funcionar em qualquer plataforma (celular, PC ou web).
  configurarBancoDeDados();

  runApp(
    // MultiProvider disponibiliza os "providers" (estado) para o app todo.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => CursosController()),
      ],
      child: const CursoStreamApp(),
    ),
  );
}
