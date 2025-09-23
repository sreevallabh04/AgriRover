enum RoverMode { manual, automatic, maintenance }

class RoverStatus {
  final bool isPowered;
  final double batteryLevel;
  final RoverMode mode;
  final String position;
  final bool isConnected;

  const RoverStatus({
    required this.isPowered,
    required this.batteryLevel,
    required this.mode,
    required this.position,
    required this.isConnected,
  });

  RoverStatus copyWith({
    bool? isPowered,
    double? batteryLevel,
    RoverMode? mode,
    String? position,
    bool? isConnected,
  }) {
    return RoverStatus(
      isPowered: isPowered ?? this.isPowered,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      mode: mode ?? this.mode,
      position: position ?? this.position,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isPowered': isPowered,
      'batteryLevel': batteryLevel,
      'mode': mode.name,
      'position': position,
      'isConnected': isConnected,
    };
  }

  factory RoverStatus.fromJson(Map<String, dynamic> json) {
    return RoverStatus(
      isPowered: json['isPowered'],
      batteryLevel: json['batteryLevel'].toDouble(),
      mode: RoverMode.values.firstWhere((e) => e.name == json['mode']),
      position: json['position'],
      isConnected: json['isConnected'],
    );
  }
}
