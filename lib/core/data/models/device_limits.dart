import 'package:hack_sfedu_2025/core/data/models/sensor_values.dart';

/// Модель для всего ответа с сервера
class DeviceResponse {
  final String deviceId;
  final String deviceName;
  final SensorValues values;

  DeviceResponse({
    required this.deviceId,
    required this.deviceName,
    required this.values,
  });

  /// Фабричный конструктор для создания DeviceResponse из JSON (Map)
  factory DeviceResponse.fromJson(Map<String, dynamic> json) {
    return DeviceResponse(
      deviceId: json['device_id'] as String,
      deviceName: json['device_name'] as String,
      // Рекурсивно вызываем fromJson для вложенного объекта
      values: SensorValues.fromJson(json['values'] as Map<String, dynamic>),
    );
  }

  /// Метод для преобразования DeviceResponse в JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'device_name': deviceName,
      // Рекурсивно вызываем toJson для вложенного объекта
      'values': values.toJson(),
    };
  }
}
