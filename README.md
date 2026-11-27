# ☄️ Órbita

<p align="center">
  <strong>Organize suas tarefas. Acompanhe seu progresso. Conquiste seus objetivos.</strong>
</p>

<p align="center">
  Um aplicativo de organização acadêmica desenvolvido com Flutter, pensado para facilitar o gerenciamento de tarefas, o acompanhamento dos estudos e a visualização do progresso.
</p>

---

## 📖 Sobre o projeto

O **Órbita** é uma aplicação de organização acadêmica que reúne tarefas, matérias e acompanhamento de produtividade em uma interface simples, intuitiva e responsiva.

O projeto foi desenvolvido utilizando Flutter e Dart, com o objetivo de proporcionar uma experiência prática de gerenciamento de atividades acadêmicas, permitindo que o usuário acompanhe suas tarefas e visualize seu progresso de maneira centralizada.

## ✨ Funcionalidades

- **Dashboard:** visão geral das atividades e do progresso.
- **Estatísticas:** acompanhamento do total de tarefas, tarefas pendentes, concluídas e matérias envolvidas.
- **Gerenciamento de tarefas:** cadastrar, editar, excluir e organizar tarefas.
- **Status das tarefas:** acompanhamento por status, como pendente, em andamento e concluída.
- **Progresso por matéria:** visualização do desempenho e da quantidade de atividades por disciplina.
- **Gráfico semanal:** visualização das tarefas concluídas durante a semana.
- **Tarefas recentes:** acompanhamento das últimas atividades adicionadas.
- **Interface responsiva:** adaptação da interface para diferentes tamanhos de tela.
- **Aplicação Web:** acesso ao projeto por meio de navegador.

## 🖥️ Demonstração

Acesse o aplicativo:

**[Abrir Órbita](https://gcorreiaSantos.github.io/orbita/)**

## 🛠️ Tecnologias utilizadas

- [Flutter](https://flutter.dev/) — Framework para desenvolvimento multiplataforma.
- [Dart](https://dart.dev/) — Linguagem de programação utilizada pelo Flutter.
- Material Design — Componentes e padrões de interface.
- Git — Controle de versão.
- GitHub — Hospedagem do repositório.
- GitHub Pages — Publicação da versão Web.

## 📂 Estrutura do projeto

```text
lib/
├── data/
│   └── task_store.dart
├── screens/
│   ├── dashboard.dart
│   ├── tasks_screen.dart
│   └── subjects_screen.dart
├── theme/
│   └── app_theme.dart
├── widgets/
│   ├── sidebar.dart
│   ├── stat_card.dart
│   ├── weekly_progress.dart
│   ├── recent_tasks.dart
│   └── subject_card.dart
└── main.dart
```

## 🚀 Como executar o projeto

### Pré-requisitos

Antes de começar, você precisa ter instalado:

- Flutter SDK
- Dart SDK (incluído no Flutter)
- Git
- Chrome (para execução Web)

### 1. Clone o repositório

```bash
git clone https://github.com/GCorreriaSantos/orbita.git
```

### 2. Entre na pasta do projeto

```bash
cd orbita
```

### 3. Instale as dependências

```bash
flutter pub get
```

### 4. Execute o aplicativo

Para executar no Chrome:

```bash
flutter run -d chrome
```

## 🌐 Build e publicação Web

Para gerar a versão Web:

```bash
flutter build web --base-href=//orbita//
```

Após o build, copie os arquivos gerados para a pasta `docs` do repositório:

```bash
cp -r build/web/* docs/
```

Ajuste o endereço base do arquivo `docs/index.html`:

```bash
sed -i 's|<base href="//orbita//">|<base href="/orbita/">|' docs/index.html
```

Adicione os arquivos, faça o commit e envie para o GitHub:

```bash
git add -f docs
git commit -m "Update web application"
git push origin main
```

A publicação é realizada pelo GitHub Pages, configurado para utilizar a pasta `docs` da branch `main`.

## 📌 Status do projeto

O Órbita está em desenvolvimento. Atualmente, possui gerenciamento de tarefas, Dashboard dinâmica, acompanhamento por matérias e visualização semanal do progresso.

Os dados atualmente são armazenados em memória durante a utilização do aplicativo, não contando ainda com persistência permanente.

## 🎯 Objetivo

O objetivo do Órbita é tornar a organização acadêmica mais simples e visual, reunindo atividades, matérias e acompanhamento de progresso em um único ambiente.

---

<p align="center">
  Desenvolvido com ☄️ e Flutter.
</p>
