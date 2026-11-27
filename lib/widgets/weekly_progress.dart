
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Widget responsável por exibir o gráfico de progresso semanal.
class WeeklyProgress extends StatelessWidget {
  const WeeklyProgress({super.key});

  @override
  Widget build(BuildContext context) {
    // Dias da semana que serão exibidos abaixo das barras.
    final days = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

    // Valores de exemplo que definem a altura de cada barra.
    // Os valores variam de 0 a 1, representando proporções.
    final values = [0.45, 0.75, 0.55, 0.90, 0.35, 0.65, 0.25];

    // Container cria o cartão que envolve o gráfico.
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título do gráfico.
          Text(
            'Progresso semanal',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.text,
            ),
          ),

          SizedBox(height: 8),

          // Descrição do gráfico.
          Text(
            'Sua atividade ao longo da semana',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.muted,
            ),
          ),

          SizedBox(height: 28),

          // Define a altura total da área do gráfico.
          SizedBox(
            height: 180,
            child: Row(
              // Alinha as barras na parte inferior.
              crossAxisAlignment: CrossAxisAlignment.end,

              // Gera uma barra para cada dia da semana.
              children: List.generate(days.length, (index) {
                return Expanded(
                  child: Padding(
                    // Espaçamento horizontal entre as barras.
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Área que permite ajustar a altura da barra.
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,

                            // Define a altura da barra conforme o valor do dia.
                            child: FractionallySizedBox(
                              heightFactor: values[index],
                              widthFactor: 1,
                              child: Container(
                                // Aparência da barra do gráfico.
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withValues(alpha: 0.85),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 12),

                        // Exibe a abreviação do dia correspondente.
                        Text(
                          days[index],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
