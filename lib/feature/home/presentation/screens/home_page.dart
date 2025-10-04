import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/feature/home/presentation/components/device_status_card.dart';
import 'package:hack_sfedu_2025/feature/statuses_overview/presentation/components/status_overview_card.dart';
import '../../../statuses_plot/presentation/components/temperature_chart_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.thermostat,
                color: Theme.of(context).primaryColor, size: 20),
            const SizedBox(width: 6),
            const Text("SmartConnector", style: TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // тут нужен провайдер для управления алертами
            },
            icon: const Icon(Icons.notifications, size: 20),
          ),
          const SizedBox(width: 4),
          const CircleAvatar(
            radius: 16,
            backgroundImage:
                NetworkImage("http://static.photos/people/200x200/3"),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: const StatusOverviewCard(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: TemperatureChartCard(),
            ),
            const SizedBox(height: 12),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                DeviceStatusCard(
                  deviceName: "Прибор 1",
                  status: "Normal",
                  value: "data",
                  minValue: 0,
                  maxValue: 200,
                ),
                DeviceStatusCard(
                  deviceName: "Прибор 2",
                  status: "Normal",
                  value: "data",
                  minValue: 0,
                  maxValue: 200,
                ),
                DeviceStatusCard(
                  deviceName: "Прибор 3",
                  status: "Normal",
                  value: "data",
                  minValue: 0,
                  maxValue: 200,
                ),
                DeviceStatusCard(
                  deviceName: "Прибор 4",
                  status: "Normal",
                  value: "data",
                  minValue: 0,
                  maxValue: 200,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
