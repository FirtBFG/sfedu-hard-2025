class Reading {
  final String id;
  final String sensorType;
  final double value;
  final String unit;
  final DateTime timestamp;

  Reading({
    required this.id,
    required this.sensorType,
    required this.value,
    required this.unit,
    required this.timestamp,
  });

  factory Reading.fromJson(Map<String, dynamic> json) {
    return Reading(
      id: json['id'],
      sensorType: json['sensor_type'],
      value: json['value'],
      unit: json['unit'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
