import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Widget responsável por exibir um cartão com uma estatística do dashboard.
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;

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
    return Container(
      padding:  EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título e ícone.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:  TextStyle(
                    fontSize: 14,
                    color: AppTheme.muted,
                  ),
                ),
              ),

               SizedBox(width: 8),

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

           SizedBox(height: 12),

          // Valor com animação de transição.
          AnimatedSwitcher(
            duration:  Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin:  Offset(0, 0.15),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Text(
              value,
              key: ValueKey(value),
              style:  TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppTheme.text,
              ),
            ),
          ),

           SizedBox(height: 8),

          // Descrição complementar.
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:  TextStyle(
              fontSize: 12,
              color: AppTheme.muted,
            ),
          ),
        ],
      ),
    );
  }
}