import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hack_sfedu_2025/core/enums/device_emums.dart';
import 'package:hack_sfedu_2025/feature/device_info/controller/device_controller.dart';
import 'package:provider/provider.dart';

class DeviceRemoteControlScreen extends StatelessWidget {
  const DeviceRemoteControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceStatusController>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButton<ControlPage>(
              value: deviceProvider.controlPage,
              items: [
                const DropdownMenuItem(
                  value: ControlPage.nothing,
                  child: Text("Выберите команду"),
                ),
                const DropdownMenuItem(
                  value: ControlPage.alarm,
                  child: Text("Переключить тревогу"),
                ),
                const DropdownMenuItem(
                  value: ControlPage.servo,
                  child: Text("Изменить состояние сервопривода"),
                ),
                const DropdownMenuItem(
                  value: ControlPage.temp,
                  child: Text("Установить лимит температуры"),
                ),
                const DropdownMenuItem(
                  value: ControlPage.fire,
                  child: Text("Установить лимит огня"),
                ),
                const DropdownMenuItem(
                  value: ControlPage.humidity,
                  child: Text("Установить лимит влажности"),
                )
              ],
              onChanged: (value) {
                deviceProvider.changeControlPanel(value!);
              },
            ),
            const ControlPageSelection()
          ],
        ),
      ),
    );
  }
}

class ControlPageSelection extends StatefulWidget {
  const ControlPageSelection({super.key});

  @override
  State<ControlPageSelection> createState() => _ControlPageSelectionState();
}

class _ControlPageSelectionState extends State<ControlPageSelection> {
  final TextEditingController servoController = TextEditingController();
  final TextEditingController tempController = TextEditingController();
  final TextEditingController fireController = TextEditingController(); // НОВЫЙ
  final TextEditingController humidityController =
      TextEditingController(); // НОВЫЙ

  void _validateLimit(TextEditingController controller) {
    String text = controller.text;
    if (text.isNotEmpty) {
      try {
        int value = int.parse(text);
        if (value > 100) {
          // Если значение превышает 100, устанавливаем его на 100
          controller.text = '100';
          // Ставим курсор в конец, чтобы было удобнее
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length),
          );
        }
      } catch (e) {
        // Игнорируем ошибки парсинга, если пользователь вводит неполное число.
      }
    }
  }

  void _validateServ() {
    String text = servoController.text;
    if (text.isNotEmpty) {
      try {
        int value = int.parse(text);
        if (value > 180) {
          // Если значение превышает 180, устанавливаем его на 180
          servoController.text = '180';
          // Ставим курсор в конец
          servoController.selection = TextSelection.fromPosition(
            TextPosition(offset: servoController.text.length),
          );
        }
      } catch (e) {
        // Игнорируем ошибки парсинга
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Используем одну функцию для валидации всех лимитов 0-100
    tempController.addListener(() => _validateLimit(tempController));
    fireController.addListener(() => _validateLimit(fireController)); // НОВЫЙ
    humidityController
        .addListener(() => _validateLimit(humidityController)); // НОВЫЙ

    // Валидация сервопривода 0-180
    servoController.addListener(_validateServ);
  }

  @override
  void dispose() {
    tempController.dispose();
    servoController.dispose();
    fireController.dispose(); // УТИЛИЗАЦИЯ
    humidityController.dispose(); // УТИЛИЗАЦИЯ
    super.dispose();
  }

  // Общая структура для полей ввода лимитов 0-100
  Widget _buildLimitControl({
    required TextEditingController controller,
    required String label,
    required String unit,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24.0, left: 8, right: 8),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              hintText: 'Например, 50',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixText: unit,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3), // Максимум 3 символа (100)
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 24.0, left: 8, right: 8, bottom: 10),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                elevation: 8,
              ),
              onPressed: onPressed,
              child:
                  Text(buttonText, style: const TextStyle(letterSpacing: 1.5)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceStatusController>(context);

    if (deviceProvider.controlPage == ControlPage.alarm) {
      // Блок для Тревоги
      return Padding(
        padding: const EdgeInsets.only(top: 24.0, left: 8, right: 8),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              elevation: 8,
            ),
            onPressed: () async {
              await deviceProvider.sendCommand("EIto", 'toggle_alert');
            },
            child: const Text("ОТПРАВИТЬ КОМАНДУ",
                style: TextStyle(letterSpacing: 1.5)),
          ),
        ),
      );
    } else if (deviceProvider.controlPage == ControlPage.servo) {
      // Блок для Сервопривода
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 8, right: 8),
            child: TextField(
              controller: servoController,
              decoration: InputDecoration(
                labelText: 'Введите значение (0-180)',
                hintText: 'Например, 90',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixText: '°',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 24.0, left: 8, right: 8, bottom: 10),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  elevation: 8,
                ),
                onPressed: () {
                  deviceProvider.sendCommand("EIto", 'set_servo_position',
                      int.tryParse(servoController.text));
                },
                child: const Text("ОТПРАВИТЬ КОМАНДУ",
                    style: TextStyle(letterSpacing: 1.5)),
              ),
            ),
          ),
        ],
      );
    } else if (deviceProvider.controlPage == ControlPage.temp) {
      // Блок для Температуры
      return _buildLimitControl(
        controller: tempController,
        label: 'Введите лимит (0-100)',
        unit: '°C',
        buttonText: 'ОТПРАВИТЬ КОМАНДУ',
        onPressed: () async {
          await deviceProvider.sendCommand("EIto", 'set_temerature_limit',
              int.tryParse(tempController.text));
        },
      );
    } else if (deviceProvider.controlPage == ControlPage.fire) {
      // НОВЫЙ БЛОК для Огня
      return _buildLimitControl(
        controller: fireController,
        label: 'Введите лимит (0-100)',
        unit: 'ед.',
        buttonText: 'ОТПРАВИТЬ КОМАНДУ',
        onPressed: () async {
          await deviceProvider.sendCommand(
              "EIto", 'set_fire_limit', int.tryParse(fireController.text));
        },
      );
    } else if (deviceProvider.controlPage == ControlPage.humidity) {
      // НОВЫЙ БЛОК для Влажности
      return _buildLimitControl(
        controller: humidityController,
        label: 'Введите лимит (0-100)',
        unit: '%',
        buttonText: 'ОТПРАВИТЬ КОМАНДУ',
        onPressed: () async {
          await deviceProvider.sendCommand("EIto", 'set_humidity_limit',
              int.tryParse(humidityController.text));
        },
      );
    } else {
      return Container();
    }
  }
}
