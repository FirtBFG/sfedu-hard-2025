// Вставьте это в файл, где определены ваши модели Device, Reading
import 'package:hack_sfedu_2025/core/data/models/device_data.dart';
import 'dart:math';

// Модель для хранения агрегированных данных одного сенсора
class SensorDataSummary {
  final String sensorType;
  final String unit;
  final double latestValue;
  final double minValue;
  final double maxValue;
  final Reading? lastReading; // Полные данные последнего измерения

  SensorDataSummary({
    required this.sensorType,
    required this.unit,
    required this.latestValue,
    required this.minValue,
    required this.maxValue,
    required this.lastReading,
  });

  /// Создает сводку по всем Reading определенного типа сенсора
  static SensorDataSummary fromReadings(String type, List<Reading> readings) {
    final filteredReadings =
        readings.where((r) => r.sensorType == type).toList();

    if (filteredReadings.isEmpty) {
      // Вернуть пустую или заглушку, если данных нет
      return SensorDataSummary(
        sensorType: type,
        unit: 'N/A',
        latestValue: -1.0,
        minValue: 0.0,
        maxValue: 0.0,
        lastReading: null,
      );
    }

    // Сортируем для нахождения самого последнего
    filteredReadings.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final latest = filteredReadings.last;
    final values = filteredReadings.map((r) => r.value);

    return SensorDataSummary(
      sensorType: type,
      unit: latest.unit,
      latestValue: latest.value,
      minValue: values.reduce(min),
      maxValue: values.reduce(max),
      lastReading: latest,
    );
  }
}
