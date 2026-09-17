import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../controllers/cursos_controller.dart';
import '../utils/app_cores.dart';
import '../widgets/estado_vazio.dart';
import '../widgets/imagem_curso.dart';
import 'curso_detalhe_screen.dart';

/// Aba "Meus Cursos": lista os cursos em que o usuário está matriculado.
class MeusCursosScreen extends StatefulWidget {
  const MeusCursosScreen({super.key});

  @override
  State<MeusCursosScreen> createState() => _MeusCursosScreenState();
}

class _MeusCursosScreenState extends State<MeusCursosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _carregar());
  }

  void _carregar() {
    final usuario = context.read<AuthController>().usuarioAtual;
    if (usuario != null) {
      context.read<CursosController>().carregarMeusCursos(usuario.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final meusCursos = context.watch<CursosController>().meusCursos;

    if (meusCursos.isEmpty) {
      return const EstadoVazio(
        icone: Icons.video_library_outlined,
        titulo: 'Você ainda não tem cursos',
        descricao: 'Matricule-se em um curso na aba Explorar para vê-lo aqui.',
      );
    }

    // RefreshIndicator permite "puxar para atualizar" a lista
    return RefreshIndicator(
      onRefresh: () async => _carregar(),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: meusCursos.length,
        itemBuilder: (context, indice) {
          final curso = meusCursos[indice];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              contentPadding: const EdgeInsets.all(8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ImagemCurso(
                  caminho: curso.thumbnail,
                  altura: 56,
                  largura: 56,
                ),
              ),
              title: Text(
                curso.titulo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                curso.nomeInstrutor,
                style: const TextStyle(color: AppCores.textoSuave),
              ),
              trailing: const Icon(Icons.play_circle_fill,
                  color: AppCores.primaria),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CursoDetalheScreen(cursoId: curso.id!),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
