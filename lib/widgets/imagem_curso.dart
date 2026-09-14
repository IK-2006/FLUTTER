import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/app_cores.dart';

/// Widget que mostra a imagem (thumbnail) de um curso.
///
/// A imagem pode vir de dois lugares:
/// - da internet (quando começa com "http"), usamos Image.network;
/// - do próprio celular (foto tirada/escolhida pelo instrutor), usamos Image.file.
/// Este widget decide sozinho qual usar.
class ImagemCurso extends StatelessWidget {
  final String caminho;
  final double? altura;
  final double? largura;
  final BoxFit fit;

  const ImagemCurso({
    super.key,
    required this.caminho,
    this.altura,
    this.largura,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final bool ehDaInternet = caminho.startsWith('http');

    if (ehDaInternet) {
      return Image.network(
        caminho,
        height: altura,
        width: largura,
        fit: fit,
        // enquanto carrega, mostra um indicador de progresso
        loadingBuilder: (context, filho, progresso) {
          if (progresso == null) return filho;
          return _placeholder(const CircularProgressIndicator(strokeWidth: 2));
        },
        // se der erro ao baixar, mostra um ícone
        errorBuilder: (context, erro, stack) =>
            _placeholder(const Icon(Icons.broken_image, color: AppCores.textoSuave)),
      );
    } else {
      return Image.file(
        File(caminho),
        height: altura,
        width: largura,
        fit: fit,
        errorBuilder: (context, erro, stack) =>
            _placeholder(const Icon(Icons.image, color: AppCores.textoSuave)),
      );
    }
  }

  Widget _placeholder(Widget filho) {
    return Container(
      height: altura,
      width: largura,
      color: AppCores.card,
      alignment: Alignment.center,
      child: filho,
    );
  }
}
