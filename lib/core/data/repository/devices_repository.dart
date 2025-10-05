import 'package:dio/dio.dart';

class DevicesRepository {
  final Dio _dio = Dio();
  final String baseURL;

  DevicesRepository({required this.baseURL});

  Future<Map<String, dynamic>> getCurrentDeviceValues(
      [String deviceId = 'EIto']) async {
    try {
      final response = await _dio.get(
        '$baseURL/api/v1/devices/$deviceId/values', // КОНЕЧНАЯ ТОЧКА
      );
      final data = response.data;
      return data;
    } on DioException catch (e) {
      // Бросаем данные ответа в случае ошибки Dio (например, 404, 500)
      throw e.response?.data ?? 'Unknown Dio error';
    } catch (e) {
      throw 'unknown error: $e';
    }
  }

  Future<Map<String, dynamic>> readDevice(
      int limit, String sensorType, String? timeframe,
      [String deviceId = 'EIto']) async {
    try {
      final response = await _dio.get(
        '$baseURL/api/v1/devices/$deviceId/readings',
        queryParameters: timeframe == null
            ? {
                'limit': limit,
                'sensor_type': sensorType,
              }
            : {
                'limit': limit,
                'sensor_type': sensorType,
                'timeframe': timeframe,
              },
      );
      final data = response.data;
      return data;
    } on DioException catch (e) {
      throw e.response!.data;
    } catch (e) {
      throw 'unknown error';
    }
  }

  Future<Map<String, dynamic>> getAllDevices(int limit,
      [String? status]) async {
    try {
      final response = await _dio.get(
        '$baseURL/api/v1/devices/',
        queryParameters: status != null
            ? {
                'limit': limit,
                'status': status,
              }
            : {'limit': limit},
      );
      final data = response.data;
      return data;
    } on DioException catch (e) {
      throw e.response!.data;
    } catch (e) {
      throw 'unknown error';
    }
  }

  Future<Map<String, dynamic>> getDeviceById(String deviceId) async {
    try {
      final response = await _dio.get('$baseURL/api/v1/devices/$deviceId');
      final data = response.data;
      return data;
    } on DioException catch (e) {
      throw e.response!.data;
    } catch (e) {
      throw 'unknown error';
    }
  }
}
