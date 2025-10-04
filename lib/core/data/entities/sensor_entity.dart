class SensorEntity {
  final String id;
  final String name;
  final String zone;
  final String location;
  final bool isActive;
  final String currentValue;
  final String unit;
  final DateTime lastUpdated;
  final String status;
  final bool isAlerting;

  const SensorEntity({
    required this.id,
    required this.name,
    required this.zone,
    required this.location,
    required this.isActive,
    required this.currentValue,
    required this.unit,
    required this.lastUpdated,
    required this.status,
    required this.isAlerting,
  });
}
