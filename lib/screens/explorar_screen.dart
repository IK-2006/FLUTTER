import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cursos_provider.dart';
import '../utils/app_cores.dart';
import '../widgets/curso_card.dart';
import '../widgets/estado_vazio.dart';
import 'curso_detalhe_screen.dart';

/// Aba "Explorar": mostra o catálogo de cursos em um grid, com busca.
class ExplorarScreen extends StatefulWidget {
  const ExplorarScreen({super.key});

  @override
  State<ExplorarScreen> createState() => _ExplorarScreenState();
}

class _ExplorarScreenState extends State<ExplorarScreen> {
  final _buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // carrega os cursos assim que a tela abre.
    // usamos addPostFrameCallback para não chamar durante o build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CursosProvider>().carregarCatalogo();
    });
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cursosProvider = context.watch<CursosProvider>();

    return Column(
      children: [
        // Campo de busca
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _buscaController,
            decoration: InputDecoration(
              hintText: 'Buscar cursos...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _buscaController.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _buscaController.clear();
                        cursosProvider.carregarCatalogo();
                        setState(() {});
                      },
                    ),
            ),
            onChanged: (texto) {
              // rebusca a cada mudança e atualiza o ícone de limpar
              cursosProvider.carregarCatalogo(busca: texto);
              setState(() {});
            },
          ),
        ),

        // Lista/grid de cursos
        Expanded(
          child: _construirConteudo(cursosProvider),
        ),
      ],
    );
  }

  Widget _construirConteudo(CursosProvider provider) {
    if (provider.carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.catalogo.isEmpty) {
      return const EstadoVazio(
        icone: Icons.search_off,
        titulo: 'Nenhum curso encontrado',
        descricao: 'Tente buscar por outro termo ou publique o primeiro curso.',
      );
    }

    // LayoutBuilder deixa o grid responsivo: mais colunas em telas largas.
    return LayoutBuilder(
      builder: (context, constraints) {
        final int colunas = constraints.maxWidth > 600 ? 3 : 2;

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: provider.catalogo.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: colunas,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, indice) {
            final curso = provider.catalogo[indice];
            return CursoCard(
              curso: curso,
              aoTocar: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CursoDetalheScreen(cursoId: curso.id!),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
