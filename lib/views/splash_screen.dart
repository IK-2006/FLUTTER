import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../utils/app_cores.dart';
import 'home_screen.dart';
import 'login_screen.dart';

/// Tela de abertura (Splash).
/// Enquanto ela aparece, o app verifica se já existe um usuário logado
/// e decide para qual tela ir: Home (se logado) ou Login (se não).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    final auth = context.read<AuthController>();

    // tenta recuperar a sessão salva (usuário que já estava logado)
    await auth.recuperarSessao();

    // pequena pausa só para a splash não "piscar" rápido demais
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    // decide a próxima tela
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            auth.estaLogado ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppCores.primaria,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.play_circle_fill,
                  size: 64, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              'CursoStream',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Seus cursos, onde você estiver',
              style: TextStyle(color: AppCores.textoSuave),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
