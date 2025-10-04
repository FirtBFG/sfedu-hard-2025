import 'package:hack_sfedu_2025/core/data/models/alert.dart';
import 'package:hack_sfedu_2025/core/data/repository/alert_repository.dart';

class AlertsService {
  final AlertsRepository _repository =
      AlertsRepository(baseURL: 'https://3piucp-194-87-191-168.ru.tuna.am/');

  Future<List<Alert>> fetchAlerts({
    required int limit,
    required String status,
    String deviceId = "EIto",
  }) async {
    try {
      final data = await _repository.getAlerts(limit, status, deviceId);
      final alertsJSONList = data['alerts'] as List<dynamic>;
      return alertsJSONList
          .map((el) => Alert.fromJson(el as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw 'Failed to fetch alerts: $e';
    }
  }
}
