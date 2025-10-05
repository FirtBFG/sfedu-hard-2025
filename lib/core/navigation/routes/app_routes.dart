import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/feature/device_info/presentation/screens/device_logs_screen.dart';
import 'package:hack_sfedu_2025/feature/device_info/presentation/screens/device_remote_control_screen.dart';
import 'package:hack_sfedu_2025/feature/home/presentation/screens/home_page.dart';
import 'package:hack_sfedu_2025/feature/device_info/presentation/screens/device_details_page.dart';

class AppRoutes {
  static const String home = "/";
  static const String deviceDetails = "/device-details";
  static const String deviceLogs = "/device-logs";
  static const String deviceRemoteControl = "/device-remote-control";

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    deviceDetails: (context) => const DeviceDetailsPage(),
    deviceLogs: (context) => const DeviceLogsScreen(),
    deviceRemoteControl: (context) => const DeviceRemoteControlScreen(),
  };
}
