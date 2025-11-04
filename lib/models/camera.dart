class CameraDevice {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String? streamUrl;
  bool isRecording;

  CameraDevice({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.streamUrl,
    this.isRecording = false,
  });
}


