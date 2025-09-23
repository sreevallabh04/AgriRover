import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/enhanced_sensor_data.dart';
import '../repositories/sensor_repository.dart';

class EnhancedSensorProvider with ChangeNotifier {
  List<EnhancedSensorData> _sensors = [];
  bool _isLoading = false;
  Timer? _updateTimer;
  DateTime _startTime = DateTime.now();
  final SensorRepository _repository = const SensorRepository();

  // Mock initial accuracies (lower for demonstration)
  final Map<String, double> _initialAccuracies = {
    'Temperature': 85.2,
    'Humidity': 78.5,
    'Soil Moisture': 72.3,
    'Air Quality': 81.7,
  };

  List<EnhancedSensorData> get sensors => _sensors;
  bool get isLoading => _isLoading;
  DateTime get startTime => _startTime;

  EnhancedSensorProvider() {
    _initializeSensors();
    _startLiveUpdates();
    _loadFromDatabase();
  }

  void _initializeSensors() {
    _sensors = [
      _createSensor('Temperature', 24.5, '°C', true, 99.2),
      _createSensor('Humidity', 65.2, '%', true, 97.8),
      _createSensor('Soil Moisture', 42.8, '%', false, 94.5),
      _createSensor('Air Quality', 85.3, 'AQI', true, 96.1),
    ];
    notifyListeners();
  }

  Future<void> _loadFromDatabase() async {
    _isLoading = true;
    notifyListeners();
    try {
      final fetched = await _repository.fetchLatestEnhancedSensors();
      if (fetched.isNotEmpty) {
        _sensors = fetched;
        _startTime = DateTime.now();
      }
    } catch (_) {
      // Keep mock data if DB unavailable
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  EnhancedSensorData _createSensor(
      String type, double value, String unit, bool isNormal, double accuracy) {
    final now = DateTime.now();
    final initialAccuracy = _initialAccuracies[type] ?? 80.0;

    // Generate historical data
    final historicalData = _generateHistoricalData(value, accuracy);

    // Generate AI analysis
    final aiAnalysis = _generateAIAnalysis(type, value, accuracy);

    return EnhancedSensorData(
      type: type,
      value: value,
      unit: unit,
      timestamp: now,
      isNormal: isNormal,
      accuracy: accuracy,
      initialAccuracy: initialAccuracy,
      calibrationDate: now.subtract(const Duration(days: 15)),
      status: _getSensorStatus(accuracy),
      historicalData: historicalData,
      aiAnalysis: aiAnalysis,
    );
  }

  List<DataPoint> _generateHistoricalData(
      double currentValue, double currentAccuracy) {
    final data = <DataPoint>[];
    final random = Random();

    for (int i = 24; i >= 0; i--) {
      final timestamp = DateTime.now().subtract(Duration(hours: i));
      final variation = (random.nextDouble() - 0.5) * 10; // ±5 variation
      final value = (currentValue + variation).clamp(0, 100).toDouble();
      final accuracyVariation =
          (random.nextDouble() - 0.5) * 2; // ±1% accuracy variation
      final accuracy =
          (currentAccuracy + accuracyVariation).clamp(70, 100).toDouble();

      data.add(DataPoint(
        value: value,
        timestamp: timestamp,
        accuracy: accuracy,
      ));
    }

    return data;
  }

  AIAnalysis _generateAIAnalysis(String type, double value, double accuracy) {
    final random = Random();
    final insights = <String>[];
    String recommendation = '';
    String trend = '';

    switch (type) {
      case 'Temperature':
        if (value > 30) {
          recommendation =
              "Temperature is high. Consider increasing irrigation.";
          trend = "Rising";
          insights.addAll([
            "Temperature shows upward trend",
            "Optimal range: 20-28°C",
            "Consider shade management"
          ]);
        } else if (value < 15) {
          recommendation = "Temperature is low. Consider warming measures.";
          trend = "Falling";
          insights.addAll([
            "Temperature below optimal range",
            "Monitor for frost conditions",
            "Consider greenhouse heating"
          ]);
        } else {
          recommendation = "Temperature is within optimal range.";
          trend = "Stable";
          insights.addAll([
            "Optimal growing conditions",
            "Maintain current practices",
            "Monitor for changes"
          ]);
        }
        break;

      case 'Humidity':
        if (value > 80) {
          recommendation = "High humidity detected. Risk of fungal diseases.";
          trend = "High";
          insights.addAll([
            "Increased disease risk",
            "Improve ventilation",
            "Monitor plant health"
          ]);
        } else if (value < 40) {
          recommendation = "Low humidity. Plants may need more water.";
          trend = "Low";
          insights.addAll([
            "Increased water stress risk",
            "Consider irrigation",
            "Monitor soil moisture"
          ]);
        } else {
          recommendation = "Humidity levels are optimal.";
          trend = "Optimal";
          insights.addAll([
            "Good growing conditions",
            "Maintain current practices",
            "Continue monitoring"
          ]);
        }
        break;

      case 'Soil Moisture':
        if (value < 30) {
          recommendation = "Soil is too dry. Immediate irrigation needed.";
          trend = "Critical";
          insights.addAll([
            "Plant stress imminent",
            "Schedule irrigation",
            "Check irrigation system"
          ]);
        } else if (value > 80) {
          recommendation = "Soil is oversaturated. Risk of root rot.";
          trend = "Oversaturated";
          insights.addAll([
            "Risk of root diseases",
            "Improve drainage",
            "Reduce irrigation"
          ]);
        } else {
          recommendation = "Soil moisture is adequate.";
          trend = "Adequate";
          insights.addAll([
            "Good soil conditions",
            "Continue current irrigation",
            "Monitor trends"
          ]);
        }
        break;

      case 'Air Quality':
        if (value > 100) {
          recommendation = "Poor air quality. Monitor plant health.";
          trend = "Poor";
          insights.addAll([
            "Potential pollution impact",
            "Monitor plant stress",
            "Consider filtration"
          ]);
        } else if (value > 50) {
          recommendation = "Moderate air quality. Some caution advised.";
          trend = "Moderate";
          insights.addAll([
            "Monitor for plant stress",
            "Consider protective measures",
            "Track trends"
          ]);
        } else {
          recommendation = "Excellent air quality conditions.";
          trend = "Excellent";
          insights.addAll([
            "Optimal air conditions",
            "No immediate concerns",
            "Continue monitoring"
          ]);
        }
        break;
    }

    return AIAnalysis(
      recommendation: recommendation,
      trend: trend,
      confidence: 0.85 + (random.nextDouble() * 0.15), // 85-100% confidence
      insights: insights,
      analysisTime: DateTime.now(),
    );
  }

  SensorStatus _getSensorStatus(double accuracy) {
    if (accuracy >= 98) return SensorStatus.excellent;
    if (accuracy >= 95) return SensorStatus.good;
    if (accuracy >= 90) return SensorStatus.fair;
    if (accuracy >= 80) return SensorStatus.poor;
    return SensorStatus.needsCalibration;
  }

  void _startLiveUpdates() {
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateSensorData();
    });
  }

