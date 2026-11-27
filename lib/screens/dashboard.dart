
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/stat_card.dart';
import '../widgets/weekly_progress.dart';
import '../widgets/recent_tasks.dart';
import '../widgets/subject_card.dart';
import '../data/task_store.dart';
import '../data/subject_store.dart';

// Dashboard conectada ao TaskStore e ao SubjectStore.
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: SubjectStore.instance,
      builder: (context, child) {
        final subjects = SubjectStore.instance.subjects;

        return AnimatedBuilder(
          animation: TaskStore.instance,
          builder: (context, child) {
            final tasks = TaskStore.instance.tasks;

            final totalTasks = tasks.length;

            final pendingTasks = tasks.where(
              (task) => task['status'] == 'Pendente',
            ).length;

            final completedTasks = tasks.where(
              (task) => task['status'] == 'Concluída',
            ).length;

            final activeSubjects = subjects.length;

            return SingleChildScrollView(
              padding:  EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'Seu próximo passo começa aqui.',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.text,
                    ),
                  ),

                   SizedBox(height: 8),

                   Text(
                    'Acompanhe seu progresso e organize sua rotina de estudos.',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.muted,
                    ),
                  ),

                   SizedBox(height: 32),

                  // Indicadores dinâmicos.
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
                        physics:  NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: columns == 1 ? 2.2 : 1.5,
                        children: [
                          StatCard(
                            title: 'Total de tarefas',
                            value: '$totalTasks',
                            subtitle: 'Tarefas cadastradas',
                            icon: Icons.assignment_outlined,
                            iconColor:  Color(0xFF7561D8),
                            iconBackground:  Color(0xFFEFE8FF),
                          ),

                          StatCard(
                            title: 'Pendentes',
                            value: '$pendingTasks',
                            subtitle: 'Precisam da sua atenção',
                            icon: Icons.schedule_outlined,
                            iconColor:  Color(0xFFE5A23C),
                            iconBackground:  Color(0xFFFFF2DF),
                          ),

                          StatCard(
                            title: 'Concluídas',
                            value: '$completedTasks',
                            subtitle: 'Você está avançando!',
                            icon: Icons.check_circle_outline,
                            iconColor:  Color(0xFF45A985),
                            iconBackground:  Color(0xFFE2F6ED),
                          ),

                          StatCard(
                            title: 'Matérias ativas',
                            value: '$activeSubjects',
                            subtitle: 'Matérias cadastradas',
                            icon: Icons.menu_book_outlined,
                            iconColor:  Color(0xFF5D91D5),
                            iconBackground:  Color(0xFFE5F0FF),
                          ),
                        ],
                      );
                    },
                  ),

                   SizedBox(height: 32),

                  // Progresso semanal e tarefas recentes.
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

                             SizedBox(width: 24),

                            Expanded(
                              flex: 3,
                              child: RecentTasks(),
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          WeeklyProgress(),

                           SizedBox(height: 24),

                          RecentTasks(),
                        ],
                      );
                    },
                  ),

                   SizedBox(height: 32),

                   Text(
                    'Minhas matérias',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.text,
                    ),
                  ),

                   SizedBox(height: 16),

                  // Cartões dinâmicos de matérias.
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
                        physics:  NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.15,

                        children: subjects.map((subject) {
                          final name = subject['name'] as String;

                          final progress =
                              TaskStore.instance.getProgress(name);

                          final taskCount =
                              TaskStore.instance.getTaskCount(name);

                          return SubjectCard(
                            name: name,
                            icon: subject['icon'] as IconData,
                            color: subject['color'] as Color,
                            progress: progress,
                            subtitle: '$taskCount tarefas no total',
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
