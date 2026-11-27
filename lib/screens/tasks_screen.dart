
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/task_store.dart';
import '../data/subject_store.dart';

// Esta tela permite cadastrar, editar, excluir e organizar tarefas.
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TasksScreen> {
  String selectedFilter = 'Todas';

  List<Map<String, dynamic>> get tasks => TaskStore.instance.tasks;

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

  Future<void> _showTaskDialog({int? taskIndex}) async {
    final bool isEditing = taskIndex != null;

    final titleController = TextEditingController(
      text: isEditing ? tasks[taskIndex]['title'] : '',
    );

    final dateController = TextEditingController(
      text: isEditing ? tasks[taskIndex]['date'] : '',
    );

    final subjects = SubjectStore.instance.subjects;

    String selectedSubject = isEditing
        ? tasks[taskIndex]['subject']
        : subjects.isNotEmpty
            ? subjects.first['name']
            : '';

    String selectedStatus =
        isEditing ? tasks[taskIndex]['status'] : 'Pendente';

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final currentSubjects = SubjectStore.instance.subjects;

            // Garante que uma matéria antiga ainda possa ser selecionada.
            final subjectNames = currentSubjects
                .map((subject) => subject['name'].toString())
                .toList();

            if (selectedSubject.isNotEmpty &&
                !subjectNames.contains(selectedSubject)) {
              subjectNames.add(selectedSubject);
            }

            return AlertDialog(
              title: Text(isEditing ? 'Editar tarefa' : 'Nova tarefa'),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          labelText: 'Nome da tarefa',
                          hintText: 'Ex: Exercícios de matemática',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      SizedBox(height: 16),

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

                          if (selectedDate != null) {
                            final day =
                                selectedDate.day.toString().padLeft(2, '0');

                            final month =
                                selectedDate.month.toString().padLeft(2, '0');

                            dateController.text =
                                '$day/$month/${selectedDate.year}';
                          }
                        },
                      ),

                      SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: subjectNames.contains(selectedSubject)
                            ? selectedSubject
                            : null,
                        decoration: InputDecoration(
                          labelText: 'Matéria',
                          border: OutlineInputBorder(),
                        ),
                        items: subjectNames.map((subject) {
                          return DropdownMenuItem<String>(
                            value: subject,
                            child: Text(subject),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setDialogState(() {
                              selectedSubject = value;
                            });
                          }
                        },
                      ),

                      SizedBox(height: 16),

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
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (value) {
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
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                ),

                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty ||
                        selectedSubject.isEmpty) {
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

    if (result != null && mounted) {
      setState(() {
        if (isEditing) {
          tasks[taskIndex] = {
            ...tasks[taskIndex],
            ...result,
            'icon': SubjectStore.instance.getIcon(result['subject']),
          };
        } else {
          tasks.add({
            ...result,
            'icon': SubjectStore.instance.getIcon(result['subject']),
          });
        }

        TaskStore.instance.updateTasks();
      });
    }

    titleController.dispose();
    dateController.dispose();
  }

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

  IconData _getSubjectIcon(String subject) {
    return SubjectStore.instance.getIcon(subject);
  }

  void _changeTaskStatus(int index) {
    setState(() {
      tasks[index]['status'] = tasks[index]['status'] == 'Pendente'
          ? 'Em andamento'
          : tasks[index]['status'] == 'Em andamento'
              ? 'Concluída'
              : 'Pendente';

      TaskStore.instance.updateTasks();
    });
  }

  Future<void> _deleteTask(int index) async {
    if (index < 0 || index >= tasks.length) {
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Excluir tarefa'),
          content: Text(
            'Tem certeza que deseja excluir esta tarefa?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Cancelar'),
            ),

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

    if (confirm == true && mounted) {
      setState(() {
        tasks.removeAt(index);
        TaskStore.instance.updateTasks();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: SubjectStore.instance,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 600;

            return SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Minhas tarefas',
                    style: TextStyle(
                      fontSize: isMobile ? 26 : 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.text,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    'Organize suas atividades e acompanhe cada etapa.',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.muted,
                    ),
                  ),

                  SizedBox(height: 32),

                  isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Lista de atividades',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.text,
                              ),
                            ),

                            SizedBox(height: 16),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: SubjectStore.instance.subjects.isEmpty
                                    ? null
                                    : _showTaskDialog,
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
                            ),
                          ],
                        )
                      : Row(
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

                            ElevatedButton.icon(
                              onPressed: SubjectStore.instance.subjects.isEmpty
                                  ? null
                                  : _showTaskDialog,
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
                                icon: task['icon'] ??
                                    _getSubjectIcon(task['subject']),
                              ),
                            );
                          }).toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(String label) {
    final bool selected = selectedFilter == label;

    return InkWell(
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

  // Constrói o cartão adaptável para celular e computador.
  Widget _buildTaskCard({
    required String title,
    required String subject,
    required String date,
    required String status,
    required IconData icon,
  }) {
    Color statusColor;
    Color statusBackground;

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

    Widget statusBadge() {
      return Container(
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
      );
    }

    Widget actionButtons() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
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
      );
    }

    Widget taskInfo() {
      return Row(
        children: [
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
        ],
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;

        return Container(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    taskInfo(),

                    SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        statusBadge(),
                        actionButtons(),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: taskInfo()),

                    SizedBox(width: 16),

                    statusBadge(),

                    SizedBox(width: 12),

                    actionButtons(),
                  ],
                ),
        );
      },
    );
  }
}
