import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/navigation_state.dart';

class NavigationProvider extends ChangeNotifier {
  NavigationState _state = const NavigationState();
  StreamSubscription<Position>? _positionSubscription;

  NavigationState get state => _state;

  Future<void> startLocationUpdates() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
        timeLimit: null,
      ),
    ).listen(_onPositionUpdate);
  }

  void _onPositionUpdate(Position pos) {
    _state = _state.copyWith(
      latitude: pos.latitude,
      longitude: pos.longitude,
      accuracy: pos.accuracy,
      hasGpsFix: pos.accuracy < 50,
      currentSpeed: pos.speed * 3.6,
    );
    notifyListeners();
  }

  void setDestination(double lat, double lng, String label) {
    _state = _state.copyWith(
      destLatitude: lat,
      destLongitude: lng,
      destLabel: label,
    );
    _calculateRoute();
    notifyListeners();
  }

  void clearDestination() {
    _state = _state.copyWith(
      destLatitude: null,
      destLongitude: null,
      destLabel: null,
      etaMinutes: 0,
      distance: 0,
    );
    notifyListeners();
  }

  void _calculateRoute() {
    if (_state.destLatitude == null || _state.destLongitude == null) return;
    final distance = Geolocator.distanceBetween(
      _state.latitude,
      _state.longitude,
      _state.destLatitude!,
      _state.destLongitude!,
    );
    final speed = _state.currentSpeed > 0 ? _state.currentSpeed : 40;
    final eta = (distance / 1000) / speed * 60;
    _state = _state.copyWith(
      distance: distance / 1000,
      etaMinutes: eta.round(),
    );
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }
}
