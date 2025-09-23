import 'sensor_data.dart';

class EnhancedSensorData extends SensorData {
  final double accuracy;
  final double initialAccuracy;
  final DateTime calibrationDate;
  final SensorStatus status;
  final List<DataPoint> historicalData;
  final AIAnalysis? aiAnalysis;

  EnhancedSensorData({
    required super.type,
    required super.value,
    required super.unit,
    required super.timestamp,
    required super.isNormal,
    required this.accuracy,
    required this.initialAccuracy,
    required this.calibrationDate,
    required this.status,
    this.historicalData = const [],
    this.aiAnalysis,
  });

  factory EnhancedSensorData.fromSensorData(
    SensorData sensorData, {
    required double accuracy,
    required double initialAccuracy,
    required DateTime calibrationDate,
    required SensorStatus status,
    List<DataPoint> historicalData = const [],
    AIAnalysis? aiAnalysis,
  }) {
    return EnhancedSensorData(
      type: sensorData.type,
      value: sensorData.value,
      unit: sensorData.unit,
      timestamp: sensorData.timestamp,
      isNormal: sensorData.isNormal,
      accuracy: accuracy,
      initialAccuracy: initialAccuracy,
      calibrationDate: calibrationDate,
      status: status,
      historicalData: historicalData,
      aiAnalysis: aiAnalysis,
    );
  }

  double get accuracyImprovement => accuracy - initialAccuracy;

  bool get isCalibrated =>
      DateTime.now().difference(calibrationDate).inDays < 30;

  String get statusText {
    switch (status) {
      case SensorStatus.excellent:
        return "Excellent";
      case SensorStatus.good:
        return "Good";
      case SensorStatus.fair:
        return "Fair";
      case SensorStatus.poor:
        return "Poor";
      case SensorStatus.needsCalibration:
        return "Needs Calibration";
    }
  }
}

enum SensorStatus {
  excellent,
  good,
  fair,
  poor,
  needsCalibration,
}

class DataPoint {
  final double value;
  final DateTime timestamp;
  final double accuracy;

  DataPoint({
    required this.value,
    required this.timestamp,
    required this.accuracy,
  });
}

class AIAnalysis {
  final String recommendation;
  final String trend;
  final double confidence;
  final List<String> insights;
  final DateTime analysisTime;

  AIAnalysis({
    required this.recommendation,
    required this.trend,
    required this.confidence,
    required this.insights,
    required this.analysisTime,
  });

  String get confidenceText {
    if (confidence >= 0.9) return "Very High";
    if (confidence >= 0.7) return "High";
    if (confidence >= 0.5) return "Medium";
    return "Low";
  }
}
