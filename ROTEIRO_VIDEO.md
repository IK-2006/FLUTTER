# Roteiro do vídeo de apresentação (~5 minutos)

Dica: grave a tela do celular/emulador enquanto usa o app e vá narrando.

## 1. Introdução (30s)
- "Olá, meu nome é [seu nome]. Este é o meu Trabalho Final de Desenvolvimento Mobile III."
- "Desenvolvi o **CursoStream**, um aplicativo de *streaming* de cursos, onde uma
  pessoa pode **vender os seus cursos** e outra pode **assistir**."

## 2. Objetivo do aplicativo (30s)
- Explique o problema: professores/criadores precisam de um lugar simples para
  vender cursos, e alunos querem assistir pelo celular.
- Diga o público-alvo: instrutores e alunos.

## 3. Demonstração das funcionalidades (2min30s)
Mostre na prática, nesta ordem:
1. **Login** com a conta de teste (`professor@cursostream.com` / `123456`).
2. **Explorar**: mostre o catálogo e faça uma **busca** por um curso.
3. **Detalhes do curso**: mostre descrição, preço e a lista de aulas.
4. **Matrícula**: entre em um curso, clique em "Comprar/Matricular" e confirme.
5. **Assistir**: abra uma aula e mostre o **vídeo tocando** (streaming).
6. **Publicar curso**: crie um curso novo, use a **câmera/galeria** para a capa,
   adicione uma aula e publique. Mostre ele aparecendo no catálogo.
7. **Compartilhar**: use o botão de compartilhar de um curso.
8. **Perfil**: troque a foto de perfil e mostre seus cursos publicados.
9. **Persistência**: feche e abra o app de novo, mostrando que continua logado e
   com os dados salvos.

## 4. Decisões técnicas (1min)
- **Flutter + Dart**.
- **Arquitetura em camadas** (models, services, providers, screens, widgets, utils).
- **Provider** para gerenciamento de estado.
- **SQLite (sqflite)** para salvar usuários, cursos, aulas e matrículas.
- **SharedPreferences** para manter o login salvo.
- **http** + **video_player/chewie** para a comunicação externa e o streaming.
- **image_picker** (câmera/galeria) e **share_plus** (compartilhamento) como
  recursos do dispositivo.

## 5. Encerramento (30s)
- "Com isso, o app cumpre todos os requisitos: interface, gerenciamento de estado,
  persistência, integração externa e uso de recursos do dispositivo."
- "Obrigado!"
