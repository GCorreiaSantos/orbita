
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Widget responsável por construir a barra lateral de navegação.
// Recebe o índice da página selecionada e a função de navegação.
class Sidebar extends StatelessWidget {
  // Indica qual página está selecionada no momento.
  final int selectedIndex;

  // Função que comunica ao widget principal qual item foi clicado.
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Container define o tamanho, o fundo e o espaçamento da sidebar.
    return Container(
      width: 260,
      color: Colors.white,
      padding:  EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 32,
      ),
      child: SingleChildScrollView(
        // Permite rolar o conteúdo caso não caiba na altura da tela.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Área da logo e nome do Órbita.
            Row(
              children: [
                // Símbolo da logo.
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

                // Nome do aplicativo.
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

            // Título da área de navegação.
             Text(
              'SEU ESPAÇO',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.muted,
              ),
            ),

             SizedBox(height: 16),

            // Item de navegação para o Dashboard.
            _menuItem(
              icon: Icons.grid_view_rounded,
              label: 'Visão geral',
              index: 0,
            ),

             SizedBox(height: 8),

            // Item de navegação para a tela de tarefas.
            _menuItem(
              icon: Icons.task_alt_outlined,
              label: 'Minhas tarefas',
              index: 1,
            ),

             SizedBox(height: 8),

            // Item de navegação para a tela de matérias.
            _menuItem(
              icon: Icons.menu_book_outlined,
              label: 'Minhas matérias',
              index: 2,
            ),

             SizedBox(height: 40),

            // Título da lista visual de matérias.
             Text(
              'MINHAS MATÉRIAS',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppTheme.muted,
              ),
            ),

             SizedBox(height: 20),

            // Exibe as matérias com suas respectivas cores.
            _subjectItem('Matemática',  Color(0xFF9A83E5)),
            _subjectItem('Português',  Color(0xFF5B9D97)),
            _subjectItem('Biologia',  Color(0xFFD09A4D)),
            _subjectItem('História',  Color(0xFFD17D9E)),

             SizedBox(height: 40),

            // Card com uma mensagem motivacional.
            Container(
              width: double.infinity,
              padding:  EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:  Color(0xFFF5F1FC),
                borderRadius: BorderRadius.circular(20),
              ),
              child:  Column(
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

            // Área de identificação do perfil.
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

  // Constrói um item do menu lateral.
  // Recebe o ícone, o nome e o índice da página.
  Widget _menuItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    // Compara o índice do item com a página selecionada.
    // Se forem iguais, o item recebe o estilo de selecionado.
    final bool selected = selectedIndex == index;

    return InkWell(
      // Executa a função recebida quando o item é clicado.
      onTap: () {
        onItemSelected(index);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding:  EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          // Muda o fundo conforme o item selecionado.
          color: selected
              ?  Color(0xFFF0EAF8)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Ícone muda de cor conforme a seleção.
            Icon(
              icon,
              size: 24,
              color: selected
                  ? AppTheme.primary
                  : AppTheme.muted,
            ),

            SizedBox(width: 16),

            // Nome do item com estilo diferente quando selecionado.
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

  // Constrói um item visual da lista de matérias.
  // Recebe o nome da matéria e a cor que será utilizada.
  Widget _subjectItem(String name, Color color) {
    return Padding(
      padding:  EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          // Círculo colorido que identifica visualmente a matéria.
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

          SizedBox(width: 16),

          // Nome da matéria.
          Text(
            name,
            style: TextStyle(
              fontSize: 15,
              color: AppTheme.muted,
            ),
          ),
        ],
      ),
    );
  }
}
