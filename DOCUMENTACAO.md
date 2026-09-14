# Documentação do Projeto — CursoStream

**Disciplina:** Desenvolvimento Mobile III
**Curso:** Análise e Desenvolvimento de Sistemas — Universidade de Passo Fundo
**Trabalho:** Trabalho Final

---

## 1. Descrição da solução

### Nome do aplicativo
**CursoStream**

### Problema que será resolvido
Muitos profissionais e professores têm conhecimento para ensinar, mas não têm uma
forma simples de **vender e disponibilizar seus cursos** em vídeo para os alunos.
Por outro lado, os alunos querem uma forma prática de **encontrar, comprar e assistir**
cursos direto do celular, a qualquer hora e lugar.

O **CursoStream** resolve isso funcionando como uma plataforma de *streaming* de
cursos: o instrutor publica seu curso (com aulas em vídeo e preço) e o aluno se
matricula e assiste pelo aplicativo.

### Público-alvo
- **Instrutores / criadores de conteúdo**: pessoas que querem vender seus cursos.
- **Alunos**: pessoas que querem aprender assistindo cursos em vídeo no celular.

### Principais funcionalidades
1. Cadastro e login de usuários.
2. Publicação de cursos (título, descrição, preço, categoria, capa e aulas em vídeo).
3. Catálogo de cursos com busca.
4. Matrícula/compra de cursos (gratuitos ou pagos).
5. Reprodução das aulas em vídeo por streaming.
6. Compartilhamento de cursos.
7. Perfil do usuário com foto e lista de cursos publicados.

---

## 2. Requisitos funcionais

- **RF01** — O usuário poderá **criar uma conta** (aluno ou instrutor).
- **RF02** — O usuário poderá **fazer login** e permanecer logado ao reabrir o app.
- **RF03** — O usuário poderá **visualizar o catálogo** de cursos disponíveis.
- **RF04** — O usuário poderá **buscar cursos** pelo título.
- **RF05** — O usuário poderá **ver os detalhes** de um curso e sua lista de aulas.
- **RF06** — O usuário poderá **se matricular / comprar** um curso.
- **RF07** — O usuário poderá **assistir às aulas em vídeo** dos cursos matriculados.
- **RF08** — O usuário poderá **publicar um novo curso** com várias aulas.
- **RF09** — O usuário poderá **adicionar uma capa** ao curso usando a câmera ou a galeria.
- **RF10** — O usuário poderá **compartilhar** um curso com outros aplicativos.
- **RF11** — O usuário poderá **editar o perfil** (nome e foto) e **sair da conta**.
- **RF12** — Os dados deverão **permanecer salvos** ao fechar e abrir o app novamente.

---

## 3. Tecnologias utilizadas

### Linguagem e framework
- **Dart**
- **Flutter** (versão estável — verificar com `flutter --version`; desenvolvido para Flutter 3.27+)

### Bibliotecas (pacotes)
| Pacote | Para que serve |
|--------|----------------|
| `provider` | Gerenciamento de estado |
| `sqflite` | Banco de dados local (SQLite) |
| `path` | Montar o caminho do arquivo do banco |
| `shared_preferences` | Guardar a sessão (quem está logado) |
| `http` | Comunicação com serviços externos (HTTP) |
| `video_player` | Reprodução de vídeo |
| `chewie` | Controles prontos para o player de vídeo |
| `image_picker` | Acesso à câmera e à galeria |
| `share_plus` | Compartilhamento com outros apps |
| `intl` | Formatação de preço em Real (R$) |
| `crypto` | Gerar o hash (SHA-256) da senha |

### Banco de dados
- **SQLite** (via `sqflite`), com as tabelas: `usuarios`, `cursos`, `aulas` e `matriculas`.
- **SharedPreferences** para guardar o id do usuário logado.

### APIs e serviços externos
- **Streaming de vídeo**: os vídeos das aulas são transmitidos pela internet a partir
  de servidores externos (amostras públicas do Google, que não exigem chave de API).
- **Requisições HTTP**: antes de abrir o player, o app faz uma requisição HTTP para
  verificar se o vídeo está disponível online.
- **Imagens remotas**: as capas dos cursos de exemplo são carregadas da internet.

