import 'package:hack_sfedu_2025/core/data/models/device.dart';
import 'package:hack_sfedu_2025/core/data/repository/devices_repository.dart';
import 'package:hack_sfedu_2025/core/data/models/device_data.dart';

class DevicesService {
  final DevicesRepository _repository =
      DevicesRepository(baseURL: 'https://3piucp-194-87-191-168.ru.tuna.am/');

  Future<List<Reading>> fetchDeviceData({
    required int limit,
    required String sensorType,
    required String timeframe,
    String deviceId = "EIto",
  }) async {
    try {
      final data =
          await _repository.readDevice(limit, sensorType, timeframe, deviceId);
      final readingsJSONList = data['readings'] as List<dynamic>;
      final readingList = readingsJSONList
          .map((el) => Reading.fromJson(el as Map<String, dynamic>))
          .toList();
      return readingList;
    } catch (e) {
      throw 'Failed to fetch device data: $e';
    }
  }

  Future<List<Device>> fetchDevices({
    required int limit,
    String? status,
  }) async {
    try {
      final data = await _repository.getAllDevices(limit, status);
      final deviceJSONList = data['devices'] as List<dynamic>;
      final deviceList =
          deviceJSONList.map((el) => Device.fromJson(el)).toList();
      return deviceList;
    } catch (e) {
      throw 'Failed to fetch devices: $e';
    }
  }
}