  void _updateSensorData() {
    final random = Random();

    for (int i = 0; i < _sensors.length; i++) {
      final sensor = _sensors[i];

      // Simulate real-time data changes
      final variation = (random.nextDouble() - 0.5) * 2; // ±1 variation
      final newValue = (sensor.value + variation).clamp(0, 100).toDouble();

      // Simulate accuracy improvement over time
      final accuracyImprovement =
          random.nextDouble() * 0.1; // Up to 0.1% improvement
      final newAccuracy =
          (sensor.accuracy + accuracyImprovement).clamp(70, 100).toDouble();

      // Update sensor data
      _sensors[i] = EnhancedSensorData(
        type: sensor.type,
        value: newValue,
        unit: sensor.unit,
        timestamp: DateTime.now(),
        isNormal: _isValueNormal(sensor.type, newValue),
        accuracy: newAccuracy,
        initialAccuracy: sensor.initialAccuracy,
        calibrationDate: sensor.calibrationDate,
        status: _getSensorStatus(newAccuracy),
        historicalData:
            _updateHistoricalData(sensor.historicalData, newValue, newAccuracy),
        aiAnalysis: _generateAIAnalysis(sensor.type, newValue, newAccuracy),
      );
    }

    notifyListeners();
  }

  List<DataPoint> _updateHistoricalData(
      List<DataPoint> existingData, double newValue, double newAccuracy) {
    final updatedData = List<DataPoint>.from(existingData);

    // Add new data point
    updatedData.add(DataPoint(
      value: newValue,
      timestamp: DateTime.now(),
      accuracy: newAccuracy,
    ));

    // Keep only last 25 data points (24 hours + current)
    if (updatedData.length > 25) {
      updatedData.removeAt(0);
    }

    return updatedData;
  }

  Future<void> loadHistory(String type) async {
    try {
      final history = await _repository.fetchHistory(type: type, limit: 50);
      final index = _sensors.indexWhere((s) => s.type == type);
      if (index >= 0) {
        final sensor = _sensors[index];
        _sensors[index] = EnhancedSensorData(
          type: sensor.type,
          value: sensor.value,
          unit: sensor.unit,
          timestamp: sensor.timestamp,
          isNormal: sensor.isNormal,
          accuracy: sensor.accuracy,
          initialAccuracy: sensor.initialAccuracy,
          calibrationDate: sensor.calibrationDate,
          status: sensor.status,
          historicalData: history,
          aiAnalysis: sensor.aiAnalysis,
        );
        notifyListeners();
      }
    } catch (_) {
      // ignore
    }
  }

  bool _isValueNormal(String type, double value) {
    switch (type) {
      case 'Temperature':
        return value >= 15 && value <= 30;
      case 'Humidity':
        return value >= 40 && value <= 80;
      case 'Soil Moisture':
        return value >= 30 && value <= 80;
      case 'Air Quality':
        return value <= 100;
      default:
        return true;
    }
  }

  void refreshData() {
    _isLoading = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 1), () {
      _updateSensorData();
      _isLoading = false;
      notifyListeners();
    });
  }

  void stopLiveUpdates() {
    _updateTimer?.cancel();
  }

  @override
  void dispose() {
    stopLiveUpdates();
    super.dispose();
  }
}
