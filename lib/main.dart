
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'widgets/sidebar.dart';
import 'screens/dashboard.dart';
import 'screens/tasks_screen.dart';
import 'screens/subjects_screen.dart';

// Função principal do Dart.
// É o ponto de entrada do aplicativo e inicia o Flutter.
void main() {
  runApp(const OrbitaApp());
}

// Widget responsável por configurar o aplicativo.
class OrbitaApp extends StatelessWidget {
  const OrbitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp configura o tema, o título e a tela inicial.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Órbita',

      // Aplica o tema visual definido no arquivo app_theme.dart.
      theme: AppTheme.lightTheme,

      // Define a tela inicial do aplicativo.
      home: HomeScreen(),

      // Define o idioma padrão como português do Brasil.
      locale: Locale('pt', 'BR'),

      // Configura os recursos de localização do Flutter,
      // incluindo textos de componentes e widgets.
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Informa os idiomas que o aplicativo suporta.
      supportedLocales: [
        Locale('pt', 'BR'),
      ],
    );
  }
}

// HomeScreen controla a navegação entre as telas do aplicativo.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Guarda o índice da página atualmente selecionada.
  int selectedIndex = 0;

  // Retorna a tela correspondente ao índice selecionado.
  Widget _buildPage() {
    if (selectedIndex == 0) {
      // Índice 0: Dashboard.
      return Dashboard();
    } else if (selectedIndex == 1) {
      // Índice 1: tela de tarefas.
      return TasksScreen();
    } else {
      // Índice 2: tela de matérias.
      return SubjectsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold fornece a estrutura principal da tela.
    return Scaffold(
      // Row posiciona a sidebar ao lado do conteúdo principal.
      body: Row(
        children: [
          // Menu lateral responsável pela navegação.
          Sidebar(
            selectedIndex: selectedIndex,

            // Recebe o índice do item clicado na sidebar.
            // setState atualiza o estado e reconstruirá a tela
            // para exibir a página selecionada.
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),

          // Ocupa o espaço restante da tela
          // e exibe a página selecionada.
          Expanded(
            child: _buildPage(),
          ),
        ],
      ),
    );
  }
}
