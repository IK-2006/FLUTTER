import 'package:http/http.dart' as http;

/// Serviço que faz a comunicação com serviços externos pela internet (HTTP).
///
/// Na plataforma, os vídeos das aulas são transmitidos (streaming) a partir
/// de servidores externos. Antes de abrir o player, usamos este serviço para
/// checar se o vídeo realmente está disponível online, evitando abrir uma
/// tela travada caso o usuário esteja sem internet.
class NetworkService {
  /// Faz uma requisição HTTP (HEAD) para ver se a URL do vídeo responde.
  /// Retorna true se o servidor respondeu com sucesso (status 200).
  static Future<bool> videoDisponivel(String url) async {
    try {
      final resposta = await http
          .head(Uri.parse(url))
          .timeout(const Duration(seconds: 8));
      return resposta.statusCode == 200;
    } catch (_) {
      // Qualquer erro (sem internet, URL inválida...) significa indisponível.
      return false;
    }
  }
}
