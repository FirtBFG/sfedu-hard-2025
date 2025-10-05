class DeviceStatus {
  final String id;
  final String name;
  final String location;
  final String status;
  final DateTime lastSeen;

  DeviceStatus({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.lastSeen,
  });

  factory DeviceStatus.fromJson(Map<String, dynamic> json) {
    return DeviceStatus(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      status: json['status'],
      lastSeen: DateTime.parse(json['last_seen']),
    );
  }
}
