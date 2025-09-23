import 'dart:async';
import '../models/enhanced_sensor_data.dart';
import '../services/database_service.dart';

class SensorRepository {
  const SensorRepository();

  Future<List<EnhancedSensorData>> fetchLatestEnhancedSensors() async {
    // Query latest reading per type using DISTINCT ON
    const sql = 'SELECT DISTINCT ON (type) '
        'type, value, unit, timestamp, accuracy, initial_accuracy, calibration_date '
        'FROM sensor_readings '
        'ORDER BY type, timestamp DESC';

    final rows = await DatabaseService.instance.query(sql);

    final now = DateTime.now();
    final List<EnhancedSensorData> sensors = [];
    for (final row in rows) {
      final String type = row[0] as String;
      final double value = (row[1] as num).toDouble();
      final String unit = row[2] as String;
      final DateTime timestamp = row[3] as DateTime? ?? now;
      final double accuracy = (row[4] as num?)?.toDouble() ?? 90.0;
      final double initialAccuracy = (row[5] as num?)?.toDouble() ?? accuracy;
      final DateTime calibrationDate = row[6] as DateTime? ?? now;

      sensors.add(
        EnhancedSensorData(
          type: type,
          value: value,
          unit: unit,
          timestamp: timestamp,
          isNormal: _isValueNormal(type, value),
          accuracy: accuracy,
          initialAccuracy: initialAccuracy,
          calibrationDate: calibrationDate,
          status: _getSensorStatus(accuracy),
          historicalData: const [],
          aiAnalysis: null,
        ),
      );
    }
    return sensors;
  }

  Future<List<DataPoint>> fetchHistory(
      {required String type, int limit = 50}) async {
    const sql = 'SELECT value, timestamp, accuracy '
        'FROM sensor_readings '
        'WHERE type = @type '
        'ORDER BY timestamp DESC '
        'LIMIT @limit';

    final rows = await DatabaseService.instance
        .query(sql, params: {'type': type, 'limit': limit});

    return rows
        .map((r) => DataPoint(
              value: (r[0] as num).toDouble(),
              timestamp: r[1] as DateTime,
              accuracy: (r[2] as num?)?.toDouble() ?? 90.0,
            ))
        .toList()
        .reversed
        .toList();
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

  SensorStatus _getSensorStatus(double accuracy) {
    if (accuracy >= 98) return SensorStatus.excellent;
    if (accuracy >= 95) return SensorStatus.good;
    if (accuracy >= 90) return SensorStatus.fair;
    if (accuracy >= 80) return SensorStatus.poor;
    return SensorStatus.needsCalibration;
  }
}
