import 'package:flutter/material.dart';

import '../models/curso.dart';
import '../utils/app_cores.dart';
import '../utils/formatadores.dart';
import 'imagem_curso.dart';

/// Card que representa um curso na lista/catálogo.
/// Ao tocar, chama a função [aoTocar] (normalmente abre os detalhes do curso).
class CursoCard extends StatelessWidget {
  final Curso curso;
  final VoidCallback aoTocar;

  const CursoCard({super.key, required this.curso, required this.aoTocar});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias, // deixa a imagem com os cantos arredondados
      child: InkWell(
        onTap: aoTocar,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // imagem do curso com um "selo" de categoria por cima
            Stack(
              children: [
                ImagemCurso(
                  caminho: curso.thumbnail,
                  altura: 120,
                  largura: double.infinity,
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: _selo(curso.categoria, AppCores.primaria),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    curso.titulo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    curso.nomeInstrutor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppCores.textoSuave,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // mostra "Grátis" ou o preço formatado
                  Text(
                    curso.ehGratuito ? 'Grátis' : Formatadores.preco(curso.preco),
                    style: TextStyle(
                      color: curso.ehGratuito ? AppCores.sucesso : AppCores.secundaria,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selo(String texto, Color cor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
