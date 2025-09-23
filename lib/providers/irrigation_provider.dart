import 'package:flutter/material.dart';
import '../models/irrigation_status.dart';

class IrrigationProvider with ChangeNotifier {
  IrrigationStatus _status = const IrrigationStatus(
    isActive: false,
    lastIrrigation: null,
    nextScheduled: null,
    totalWaterUsed: 1250.5,
    efficiency: 87.3,
  );

  bool _isProcessing = false;

  IrrigationStatus get status => _status;
  bool get isProcessing => _isProcessing;

  IrrigationProvider() {
    _scheduleNextIrrigation();
  }

  void toggleIrrigation() async {
    if (_isProcessing) return;

    _isProcessing = true;
    notifyListeners();

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 2000));

    final now = DateTime.now();
    final wasActive = _status.isActive;

    _status = _status.copyWith(
      isActive: !_status.isActive,
      lastIrrigation: !wasActive ? now : _status.lastIrrigation,
    );

    if (!wasActive) {
      _scheduleNextIrrigation();
    }

    _isProcessing = false;
    notifyListeners();
  }

  void _scheduleNextIrrigation() {
    final nextScheduled = DateTime.now().add(const Duration(hours: 6));
    _status = _status.copyWith(nextScheduled: nextScheduled);
  }

  void updateWaterUsage(double amount) {
    _status = _status.copyWith(
      totalWaterUsed: _status.totalWaterUsed + amount,
    );
    notifyListeners();
  }

  void updateEfficiency(double efficiency) {
    _status = _status.copyWith(efficiency: efficiency);
    notifyListeners();
  }

  void startManualIrrigation() async {
    if (_isProcessing || _status.isActive) return;

    _isProcessing = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    _status = _status.copyWith(
      isActive: true,
      lastIrrigation: DateTime.now(),
    );

    _isProcessing = false;
    notifyListeners();
  }

  void stopManualIrrigation() async {
    if (_isProcessing || !_status.isActive) return;

    _isProcessing = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    _status = _status.copyWith(isActive: false);

    _isProcessing = false;
    notifyListeners();
  }
}
