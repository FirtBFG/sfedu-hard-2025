class Command {
  final String id;
  final String deviceId;
  final String action;
  final String status;
  final DateTime createdAt;
  final dynamic params;

  Command({
    required this.id,
    required this.deviceId,
    required this.action,
    required this.status,
    required this.createdAt,
    this.params,
  });

  factory Command.fromJson(Map<String, dynamic> json) {
    return Command(
      id: json['id'],
      deviceId: json['device_id'],
      action: json['action'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      params: json['params'],
    );
  }
}
