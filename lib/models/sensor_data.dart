class SensorData {
  final String type;
  final double value;
  final String unit;
  final DateTime timestamp;
  final bool isNormal;

  const SensorData({
    required this.type,
    required this.value,
    required this.unit,
    required this.timestamp,
    required this.isNormal,
  });

  SensorData copyWith({
    String? type,
    double? value,
    String? unit,
    DateTime? timestamp,
    bool? isNormal,
  }) {
    return SensorData(
      type: type ?? this.type,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      timestamp: timestamp ?? this.timestamp,
      isNormal: isNormal ?? this.isNormal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'isNormal': isNormal,
    };
  }

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      type: json['type'],
      value: json['value'].toDouble(),
      unit: json['unit'],
      timestamp: DateTime.parse(json['timestamp']),
      isNormal: json['isNormal'],
    );
  }
}
