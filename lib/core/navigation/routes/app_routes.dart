import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/feature/home/presentation/home_page.dart';

class AppRoutes {
  static const String home = "/";

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
  };
}
