
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Esta tela permite cadastrar, editar, excluir e organizar tarefas.
// O StatefulWidget é utilizado porque os dados e filtros mudam
// durante a utilização do aplicativo.
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TasksScreen> {
  // Guarda o filtro selecionado pelo usuário.
  String selectedFilter = 'Todas';

  // Lista inicial de tarefas.
  // Os dados são mantidos em memória durante a execução do app.
  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Exercícios de equação',
      'subject': 'Matemática',
      'date': '25/11/2026',
      'status': 'Pendente',
      'icon': Icons.calculate_outlined,
    },
    {
      'title': 'Leitura do capítulo 5',
      'subject': 'Português',
      'date': '25/11/2026',
      'status': 'Em andamento',
      'icon': Icons.menu_book_outlined,
    },
    {
      'title': 'Resumo sobre células',
      'subject': 'Biologia',
      'date': '26/11/2026',
      'status': 'Concluída',
      'icon': Icons.biotech_outlined,
    },
    {
      'title': 'Revisão da Revolução Francesa',
      'subject': 'História',
      'date': '27/11/2026',
      'status': 'Pendente',
      'icon': Icons.account_balance_outlined,
    },
  ];

  // Retorna as tarefas de acordo com o filtro selecionado.
  // Em seguida, organiza a lista por data de entrega.
  List<Map<String, dynamic>> get filteredTasks {
    List<Map<String, dynamic>> filtered;

    if (selectedFilter == 'Todas') {
      filtered = List.from(tasks);
    } else {
      String status = selectedFilter == 'Pendentes'
          ? 'Pendente'
          : selectedFilter == 'Concluídas'
              ? 'Concluída'
              : 'Em andamento';

      filtered = tasks.where((task) {
        return task['status'] == status;
      }).toList();
    }

    // Ordena as tarefas da data mais próxima para a mais distante.
    // Tarefas sem data ficam no final da lista.
    filtered.sort((a, b) {
      DateTime? dateA = _parseTaskDate(a['date']);
      DateTime? dateB = _parseTaskDate(b['date']);

      if (dateA == null && dateB == null) return 0;
      if (dateA == null) return 1;
      if (dateB == null) return -1;

      return dateA.compareTo(dateB);
    });

    return filtered;
  }

  // Abre o formulário para criar ou editar uma tarefa.
  // O taskIndex identifica a tarefa que será editada.
  // Quando não é informado, o formulário cria uma nova tarefa.
  Future<void> _showTaskDialog({int? taskIndex}) async {
    final bool isEditing = taskIndex != null;

    // Controllers permitem acessar e controlar os textos dos campos.
    final titleController = TextEditingController(
      text: isEditing ? tasks[taskIndex]['title'] : '',
    );

    final dateController = TextEditingController(
      text: isEditing ? tasks[taskIndex]['date'] : '',
    );

    // Define os valores iniciais do formulário.
    String selectedSubject = isEditing
        ? tasks[taskIndex]['subject']
        : 'Matemática';

    String selectedStatus = isEditing
        ? tasks[taskIndex]['status']
        : 'Pendente';

    // Exibe o formulário em um diálogo.
    // O StatefulBuilder permite atualizar os campos do diálogo
    // sem reconstruir toda a tela de tarefas.
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEditing ? 'Editar tarefa' : 'Nova tarefa'),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Campo para informar o título da tarefa.
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Nome da tarefa',
                        hintText: 'Ex: Exercícios de matemática',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Campo de data.
                    // O usuário seleciona a data através do calendário.
                    TextField(
                      controller: dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Data de entrega',
                        suffixIcon: Icon(Icons.calendar_month_outlined),
                      ),
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        // Verifica se o usuário selecionou uma data.
                        if (selectedDate != null) {
                          final day = selectedDate.day
                              .toString()
                              .padLeft(2, '0');

                          final month = selectedDate.month
                              .toString()
                              .padLeft(2, '0');

                          // Formata a data no padrão dd/MM/yyyy.
                          dateController.text =
                              '$day/$month/${selectedDate.year}';
                        }
                      },
                    ),

                    SizedBox(height: 16),

                    // Dropdown para selecionar a matéria.
                    DropdownButtonFormField<String>(
                      value: selectedSubject,
                      decoration: InputDecoration(
                        labelText: 'Matéria',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        'Matemática',
                        'Português',
                        'Biologia',
                        'História',
                      ].map((subject) {
                        return DropdownMenuItem(
                          value: subject,
                          child: Text(subject),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // Atualiza a matéria selecionada no diálogo.
                        if (value != null) {
                          setDialogState(() {
                            selectedSubject = value;
                          });
                        }
                      },
                    ),

                    SizedBox(height: 16),

                    // Dropdown para selecionar o status da tarefa.
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        'Pendente',
                        'Em andamento',
                        'Concluída',
                      ].map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // Atualiza o status selecionado no diálogo.
                        if (value != null) {
                          setDialogState(() {
                            selectedStatus = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Botões de ação do formulário.
              actions: [
                // Fecha o diálogo sem salvar.
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                ),

                // Valida e retorna os dados preenchidos.
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) {
                      return;
                    }

                    Navigator.pop(context, {
                      'title': titleController.text.trim(),
                      'subject': selectedSubject,
                      'date': dateController.text.trim().isEmpty
                          ? 'Sem data'
                          : dateController.text.trim(),
                      'status': selectedStatus,
                    });
                  },
                  child: Text('Salvar tarefa'),
                ),
              ],
            );
          },
        );
      },
    );

    // Verifica se o diálogo retornou dados.
    // Se retornou, cria ou atualiza a tarefa.
    if (result != null && mounted) {
      setState(() {
        if (isEditing) {
          // Atualiza os dados da tarefa existente.
          tasks[taskIndex] = {
            ...tasks[taskIndex],
            ...result,
            'icon': _getSubjectIcon(result['subject']),
          };
        } else {
          // Adiciona uma nova tarefa à lista.
          tasks.add({
            ...result,
            'icon': _getSubjectIcon(result['subject']),
          });
        }
      });
    }

    // Libera os recursos dos controllers após o uso.
    titleController.dispose();
    dateController.dispose();
  }

  // Converte uma data no formato dd/MM/yyyy para DateTime.
  // Essa conversão permite comparar e ordenar as datas.
  // Se a tarefa não possuir data válida, retorna null.
  DateTime? _parseTaskDate(String date) {
    if (date == 'Sem data' || date.trim().isEmpty) {
      return null;
    }

    try {
      if (date.contains('/')) {
        final parts = date.split('/');

        if (parts.length != 3) {
          return null;
        }

        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  // Retorna o ícone correspondente à matéria da tarefa.
  IconData _getSubjectIcon(String subject) {
    switch (subject) {
      case 'Matemática':
        return Icons.calculate_outlined;

      case 'Português':
        return Icons.menu_book_outlined;

      case 'Biologia':
        return Icons.biotech_outlined;

      case 'História':
        return Icons.account_balance_outlined;

      default:
        return Icons.assignment_outlined;
    }
  }

  // Alterna o status da tarefa entre Pendente,
  // Em andamento e Concluída.
  void _changeTaskStatus(int index) {
    setState(() {
      tasks[index]['status'] = tasks[index]['status'] == 'Pendente'
          ? 'Em andamento'
          : tasks[index]['status'] == 'Em andamento'
              ? 'Concluída'
              : 'Pendente';
    });
  }

  // Exibe uma confirmação antes de excluir uma tarefa.
  Future<void> _deleteTask(int index) async {
    // Verifica se o índice é válido.
    if (index < 0 || index >= tasks.length) {
      return;
    }

    // Solicita a confirmação do usuário.
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Excluir tarefa'),
          content: Text(
            'Tem certeza que deseja excluir esta tarefa?',
          ),
          actions: [
            // Cancela a exclusão.
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Cancelar'),
            ),

            // Confirma a exclusão.
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );

    // Remove a tarefa somente após a confirmação.
    if (confirm == true && mounted) {
      setState(() {
        tasks.removeAt(index);
      });
    }
  }

  // Constrói a interface principal da tela de tarefas.
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da tela.
          Text(
            'Minhas tarefas',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.text,
            ),
          ),

          SizedBox(height: 8),

          // Descrição da tela.
          Text(
            'Organize suas atividades e acompanhe cada etapa.',
            style: TextStyle(
              fontSize: 15,
              color: AppTheme.muted,
            ),
          ),

          SizedBox(height: 32),

          // Título da lista e botão para adicionar tarefa.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lista de atividades',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.text,
                ),
              ),

              // Abre o formulário de cadastro.
              ElevatedButton.icon(
                onPressed: _showTaskDialog,
                icon: Icon(Icons.add),
                label: Text('Nova tarefa'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Exibe os filtros disponíveis.
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildFilterChip('Todas'),
              _buildFilterChip('Pendentes'),
              _buildFilterChip('Em andamento'),
              _buildFilterChip('Concluídas'),
            ],
          ),

          SizedBox(height: 24),

          // Exibe as tarefas filtradas.
          // Caso não existam tarefas, mostra uma mensagem.
          Column(
            children: filteredTasks.isEmpty
                ? [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Nenhuma tarefa encontrada.',
                          style: TextStyle(
                            color: AppTheme.muted,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ]
                : filteredTasks.map((task) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: _buildTaskCard(
                        title: task['title'],
                        subject: task['subject'],
                        date: task['date'],
                        status: task['status'],
                        icon: task['icon'],
                      ),
                    );
                  }).toList(),
          ),
        ],
      ),
    );
  }

  // Constrói os filtros e controla qual deles está selecionado.
  Widget _buildFilterChip(String label) {
    // Verifica se o filtro corresponde à seleção atual.
    final bool selected = selectedFilter == label;

    return InkWell(
      // Atualiza o filtro selecionado.
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppTheme.primary : AppTheme.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppTheme.muted,
          ),
        ),
      ),
    );
  }

  // Constrói o cartão visual que representa cada tarefa.
  Widget _buildTaskCard({
    required String title,
    required String subject,
    required String date,
    required String status,
    required IconData icon,
  }) {
    Color statusColor;
    Color statusBackground;

    // Define a cor do status conforme a situação da tarefa.
    switch (status) {
      case 'Concluída':
        statusColor = Color(0xFF45A985);
        statusBackground = Color(0xFFE2F6ED);
        break;

      case 'Em andamento':
        statusColor = Color(0xFF5D91D5);
        statusBackground = Color(0xFFE5F0FF);
        break;

      default:
        statusColor = Color(0xFFE5A23C);
        statusBackground = Color(0xFFFFF2DF);
        break;
    }

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Ícone que representa a matéria.
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color(0xFFEFE8FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: AppTheme.primary,
              size: 22,
            ),
          ),

          SizedBox(width: 16),

          // Exibe o título, a matéria e a data da tarefa.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.text,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  '$subject • $date',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.muted,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12),

          // Exibe o status e os botões de ação da tarefa.
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Indicador visual do status.
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),

              // Localiza a tarefa e abre o formulário de edição.
              IconButton(
                onPressed: () {
                  final index = tasks.indexWhere(
                    (task) => task['title'] == title,
                  );

                  if (index != -1) {
                    _showTaskDialog(taskIndex: index);
                  }
                },
                icon: Icon(Icons.edit_outlined),
                tooltip: 'Editar tarefa',
                color: AppTheme.primary,
              ),

              SizedBox(width: 8),

              // Localiza a tarefa e altera seu status.
              IconButton(
                onPressed: () {
                  final index = tasks.indexWhere(
                    (task) => task['title'] == title,
                  );

                  if (index != -1) {
                    _changeTaskStatus(index);
                  }
                },
                icon: Icon(Icons.refresh_rounded),
                tooltip: 'Alterar status',
                color: AppTheme.primary,
              ),

              // Localiza a tarefa e solicita sua exclusão.
              IconButton(
                onPressed: () {
                  _deleteTask(
                    tasks.indexWhere((task) => task['title'] == title),
                  );
                },
                icon: Icon(Icons.delete_outline_outlined),
                tooltip: 'Excluir tarefa',
                color: Colors.redAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
