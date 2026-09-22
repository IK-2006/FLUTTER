import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/aula.dart';
import '../models/curso.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cursos_controller.dart';
import '../utils/app_cores.dart';
import '../widgets/imagem_curso.dart';

/// Formulário para criar OU editar um curso.
///
/// - Quando usada como aba (sem [cursoParaEditar]), funciona no modo "criar".
/// - Quando aberta com um [cursoParaEditar], funciona no modo "editar":
///   o formulário já vem preenchido e o botão salva as alterações.
///
/// Aqui usamos o recurso do dispositivo (câmera/galeria) para a capa do curso.
class PublicarCursoScreen extends StatefulWidget {
  /// Se vier um curso, a tela abre em modo edição. Se for null, é criação.
  final Curso? cursoParaEditar;

  const PublicarCursoScreen({super.key, this.cursoParaEditar});

  @override
  State<PublicarCursoScreen> createState() => _PublicarCursoScreenState();
}

class _PublicarCursoScreenState extends State<PublicarCursoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();

  String _categoria = 'Programação';
  final List<String> _categorias = const [
    'Programação',
    'Design',
    'Marketing',
    'Negócios',
    'Idiomas',
    'Outros',
  ];

  // caminho da foto de capa escolhida no celular (null = ainda não escolheu)
  String? _capaPath;
  // capa que o curso já tinha (usada no modo edição, pode ser URL ou arquivo)
  String? _capaExistente;

  // controllers das aulas (cada aula tem título e URL do vídeo)
  final List<_ControllersAula> _aulas = [_ControllersAula()];

  /// true quando estamos editando um curso já existente.
  bool get _editando => widget.cursoParaEditar != null;

  @override
  void initState() {
    super.initState();
    // no modo edição, preenchemos o formulário com os dados do curso
    final curso = widget.cursoParaEditar;
    if (curso != null) {
      _tituloController.text = curso.titulo;
      _descricaoController.text = curso.descricao;
      _precoController.text =
          curso.preco == 0 ? '0' : curso.preco.toStringAsFixed(2);
      _categoria =
          _categorias.contains(curso.categoria) ? curso.categoria : 'Outros';
      _capaExistente = curso.thumbnail;

      // troca as aulas iniciais pelas aulas reais do curso
      for (final aula in _aulas) {
        aula.dispose();
      }
      _aulas.clear();
      for (final aula in curso.aulas) {
        final c = _ControllersAula();
        c.titulo.text = aula.titulo;
        c.url.text = aula.videoUrl;
        _aulas.add(c);
      }
      if (_aulas.isEmpty) _aulas.add(_ControllersAula());
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _precoController.dispose();
    for (final aula in _aulas) {
      aula.dispose();
    }
    super.dispose();
  }

  /// Abre um menu para escolher a capa da câmera ou da galeria.
  Future<void> _escolherCapa() async {
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

    final picker = ImagePicker();
    final arquivo = await picker.pickImage(source: origem, imageQuality: 70);
    if (arquivo != null) {
      setState(() => _capaPath = arquivo.path);
    }
  }

  void _adicionarAula() {
    setState(() => _aulas.add(_ControllersAula()));
  }

  void _removerAula(int indice) {
    setState(() {
      _aulas[indice].dispose();
      _aulas.removeAt(indice);
    });
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final usuario = context.read<AuthController>().usuarioAtual!;

    // monta a lista de aulas a partir dos controllers
    final aulas = <Aula>[];
    for (int i = 0; i < _aulas.length; i++) {
      aulas.add(Aula(
        cursoId: widget.cursoParaEditar?.id ?? 0,
        titulo: _aulas[i].titulo.text.trim(),
        videoUrl: _aulas[i].url.text.trim(),
        ordem: i + 1,
      ));
    }

    // capa: a nova escolhida, ou a que já existia, ou uma imagem da internet
    final capa = _capaPath ??
        _capaExistente ??
        'https://picsum.photos/seed/${Uri.encodeComponent(_tituloController.text)}/600/360';

    // troca vírgula por ponto para aceitar "49,90" e "49.90"
    final preco =
        double.tryParse(_precoController.text.replaceAll(',', '.')) ?? 0.0;

    final controller = context.read<CursosController>();

    if (_editando) {
      // MODO EDITAR: atualiza o curso existente
      final cursoAtualizado = Curso(
        id: widget.cursoParaEditar!.id,
        titulo: _tituloController.text.trim(),
        descricao: _descricaoController.text.trim(),
        preco: preco,
        categoria: _categoria,
        thumbnail: capa,
        instrutorId: widget.cursoParaEditar!.instrutorId,
        nomeInstrutor: widget.cursoParaEditar!.nomeInstrutor,
      );

      await controller.editarCurso(
        curso: cursoAtualizado,
        aulas: aulas,
        usuarioId: usuario.id!,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Curso atualizado!'),
          backgroundColor: AppCores.sucesso,
        ),
      );
      Navigator.of(context).pop(true); // volta para a tela de detalhes
    } else {
      // MODO CRIAR: publica um curso novo
      await controller.publicarCurso(
        titulo: _tituloController.text.trim(),
        descricao: _descricaoController.text.trim(),
        preco: preco,
        categoria: _categoria,
        thumbnail: capa,
        instrutorId: usuario.id!,
        nomeInstrutor: usuario.nome,
        aulas: aulas,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Curso publicado com sucesso!'),
          backgroundColor: AppCores.sucesso,
        ),
      );
      _limparFormulario();
    }
  }

  void _limparFormulario() {
    _tituloController.clear();
    _descricaoController.clear();
    _precoController.clear();
    setState(() {
      _capaPath = null;
      _categoria = 'Programação';
      for (final aula in _aulas) {
        aula.dispose();
      }
      _aulas
        ..clear()
        ..add(_ControllersAula());
    });
  }

  @override
  Widget build(BuildContext context) {
    final formulario = SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _construirCapa(),
            const SizedBox(height: 16),

            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título do curso'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Informe o título' : null,
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _descricaoController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Descrição'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Informe a descrição' : null,
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                // Preço
                Expanded(
                  child: TextFormField(
                    controller: _precoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Preço (R\$)',
                      hintText: '0 = grátis',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Informe o preço';
                      final n = double.tryParse(v.replaceAll(',', '.'));
                      if (n == null || n < 0) return 'Preço inválido';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Categoria
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _categoria,
                    decoration: const InputDecoration(labelText: 'Categoria'),
                    items: _categorias
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (valor) =>
                        setState(() => _categoria = valor!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Lista de aulas
            const Text('Aulas do curso',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._construirCamposAulas(),

            OutlinedButton.icon(
              onPressed: _adicionarAula,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar aula'),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _salvar,
              icon: Icon(_editando ? Icons.save : Icons.publish),
              label: Text(_editando ? 'Salvar alterações' : 'Publicar curso'),
            ),
          ],
        ),
      ),
    );

    // No modo criar, a tela é uma aba (o Scaffold vem da Home).
    // No modo editar, ela é aberta como tela própria, então tem seu Scaffold.
    if (!_editando) return formulario;
    return Scaffold(
      appBar: AppBar(title: const Text('Editar curso')),
      body: formulario,
    );
  }

  /// Área da capa: mostra a nova imagem, a capa atual ou o "toque para adicionar".
  Widget _construirCapa() {
    Widget conteudo;

    if (_capaPath != null) {
      // imagem nova escolhida do aparelho
      conteudo = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(_capaPath!),
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } else if (_capaExistente != null) {
      // capa que o curso já tinha (URL ou arquivo)
      conteudo = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ImagemCurso(
          caminho: _capaExistente!,
          altura: 160,
          largura: double.infinity,
        ),
      );
    } else {
      // sem capa ainda
      conteudo = Container(
        height: 160,
        decoration: BoxDecoration(
          color: AppCores.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, size: 40, color: AppCores.textoSuave),
            SizedBox(height: 8),
            Text('Toque para adicionar a capa',
                style: TextStyle(color: AppCores.textoSuave)),
          ],
        ),
      );
    }

    return GestureDetector(onTap: _escolherCapa, child: conteudo);
  }

  List<Widget> _construirCamposAulas() {
    return List.generate(_aulas.length, (i) {
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Aula ${i + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  if (_aulas.length > 1)
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: AppCores.erro),
                      onPressed: () => _removerAula(i),
                    ),
                ],
              ),
              TextFormField(
                controller: _aulas[i].titulo,
                decoration: const InputDecoration(labelText: 'Título da aula'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Informe o título da aula'
                    : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _aulas[i].url,
                decoration: const InputDecoration(
                  labelText: 'URL do vídeo (.mp4)',
                  hintText: 'https://...',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Informe a URL do vídeo';
                  }
                  if (!v.startsWith('http')) {
                    return 'A URL deve começar com http';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}

/// Classe auxiliar que guarda os controllers de uma aula (título + URL).
class _ControllersAula {
  final TextEditingController titulo = TextEditingController();
  final TextEditingController url = TextEditingController(
    // já vem com um vídeo de exemplo para facilitar o teste
    text:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  );

  void dispose() {
    titulo.dispose();
    url.dispose();
  }
}
