import 'package:hack_sfedu_2025/core/data/models/device.dart';
import 'package:hack_sfedu_2025/core/data/models/device_limits.dart';
import 'package:hack_sfedu_2025/core/data/models/device_status.dart';
import 'package:hack_sfedu_2025/core/data/repository/devices_repository.dart';
import 'package:hack_sfedu_2025/core/data/models/device_data.dart';

class DevicesService {
  final DevicesRepository _repository =
      DevicesRepository(baseURL: 'https://3piucp-194-87-191-168.ru.tuna.am');

  Future<void> sendDeviceCommand({
    required String deviceId,
    required String action,
    required int? value,
  }) async {
    try {
      await _repository.sendCommand(
        deviceId: deviceId,
        action: action,
        value: value,
      );
    } catch (e) {
      throw 'Failed to send command $action to device $deviceId: $e';
    }
  }

  Future<DeviceResponse> fetchCurrentDeviceValues({
    String deviceId = "EIto",
  }) async {
    try {
      final data = await _repository.getCurrentDeviceValues(deviceId);
      final deviceResponse = DeviceResponse.fromJson(data);
      return deviceResponse;
    } catch (e) {
      throw 'Failed to fetch current device values: $e';
    }
  }

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

  Future<List<Reading>> fetchLastDeviceData({
    required String sensorType,
    String deviceId = "EIto",
  }) async {
    try {
      final data = await _repository.readDevice(1, sensorType, null, deviceId);
      final readingsJSONList = data['readings'] as List<dynamic>;
      final readingList = readingsJSONList
          .map((el) => Reading.fromJson(el as Map<String, dynamic>))
          .toList();
      return readingList;
    } catch (e) {
      throw 'Failed to fetch device data: $e';
    }
  }

  Future<List<DeviceStatus>> fetchDevices({
    required int limit,
    String? status,
  }) async {
    try {
      final data = await _repository.getAllDevices(limit, status);
      final deviceJSONList = data['devices'] as List<dynamic>;
      final deviceList =
          deviceJSONList.map((el) => DeviceStatus.fromJson(el)).toList();
      return deviceList;
    } catch (e) {
      throw 'Failed to fetch devices: $e';
    }
  }

  Future<Device> getDeviceById({required String deviceId}) async {
    try {
      final data = await _repository.getDeviceById(deviceId);
      final deviceJSON = data['device'];
      final device = Device.fromJson(deviceJSON);
      return device;
    } catch (e) {
      throw 'Failed to fetch device: $e';
    }
  }
}
