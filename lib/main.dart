import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'theme/app_theme.dart';
import 'widgets/sidebar.dart';
import 'screens/dashboard.dart';
import 'screens/tasks_screen.dart';
import 'screens/subjects_screen.dart';

void main() {
  runApp(const OrbitaApp());
}

class OrbitaApp extends StatelessWidget {
  const OrbitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Órbita',
      theme: AppTheme.lightTheme,
      home:  HomeScreen(),
      locale:  Locale('pt', 'BR'),
      localizationsDelegates:  [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales:  [
        Locale('pt', 'BR'),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  // Todas as telas permanecem montadas.
  final List<Widget> pages =  [
    Dashboard(),
    TasksScreen(),
    SubjectsScreen(),
  ];

  // Atualiza a tela selecionada.
  void _selectPage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      body: isMobile
          ? IndexedStack(
              index: selectedIndex,
              children: pages,
            )
          : Row(
              children: [
                Sidebar(
                  selectedIndex: selectedIndex,
                  onItemSelected: _selectPage,
                ),
                Expanded(
                  child: IndexedStack(
                    index: selectedIndex,
                    children: pages,
                  ),
                ),
              ],
            ),

      // Navegação inferior para telas menores.
      bottomNavigationBar: isMobile
          ? NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: _selectPage,
              destinations:  [
                NavigationDestination(
                  icon: Icon(Icons.grid_view_rounded),
                  label: 'Visão geral',
                ),
                NavigationDestination(
                  icon: Icon(Icons.task_alt_outlined),
                  label: 'Tarefas',
                ),
                NavigationDestination(
                  icon: Icon(Icons.menu_book_outlined),
                  label: 'Matérias',
                ),
              ],
            )
          : null,
    );
  }
}