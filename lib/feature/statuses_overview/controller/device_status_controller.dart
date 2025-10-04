import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/core/data/models/device.dart';
import 'package:hack_sfedu_2025/core/service/devices_service.dart';

enum DeviceStatus {
  online,
  offline,
}

class DeviceStatusController extends ChangeNotifier {
  final DevicesService _devicesService = DevicesService();
  List<Device> _devicesList = [];
  int _activeCount = 0;

  bool _isLoading = true; // Состояние загрузки
  String? _errorMessage; // Сообщение об ошибке

  List<Device> get devivesList => _devicesList;
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
        if (device.status == DeviceStatus.online.name) {
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
