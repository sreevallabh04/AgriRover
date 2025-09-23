import 'package:flutter/material.dart';
import '../models/sensor_data.dart';

class SensorProvider with ChangeNotifier {
  List<SensorData> _sensors = [];
  bool _isLoading = false;

  List<SensorData> get sensors => _sensors;
  bool get isLoading => _isLoading;

  SensorProvider() {
    _generateMockData();
  }

  void _generateMockData() {
    _sensors = [
      SensorData(
        type: 'Temperature',
        value: 24.5,
        unit: '°C',
        timestamp: DateTime.now(),
        isNormal: true,
      ),
      SensorData(
        type: 'Humidity',
        value: 65.2,
        unit: '%',
        timestamp: DateTime.now(),
        isNormal: true,
      ),
      SensorData(
        type: 'Soil Moisture',
        value: 42.8,
        unit: '%',
        timestamp: DateTime.now(),
        isNormal: false,
      ),
      SensorData(
        type: 'Air Quality',
        value: 85.3,
        unit: 'AQI',
        timestamp: DateTime.now(),
        isNormal: true,
      ),
    ];
    notifyListeners();
  }

  void refreshData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    _generateMockData();
    _isLoading = false;
    notifyListeners();
  }

  void updateSensorValue(String type, double newValue) {
    final index = _sensors.indexWhere((sensor) => sensor.type == type);
    if (index != -1) {
      _sensors[index] = _sensors[index].copyWith(
        value: newValue,
        timestamp: DateTime.now(),
        isNormal: _isValueNormal(type, newValue),
      );
      notifyListeners();
    }
  }

  bool _isValueNormal(String type, double value) {
    switch (type) {
      case 'Temperature':
        return value >= 15 && value <= 35;
      case 'Humidity':
        return value >= 40 && value <= 80;
      case 'Soil Moisture':
        return value >= 30 && value <= 70;
      case 'Air Quality':
        return value >= 0 && value <= 100;
      default:
        return true;
    }
  }

  List<SensorData> getHistoricalData(String type, {int hours = 24}) {
    final now = DateTime.now();
    final List<SensorData> historical = [];

    for (int i = hours; i >= 0; i--) {
      final timestamp = now.subtract(Duration(hours: i));
      final sensor = _sensors.firstWhere((s) => s.type == type);

      // Generate some variation in values
      final variation = (i % 3 - 1) * 2.0;
      final value = sensor.value + variation;

      historical.add(sensor.copyWith(
        value: value,
        timestamp: timestamp,
      ));
    }

    return historical;
  }
}
