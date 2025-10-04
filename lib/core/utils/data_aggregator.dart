import 'package:hack_sfedu_2025/core/data/models/device_data.dart';
import 'package:hack_sfedu_2025/core/enums/time_period.dart';

/// Класс для агрегации и фильтрации данных с сервера
/// Обрабатывает большие массивы данных с высокой частотой и группирует их по интервалам
class DataAggregator {
  /// Группирует данные по выбранному периоду времени и возвращает агрегированные значения
  // Обновляем публичный метод для использования унифицированной логики
  static List<AggregatedReading> aggregateData(
    List<Reading> rawData,
    TimePeriod period,
  ) {
    // Сортируем сырые данные один раз, чтобы упростить поиск LKV и итерацию
    rawData.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Используем единый метод ресамплинга и заполнения
    return _resampleAndFill(rawData, period);
  }

  /// Агрегация данных по дням для периодов день/неделя/месяц
  // // ?

  // /// Агрегация данных по минутам для часовых периодов
  // static List<AggregatedReading> _aggregateByMinutes(
  //     List<Reading> rawData, TimePeriod period) {
  //   // Определяем интервал группировки в минутах
  //   final intervalMinutes = _getIntervalMinutes(period);

  //   // Создаем мапу для группировки данных
  //   final groupedData = <String, List<Reading>>{};

  //   for (final reading in rawData) {
  //     // Определяем ключ группировки (округленное время)
  //     final roundedTime = _roundToInterval(reading.timestamp, intervalMinutes);
  //     final key = roundedTime.toIso8601String();

  //     // Добавляем в соответствующую группу
  //     groupedData.putIfAbsent(key, () => []).add(reading);
  //   }

  //   // Сортируем ключи по времени
  //   final sortedKeys = groupedData.keys.toList()..sort();

  //   // Создаем список агрегированных данных в нужном количестве точек
  //   final expectedPoints = _getExpectedPointsCount(period);
  //   final aggregatedReadings = <AggregatedReading>[];

  //   // Выбираем нужное количество точек данных (последние N точек)
  //   final startIndex = sortedKeys.length > expectedPoints
  //       ? sortedKeys.length - expectedPoints
  //       : 0;

  //   for (int i = startIndex; i < sortedKeys.length; i++) {
  //     final key = sortedKeys[i];
  //     final readings = groupedData[key]!;

  //     // Агрегируем данные в группе (используем среднее значение)
  //     final avgValue = readings.map((r) => r.value).reduce((a, b) => a + b) /
  //         readings.length;
  //     final timestamp = DateTime.parse(key);

  //     aggregatedReadings.add(AggregatedReading(
  //       timestamp: timestamp,
  //       value: avgValue,
  //       sampleCount: readings.length,
  //       unit: readings.first.unit,
  //       sensorType: readings.first.sensorType,
  //     ));
  //   }

  //   return aggregatedReadings;
  // }

  /// Определяет интервал группировки в минутах в зависимости от периода
  static Duration _getIntervalDuration(TimePeriod period) {
    switch (period) {
      case TimePeriod.hour:
        return const Duration(minutes: 5); // 1 час: каждые 5 минут
      case TimePeriod.hours3:
        return const Duration(minutes: 10); // 3 часа: каждые 10 минут
      case TimePeriod.hours6:
        return const Duration(minutes: 20); // 6 часов: каждые 20 минут
      case TimePeriod.hours8:
        return const Duration(minutes: 30); // 8 часов: каждые 30 минут
      case TimePeriod.hours12:
        return const Duration(minutes: 30); // 12 часов: каждые 30 минут
      case TimePeriod.day:
        return const Duration(hours: 1); // 24 часа: каждый час
      case TimePeriod.week:
        return const Duration(days: 1); // Неделя: каждый день
      case TimePeriod.month:
        return const Duration(days: 1); // Месяц: каждый день
    }
  }

  /// общая длительность периода
  static Duration _getScopeDuration(TimePeriod period) {
    switch (period) {
      case TimePeriod.hour:
        return const Duration(hours: 1);
      case TimePeriod.hours3:
        return const Duration(hours: 3);
      case TimePeriod.hours6:
        return const Duration(hours: 6);
      case TimePeriod.hours8:
        return const Duration(hours: 8);
      case TimePeriod.hours12:
        return const Duration(hours: 12);
      case TimePeriod.day:
        return const Duration(hours: 24);
      case TimePeriod.week:
        return const Duration(days: 7);
      case TimePeriod.month:
        return const Duration(days: 30); // Используем 30 дней для простоты
    }
  }

