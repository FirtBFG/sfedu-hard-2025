import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/core/navigation/routes/app_routes.dart';
import 'package:hack_sfedu_2025/core/theme/app_theme.dart';
import 'package:hack_sfedu_2025/feature/statuses_overview/controller/alerts_controller.dart';
import 'package:hack_sfedu_2025/feature/statuses_overview/controller/device_status_controller.dart';
import 'package:hack_sfedu_2025/feature/statuses_plot/controller/plot_controller.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PlotController()..fetchData(),
        ),
        ChangeNotifierProvider(
          create: (context) => DeviceStatusController()..getAllDevices(100),
        ),
        ChangeNotifierProvider(
          create: (context) => AlertsController()..loadAlertsOnStart(),
        ),
      ],
      child: MaterialApp(
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.home,
        theme: AppTheme.darkTheme,
      ),
    );
  }
}
