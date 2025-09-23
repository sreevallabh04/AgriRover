import 'package:flutter/material.dart';
import '../models/alert.dart';

class AlertsProvider with ChangeNotifier {
  List<Alert> _alerts = [];
  bool _isLoading = false;

  List<Alert> get alerts => _alerts;
  List<Alert> get unreadAlerts =>
      _alerts.where((alert) => !alert.isRead).toList();
  List<Alert> get criticalAlerts => _alerts
      .where((alert) => alert.priority == AlertPriority.critical)
      .toList();
  bool get isLoading => _isLoading;
  int get unreadCount => unreadAlerts.length;

  AlertsProvider() {
    _generateMockAlerts();
  }

  void _generateMockAlerts() {
    _alerts = [
      Alert(
        id: '1',
        title: 'Low Soil Moisture',
        message:
            'Soil moisture level in Field A has dropped below optimal range.',
        type: AlertType.warning,
        priority: AlertPriority.medium,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
        isResolved: false,
      ),
      Alert(
        id: '2',
        title: 'Rover Battery Low',
        message: 'Rover battery level is at 15%. Consider charging soon.',
        type: AlertType.warning,
        priority: AlertPriority.high,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
        isResolved: false,
      ),
      Alert(
        id: '3',
        title: 'Irrigation Complete',
        message:
            'Automatic irrigation cycle completed successfully in Field B.',
        type: AlertType.success,
        priority: AlertPriority.low,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
        isResolved: true,
      ),
      Alert(
        id: '4',
        title: 'Sensor Malfunction',
        message: 'Temperature sensor in Field C is not responding.',
        type: AlertType.error,
        priority: AlertPriority.critical,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: false,
        isResolved: false,
      ),
      Alert(
        id: '5',
        title: 'Weather Update',
        message: 'Rain forecast for tomorrow. Irrigation schedule adjusted.',
        type: AlertType.info,
        priority: AlertPriority.low,
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        isRead: true,
        isResolved: true,
      ),
    ];
    notifyListeners();
  }

  void markAsRead(String alertId) {
    final index = _alerts.indexWhere((alert) => alert.id == alertId);
    if (index != -1) {
      _alerts[index] = _alerts[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < _alerts.length; i++) {
      if (!_alerts[i].isRead) {
        _alerts[i] = _alerts[i].copyWith(isRead: true);
      }
    }
    notifyListeners();
  }

  void resolveAlert(String alertId) {
    final index = _alerts.indexWhere((alert) => alert.id == alertId);
    if (index != -1) {
      _alerts[index] = _alerts[index].copyWith(
        isResolved: true,
        isRead: true,
      );
      notifyListeners();
    }
  }

  void deleteAlert(String alertId) {
    _alerts.removeWhere((alert) => alert.id == alertId);
    notifyListeners();
  }

  void addAlert(Alert alert) {
    _alerts.insert(0, alert);
    notifyListeners();
  }

  void refreshAlerts() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _generateMockAlerts();
    _isLoading = false;
    notifyListeners();
  }

  void clearAllAlerts() {
    _alerts.clear();
    notifyListeners();
  }

  void createTestAlert() {
    final newAlert = Alert(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Test Alert',
      message: 'This is a test alert created at ${DateTime.now().toString()}',
      type: AlertType.info,
      priority: AlertPriority.low,
      timestamp: DateTime.now(),
      isRead: false,
      isResolved: false,
    );

    addAlert(newAlert);
  }
}
