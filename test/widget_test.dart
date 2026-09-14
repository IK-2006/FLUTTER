import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:curso_stream/utils/formatadores.dart';
import 'package:curso_stream/widgets/estado_vazio.dart';

/// Testes simples do aplicativo.
/// Rode com: flutter test
void main() {
  // Teste de unidade: verifica a formatação de preço.
  test('Formatadores.preco formata o valor em Real', () {
    final resultado = Formatadores.preco(49.90);
    expect(resultado.contains('49,90'), true);
    expect(resultado.contains('R\$'), true);
  });

  // Teste de widget: verifica se o EstadoVazio mostra o texto informado.
  testWidgets('EstadoVazio mostra título e descrição', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EstadoVazio(
            icone: Icons.info,
            titulo: 'Nada aqui',
            descricao: 'Lista vazia',
          ),
        ),
      ),
    );

    expect(find.text('Nada aqui'), findsOneWidget);
    expect(find.text('Lista vazia'), findsOneWidget);
  });
}
