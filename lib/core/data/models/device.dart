import 'package:hack_sfedu_2025/core/data/models/Command.dart';
import 'package:hack_sfedu_2025/core/data/models/alert.dart';
import 'package:hack_sfedu_2025/core/data/models/device_data.dart';

class Device {
  final String id;
  final String name;
  final String location;
  final String status;
  final DateTime lastSeen;
  final DateTime createdAt;
  final dynamic meta;
  final List<Reading> readings;
  final List<Alert> alerts;
  final List<Command> commands;
  final int readingsCount;
  final int alertsCount;
  final int commandsCount;

  Device({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.lastSeen,
    required this.createdAt,
    required this.meta,
    required this.readings,
    required this.alerts,
    required this.commands,
    required this.readingsCount,
    required this.alertsCount,
    required this.commandsCount,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    final readingsJson = json['readings'] as List<dynamic>;
    final alertsJson = json['alerts'] as List<dynamic>;
    final commandsJson = json['commands'] as List<dynamic>;

    return Device(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      status: json['status'],
      lastSeen: DateTime.parse(json['last_seen']),
      createdAt: DateTime.parse(json['created_at']),
      meta: json['meta'],
      readings: readingsJson.map((e) => Reading.fromJson(e)).toList(),
      alerts: alertsJson.map((e) => Alert.fromJson(e)).toList(),
      commands: commandsJson.map((e) => Command.fromJson(e)).toList(),
      readingsCount: json['reading_counts'],
      alertsCount: json['alertsCount'],
      commandsCount: json['commandsCount'],
    );
  }
}
