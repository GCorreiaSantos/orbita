
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Widget responsável por exibir um cartão com uma estatística do dashboard.
// Como não possui alterações de estado, utiliza StatelessWidget.
class StatCard extends StatelessWidget {
  // Informações que serão exibidas no cartão.
  final String title;
  final String value;
  final String subtitle;

  // Ícone e cores utilizados na parte visual do cartão.
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

  // Construtor que recebe os dados necessários para montar o cartão.
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {
    // Container cria o cartão e define seu espaçamento e aparência.
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        // Organiza os elementos do cartão na vertical.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Linha superior com o título e o ícone.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expanded permite que o título ocupe o espaço disponível.
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.muted,
                  ),
                ),
              ),

              // Container cria o fundo do ícone.
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
            ],
          ),

          // Espaçamento entre o título e o valor.
          SizedBox(height: 12),

          // Exibe o valor principal da estatística.
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppTheme.text,
            ),
          ),

          // Espaçamento entre o valor e a descrição.
          SizedBox(height: 8),

          // Exibe uma descrição complementar.
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.muted,
            ),
          ),
        ],
      ),
    );
  }
}
