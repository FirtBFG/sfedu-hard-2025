import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/core/enums/sensor_type.dart';
import 'package:hack_sfedu_2025/feature/statuses_plot/controller/plot_controller.dart';
import 'package:hack_sfedu_2025/feature/statuses_plot/presentation/components/temperature_line_chart_plot.dart';
import 'package:hack_sfedu_2025/feature/statuses_plot/presentation/components/time_period_dropdown_button.dart';
import 'package:provider/provider.dart';

class TemperatureChartCard extends StatelessWidget {
  const TemperatureChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final plotProvider = Provider.of<PlotController>(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Мониторинг датчиков',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TimePeriodDropdownButton(plotProvider: plotProvider),
                    SensorTypeDropdownButton(plotProvider: plotProvider),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: _buildChartContent(plotProvider),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContent(PlotController plotProvider) {
    if (plotProvider.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Загрузка данных...'),
          ],
        ),
      );
    }

    if (plotProvider.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              plotProvider.errorMessage ?? 'Ошибка загрузки данных',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => plotProvider.refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
          ],
        ),
      );
    }

    if (plotProvider.plotData.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.not_interested_outlined, color: Colors.grey, size: 48),
            SizedBox(height: 16),
            Text(
              'Нет данных для отображения',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return TemperatureLineChartPlot(plotProvider: plotProvider);
  }
}

class SensorTypeDropdownButton extends StatelessWidget {
  const SensorTypeDropdownButton({
    super.key,
    required this.plotProvider,
  });

  final PlotController plotProvider;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<SensorType>(
      value: plotProvider.sensorType,
      items: [
        DropdownMenuItem(
          value: SensorType.humidity,
          child: Text('Влажность'),
        ),
        DropdownMenuItem(
          value: SensorType.temperature,
          child: Text('Температура'),
        ),
        DropdownMenuItem(
          value: SensorType.fire,
          child: Text('Возгорания'),
        ),
      ],
      onChanged: (value) {
        plotProvider.changeSensorType(value ?? SensorType.temperature);
      },
    );
  }
}
