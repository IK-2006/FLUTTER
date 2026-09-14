import 'package:flutter/material.dart';
import '../utils/app_cores.dart';

/// Widget mostrado quando uma lista está vazia (ex: nenhum curso encontrado).
/// Ajuda o usuário a entender que não é um erro, apenas não há nada ali ainda.
class EstadoVazio extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String descricao;

  const EstadoVazio({
    super.key,
    required this.icone,
    required this.titulo,
    required this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, size: 64, color: AppCores.textoSuave),
            const SizedBox(height: 16),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              descricao,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppCores.textoSuave),
            ),
          ],
        ),
      ),
    );
  }
}
