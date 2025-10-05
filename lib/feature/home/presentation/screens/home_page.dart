import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/feature/home/presentation/components/device_status_card.dart';
import 'package:hack_sfedu_2025/feature/statuses_overview/controller/device_status_controller.dart';
import 'package:hack_sfedu_2025/feature/statuses_overview/presentation/components/status_overview_card.dart';
import 'package:provider/provider.dart';
import '../../../statuses_plot/presentation/components/temperature_chart_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceStatusController>(context);
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
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: deviceProvider.devicesList.length,
              itemBuilder: (context, index) => DeviceStatusCard(
                deviceId: deviceProvider.devicesList[index].id,
                deviceName: deviceProvider.devicesList[index].name,
                status: deviceProvider.devicesList[index].status,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
