import 'package:flutter/foundation.dart';
import '../models/sensor_data.dart';

class PredictiveInsight {
  final double recommendedIrrigationPercent;
  final bool anomalyDetected;
  final String summary;
  const PredictiveInsight({
    required this.recommendedIrrigationPercent,
    required this.anomalyDetected,
    required this.summary,
  });
}

class PredictiveProvider with ChangeNotifier {
  PredictiveInsight _latest = const PredictiveInsight(
    recommendedIrrigationPercent: 0,
    anomalyDetected: false,
    summary: 'Insufficient data',
  );

  PredictiveInsight get latest => _latest;

  void recompute(List<SensorData> sensors) {
    if (sensors.isEmpty) {
      _latest = const PredictiveInsight(
        recommendedIrrigationPercent: 0,
        anomalyDetected: false,
        summary: 'No sensors available',
      );
      notifyListeners();
      return;
    }

    final moisture = sensors.firstWhere(
      (s) => s.type == 'Soil Moisture',
      orElse: () => SensorData(
        type: 'Soil Moisture',
        value: 50,
        unit: '%',
        timestamp: DateTime.now(),
        isNormal: true,
      ),
    );
    final temp = sensors.firstWhere(
      (s) => s.type == 'Temperature',
      orElse: () => SensorData(
        type: 'Temperature',
        value: 28,
        unit: '°C',
        timestamp: DateTime.now(),
        isNormal: true,
      ),
    );
    final humidity = sensors.firstWhere(
      (s) => s.type == 'Humidity',
      orElse: () => SensorData(
        type: 'Humidity',
        value: 40,
        unit: '%',
        timestamp: DateTime.now(),
        isNormal: true,
      ),
    );

    // Simple heuristic: lower soil moisture -> higher irrigation; hot and dry -> increase more
    double irrigation = (60 - moisture.value).clamp(0, 40);
    irrigation += (temp.value > 32 ? 10 : 0);
    irrigation += (humidity.value < 35 ? 5 : 0);
    irrigation = irrigation.clamp(0, 60);

    final anomaly = sensors.any((s) => !s.isNormal);
    final summary = anomaly
        ? 'Anomaly detected in sensor readings; apply caution.'
        : 'Field within expected range. Apply ${irrigation.toStringAsFixed(0)}% irrigation.';

    _latest = PredictiveInsight(
      recommendedIrrigationPercent: irrigation.toDouble(),
      anomalyDetected: anomaly,
      summary: summary,
    );
    notifyListeners();
  }
}
