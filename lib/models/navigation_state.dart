class NavigationState {
  final double currentSpeed;
  final double avgSpeed;
  final double maxSpeed;
  final double distance;
  final String speedUnit;
  final bool hasGpsFix;
  final double latitude;
  final double longitude;
  final double? destLatitude;
  final double? destLongitude;
  final String? destLabel;
  final int etaMinutes;
  final double accuracy;

  const NavigationState({
    this.currentSpeed = 0,
    this.avgSpeed = 0,
    this.maxSpeed = 0,
    this.distance = 0,
    this.speedUnit = 'km/h',
    this.hasGpsFix = false,
    this.latitude = 37.7749,
    this.longitude = -122.4194,
    this.destLatitude,
    this.destLongitude,
    this.destLabel,
    this.etaMinutes = 0,
    this.accuracy = 0,
  });

  NavigationState copyWith({
    double? currentSpeed,
    double? avgSpeed,
    double? maxSpeed,
    double? distance,
    String? speedUnit,
    bool? hasGpsFix,
    double? latitude,
    double? longitude,
    double? destLatitude,
    double? destLongitude,
    String? destLabel,
    int? etaMinutes,
    double? accuracy,
  }) {
    return NavigationState(
      currentSpeed: currentSpeed ?? this.currentSpeed,
      avgSpeed: avgSpeed ?? this.avgSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      distance: distance ?? this.distance,
      speedUnit: speedUnit ?? this.speedUnit,
      hasGpsFix: hasGpsFix ?? this.hasGpsFix,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      destLatitude: destLatitude ?? this.destLatitude,
      destLongitude: destLongitude ?? this.destLongitude,
      destLabel: destLabel ?? this.destLabel,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      accuracy: accuracy ?? this.accuracy,
    );
  }
}
