import 'package:flutter/material.dart';

class StatusOverviewCard extends StatelessWidget {
  const StatusOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    // тут нужен провайдер для получения статусов
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Warehouse Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio:
                  2.3, // Changed from 1.5 to 2.0 to make tiles shorter
              children: const [
                StatusTile(
                  icon: Icons.check_circle,
                  title: 'Operational',
                  value: '14/14 Modules',
                  color: Colors.green,
                ),
                StatusTile(
                  icon: Icons.warning,
                  title: 'Warnings',
                  value: '2 Alerts',
                  color: Colors.blue,
                ),
                StatusTile(
                  icon: Icons.error,
                  title: 'Critical',
                  value: '0 Errors',
                  color: Colors.red,
                ),
                StatusTile(
                  icon: Icons.storage,
                  title: 'Logs',
                  value: '24h: 142',
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatusTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const StatusTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
