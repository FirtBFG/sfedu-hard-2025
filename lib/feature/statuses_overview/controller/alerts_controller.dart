import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/core/data/models/alert.dart';
import 'package:hack_sfedu_2025/core/service/alert_service.dart';

class AlertsController extends ChangeNotifier {
  final AlertsService _alertsService = AlertsService();

  List<Alert> _alerts = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<Alert> get alerts => _alerts;
  bool get isLoading => _isLoading;
  bool get hasError => _errorMessage != null;
  String? get errorMessage => _errorMessage;

  /// Загрузка уведомлений при инициализации приложения
  Future<void> loadAlertsOnStart() async {
    _setLoading(true);

    try {
      _alerts = await _alertsService.fetchAlerts(
        limit: 10,
        status: 'new',
        deviceId: "EIto",
      );
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      print('Error loading alerts: $e');
      _setError('Ошибка загрузки уведомлений: $e');
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      _errorMessage = null;
    }
  }

  void _setError(String error) {
    _isLoading = false;
    _errorMessage = error;
  }
}
