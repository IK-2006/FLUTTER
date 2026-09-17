import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../utils/app_cores.dart';
import 'explorar_screen.dart';
import 'meus_cursos_screen.dart';
import 'publicar_curso_screen.dart';
import 'perfil_screen.dart';
import 'login_screen.dart';

/// Tela principal depois do login.
/// Contém o Scaffold com AppBar, Drawer (menu lateral) e
/// BottomNavigationBar (menu inferior) para trocar entre as abas.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indiceAtual = 0;

  // as quatro telas (abas) do menu inferior
  final List<Widget> _telas = const [
    ExplorarScreen(),
    MeusCursosScreen(),
    PublicarCursoScreen(),
    PerfilScreen(),
  ];

  // títulos que aparecem na AppBar de cada aba
  final List<String> _titulos = const [
    'Explorar',
    'Meus Cursos',
    'Publicar Curso',
    'Perfil',
  ];

  Future<void> _sair() async {
    await context.read<AuthController>().logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (rota) => false,
    );
  }

  void _mostrarSobre() {
    showAboutDialog(
      context: context,
      applicationName: 'CursoStream',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.play_circle_fill,
          color: AppCores.primaria, size: 40),
      children: const [
        Text(
          'Plataforma mobile para vender e assistir cursos online, '
          'no estilo streaming.\n\nTrabalho Final - Desenvolvimento Mobile III.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthController>().usuarioAtual;

    return Scaffold(
      appBar: AppBar(title: Text(_titulos[_indiceAtual])),

      // Menu lateral (Drawer)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppCores.primaria),
              accountName: Text(usuario?.nome ?? ''),
              accountEmail: Text(usuario?.email ?? ''),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: AppCores.primaria, size: 32),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.explore),
              title: const Text('Explorar cursos'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _indiceAtual = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Meus cursos'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _indiceAtual = 1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text('Publicar curso'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _indiceAtual = 2);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Sobre o app'),
              onTap: () {
                Navigator.pop(context);
                _mostrarSobre();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: AppCores.erro),
              title: const Text('Sair', style: TextStyle(color: AppCores.erro)),
              onTap: _sair,
            ),
          ],
        ),
      ),

      // troca a tela conforme a aba selecionada
      body: _telas[_indiceAtual],

      // Menu inferior (BottomNavigationBar)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (indice) => setState(() => _indiceAtual = indice),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.explore), label: 'Explorar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_library), label: 'Meus Cursos'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Publicar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
