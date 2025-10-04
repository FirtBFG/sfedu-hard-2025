import 'package:dio/dio.dart';

class AlertsRepository {
  final Dio _dio = Dio();
  final String baseURL;

  AlertsRepository({required this.baseURL});

  Future<Map<String, dynamic>> getAlerts(int limit, String status,
      [String deviceId = 'EIto']) async {
    try {
      final response = await _dio.get(
        '$baseURL/api/v1/alerts/$deviceId/alerts',
        queryParameters: {
          'limit': limit,
          'status': status,
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
}
