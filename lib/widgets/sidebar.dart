import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/subject_store.dart';

// Widget responsável pela barra lateral de navegação.
class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.white,
      padding:  EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 32,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo.
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:  Center(
                    child: Text(
                      'ó',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                 SizedBox(width: 12),

                Text(
                  'órbita',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.text,
                  ),
                ),
              ],
            ),

             SizedBox(height: 48),

            // Menu principal.
            Text(
              'SEU ESPAÇO',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.muted,
              ),
            ),

             SizedBox(height: 16),

            _menuItem(
              icon: Icons.grid_view_rounded,
              label: 'Visão geral',
              index: 0,
            ),

             SizedBox(height: 8),

            _menuItem(
              icon: Icons.task_alt_outlined,
              label: 'Minhas tarefas',
              index: 1,
            ),

             SizedBox(height: 8),

            _menuItem(
              icon: Icons.menu_book_outlined,
              label: 'Minhas matérias',
              index: 2,
            ),

             SizedBox(height: 40),

            // Lista dinâmica de matérias.
            Text(
              'MINHAS MATÉRIAS',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.muted,
              ),
            ),

             SizedBox(height: 20),

            AnimatedBuilder(
              animation: SubjectStore.instance,
              builder: (context, child) {
                final subjects = SubjectStore.instance.subjects;

                if (subjects.isEmpty) {
                  return Text(
                    'Nenhuma matéria cadastrada.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.muted,
                    ),
                  );
                }

                return Column(
                  children: subjects.map((subject) {
                    final name = subject['name'] as String;

                    return _subjectItem(
                      name,
                      SubjectStore.instance.getColor(name),
                    );
                  }).toList(),
                );
              },
            ),

             SizedBox(height: 40),

            // Mensagem motivacional.
            Container(
              width: double.infinity,
              padding:  EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:  Color(0xFFF5F1FC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Um passo de cada vez.',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),

                   SizedBox(height: 8),

                  Text(
                    'Seu futuro começa com o que você estuda hoje.',
                    style: TextStyle(
                      color: AppTheme.muted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

             SizedBox(height: 24),

            // Perfil.
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ana Ferreira',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.text,
                    ),
                  ),
                ),

                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.muted,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Item de navegação.
  Widget _menuItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool selected = selectedIndex == index;

    return InkWell(
      onTap: () => onItemSelected(index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding:  EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: selected
              ?  Color(0xFFF0EAF8)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: selected
                  ? AppTheme.primary
                  : AppTheme.muted,
            ),

             SizedBox(width: 16),

            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.normal,
                color: selected
                    ? AppTheme.primary
                    : AppTheme.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Item visual de matéria.
  Widget _subjectItem(String name, Color color) {
    return Padding(
      padding:  EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

           SizedBox(width: 16),

          Expanded(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                color: AppTheme.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}