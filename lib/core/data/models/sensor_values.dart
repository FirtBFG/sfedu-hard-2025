/// Модель для вложенного объекта "values"
class SensorValues {
  final double temperatureLimit;
  final double humidityLimit;
  final double fireLimit;
  final int servoPosition;

  SensorValues({
    required this.temperatureLimit,
    required this.humidityLimit,
    required this.fireLimit,
    required this.servoPosition,
  });

  /// Фабричный конструктор для создания SensorValues из JSON (Map)
  factory SensorValues.fromJson(Map<String, dynamic> json) {
    return SensorValues(
      // Используем as double или toDouble() для безопасности,
      // так как JSON может вернуть int, который нужно привести к double
      temperatureLimit: (json['temperature_limit'] as num).toDouble(),
      humidityLimit: (json['humidity_limit'] as num).toDouble(),
      fireLimit: (json['fire_limit'] as num).toDouble(),
      servoPosition: json['servo_position'] as int,
    );
  }

  /// Метод для преобразования SensorValues в JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'temperature_limit': temperatureLimit,
      'humidity_limit': humidityLimit,
      'fire_limit': fireLimit,
      'servo_position': servoPosition,
    };
  }
}
