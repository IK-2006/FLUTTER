import '../utils/seguranca.dart';

/// "Seed" = dados iniciais que são inseridos no banco na primeira vez
/// que o aplicativo abre. Isso serve para o app não começar vazio:
/// já vem com um instrutor de exemplo e alguns cursos com vídeos reais
/// (transmitidos pela internet).
///
/// Os vídeos são amostras públicas oficiais do Flutter (não precisam de
/// chave/API e funcionam tanto no celular quanto no navegador) e as imagens
/// vêm do serviço público picsum.photos.
class SeedDados {
  SeedDados._();

  // Vídeos de exemplo, públicos e confiáveis.
  static const String _video1 =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';
  static const String _video2 =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  // Conta de instrutor de demonstração.
  // Login: professor@cursostream.com  |  Senha: 123456
  static Map<String, dynamic> instrutorDemo() {
    return {
      'nome': 'Prof. Ana Souza',
      'email': 'professor@cursostream.com',
      'senha_hash': Seguranca.gerarHash('123456'),
      'eh_instrutor': 1,
      'foto_path': null,
    };
  }

  /// Cursos de exemplo. O campo 'aulas' é usado depois para inserir as aulas.
  static List<Map<String, dynamic>> cursosDemo(int instrutorId) {
    return [
      {
        'titulo': 'Introdução ao Flutter',
        'descricao':
            'Aprenda a criar seu primeiro aplicativo mobile usando Flutter e Dart, '
                'do zero até publicar. Ideal para quem está começando.',
        'preco': 49.90,
        'categoria': 'Programação',
        'thumbnail': 'https://picsum.photos/seed/flutter/600/360',
        'instrutor_id': instrutorId,
        'nome_instrutor': 'Prof. Ana Souza',
        'aulas': [
          {'titulo': 'Boas-vindas ao curso', 'video_url': _video1},
          {'titulo': 'Instalando o ambiente', 'video_url': _video2},
          {'titulo': 'Primeiro app na tela', 'video_url': _video1},
        ],
      },
      {
        'titulo': 'Design de Interfaces (UI/UX)',
        'descricao':
            'Descubra os princípios de um bom design de aplicativos: cores, '
                'espaçamento, tipografia e como deixar o app agradável de usar.',
        'preco': 0.0, // curso gratuito
        'categoria': 'Design',
        'thumbnail': 'https://picsum.photos/seed/design/600/360',
        'instrutor_id': instrutorId,
        'nome_instrutor': 'Prof. Ana Souza',
        'aulas': [
          {'titulo': 'O que é UX?', 'video_url': _video2},
          {'titulo': 'Escolhendo cores', 'video_url': _video1},
        ],
      },
      {
        'titulo': 'Marketing Digital para Iniciantes',
        'descricao':
            'Entenda como divulgar um produto ou serviço na internet usando '
                'redes sociais, tráfego pago e criação de conteúdo.',
        'preco': 79.90,
        'categoria': 'Marketing',
        'thumbnail': 'https://picsum.photos/seed/marketing/600/360',
        'instrutor_id': instrutorId,
        'nome_instrutor': 'Prof. Ana Souza',
        'aulas': [
          {'titulo': 'Introdução ao marketing', 'video_url': _video1},
          {'titulo': 'Redes sociais na prática', 'video_url': _video2},
          {'titulo': 'Medindo resultados', 'video_url': _video1},
        ],
      },
    ];
  }
}
