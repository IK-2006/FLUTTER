import 'package:intl/intl.dart';

/// Funções para formatar textos (preço, data...).
/// Deixei separado para reaproveitar em várias telas.
class Formatadores {
  Formatadores._();

  /// Transforma um número em dinheiro no formato brasileiro. Ex: 49.9 -> "R$ 49,90"
  static String preco(double valor) {
    final formato = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formato.format(valor);
  }

  /// Transforma uma data em texto. Ex: "14/09/2026"
  static String data(DateTime data) {
    return DateFormat('dd/MM/yyyy').format(data);
  }
}
