class SensorData {
  final String id;
  final String zoneName;
  final String location;
  final String currentValue;
  final String status;
  final bool isAlerting;
  final String? changeRate;
  final String? minValue;
  final String? maxValue;
  final DateTime lastUpdated;

  const SensorData({
    required this.id,
    required this.zoneName,
    required this.location,
    required this.currentValue,
    required this.status,
    required this.isAlerting,
    this.changeRate,
    this.minValue,
    this.maxValue,
    required this.lastUpdated,
  });
}
