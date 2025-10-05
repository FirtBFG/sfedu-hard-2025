import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/core/data/models/device_limits.dart';
import 'package:hack_sfedu_2025/core/data/models/sensor_values.dart';
import 'package:hack_sfedu_2025/core/navigation/routes/app_routes.dart';
import 'package:hack_sfedu_2025/feature/device_info/controller/device_controller.dart';
import 'package:hack_sfedu_2025/feature/device_info/presentation/components/error_loads_card_widget.dart';
import 'package:hack_sfedu_2025/feature/device_info/presentation/components/status_card_widet.dart';
import 'package:provider/provider.dart';

class DeviceDetailsPage extends StatefulWidget {
  const DeviceDetailsPage({super.key});

  @override
  State<DeviceDetailsPage> createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
  Future<DeviceResponse>? _deviceValuesFuture;

  late String _deviceId;
  late String _deviceName;
  late String _status;
  late String _value;
  late String _lastSeen;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _deviceId = args['deviceId'];
    _deviceName = args['deviceName'];
    _status = args['status'];
    _value = args['value'];
    _lastSeen = args['lastSeen'];

    _deviceValuesFuture ??= _fetchDeviceValues();
  }

  // Метод для вызова контроллера и получения Future
  Future<DeviceResponse> _fetchDeviceValues() {
    final controller = context.read<DeviceStatusController>();
    return controller.getDeviceValues(deviceId: _deviceId);
  }

  @override
  Widget build(BuildContext context) {
    Color chipColor = _status.toLowerCase() == 'online'
        ? Colors.green.withValues(alpha: 0.2)
        : Colors.red.withValues(alpha: 0.2);
    Color textColor =
        _status.toLowerCase() == 'online' ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text(_deviceName),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusCardWidget(
              chipColor: chipColor,
              status: _status,
              textColor: textColor,
              value: _value,
            ),

            const SizedBox(height: 16),

            FutureBuilder<DeviceResponse>(
              future: _deviceValuesFuture!,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ));
                } else if (snapshot.hasError) {
                  return ErrorLoadCardWidget(snapshot: snapshot);
                } else if (snapshot.hasData && snapshot.data!.values != null) {
                  return _buildSensorValuesCard(context, snapshot.data!.values);
                } else {
                  // Если данных нет, но и нет ошибки
                  return const SizedBox.shrink();
                }
              },
            ),

            const SizedBox(height: 16),

            // Действия с устройством
            const Text(
              'Действия',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildActionCard(
                  context,
                  icon: Icons.control_camera_sharp,
                  title: 'Управление',
                  subtitle: 'Удалённое управление',
                  onTap: () {
                    // Навигация к настройкам
                    Navigator.pushNamed(
                      context,
                      AppRoutes.deviceRemoteControl,
                    );
                  },
                ),
                _buildActionCard(
                  context,
                  icon: Icons.history,
                  title: 'История',
                  subtitle: 'Просмотр логов',
                  onTap: () {
                    // Навигация к истории
                    _showSnackBar(context, 'Открываем историю $_deviceName');
                  },
                ),
                _buildActionCard(
                  context,
                  icon: Icons.info_outline,
                  title: 'Детали',
                  subtitle: 'Подробная информация',
                  onTap: () {
                    // Навигация к деталям
                    _showSnackBar(context, 'Открываем детали $_deviceName');
                  },
                ),
                _buildActionCard(
                  context,
                  icon: Icons.refresh,
                  title: 'Обновить',
                  subtitle: 'Синхронизация данных',
                  onTap: () {
                    // Обновление данных: перезапускаем Future
                    setState(() {
                      _deviceValuesFuture = _fetchDeviceValues();
                    });
                    _showSnackBar(context, 'Обновляем данные $_deviceName');
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Полезная информация
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Информация об устройстве',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('ID:', _deviceId),
                    _buildInfoRow('Статус:', _status),
                    _buildInfoRow('Тип:', 'Температурный датчик'),
                    _buildInfoRow('Последнее обновление:', _lastSeen),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorValuesCard(
      BuildContext context, SensorValues sensorValues) {
    final List<Widget> valueChips = [];

    valueChips.add(_buildValueChip(
      context,
      label: 'Предел пламени',
      value: sensorValues.fireLimit.toString(),
      unit: 'ед.',
    ));

    valueChips.add(_buildValueChip(
      context,
      label: 'Предел температуры',
      value: sensorValues.humidityLimit.toString(),
      unit: '°C',
    ));

    valueChips.add(_buildValueChip(
      context,
      label: 'Положение серво',
      value: sensorValues.servoPosition.toString(),
      unit: 'град',
    ));

    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Установленные лимиты и параметры',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // Используем Wrap для адаптивного отображения двух элементов в ряд
              Wrap(
                spacing: 16, // Горизонтальный отступ
                runSpacing: 12, // Вертикальный отступ
                children: valueChips.map((chip) {
                  return SizedBox(
                    width: (MediaQuery.of(context).size.width / 2) -
                        32, // Почти половина ширины экрана
                    child: chip,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValueChip(
    BuildContext context, {
    required String label,
    required String value,
    required String unit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '$value $unit',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class ErrorLoadCardWidget extends StatelessWidget {
  const ErrorLoadCardWidget({
    super.key,
    required this.snapshot,
  });

  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.withValues(alpha: 0.1),
      child: Text('Ошибка загрузки данных: ${snapshot.error}',
          style: const TextStyle(color: Colors.red)),
    );
  }
}

class StatusCardWidget extends StatelessWidget {
  const StatusCardWidget({
    super.key,
    required this.chipColor,
    required String status,
    required this.textColor,
    required String value,
  })  : _status = status,
        _value = value;

  final Color chipColor;
  final String _status;
  final Color textColor;
  final String _value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Статус устройства',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: chipColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _status,
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Текущее значение
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Текущее значение',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _value,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
