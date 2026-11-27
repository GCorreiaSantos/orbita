
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Widget reutilizável que exibe informações e progresso de uma matéria.
class SubjectCard extends StatelessWidget {
  // Dados que serão exibidos no cartão.
  final String name;
  final IconData icon;
  final Color color;
  final double progress;
  final String subtitle;

  // Construtor que recebe as informações da matéria.
  SubjectCard({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.progress,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    // Container cria o cartão e define seu espaçamento e aparência.
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Linha superior com ícone e nome da matéria.
          Row(
            children: [
              // Container cria o fundo do ícone.
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),

              SizedBox(width: 12),

              // Expanded permite que o nome ocupe o espaço disponível.
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.text,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Exibe a descrição ou quantidade de atividades.
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.muted,
            ),
          ),

          SizedBox(height: 12),

          // Barra que representa visualmente o progresso da matéria.
          // ClipRRect arredonda as bordas da barra.
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              // Limita o progresso entre 0 e 1.
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),

          SizedBox(height: 8),

          // Converte o progresso decimal para porcentagem.
          // Exemplo: 0.75 será exibido como 75%.
          Text(
            '${(progress * 100).round()}% concluído',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
