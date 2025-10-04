class Alert {
  final String id;
  final String alertType;
  final String message;
  final String severity;
  final String status;
  final DateTime timestamp;

  Alert({
    required this.id,
    required this.alertType,
    required this.message,
    required this.severity,
    required this.status,
    required this.timestamp,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'],
      alertType: json['alert_type'],
      message: json['message'],
      severity: json['severity'],
      status: json['status'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
