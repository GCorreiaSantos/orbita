import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/task_store.dart';

// Widget responsável por exibir as tarefas recentes.
class RecentTasks extends StatelessWidget {
  const RecentTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: TaskStore.instance,
      builder: (context, child) {
        // Pega as 4 tarefas mais recentemente adicionadas.
        final tasks = TaskStore.instance.tasks.reversed.take(4).toList();

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tarefas recentes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.text,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Acompanhe suas atividades',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.muted,
                ),
              ),

              const SizedBox(height: 20),

              // Mensagem caso não existam tarefas.
              if (tasks.isEmpty)
                Text(
                  'Nenhuma tarefa cadastrada.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.muted,
                  ),
                ),

              // Exibe as tarefas mais recentes.
              ...tasks.map((task) {
                final status = task['status'] ?? 'Pendente';

                Color statusColor;
                Color statusBackground;

                switch (status) {
                  case 'Concluída':
                    statusColor = const Color(0xFF45A985);
                    statusBackground = const Color(0xFFE2F6ED);
                    break;

                  case 'Em andamento':
                    statusColor = const Color(0xFF5D91D5);
                    statusBackground = const Color(0xFFE5F0FF);
                    break;

                  default:
                    statusColor = const Color(0xFFE5A23C);
                    statusBackground = const Color(0xFFFFF2DF);
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE8FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.assignment_outlined,
                          color: AppTheme.primary,
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task['title'] ?? 'Sem título',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.text,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              '${task['subject'] ?? 'Sem matéria'} • ${task['date'] ?? 'Sem data'}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.muted,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}