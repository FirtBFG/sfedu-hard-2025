import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/core/data/models/device_data.dart';
import 'package:hack_sfedu_2025/core/enums/sensor_type.dart';
import 'package:hack_sfedu_2025/core/service/devices_service.dart';
import 'package:hack_sfedu_2025/core/utils/data_aggregator.dart';
import 'package:hack_sfedu_2025/core/enums/time_period.dart';

class PlotController extends ChangeNotifier {
  TimePeriod _selectedPeriod = TimePeriod.day;
  SensorType _selectedSensorType = SensorType.temperature;

  final DevicesService _devicesService = DevicesService();
  List<Reading> _rawData = []; // Исходные данные с сервера
  List<AggregatedReading> _aggregatedData =
      []; // Агрегированные данные для отображения

  bool _isLoading = true; // Состояние загрузки
  String? _errorMessage; // Сообщение об ошибке

  TimePeriod get timePeriod => _selectedPeriod;
  SensorType get sensorType => _selectedSensorType;
  bool get isLoading => _isLoading;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;
  List<Reading> get rawData => _rawData;

  Future<void> fetchData() async {
    _setLoading(true);

    try {
      _rawData = await _devicesService.fetchDeviceData(
        limit: 1000,
        sensorType: _selectedSensorType.name,
        timeframe: _selectedPeriod.serverValue,
      );

      // Агрегируем данные. Теперь Da.taAggregator гарантирует полную сетку.
      _aggregatedData = DataAggregator.aggregateData(_rawData, _selectedPeriod);

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      print('Error fetching or aggregating data: $e');
      // В случае ошибки, очищаем данные
      _rawData = [];
      _aggregatedData = [];
      _setError('Ошибка загрузки данных: $e');
      notifyListeners();
    }
  }

  /// Управляет состоянием загрузки
  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      _errorMessage = null; // Очищаем ошибки при начале загрузки
    }
  }

  /// Устанавливает ошибку
  void _setError(String error) {
    _isLoading = false;
    _errorMessage = error;
  }

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
    if (_selectedPeriod != period) {
      _selectedPeriod = period;
      fetchData();
    }
  }

  void changeSensorType(SensorType sensorType) {
    if (_selectedSensorType != sensorType) {
      _selectedSensorType = sensorType;
      fetchData();
    }
  }

  /// Принудительная перезагрузка данных
  Future<void> refresh() async {
    await fetchData();
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

  String getLeftTitle(double value) {
    switch (_selectedSensorType) {
      case SensorType.humidity:
        return '$value%';
      case SensorType.temperature:
        return '${value.toStringAsFixed(1)}°C';
      case SensorType.alert:
        return '$value%';
      case SensorType.fire:
        return '$value ед.';
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

    String simb = '';
    if (_selectedSensorType == SensorType.temperature) {
      simb = '°C';
    } else if (_selectedSensorType == SensorType.humidity) {
      simb = '%';
    } else {
      simb = ' ед.';
    }

    switch (_selectedPeriod) {
      case TimePeriod.hour:
      case TimePeriod.hours3:
      case TimePeriod.hours6:
      case TimePeriod.hours8:
      case TimePeriod.hours12:
        return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}\n${reading.value.toStringAsFixed(1)}$simb\n(${reading.sampleCount} измерений)';
      case TimePeriod.day:
        return '${timestamp.hour.toString().padLeft(2, '0')}:00\n${reading.value.toStringAsFixed(1)}$simb\n(${reading.sampleCount} измерений)';
      case TimePeriod.week:
      case TimePeriod.month:
        return '${timestamp.day.toString().padLeft(2, '0')}.${timestamp.month.toString().padLeft(2, '0')}\n${reading.value.toStringAsFixed(1)}$simb\n(${reading.sampleCount} измерений)';
    }
  }
}
