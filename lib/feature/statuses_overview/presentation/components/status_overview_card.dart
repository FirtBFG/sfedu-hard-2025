import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/feature/statuses_overview/controller/alerts_controller.dart';
import 'package:hack_sfedu_2025/feature/statuses_overview/controller/device_status_controller.dart';
import 'package:hack_sfedu_2025/feature/statuses_overview/presentation/components/status_tile.dart';
import 'package:provider/provider.dart';

class StatusOverviewCard extends StatelessWidget {
  const StatusOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceStatusController>(context);
    final alertProvider = Provider.of<AlertsController>(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Статус склада',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildStatusContent(deviceProvider, alertProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusContent(
      DeviceStatusController deviceProvider, AlertsController alertsProvider) {
    if (deviceProvider.isLoading) {
      return SizedBox(
        height: 80,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text(
                'Загрузка устройств...',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    if (deviceProvider.hasError) {
      return SizedBox(
        height: 80,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 24),
              const SizedBox(height: 8),
              Text(
                deviceProvider.errorMessage ?? 'Ошибка загрузки',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 10),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => deviceProvider.refresh(),
                icon: const Icon(Icons.refresh, size: 12),
                label: const Text('Повторить', style: TextStyle(fontSize: 10)),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          childAspectRatio: 2.5,
          children: [
            StatusTile(
              icon: Icons.check_circle,
              title: 'Устройства',
              value:
                  '${deviceProvider.activeCount}/${deviceProvider.devivesList.length} Девайсов',
              color: Colors.green,
            ),
            StatusTile(
              icon: Icons.warning,
              title: 'Alerts',
              value: '${alertsProvider.alerts.length} Alerts',
              color: Colors.amber,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SizedBox(
            width: double.infinity,
            child: StatusTile(
              icon: Icons.storage,
              title: 'Logs',
              value: '24h: 142',
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
