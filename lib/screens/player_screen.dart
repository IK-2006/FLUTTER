import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/aula.dart';
import '../services/network_service.dart';
import '../utils/app_cores.dart';

/// Tela do player de vídeo.
/// O vídeo é transmitido pela internet (streaming) a partir da URL da aula.
/// Usamos o pacote "chewie" por cima do "video_player" para ter controles
/// prontos (play/pause, barra de progresso, tela cheia...).
class PlayerScreen extends StatefulWidget {
  final Aula aula;

  const PlayerScreen({super.key, required this.aula});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _prepararVideo();
  }

  Future<void> _prepararVideo() async {
    // 1) verifica se o vídeo está disponível online (comunicação HTTP)
    final disponivel = await NetworkService.videoDisponivel(widget.aula.videoUrl);
    if (!disponivel) {
      setState(() {
        _erro = 'Não foi possível carregar o vídeo. Verifique sua conexão.';
        _carregando = false;
      });
      return;
    }

    // 2) inicializa o player com a URL do vídeo
    try {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.aula.videoUrl));
      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoController!.value.aspectRatio,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppCores.primaria,
          handleColor: AppCores.primaria,
        ),
      );

      setState(() => _carregando = false);
    } catch (e) {
      setState(() {
        _erro = 'Erro ao reproduzir o vídeo.';
        _carregando = false;
      });
    }
  }

  @override
  void dispose() {
    // MUITO importante liberar os controllers para não travar o app
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.aula.titulo)),
      backgroundColor: Colors.black,
      body: Center(child: _construirCorpo()),
    );
  }

  Widget _construirCorpo() {
    if (_carregando) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Carregando vídeo...'),
        ],
      );
    }

    if (_erro != null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppCores.erro),
            const SizedBox(height: 12),
            Text(_erro!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _carregando = true;
                  _erro = null;
                });
                _prepararVideo();
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    // player pronto
    return Chewie(controller: _chewieController!);
  }
}
