import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  bool _serviceEnabled = false;
  LocationPermission _permission = LocationPermission.denied;
  Stream<Position>? _positionStream;

  Position? get currentPosition => _currentPosition;
  bool get serviceEnabled => _serviceEnabled;
  LocationPermission get permission => _permission;

  Future<void> initialize() async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      notifyListeners();
      return;
    }

    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
    }

    if (_permission == LocationPermission.deniedForever ||
        _permission == LocationPermission.denied) {
      notifyListeners();
      return;
    }

    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
    } catch (_) {}

    _positionStream ??= Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    );

    _positionStream!.listen((pos) {
      _currentPosition = pos;
      notifyListeners();
    });

    notifyListeners();
  }
}


