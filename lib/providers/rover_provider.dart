import 'package:flutter/material.dart';
import '../models/rover_status.dart';

class RoverProvider with ChangeNotifier {
  RoverStatus _status = const RoverStatus(
    isPowered: false,
    batteryLevel: 85.0,
    mode: RoverMode.manual,
    position: 'Field A',
    isConnected: true,
  );

  bool _isProcessing = false;

  RoverStatus get status => _status;
  bool get isProcessing => _isProcessing;

  void togglePower() async {
    if (_isProcessing) return;

    _isProcessing = true;
    notifyListeners();

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 1500));

    _status = _status.copyWith(
      isPowered: !_status.isPowered,
    );

    _isProcessing = false;
    notifyListeners();
  }

  void setMode(RoverMode mode) {
    _status = _status.copyWith(mode: mode);
    notifyListeners();
  }

  void updateBatteryLevel(double level) {
    _status = _status.copyWith(batteryLevel: level);
    notifyListeners();
  }

  void updatePosition(String position) {
    _status = _status.copyWith(position: position);
    notifyListeners();
  }

  void setConnectionStatus(bool connected) {
    _status = _status.copyWith(isConnected: connected);
    notifyListeners();
  }

  void sendCommand(String command) async {
    if (_isProcessing || !_status.isPowered) return;

    _isProcessing = true;
    notifyListeners();

    // Simulate command processing
    await Future.delayed(const Duration(milliseconds: 800));

    _isProcessing = false;
    notifyListeners();
  }
}
