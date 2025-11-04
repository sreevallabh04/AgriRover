import 'package:flutter/foundation.dart';
import '../models/camera.dart';

class CamerasProvider with ChangeNotifier {
  final List<CameraDevice> _cameras = [
    CameraDevice(
      id: 'cam-1',
      name: 'Rover A - Field North',
      latitude: 37.4219999,
      longitude: -122.0840575,
      streamUrl: null,
    ),
    CameraDevice(
      id: 'cam-2',
      name: 'Rover B - Greenhouse',
      latitude: 37.4225,
      longitude: -122.081,
      streamUrl: null,
    ),
    CameraDevice(
      id: 'cam-3',
      name: 'Rover C - Field South',
      latitude: 37.4205,
      longitude: -122.086,
      streamUrl: null,
    ),
  ];

  List<CameraDevice> get cameras => List.unmodifiable(_cameras);

  void toggleRecording(String id) {
    final cam = _cameras.firstWhere((c) => c.id == id);
    cam.isRecording = !cam.isRecording;
    notifyListeners();
  }
}


