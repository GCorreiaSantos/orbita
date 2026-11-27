
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/weekly_progress.dart';
import '../widgets/recent_tasks.dart';
import '../widgets/subject_card.dart';

// Esta tela apresenta um resumo visual da organização dos estudos.
// Como os dados são demonstrativos e não são alterados nesta tela,
// utilizamos StatelessWidget.
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  // Constrói a interface principal do Dashboard.
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Espaçamento interno da tela.
      padding: const EdgeInsets.all(32),

      // Organiza os elementos verticalmente.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho do Dashboard.
          const Text(
            'Seu próximo passo começa aqui.',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.text,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Acompanhe seu progresso e organize sua rotina de estudos.',
            style: TextStyle(
              fontSize: 15,
              color: AppTheme.muted,
            ),
          ),

          const SizedBox(height: 32),

          // Cards com indicadores demonstrativos.
          // O LayoutBuilder permite adaptar a quantidade de colunas
          // de acordo com o espaço disponível na tela.
          LayoutBuilder(
            builder: (context, constraints) {
              int columns = 4;

              if (constraints.maxWidth < 900) {
                columns = 2;
              }

              if (constraints.maxWidth < 500) {
                columns = 1;
              }

              return GridView.count(
                crossAxisCount: columns,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: columns == 1 ? 2.2 : 1.5,

                // Cada StatCard representa um indicador do Dashboard.
                children: [
                  StatCard(
                    title: 'Total de tarefas',
                    value: '24',
                    subtitle: 'Tarefas cadastradas',
                    icon: Icons.assignment_outlined,
                    iconColor: const Color(0xFF7561D8),
                    iconBackground: const Color(0xFFEFE8FF),
                  ),

                  StatCard(
                    title: 'Pendentes',
                    value: '12',
                    subtitle: 'Precisam da sua atenção',
                    icon: Icons.schedule_outlined,
                    iconColor: const Color(0xFFE5A23C),
                    iconBackground: const Color(0xFFFFF2DF),
                  ),

                  StatCard(
                    title: 'Concluídas',
                    value: '8',
                    subtitle: 'Você está avançando!',
                    icon: Icons.check_circle_outline,
                    iconColor: const Color(0xFF45A985),
                    iconBackground: const Color(0xFFE2F6ED),
                  ),

                  StatCard(
                    title: 'Matérias ativas',
                    value: '4',
                    subtitle: 'Matérias em andamento',
                    icon: Icons.menu_book_outlined,
                    iconColor: const Color(0xFF5D91D5),
                    iconBackground: const Color(0xFFE5F0FF),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 32),

          // Seção de progresso semanal e tarefas recentes.
          // Em telas maiores, os componentes ficam lado a lado.
          // Em telas menores, são organizados verticalmente.
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: WeeklyProgress(),
                    ),

                    const SizedBox(width: 24),

                    Expanded(
                      flex: 3,
                      child: RecentTasks(),
                    ),
                  ],
                );
              }

              // Layout para telas com menor largura.
              return Column(
                children: [
                  WeeklyProgress(),

                  const SizedBox(height: 24),

                  RecentTasks(),
                ],
              );
            },
          ),

          const SizedBox(height: 32),

          // Título da seção de matérias.
          const Text(
            'Minhas matérias',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.text,
            ),
          ),

          const SizedBox(height: 16),

          // Grid de matérias.
          // A quantidade de colunas é ajustada conforme a largura.
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 900
                  ? 4
                  : constraints.maxWidth >= 600
                      ? 2
                      : 1;

              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.15,

                // Cards demonstrativos das matérias.
                // Cada card apresenta nome, ícone, progresso e quantidade.
                children: [
                  SubjectCard(
                    name: 'Matemática',
                    icon: Icons.calculate_outlined,
                    color: const Color(0xFF7561D8),
                    progress: 0.75,
                    subtitle: '6 tarefas no total',
                  ),

                  SubjectCard(
                    name: 'Português',
                    icon: Icons.menu_book_outlined,
                    color: const Color(0xFFE69A57),
                    progress: 0.60,
                    subtitle: '5 tarefas no total',
                  ),

                  SubjectCard(
                    name: 'Biologia',
                    icon: Icons.biotech_outlined,
                    color: const Color(0xFF55B89A),
                    progress: 0.85,
                    subtitle: '7 tarefas no total',
                  ),

                  SubjectCard(
                    name: 'História',
                    icon: Icons.account_balance_outlined,
                    color: const Color(0xFFE47791),
                    progress: 0.45,
                    subtitle: '6 tarefas no total',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
