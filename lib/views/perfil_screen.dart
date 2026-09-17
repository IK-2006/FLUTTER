import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/curso.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cursos_controller.dart';
import '../utils/app_cores.dart';
import '../utils/formatadores.dart';
import 'curso_detalhe_screen.dart';
import 'login_screen.dart';

/// Aba "Perfil": dados do usuário, foto de perfil (câmera/galeria),
/// cursos que ele publicou e botão de sair.
class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Future<void> _trocarFoto() async {
    final origem = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tirar foto'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Escolher da galeria'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (origem == null) return;

    final arquivo = await ImagePicker().pickImage(source: origem, imageQuality: 70);
    if (arquivo != null && mounted) {
      await context.read<AuthController>().atualizarPerfil(fotoPath: arquivo.path);
    }
  }

  Future<void> _editarNome() async {
    final usuario = context.read<AuthController>().usuarioAtual!;
    final controller = TextEditingController(text: usuario.nome);

    final novoNome = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar nome'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Nome'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (novoNome != null && novoNome.isNotEmpty && mounted) {
      await context.read<AuthController>().atualizarPerfil(nome: novoNome);
    }
  }

  Future<void> _sair() async {
    await context.read<AuthController>().logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (rota) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthController>().usuarioAtual!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Foto de perfil
        Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppCores.card,
                backgroundImage: usuario.fotoPath != null
                    ? FileImage(File(usuario.fotoPath!))
                    : null,
                child: usuario.fotoPath == null
                    ? const Icon(Icons.person, size: 50, color: AppCores.textoSuave)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _trocarFoto,
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppCores.primaria,
                    child: Icon(Icons.camera_alt, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(usuario.nome,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Center(
          child: Text(usuario.email,
              style: const TextStyle(color: AppCores.textoSuave)),
        ),
        if (usuario.ehInstrutor)
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Chip(
                label: Text('Instrutor'),
                backgroundColor: AppCores.primaria,
              ),
            ),
          ),
        const SizedBox(height: 16),

        OutlinedButton.icon(
          onPressed: _editarNome,
          icon: const Icon(Icons.edit),
          label: const Text('Editar nome'),
        ),
        const Divider(height: 32),

        const Text('Meus cursos publicados',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _minhasPublicacoes(usuario.id!),

        const Divider(height: 32),
        ElevatedButton.icon(
          onPressed: _sair,
          icon: const Icon(Icons.logout),
          label: const Text('Sair da conta'),
          style: ElevatedButton.styleFrom(backgroundColor: AppCores.erro),
        ),
      ],
    );
  }

  /// Busca e mostra os cursos publicados pelo usuário.
  Widget _minhasPublicacoes(int instrutorId) {
    return FutureBuilder<List<Curso>>(
      future: context.read<CursosController>().minhasPublicacoes(instrutorId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final cursos = snapshot.data ?? [];
        if (cursos.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Você ainda não publicou nenhum curso.',
              style: TextStyle(color: AppCores.textoSuave),
            ),
          );
        }

        // Column simples porque estamos dentro de um ListView
        return Column(
          children: cursos.map((curso) {
            return Card(
              child: ListTile(
                title: Text(curso.titulo),
                subtitle: Text(curso.ehGratuito
                    ? 'Grátis'
                    : Formatadores.preco(curso.preco)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CursoDetalheScreen(cursoId: curso.id!),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