### Recursos do dispositivo utilizados
- **Câmera / Galeria** (`image_picker`) — para a capa do curso e a foto de perfil.
- **Compartilhamento** (`share_plus`) — para compartilhar cursos.

---

## 4. Arquitetura da aplicação

### Padrão arquitetural utilizado
O projeto usa uma **arquitetura em camadas** (também chamada de *layered architecture*),
separando as responsabilidades em pastas diferentes. A ideia é que cada parte do
código tenha uma única função, ficando mais fácil de entender e manter.

O fluxo de dados segue assim:

```
Telas (screens)  ->  Providers (estado)  ->  Services  ->  Banco de dados / Internet
     (UI)                (lógica)          (acesso a dados)
```

- As **telas** só cuidam da interface e chamam os providers.
- Os **providers** guardam o estado e chamam os serviços.
- Os **serviços** acessam o banco de dados (SQLite) e a internet (HTTP).
- Os **models** representam os dados (Usuario, Curso, Aula, Matricula).

Isso evita colocar toda a lógica dentro das telas — que é justamente o que o
enunciado do trabalho pede para evitar.

### Organização dos diretórios

```
lib/
├── main.dart          # Inicializa o app e os Providers
├── app.dart           # Configura o MaterialApp (tema + tela inicial)
│
├── models/            # Classes de dados (representam as tabelas do banco)
│   ├── usuario.dart
│   ├── curso.dart
│   ├── aula.dart
│   └── matricula.dart
│
├── services/          # Acesso a dados e serviços externos
│   ├── database_service.dart   # CRUD no SQLite
│   ├── auth_service.dart       # Login, cadastro e sessão
│   ├── network_service.dart    # Verificação HTTP
│   └── seed_dados.dart         # Dados iniciais (cursos de exemplo)
│
├── providers/         # Gerenciamento de estado
│   ├── auth_provider.dart      # Usuário logado
│   └── cursos_provider.dart    # Catálogo, matrículas e publicação
│
├── screens/           # Telas do aplicativo
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── registro_screen.dart
│   ├── home_screen.dart        # Scaffold + Drawer + BottomNavigationBar
│   ├── explorar_screen.dart
│   ├── meus_cursos_screen.dart
│   ├── publicar_curso_screen.dart
│   ├── curso_detalhe_screen.dart
│   └── player_screen.dart
│
├── widgets/           # Componentes reutilizáveis
│   ├── curso_card.dart
│   ├── imagem_curso.dart
│   └── estado_vazio.dart
│
└── utils/             # Utilidades
    ├── app_cores.dart          # Paleta de cores
    ├── app_tema.dart           # Tema visual
    ├── formatadores.dart       # Formatação de preço e data
    └── seguranca.dart          # Hash da senha
```

### Estratégia de gerenciamento de estado
Foi utilizado o **Provider**, uma das formas mais recomendadas e simples de
gerenciar estado no Flutter. Foram criados dois providers:

- **`AuthProvider`** — guarda o usuário logado e reage a login, logout e edição de perfil.
- **`CursosProvider`** — guarda a lista de cursos do catálogo e os cursos matriculados,
  além de tratar a publicação e a matrícula.

As telas "ouvem" esses providers com `context.watch()` e reagem automaticamente
quando o estado muda (por exemplo, ao publicar um curso, o catálogo é recarregado).

### Modelo de dados (banco SQLite)

```
usuarios
  id | nome | email | senha_hash | eh_instrutor | foto_path

cursos
  id | titulo | descricao | preco | categoria | thumbnail | instrutor_id | nome_instrutor

aulas
  id | curso_id | titulo | video_url | ordem

matriculas
  id | usuario_id | curso_id | data_compra
```

- Um **curso** tem várias **aulas** (`aulas.curso_id` aponta para `cursos.id`).
- Uma **matrícula** liga um **usuário** a um **curso** (é o que libera o acesso às aulas).

---

## 5. Como executar e testar

As instruções completas de execução (instalar dependências, liberar internet no
Android, rodar o app e gerar o APK) estão no arquivo **[README.md](README.md)**.

Para rodar os testes automatizados:

```bash
flutter test
```
