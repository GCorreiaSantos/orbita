
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/task_store.dart';

// Gráfico semanal baseado nas tarefas concluídas.
class WeeklyProgress extends StatelessWidget {
  const WeeklyProgress({super.key});

  // Converte uma data no formato dd/MM/yyyy com segurança.
  DateTime? _parseDate(String? date) {
    if (date == null || date == 'Sem data' || date.trim().isEmpty) {
      return null;
    }

    try {
      final parts = date.split('/');

      if (parts.length != 3) return null;

      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: TaskStore.instance,
      builder: (context, child) {
        final days = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

        final now = DateTime.now();

        // Encontra a segunda-feira da semana atual.
        final monday = DateTime(
          now.year,
          now.month,
          now.day,
        ).subtract(Duration(days: now.weekday - 1));

        // Conta tarefas concluídas por dia na semana atual.
        final values = List<int>.generate(7, (index) {
          final day = monday.add(Duration(days: index));

          return TaskStore.instance.tasks.where((task) {
            if (task['status'] != 'Concluída') return false;

            final taskDate = _parseDate(task['date']?.toString());

            if (taskDate == null) return false;

            return taskDate.year == day.year &&
                taskDate.month == day.month &&
                taskDate.day == day.day;
          }).length;
        });

        final maxValue = values.fold<int>(
          0,
          (previous, current) =>
              current > previous ? current : previous,
        );

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Progresso semanal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.text,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Tarefas concluídas nesta semana',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.muted,
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                height: 180,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(days.length, (index) {
                    final barHeight = maxValue == 0
                        ? 0.0
                        : (values[index] / maxValue) * 120;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${values[index]}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.muted,
                              ),
                            ),

                            const SizedBox(height: 6),

                            SizedBox(
                              height: 120,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                  width: double.infinity,
                                  height: barHeight,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary.withValues(
                                      alpha: 0.85,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              days[index],
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
