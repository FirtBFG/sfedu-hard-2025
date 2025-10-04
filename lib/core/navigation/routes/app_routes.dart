import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/feature/home/presentation/screens/home_page.dart';
import 'package:hack_sfedu_2025/feature/device_info/presentation/screens/device_details_page.dart';

class AppRoutes {
  static const String home = "/";
  static const String deviceDetails = "/device-details";

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    deviceDetails: (context) => const DeviceDetailsPage(),
  };
}
