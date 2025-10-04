import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/feature/statuses_plot/controller/plot_controller.dart';
import 'package:hack_sfedu_2025/feature/statuses_plot/presentation/components/temperature_line_chart_plot.dart';
import 'package:hack_sfedu_2025/feature/statuses_plot/presentation/components/time_period_dropdown_button.dart';
import 'package:provider/provider.dart';

class TemperatureChartCard extends StatelessWidget {
  const TemperatureChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    // тут нужен провайдер для получения данных температуры
    final plotProvider = Provider.of<PlotController>(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: const Text(
                    'Temperature Monitoring',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TimePeriodDropdownButton(plotProvider: plotProvider),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TemperatureLineChartPlot(plotProvider: plotProvider),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
