import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/core/data/models/device_data.dart';
import 'package:hack_sfedu_2025/core/data/models/device_limits.dart';
import 'package:hack_sfedu_2025/core/data/models/device_status.dart';
import 'package:hack_sfedu_2025/core/service/devices_service.dart';

enum DeviceStatusEnum {
  online,
  offline,
}

class DeviceStatusController extends ChangeNotifier {
  final DevicesService _devicesService = DevicesService();
  List<DeviceStatus> _devicesList = [];
  int _activeCount = 0;

  bool _isLoading = true; // Состояние загрузки
  String? _errorMessage; // Сообщение об ошибке

  List<DeviceStatus> get devicesList => _devicesList;
  int get activeCount => _activeCount;
  bool get isLoading => _isLoading;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;

  Future<void> getAllDevices(int limit) async {
    _setLoading(true);

    try {
      _devicesList = await _devicesService.fetchDevices(
        limit: limit,
      );

      _activeCount = 0; // Сбрасываем счетчик
      for (final device in _devicesList) {
        if (device.status == DeviceStatusEnum.online.name) {
          _activeCount++;
        }
      }

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      print('Error fetching devices: $e');
      _setError('Ошибка загрузки устройств: $e');
      notifyListeners();
    }
  }

  Future<Reading> getLastReading(String sensorType, String deviceId) async {
    final reading =
        await _devicesService.fetchLastDeviceData(sensorType: sensorType);
    return reading.first;
  }

  Future<DeviceResponse> getDeviceValues({required String deviceId}) async {
    try {
      // Вызываем метод сервиса, который обращается к репозиторию
      final DeviceResponse response =
          await _devicesService.fetchCurrentDeviceValues(
        deviceId: deviceId,
      );
      return response;
    } catch (e) {
      // В случае ошибки, пробрасываем ее дальше, чтобы UI мог ее обработать
      throw 'Failed to fetch device values for $deviceId: $e';
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

  /// Принудительная перезагрузка данных
  Future<void> refresh() async {
    await getAllDevices(100);
  }
}
