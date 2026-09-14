# CursoStream 🎬📚

Plataforma mobile (estilo *streaming*) para **vender e assistir cursos online**, desenvolvida em **Flutter** como Trabalho Final da disciplina de Desenvolvimento Mobile III.

Qualquer pessoa pode se cadastrar, **publicar seus próprios cursos** (com preço e aulas em vídeo) e **assistir** aos cursos em que se matricular — tudo funcionando offline nos dados e transmitindo os vídeos pela internet.

---

## 📱 Funcionalidades

- Cadastro e login de usuários (com senha protegida por hash)
- Sessão que continua logada mesmo depois de fechar o app
- Catálogo de cursos com **busca** e layout responsivo (grid)
- Tela de detalhes com descrição, preço e lista de aulas
- **Matrícula/compra** de cursos (grátis ou pagos)
- **Player de vídeo** com streaming pela internet (play, pause, tela cheia)
- **Publicação de cursos**: título, descrição, preço, categoria, capa e aulas
- Foto de capa do curso e foto de perfil tiradas da **câmera** ou **galeria**
- **Compartilhamento** de cursos com outros apps
- Perfil do usuário com seus cursos publicados

---

## ✅ Requisitos do trabalho atendidos

| Requisito | Como foi atendido |
|-----------|-------------------|
| Interface gráfica com Flutter | Scaffold, AppBar, Drawer, BottomNavigationBar, Cards, ListView, GridView, Forms, Dialogs, SnackBars |
| Layout responsivo | `LayoutBuilder` ajusta o número de colunas do grid; `ConstrainedBox` limita a largura em telas grandes |
| Navegação entre telas | `Navigator` (push, pushReplacement, pushAndRemoveUntil) |
| Gerenciamento de estado | **Provider** (`AuthProvider` e `CursosProvider`) |
| Persistência de dados | **SQLite** (`sqflite`) + **SharedPreferences** para a sessão |
| Comunicação com serviço externo | **HTTP** (`http`) e **streaming de vídeo** pela internet (`video_player`) |
| Recurso do dispositivo | **Câmera/Galeria** (`image_picker`) e **Compartilhamento** (`share_plus`) |
| Arquitetura organizada | Código em camadas (models, services, providers, screens, widgets, utils) |

> Detalhes completos estão em **[DOCUMENTACAO.md](DOCUMENTACAO.md)**.

---

## 🚀 Como executar o projeto

> **Pré-requisito:** ter o [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.
> Confira com: `flutter --version` (recomendado Flutter 3.27 ou mais novo).

### 1. Gerar as pastas de plataforma (android/ios)

Este repositório contém apenas o código-fonte (`lib/`), a configuração e a documentação. Rode o comando abaixo **dentro da pasta do projeto** para o Flutter criar as pastas `android/` e `ios/` (ele **não** apaga o código já existente):

```bash
flutter create .
```

### 2. Baixar as dependências

```bash
flutter pub get
```

### 3. Liberar o acesso à internet (Android)

Abra o arquivo `android/app/src/main/AndroidManifest.xml` e adicione a linha abaixo **logo acima** da tag `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

> Isso é necessário para o app baixar as imagens e transmitir os vídeos.
> A câmera e a galeria funcionam pelo `image_picker` sem permissões extras.

### 4. Rodar o aplicativo

Com um emulador aberto ou um celular conectado:

```bash
flutter run
```

### 5. Gerar o APK (para entrega)

```bash
flutter build apk --release
```

O APK ficará em: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🔑 Conta de teste (já vem cadastrada)

O app já inicia com um instrutor e alguns cursos de exemplo:

- **E-mail:** `professor@cursostream.com`
- **Senha:** `123456`

Você também pode criar sua própria conta na tela de cadastro.

---

## 🗂️ Estrutura de pastas

```
lib/
├── main.dart                # Início do app (configura os Providers)
├── app.dart                 # MaterialApp (tema e tela inicial)
├── models/                  # Classes de dados (Usuario, Curso, Aula, Matricula)
├── services/                # Acesso a dados e serviços externos
│   ├── database_service.dart   # Banco de dados SQLite
│   ├── auth_service.dart       # Login/cadastro + sessão
│   ├── network_service.dart    # Comunicação HTTP
│   └── seed_dados.dart         # Dados iniciais (cursos de exemplo)
├── providers/               # Gerenciamento de estado (Provider)
│   ├── auth_provider.dart
│   └── cursos_provider.dart
├── screens/                 # Telas do aplicativo
├── widgets/                 # Componentes reutilizáveis
└── utils/                   # Cores, tema, formatadores, segurança
```

---

## 🛠️ Tecnologias e bibliotecas

- **Flutter** e **Dart**
- `provider` — gerenciamento de estado
- `sqflite` + `path` — banco de dados local (SQLite)
- `shared_preferences` — guardar a sessão do usuário
- `http` — comunicação com serviços externos
- `video_player` + `chewie` — reprodução de vídeo (streaming)
- `image_picker` — câmera e galeria
- `share_plus` — compartilhamento
- `intl` — formatação de valores em Real (R$)
- `crypto` — hash da senha (SHA-256)
