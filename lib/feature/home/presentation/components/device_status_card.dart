import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/core/data/models/device_data.dart';
import 'package:hack_sfedu_2025/core/enums/sensor_type.dart';
import 'package:hack_sfedu_2025/feature/device_info/controller/device_controller.dart';
import 'package:provider/provider.dart';

class DeviceStatusCard extends StatelessWidget {
  final String deviceName;
  final String status;
  final String deviceId; // ID для запроса данных

  const DeviceStatusCard({
    super.key,
    required this.deviceName,
    required this.status,
    required this.deviceId,
  });

  // Вспомогательная функция для получения Future (лучше, чем внутри build)
  Future<Reading> _fetchReading(BuildContext context) {
    // Получаем контроллер (listen: false, т.к. нас не интересуют общие обновления)
    final deviceController =
        Provider.of<DeviceStatusController>(context, listen: false);

    // Вызываем ваш асинхронный метод
    return deviceController.getLastReading(
        SensorType.temperature.name, // Используем .name для передачи String
        deviceId);
  }

  @override
  Widget build(BuildContext context) {
    // Используем FutureBuilder для асинхронной загрузки данных карточки
    return FutureBuilder<Reading>(
      // Future генерируется вызовом асинхронного метода
      future: _fetchReading(context),
      builder: (context, snapshot) {
        // 1. Загрузка (Показываем заглушку, пока Future не завершится)
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Используем вашу заглушку
          return _buildLoadingCard(context);
        }

        // 2. Ошибка или отсутствие данных
        if (snapshot.hasError || !snapshot.hasData) {
          final error = snapshot.error ?? "Нет данных для этого устройства";
          return _buildErrorCard(context, error);
        }

        // 3. Успешно получено:
        final Reading latestReading = snapshot.data!;
        final String latestValue =
            '${latestReading.value.toStringAsFixed(1)} ${latestReading.unit}';

        // --- Тело карточки с данными ---
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            // В DeviceStatusCard.dart, в методе onTap:

            onTap: () {
              Navigator.of(context).pushNamed(
                '/device-details',
                arguments: {
                  'deviceId': deviceId,
                  'value':
                      latestValue, // Используйте значение, которое вы вычислили в FutureBuilder
                  'deviceName': deviceName,
                  'status': status,
                  'lastSeen': latestReading.timestamp
                      .toIso8601String(), // Предполагаем, что вы хотите передать дату/время
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Верхняя часть с названием и статусом
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          deviceName,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildStatusChip(context, status),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Средняя часть с данными
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            latestValue, // <-- Актуальное значение
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Вспомогательные методы UI ---

  Widget _buildStatusChip(BuildContext context, String status) {
    Color chipColor = status.toLowerCase() == 'online'
        ? Colors.green.withOpacity(0.2)
        : Colors.red.withOpacity(0.2);
    Color textColor =
        status.toLowerCase() == 'online' ? Colors.green : Colors.red;

    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          status.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(deviceName, style: Theme.of(context).textTheme.titleSmall),
                _buildStatusChip(context, status),
              ],
            ),
            const Expanded(
              child: Center(
                child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, Object? error) {
    return Card(
      color: Theme.of(context).colorScheme.error.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(deviceName, style: Theme.of(context).textTheme.titleSmall),
                _buildStatusChip(context, status),
              ],
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Theme.of(context).colorScheme.error),
                    const SizedBox(height: 4),
                    Text('Ошибка: ${error.toString().split(':')[0]}',
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
