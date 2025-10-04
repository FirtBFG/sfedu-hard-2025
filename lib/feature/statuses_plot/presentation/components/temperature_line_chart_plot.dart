import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/feature/statuses_plot/controller/plot_controller.dart';

class TemperatureLineChartPlot extends StatelessWidget {
  const TemperatureLineChartPlot({
    super.key,
    required this.plotProvider,
  });

  final PlotController plotProvider;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          horizontalInterval: 2,
          verticalInterval: 4,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withValues(alpha: 0.2),
              strokeWidth: 1,
            );
          },
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        minX: 0,
        maxX: plotProvider.tempDataList.length.toDouble() - 1,
        minY: plotProvider.minTemp - 0.5,
        maxY: plotProvider.maxTemp + 0.5,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              interval: max(
                ((plotProvider.maxTemp - plotProvider.minTemp) / 5)
                    .roundToDouble(),
                0.5, // минимальный интервал
              ),
              getTitlesWidget: (value, meta) {
                // Показываем значение только если оно укладывается в интервал
                if (value > plotProvider.maxTemp + 0.3 ||
                    value < plotProvider.minTemp - 0.3) {
                  return const SizedBox.shrink();
                }
                // Округляем до одного знака после запятой
                return Text(
                  '${value.toStringAsFixed(1)}°C',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 20,
              interval: plotProvider.getInterval(), // добавляем интервал
              getTitlesWidget: (value, meta) {
                // Показываем подписи только для определенных значений
                if (value % plotProvider.getInterval() != 0) {
                  return const SizedBox.shrink();
                }
                return Text(
                  plotProvider.getBottomTitle(value.toInt()),
                  style:
                      const TextStyle(fontSize: 10), // уменьшаем размер шрифта
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withValues(alpha: 0.8),
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((LineBarSpot touchedSpot) {
                return LineTooltipItem(
                  plotProvider.getTooltipText(touchedSpot.x.toInt()),
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              plotProvider.tempDataList.length,
              (index) =>
                  FlSpot(index.toDouble(), plotProvider.tempDataList[index]),
            ),
            isCurved: true,
            curveSmoothness: 0.2, // Уменьшаем округлость линии
            color: Theme.of(context).primaryColor,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}
