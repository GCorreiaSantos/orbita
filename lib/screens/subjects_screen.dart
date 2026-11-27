
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/subject_card.dart';
import '../data/task_store.dart';
import '../data/subject_store.dart';

// Tela responsável por exibir e gerenciar as matérias.
class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  // Abre o diálogo de criação ou edição.
  Future<void> _showSubjectDialog(
    BuildContext context, {
    int? index,
  }) async {
    final store = SubjectStore.instance;
    final controller = TextEditingController(
      text: index != null ? store.subjects[index]['name'] : '',
    );

    final isEditing = index != null;

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar matéria' : 'Nova matéria'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Nome da matéria',
              hintText: 'Ex: Física',
            ),
            textCapitalization: TextCapitalization.words,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = controller.text.trim();

                if (name.isEmpty) return;

                Navigator.pop(context, name);
              },
              child: Text(isEditing ? 'Salvar' : 'Adicionar'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (result == null || result.trim().isEmpty) return;

    final newName = result.trim();

    // Evita nomes duplicados.
    final duplicate = store.subjects.any((subject) {
      final existingName = subject['name'].toString().toLowerCase();

      if (isEditing && existingName == 
          store.subjects[index]['name'].toString().toLowerCase()) {
        return false;
      }

      return existingName == newName.toLowerCase();
    });

    if (duplicate) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Essa matéria já existe.')),
      );
      return;
    }

    if (isEditing) {
      final oldName = store.subjects[index]['name'];

      // Atualiza o nome da matéria nas tarefas existentes.
      for (final task in TaskStore.instance.tasks) {
        if (task['subject'] == oldName) {
          task['subject'] = newName;
        }
      }

      store.editSubject(index, newName);
      TaskStore.instance.updateTasks();
    } else {
      store.addSubject(newName);
    }
  }

  // Confirma a exclusão da matéria.
  Future<void> _deleteSubject(
    BuildContext context,
    int index,
  ) async {
    final store = SubjectStore.instance;
    final name = store.subjects[index]['name'];

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir matéria'),
        content: Text(
          'Deseja realmente excluir "$name"? '
          'As tarefas vinculadas não serão apagadas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      store.deleteSubject(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: SubjectStore.instance,
      builder: (context, child) {
        return AnimatedBuilder(
          animation: TaskStore.instance,
          builder: (context, child) {
            final subjects = SubjectStore.instance.subjects;

            return SingleChildScrollView(
              padding: EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Minhas matérias',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.text,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Acompanhe seu progresso em cada disciplina.',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppTheme.muted,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 12),

                      ElevatedButton.icon(
                        onPressed: () => _showSubjectDialog(context),
                        icon: Icon(Icons.add),
                        label: Text('Nova matéria'),
                      ),
                    ],
                  ),

                  SizedBox(height: 32),

                  if (subjects.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'Nenhuma matéria cadastrada.',
                          style: TextStyle(color: AppTheme.muted),
                        ),
                      ),
                    ),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth > 900
                          ? 3
                          : constraints.maxWidth > 600
                              ? 2
                              : 1;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: subjects.length,
                        itemBuilder: (context, index) {
                          final subject = subjects[index];
                          final name = subject['name'] as String;
                          final icon = subject['icon'] as IconData;
                          final color = subject['color'] as Color;

                          final progress =
                              TaskStore.instance.getProgress(name);

                          final taskCount =
                              TaskStore.instance.getTaskCount(name);

                          return Stack(
                            children: [
                              Positioned.fill(
                                child: SubjectCard(
                                  name: name,
                                  icon: icon,
                                  color: color,
                                  progress: progress,
                                  subtitle: '$taskCount atividades',
                                ),
                              ),

                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        tooltip: 'Editar matéria',
                                        icon: Icon(
                                          Icons.edit_outlined,
                                          size: 18,
                                        ),
                                        onPressed: () =>
                                            _showSubjectDialog(
                                          context,
                                          index: index,
                                        ),
                                      ),
                                      IconButton(
                                        tooltip: 'Excluir matéria',
                                        icon: Icon(
                                          Icons.delete_outline,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                        onPressed: () =>
                                            _deleteSubject(
                                          context,
                                          index,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
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
