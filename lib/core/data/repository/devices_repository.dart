import 'package:dio/dio.dart';

class DevicesRepository {
  final Dio _dio = Dio();
  final String baseURL;

  DevicesRepository({required this.baseURL});

  Future<Map<String, dynamic>> readDevice(
      int limit, String sensorType, String timeframe,
      [String deviceId = 'EIto']) async {
    try {
      final response = await _dio
          .get('$baseURL/api/v1/devices/$deviceId/readings', queryParameters: {
        'limit': limit,
        'sensor_type': sensorType,
        'timeframe': timeframe,
      });
      final data = response.data;
      return data;
    } on DioException catch (e) {
      throw e.response!.data;
    } catch (e) {
      throw 'unknown error';
    }
  }
}
