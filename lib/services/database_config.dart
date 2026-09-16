import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show databaseFactory, databaseFactoryFfi, sqfliteFfiInit;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'
    show databaseFactoryFfiWebNoWebWorker;

/// Configura o banco de dados de acordo com a plataforma em que o app roda.
///
/// - No **celular (Android/iOS)** o `sqflite` já funciona sozinho.
/// - No **computador (Windows/Linux/macOS)** e na **web** ele NÃO funciona
///   direto; por isso ativamos uma implementação alternativa (FFI).
///
/// Sem isso, ao abrir o banco no Windows ou no navegador, o app dava erro
/// (e a tela de login ficava carregando para sempre).
void configurarBancoDeDados() {
  if (kIsWeb) {
    // Navegador (Chrome, Edge...) — versão sem "web worker", mais simples.
    databaseFactory = databaseFactoryFfiWebNoWebWorker;
  } else if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    // Computador
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  // Android e iOS: não precisa fazer nada, usa o padrão.
}
