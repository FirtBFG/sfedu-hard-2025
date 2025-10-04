import 'package:flutter/material.dart';
import '../../statuses_overview/presentation/status_overview_card.dart';
import '../../statuses_plot/presentation/temperature_chart_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.thermostat, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            const Text("ColdGuard Pro"),
          ],
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              // тут нужен провайдер для управления алертами
            },
            icon: const Icon(Icons.notifications),
            label: const Text("Alerts"),
          ),
          const SizedBox(width: 16),
          const CircleAvatar(
            backgroundImage:
                NetworkImage("http://static.photos/people/200x200/3"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 350, // Fixed height for the row
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Expanded(
                    flex: 1,
                    child: StatusOverviewCard(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TemperatureChartCard(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
