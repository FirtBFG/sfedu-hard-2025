import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/core/data/models/device_data.dart';
import 'package:hack_sfedu_2025/core/service/devices_service.dart';
import 'package:hack_sfedu_2025/core/utils/data_aggregator.dart';
import 'package:hack_sfedu_2025/core/enums/time_period.dart';

// TimePeriod enum теперь импортируется из lib/core/enums/time_period.dart

// TimePeriodExtension теперь импортируется из lib/core/enums/time_period.dart

enum SensorType {
  temperature,
  humidity,
  alert,
  fire,
}

class PlotController extends ChangeNotifier {
  TimePeriod _selectedPeriod = TimePeriod.day;
  SensorType _selectedSensorType = SensorType.temperature;

  final DevicesService _devicesService = DevicesService();
  List<Reading> _rawData = []; // Исходные данные с сервера
  List<AggregatedReading> _aggregatedData =
      []; // Агрегированные данные для отображения

  TimePeriod get timePeriod => _selectedPeriod;

  Future<void> fetchData() async {
    try {
      // Получаем сырые данные с сервера (больше лимит для получения достаточного количества данных)
      _rawData = await _devicesService.fetchDeviceData(
        limit: 1000,
        sensorType: _selectedSensorType.name,
        timeframe: _selectedPeriod.serverValue,
      );

      // Агрегируем данные согласно выбранному периоду
      _aggregatedData = DataAggregator.aggregateData(_rawData, _selectedPeriod);

      // Форсируем создание точек данных если их недостаточно
      _ensureMinimumDataPoints();

      notifyListeners();
    } catch (e) {
      print('Error fetching or aggregating data: $e');
      // В случае ошибки, очищаем данные
      _rawData = [];
      _aggregatedData = [];
      notifyListeners();
    }
  }

  /// Обеспечивает минимальное количество точек данных для корректного отображения графика
  void _ensureMinimumDataPoints() {
    final expectedPoints = _getExpectedPointsCount(_selectedPeriod);
    final currentPoints = _aggregatedData.length;

    if (currentPoints < expectedPoints) {
      print(
          'Недостаточно данных: $currentPoints из $expectedPoints точек. Заполняем значениями по умолчанию.');

      // Добавляем точки с последним знаением температуры
      final baseValue = _rawData.isEmpty ? -1.0 : _aggregatedData.last.value;
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: expectedPoints - 1));

      while (_aggregatedData.length < expectedPoints) {
        final currentDay =
            startDate.add(Duration(days: _aggregatedData.length));

        _aggregatedData.add(AggregatedReading(
          timestamp: currentDay,
          value: baseValue,
          sampleCount: 0,
          unit: 'celsius',
          sensorType: 'temperature',
        ));
      }
    }
  }

  // Геттеры для доступа к агрегированным данным
  List<AggregatedReading> get plotData => _aggregatedData;

  double get minValue {
    if (_aggregatedData.isEmpty) return 0;
    return _aggregatedData.map((reading) => reading.value).reduce(min);
  }

  double get maxValue {
    if (_aggregatedData.isEmpty) return 0;
    return _aggregatedData.map((reading) => reading.value).reduce(max);
  }

  // Статистика для отладки
  Map<String, dynamic> get dataStats =>
      DataAggregator.getDataStats(_rawData, _aggregatedData);

  int get rawDataCount => _rawData.length;
  int get aggregatedDataCount => _aggregatedData.length;

  void changePeriod(TimePeriod period) {
    _selectedPeriod = period;
    fetchData(); // Сразу обновляем данные при смене периода
  }

  /// Получает ожидаемое количество точек для текущего периода
  int _getExpectedPointsCount(TimePeriod period) {
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

  String getBottomTitle(int value) {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case TimePeriod.hour:
        final time = now.subtract(Duration(minutes: (11 - value) * 5));
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      case TimePeriod.hours3:
        final time = now.subtract(Duration(minutes: (17 - value) * 10));
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      case TimePeriod.hours6:
        final time = now.subtract(Duration(minutes: (35 - value) * 10));
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      case TimePeriod.hours8:
        final time = now.subtract(Duration(minutes: (47 - value) * 10));
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      case TimePeriod.hours12:
        final time = now.subtract(Duration(minutes: (71 - value) * 10));
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      case TimePeriod.day:
        return '${value.toString().padLeft(2, '0')}:00';
      case TimePeriod.week:
        final date = DateTime.now()
            .subtract(const Duration(days: 6))
            .add(Duration(days: value));
        return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
      case TimePeriod.month:
        final date = DateTime.now()
            .subtract(const Duration(days: 29))
            .add(Duration(days: value));
        return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
    }
  }

  double getInterval() {
    switch (_selectedPeriod) {
      case TimePeriod.hour:
        return 2; // каждые 10 минут (6 подписей)
      case TimePeriod.hours3:
        return 3; // каждые 30 минут (6 подписей)
      case TimePeriod.hours6:
        return 6; // каждый час (6 подписей)
      case TimePeriod.hours8:
        return 8; // каждые 80 минут (6 подписей)
      case TimePeriod.hours12:
        return 12; // каждые 2 часа (6 подписей)
      case TimePeriod.day:
        return 4; // каждые 4 часа (6 подписей)
      case TimePeriod.week:
        return 1; // каждый день (7 подписей)
      case TimePeriod.month:
        return 5; // каждые 5 дней (6 подписей)
    }
  }

  String getTooltipText(int index) {
    if (index >= _aggregatedData.length) return 'Данных нет';

    final reading = _aggregatedData[index];
    final timestamp = reading.timestamp;

    switch (_selectedPeriod) {
      case TimePeriod.hour:
      case TimePeriod.hours3:
      case TimePeriod.hours6:
      case TimePeriod.hours8:
      case TimePeriod.hours12:
        return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}\n${reading.value.toStringAsFixed(1)}°C\n(${reading.sampleCount} измерений)';
      case TimePeriod.day:
        return '${timestamp.hour.toString().padLeft(2, '0')}:00\n${reading.value.toStringAsFixed(1)}°C\n(${reading.sampleCount} измерений)';
      case TimePeriod.week:
      case TimePeriod.month:
        return '${timestamp.day.toString().padLeft(2, '0')}.${timestamp.month.toString().padLeft(2, '0')}\n${reading.value.toStringAsFixed(1)}°C\n(${reading.sampleCount} измерений)';
    }
  }
}
