class Device {
  final String id;
  final String name;
  final String location;
  final String status;
  final DateTime last_seen;

  Device({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.last_seen,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      status: json['status'],
      last_seen: DateTime.parse(json['last_seen']),
    );
  }
}
