import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/curso.dart';
import '../models/aula.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cursos_controller.dart';
import '../utils/app_cores.dart';
import '../utils/formatadores.dart';
import '../widgets/imagem_curso.dart';
import 'player_screen.dart';

/// Tela de detalhes de um curso.
/// Mostra as informações, a lista de aulas e o botão de matrícula/compra.
/// Se o usuário já tiver acesso, ele pode assistir as aulas.
class CursoDetalheScreen extends StatefulWidget {
  final int cursoId;

  const CursoDetalheScreen({super.key, required this.cursoId});

  @override
  State<CursoDetalheScreen> createState() => _CursoDetalheScreenState();
}

class _CursoDetalheScreenState extends State<CursoDetalheScreen> {
  Curso? _curso;
  bool _carregando = true;
  bool _temAcesso = false; // matriculado OU dono do curso
  bool _ehDono = false;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final cursosProvider = context.read<CursosController>();
    final usuario = context.read<AuthController>().usuarioAtual!;

    final curso = await cursosProvider.detalhesDoCurso(widget.cursoId);
    final matriculado =
        await cursosProvider.estaMatriculado(usuario.id!, widget.cursoId);

    if (!mounted) return;
    setState(() {
      _curso = curso;
      _ehDono = curso?.instrutorId == usuario.id;
      _temAcesso = matriculado || _ehDono;
      _carregando = false;
    });
  }

  /// Confirma e realiza a matrícula/compra do curso.
  Future<void> _matricular() async {
    final curso = _curso!;
    final usuario = context.read<AuthController>().usuarioAtual!;

    // pergunta de confirmação (Dialog)
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar matrícula'),
        content: Text(
          curso.ehGratuito
              ? 'Deseja se matricular gratuitamente em "${curso.titulo}"?'
              : 'Deseja comprar o curso "${curso.titulo}" por '
                  '${Formatadores.preco(curso.preco)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;
    if (!mounted) return; // garante que a tela ainda existe após o diálogo

    await context
        .read<CursosController>()
        .matricular(usuario.id!, curso.id!);

    if (!mounted) return;
    setState(() => _temAcesso = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Matrícula realizada! Bons estudos.'),
        backgroundColor: AppCores.sucesso,
      ),
    );
  }

  /// Compartilha o curso usando o recurso de compartilhamento do celular.
  void _compartilhar() {
    final curso = _curso!;
    Share.share(
      'Estou usando o CursoStream! Dá uma olhada no curso "${curso.titulo}" '
      'com ${curso.nomeInstrutor}.',
      subject: curso.titulo,
    );
  }

  void _abrirAula(Aula aula) {
    if (!_temAcesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Matricule-se para assistir as aulas.')),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlayerScreen(aula: aula),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_curso == null) {
      return const Scaffold(
        body: Center(child: Text('Curso não encontrado.')),
      );
    }

    final curso = _curso!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _compartilhar,
          ),
        ],
      ),
      body: ListView(
        children: [
          ImagemCurso(caminho: curso.thumbnail, altura: 200, largura: double.infinity),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(curso.titulo,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: AppCores.textoSuave),
                    const SizedBox(width: 4),
                    Text(curso.nomeInstrutor,
                        style: const TextStyle(color: AppCores.textoSuave)),
                    const SizedBox(width: 12),
                    const Icon(Icons.category,
                        size: 16, color: AppCores.textoSuave),
                    const SizedBox(width: 4),
                    Text(curso.categoria,
                        style: const TextStyle(color: AppCores.textoSuave)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  curso.ehGratuito ? 'Grátis' : Formatadores.preco(curso.preco),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: curso.ehGratuito
                        ? AppCores.sucesso
                        : AppCores.secundaria,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Sobre o curso',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(curso.descricao,
                    style: const TextStyle(color: AppCores.textoSuave, height: 1.4)),
                const SizedBox(height: 20),

                _botaoAcao(curso),

                const SizedBox(height: 24),
                Text('Conteúdo (${curso.aulas.length} aulas)',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...curso.aulas.map((aula) => _itemAula(aula)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _botaoAcao(Curso curso) {
    if (_ehDono) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppCores.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Você é o instrutor deste curso',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    if (_temAcesso) {
      return ElevatedButton.icon(
        onPressed: () {
          if (curso.aulas.isNotEmpty) _abrirAula(curso.aulas.first);
        },
        icon: const Icon(Icons.play_arrow),
        label: const Text('Assistir agora'),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: _matricular,
      icon: const Icon(Icons.shopping_cart),
      label: Text(curso.ehGratuito ? 'Matricular grátis' : 'Comprar curso'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
      ),
    );
  }

  Widget _itemAula(Aula aula) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppCores.primaria,
          child: Text('${aula.ordem}',
              style: const TextStyle(color: Colors.white)),
        ),
        title: Text(aula.titulo),
        trailing: Icon(
          _temAcesso ? Icons.play_circle_fill : Icons.lock,
          color: _temAcesso ? AppCores.primaria : AppCores.textoSuave,
        ),
        onTap: () => _abrirAula(aula),
      ),
    );
  }
}
