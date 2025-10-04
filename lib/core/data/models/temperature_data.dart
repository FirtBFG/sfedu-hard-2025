class TemperatureData {
  final DateTime timestamp;
  final double value;
  final String zoneId;

  const TemperatureData({
    required this.timestamp,
    required this.value,
    required this.zoneId,
  });

  factory TemperatureData.fromJson(Map<String, dynamic> json) {
    return TemperatureData(
      timestamp: DateTime.parse(json['timestamp']),
      value: json['value'].toDouble(),
      zoneId: json['zoneId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'value': value,
        'zoneId': zoneId,
      };
}
