
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/subject_card.dart';

// Tela responsável por exibir as matérias e o progresso de cada uma.
// Como os dados são apenas demonstrativos, utiliza StatelessWidget.
class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista com os dados das matérias exibidas na tela.
    // Cada matéria possui nome, ícone, cor, progresso e descrição.
    final subjects = [
      {
        'name': 'Matemática',
        'icon': Icons.calculate_outlined,
        'color': Color(0xFF7561D8),
        'progress': 0.75,
        'subtitle': '12 atividades',
      },
      {
        'name': 'Português',
        'icon': Icons.menu_book_outlined,
        'color': Color(0xFFE58B65),
        'progress': 0.60,
        'subtitle': '8 atividades',
      },
      {
        'name': 'Biologia',
        'icon': Icons.biotech_outlined,
        'color': Color(0xFF45A985),
        'progress': 0.40,
        'subtitle': '5 atividades',
      },
      {
        'name': 'História',
        'icon': Icons.account_balance_outlined,
        'color': Color(0xFF5D91D5),
        'progress': 0.85,
        'subtitle': '10 atividades',
      },
    ];

    // SingleChildScrollView permite rolar a tela caso o conteúdo ultrapasse
    // o espaço disponível.
    return SingleChildScrollView(
      padding: EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da tela.
          Text(
            'Minhas matérias',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.text,
            ),
          ),

          SizedBox(height: 8),

          // Texto de apresentação da tela.
          Text(
            'Acompanhe seu progresso em cada disciplina.',
            style: TextStyle(
              fontSize: 15,
              color: AppTheme.muted,
            ),
          ),

          SizedBox(height: 32),

          // LayoutBuilder verifica o espaço disponível
          // para ajustar a quantidade de colunas.
          LayoutBuilder(
            builder: (context, constraints) {
              // Define a quantidade de colunas conforme a largura da tela.
              final columns = constraints.maxWidth > 900
                  ? 3
                  : constraints.maxWidth > 600
                      ? 2
                      : 1;

              // GridView.builder monta os cartões em uma grade.
              return GridView.builder(
                // Permite que a grade ocupe o espaço necessário
                // dentro da rolagem principal.
                shrinkWrap: true,

                // Evita que a grade tenha uma rolagem própria.
                physics: NeverScrollableScrollPhysics(),

                // Define o formato e o espaçamento dos cartões.
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.5,
                ),

                // Informa quantos cartões serão criados.
                itemCount: subjects.length,

                // Monta cada cartão de acordo com os dados da matéria.
                itemBuilder: (context, index) {
                  final subject = subjects[index];

                  // Reutiliza o widget SubjectCard para exibir a matéria.
                  return SubjectCard(
                    name: subject['name'] as String,
                    icon: subject['icon'] as IconData,
                    color: subject['color'] as Color,
                    progress: subject['progress'] as double,
                    subtitle: subject['subtitle'] as String,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
