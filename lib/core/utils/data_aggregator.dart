import 'package:hack_sfedu_2025/core/data/models/device_data.dart';
import 'package:hack_sfedu_2025/core/enums/time_period.dart';

/// Класс для агрегации и фильтрации данных с сервера
/// Обрабатывает большие массивы данных с высокой частотой и группирует их по интервалам
class DataAggregator {
  /// Группирует данные по выбранному периоду времени и возвращает агрегированные значения
  static List<AggregatedReading> aggregateData(
    List<Reading> rawData,
    TimePeriod period,
  ) {
    if (rawData.isEmpty) return [];

    // Для периодов день/неделя/месяц используем специальную логику
    if (period == TimePeriod.week || period == TimePeriod.month) {
      return _aggregateByDays(rawData, period);
    }

    // Для часовых периодов используем старую логику с минутами
    return _aggregateByMinutes(rawData, period);
  }

  /// Агрегация данных по дням для периодов день/неделя/месяц
  static List<AggregatedReading> _aggregateByDays(
      List<Reading> rawData, TimePeriod period) {
    final expectedDays = _getExpectedPointsCount(period);
    final aggregatedReadings = <AggregatedReading>[];

    // Получаем диапазон дней
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: expectedDays - 1));

    // Сортируем данные по времени
    rawData.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Группируем данные по дням
    final dailyData = <DateTime, List<Reading>>{};
    for (final reading in rawData) {
      // Округляем до начала дня
      final dayStart = DateTime(reading.timestamp.year, reading.timestamp.month,
          reading.timestamp.day);

      // Проверяем, попадает ли день в наш диапазон
      if (dayStart.isAfter(startDate.subtract(const Duration(days: 1))) &&
          dayStart.isBefore(endDate.add(const Duration(days: 1)))) {
        dailyData.putIfAbsent(dayStart, () => []).add(reading);
      }
    }

    // Создаем точки для каждого дня в диапазоне
    for (int i = 0; i < expectedDays; i++) {
      final currentDay = startDate.add(Duration(days: i)).copyWith(
          hour: 0, microsecond: 0, millisecond: 0, minute: 0, second: 0);

      final dayData = dailyData[currentDay];

      if (dayData != null && dayData.isNotEmpty) {
        // Если есть данные за этот день, вычисляем среднее
        final avgValue = dayData.map((r) => r.value).reduce((a, b) => a + b) /
            dayData.length;

        aggregatedReadings.add(AggregatedReading(
          timestamp: currentDay,
          value: avgValue,
          sampleCount: dayData.length,
          unit: dayData.first.unit,
          sensorType: dayData.first.sensorType,
        ));
      } else {
        // Если данных нет за этот день, создаем точку с последним известным значением
        double defaultValue = aggregatedReadings.isNotEmpty
            ? aggregatedReadings.last.value
            : -1.0; // базовое значение температуры

        aggregatedReadings.add(AggregatedReading(
          timestamp: currentDay,
          value: defaultValue,
          sampleCount: 0, // указываем что данных нет
          unit: 'celsius',
          sensorType: 'temperature',
        ));
      }
    }

    return aggregatedReadings;
  }

  /// Агрегация данных по минутам для часовых периодов
  static List<AggregatedReading> _aggregateByMinutes(
      List<Reading> rawData, TimePeriod period) {
    // Определяем интервал группировки в минутах
    final intervalMinutes = _getIntervalMinutes(period);

    // Создаем мапу для группировки данных
    final groupedData = <String, List<Reading>>{};

    for (final reading in rawData) {
      // Определяем ключ группировки (округленное время)
      final roundedTime = _roundToInterval(reading.timestamp, intervalMinutes);
      final key = roundedTime.toIso8601String();

      // Добавляем в соответствующую группу
      groupedData.putIfAbsent(key, () => []).add(reading);
    }

    // Сортируем ключи по времени
    final sortedKeys = groupedData.keys.toList()..sort();

    // Создаем список агрегированных данных в нужном количестве точек
    final expectedPoints = _getExpectedPointsCount(period);
    final aggregatedReadings = <AggregatedReading>[];

    // Выбираем нужное количество точек данных (последние N точек)
    final startIndex = sortedKeys.length > expectedPoints
        ? sortedKeys.length - expectedPoints
        : 0;

    for (int i = startIndex; i < sortedKeys.length; i++) {
      final key = sortedKeys[i];
      final readings = groupedData[key]!;

      // Агрегируем данные в группе (используем среднее значение)
      final avgValue = readings.map((r) => r.value).reduce((a, b) => a + b) /
          readings.length;
      final timestamp = DateTime.parse(key);

      aggregatedReadings.add(AggregatedReading(
        timestamp: timestamp,
        value: avgValue,
        sampleCount: readings.length,
        unit: readings.first.unit,
        sensorType: readings.first.sensorType,
      ));
    }

    return aggregatedReadings;
  }

  /// Определяет интервал группировки в минутах в зависимости от периода
  static int _getIntervalMinutes(TimePeriod period) {
    switch (period) {
      case TimePeriod.hour:
        return 5; // Каждые 5 минут
      case TimePeriod.hours3:
        return 10; // Каждые 10 минут
      case TimePeriod.hours6:
        return 10; // Каждые 10 минут
      case TimePeriod.hours8:
        return 10; // Каждые 10 минут
      case TimePeriod.hours12:
        return 10; // Каждые 10 минут
      case TimePeriod.day:
        return 60; // Каждый час
      case TimePeriod.week:
        return 1440; // Каждый день (24*60 минут)
      case TimePeriod.month:
        return 1440; // Каждый день
    }
  }

  /// Определяет ожидаемое количество точек данных для каждого периода
  static int _getExpectedPointsCount(TimePeriod period) {
    switch (period) {
      case TimePeriod.hour:
        return 12; // 12 точек за час (каждые 5 минут)
      case TimePeriod.hours3:
        return 18; // 18 точек за 3 часа (каждые 10 минут)
      case TimePeriod.hours6:
        return 36; // 36 точек за 6 часов
      case TimePeriod.hours8:
        return 48; // 48 точек за 8 часов
      case TimePeriod.hours12:
        return 72; // 72 точки за 12 часов
      case TimePeriod.day:
        return 24; // 24 точки за день (каждый час)
      case TimePeriod.week:
        return 7; // 7 дней в неделе
      case TimePeriod.month:
        return 30; // 30 дней в месяце
    }
  }

  /// Округляет время до ближайшего интервала
  static DateTime _roundToInterval(DateTime timestamp, int intervalMinutes) {
    final minutes = timestamp.minute;
    final roundedMinutes = (minutes ~/ intervalMinutes) * intervalMinutes;

    return DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
      timestamp.hour,
      roundedMinutes,
      0,
      0,
    );
  }

  /// Получает статистику по данным для отладки
  static Map<String, dynamic> getDataStats(
      List<Reading> rawData, List<AggregatedReading> aggregatedData) {
    if (rawData.isEmpty) return {'rawCount': 0, 'aggregatedCount': 0};

    final minTimestamp =
        rawData.map((r) => r.timestamp).reduce((a, b) => a.isBefore(b) ? a : b);
    final maxTimestamp =
        rawData.map((r) => r.timestamp).reduce((a, b) => a.isAfter(b) ? a : b);

    return {
      'rawCount': rawData.length,
      'aggregatedCount': aggregatedData.length,
      'compressionRatio': rawData.length / aggregatedData.length,
      'timeSpan': maxTimestamp.difference(minTimestamp).inMinutes,
      'minTimestamp': minTimestamp.toIso8601String(),
      'maxTimestamp': maxTimestamp.toIso8601String(),
    };
  }
}

// Enum TimePeriod теперь импортируется из PlotController

/// Модель для агрегированных данных
class AggregatedReading {
  final DateTime timestamp;
  final double value;
  final int sampleCount; // Количество исходных измерений в этой точке
  final String unit;
  final String sensorType;

  AggregatedReading({
    required this.timestamp,
    required this.value,
    required this.sampleCount,
    required this.unit,
    required this.sensorType,
  });

  @override
  String toString() {
    return 'AggregatedReading(timestamp: $timestamp, value: $value, samples: $sampleCount)';
  }
}
