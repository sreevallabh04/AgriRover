class IrrigationStatus {
  final bool isActive;
  final DateTime? lastIrrigation;
  final DateTime? nextScheduled;
  final double totalWaterUsed;
  final double efficiency;

  const IrrigationStatus({
    required this.isActive,
    this.lastIrrigation,
    this.nextScheduled,
    required this.totalWaterUsed,
    required this.efficiency,
  });

  IrrigationStatus copyWith({
    bool? isActive,
    DateTime? lastIrrigation,
    DateTime? nextScheduled,
    double? totalWaterUsed,
    double? efficiency,
  }) {
    return IrrigationStatus(
      isActive: isActive ?? this.isActive,
      lastIrrigation: lastIrrigation ?? this.lastIrrigation,
      nextScheduled: nextScheduled ?? this.nextScheduled,
      totalWaterUsed: totalWaterUsed ?? this.totalWaterUsed,
      efficiency: efficiency ?? this.efficiency,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isActive': isActive,
      'lastIrrigation': lastIrrigation?.toIso8601String(),
      'nextScheduled': nextScheduled?.toIso8601String(),
      'totalWaterUsed': totalWaterUsed,
      'efficiency': efficiency,
    };
  }

  factory IrrigationStatus.fromJson(Map<String, dynamic> json) {
    return IrrigationStatus(
      isActive: json['isActive'],
      lastIrrigation: json['lastIrrigation'] != null
          ? DateTime.parse(json['lastIrrigation'])
          : null,
      nextScheduled: json['nextScheduled'] != null
          ? DateTime.parse(json['nextScheduled'])
          : null,
      totalWaterUsed: json['totalWaterUsed'].toDouble(),
      efficiency: json['efficiency'].toDouble(),
    );
  }
}
