
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Widget responsável por exibir uma lista de tarefas recentes.
class RecentTasks extends StatelessWidget {
  const RecentTasks({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de tarefas demonstrativas exibidas no Dashboard.
    final tasks = [
      {
        'title': 'Exercícios de equação',
        'subject': 'Matemática',
        'date': 'Hoje',
        'status': 'Pendente',
      },
      {
        'title': 'Leitura do capítulo 5',
        'subject': 'Português',
        'date': '25 Nov',
        'status': 'Em andamento',
      },
      {
        'title': 'Resumo sobre células',
        'subject': 'Biologia',
        'date': '26 Nov',
        'status': 'Concluída',
      },
      {
        'title': 'Revisão da Revolução Francesa',
        'subject': 'História',
        'date': '27 Nov',
        'status': 'Pendente',
      }
    ];

    // Container cria o cartão que envolve a lista de tarefas.
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da seção.
          Text(
            'Tarefas recentes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.text,
            ),
          ),

          SizedBox(height: 8),

          // Descrição da seção.
          Text(
            'Acompanhe suas atividades',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.muted,
            ),
          ),

          SizedBox(height: 20),

          // Percorre a lista e cria um widget para cada tarefa.
          ...tasks.map((task) {
            // Define as cores de acordo com o status da tarefa.
            Color statusColor;
            Color statusBackground;

            switch (task['status']) {
              // Tarefa concluída.
              case 'Concluída':
                statusColor = Color(0xFF45A985);
                statusBackground = Color(0xFFE2F6ED);
                break;

              // Tarefa em andamento.
              case 'Em andamento':
                statusColor = Color(0xFF5D91D5);
                statusBackground = Color(0xFFE5F0FF);
                break;

              // Tarefa pendente (status padrão).
              default:
                statusColor = Color(0xFFE5A23C);
                statusBackground = Color(0xFFFFF2DF);
            }

            // Padding cria o espaçamento entre as tarefas.
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  // Ícone que identifica visualmente uma tarefa.
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFFEDE8FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.assignment_outlined,
                      color: AppTheme.primary,
                      size: 20,
                    ),
                  ),

                  SizedBox(width: 12),

                  // Área com o título, a matéria e a data.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nome da tarefa.
                        Text(
                          task['title']!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.text,
                          ),
                        ),

                        SizedBox(height: 4),

                        // Exibe a matéria e a data da tarefa.
                        Text(
                          '${task['subject']} • ${task['date']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Card que exibe o status da tarefa.
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      task['status']!,
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
  }
}
