import '../utils/seguranca.dart';

/// "Seed" = dados iniciais que são inseridos no banco na primeira vez
/// que o aplicativo abre. Isso serve para o app não começar vazio:
/// já vem com um instrutor de exemplo e alguns cursos com vídeos reais
/// (transmitidos pela internet).
///
/// Os vídeos são amostras públicas do Google (não precisam de chave/API)
/// e as imagens vêm do serviço público picsum.photos.
class SeedDados {
  SeedDados._();

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
          {
            'titulo': 'Boas-vindas ao curso',
            'video_url':
                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          },
          {
            'titulo': 'Instalando o ambiente',
            'video_url':
                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          },
          {
            'titulo': 'Primeiro app na tela',
            'video_url':
                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          },
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
          {
            'titulo': 'O que é UX?',
            'video_url':
                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
          },
          {
            'titulo': 'Escolhendo cores',
            'video_url':
                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
          },
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
          {
            'titulo': 'Introdução ao marketing',
            'video_url':
                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4',
          },
          {
            'titulo': 'Redes sociais na prática',
            'video_url':
                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
          },
          {
            'titulo': 'Medindo resultados',
            'video_url':
                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
          },
        ],
      },
    ];
  }
}