  /// Округляет время до ближайшего шага интервала.
  static DateTime _roundToInterval(DateTime timestamp, Duration interval) {
    final intervalMinutes = interval.inMinutes;

    // Для интервалов >= 1 час, округляем до ближайшего часа/дня
    if (intervalMinutes >= 60 * 24) {
      return DateTime(timestamp.year, timestamp.month, timestamp.day);
    } else if (intervalMinutes >= 60) {
      return DateTime(
          timestamp.year, timestamp.month, timestamp.day, timestamp.hour);
    }

    // Для интервалов < 1 часа
    final totalMinutes = timestamp.hour * 60 + timestamp.minute;
    final roundedTotalMinutes =
        (totalMinutes ~/ intervalMinutes) * intervalMinutes;

    final roundedHour = roundedTotalMinutes ~/ 60;
    final roundedMinute = roundedTotalMinutes % 60;

    return DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
      roundedHour,
      roundedMinute,
      0, // Обнуляем секунды/миллисекунды
      0,
    );
  }

  /// Основной метод для агрегации, ресамплинга и заполнения пропусков (Forward Fill).
  static List<AggregatedReading> _resampleAndFill(
      List<Reading> rawData, TimePeriod period) {
    if (rawData.isEmpty) {
      // Если нет данных вообще, возвращаем пустой список
      return [];
    }

    // 1. Получаем параметры
    final scopeDuration = _getScopeDuration(period);
    final resampleInterval = _getIntervalDuration(period);

    final now = DateTime.now();
    final startTime = now.subtract(scopeDuration);

    // 2. Находим начальное Last Known Value (LKV) и шаблон данных
    double lastKnownValue = -1.0;
    // Ищем последнее значение, которое было ДО начала просмотра.
    final dataBeforeScope = rawData
        .where((item) => item.timestamp.isBefore(startTime))
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (dataBeforeScope.isNotEmpty) {
      lastKnownValue = dataBeforeScope.last.value;
    }

    // Используем любую точку как шаблон для unit/sensorType
    final templateReading = rawData.first;
    final unit = templateReading.unit;
    final sensorType = templateReading.sensorType;

    // 3. Создаем Сетку Времени (Time Grid)
    List<AggregatedReading> finalData = [];

    // Определяем начальную точку сетки, округленную к шагу
    DateTime currentTime = _roundToInterval(startTime, resampleInterval);

    // Убедимся, что сетка начинается не позже, чем startTime
    while (currentTime.isBefore(startTime)) {
      currentTime = currentTime.add(resampleInterval);
    }

    // 4. Итерация по сетке и Forward Fill
    // Мы ищем данные, попавшие в интервал [currentTime, nextTime)
    int currentRawIndex = 0;

    while (currentTime.isBefore(now) || currentTime.isAtSameMomentAs(now)) {
      final nextTime = currentTime.add(resampleInterval);

      List<Reading> intervalData = [];

      // Эффективно ищем данные, двигаясь вперед по отсортированному rawData
      while (currentRawIndex < rawData.length &&
          rawData[currentRawIndex].timestamp.isBefore(nextTime)) {
        if (rawData[currentRawIndex].timestamp.isAfter(currentTime) ||
            rawData[currentRawIndex].timestamp.isAtSameMomentAs(currentTime)) {
          intervalData.add(rawData[currentRawIndex]);
        }
        currentRawIndex++;
      }

      double value;
      int sampleCount;

      if (intervalData.isNotEmpty) {
        // A. Данные есть: берем среднее значение
        final sum = intervalData.map((r) => r.value).reduce((a, b) => a + b);
        value = sum / intervalData.length;
        sampleCount = intervalData.length;

        // Обновляем LKV для следующего интервала
        lastKnownValue = value;
      } else {
        // B. Данных нет: используем последнее известное значение (LKV)
        value = lastKnownValue;
        sampleCount = 0; // Нет новых данных в этом интервале
      }

      // Добавляем точку в финальный список
      finalData.add(AggregatedReading(
        timestamp: currentTime,
        value: value,
        sampleCount: sampleCount,
        unit: unit,
        sensorType: sensorType,
      ));

      // Переходим к следующей точке сетки
      currentTime = nextTime;
    }

    return finalData;
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
