// 현재 위치와 역 위치를 비교해 도착 알림 이벤트를 계산한다.
import 'dart:math';

import '../models/subway_alert.dart';

class GeoPoint {
  const GeoPoint({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

class StationLocation {
  const StationLocation({
    required this.stationName,
    required this.point,
  });

  final String stationName;
  final GeoPoint point;
}

class AlertEvent {
  const AlertEvent({
    required this.stationName,
    required this.push,
    required this.vibration,
    required this.voice,
  });

  final String stationName;
  final bool push;
  final bool vibration;
  final bool voice;
}

class ArrivalAlertEngine {
  ArrivalAlertEngine({
    this.thresholdMeters = 250,
    Set<String>? notifiedStations,
  }) : _notifiedStations = notifiedStations ?? <String>{};

  final double thresholdMeters;
  final Set<String> _notifiedStations;

  AlertEvent? evaluate({
    required GeoPoint? current,
    required SubwayAlert alert,
    required StationLocation? target,
  }) {
    if (current == null ||
        target == null ||
        _notifiedStations.contains(alert.station.name)) {
      return null;
    }

    final distance = distanceMeters(current, target.point);
    if (distance > thresholdMeters) {
      return null;
    }

    _notifiedStations.add(alert.station.name);
    return AlertEvent(
      stationName: alert.station.name,
      push: alert.push,
      vibration: alert.vibration,
      voice: alert.voice,
    );
  }

  double distanceMeters(GeoPoint a, GeoPoint b) {
    const earthRadiusMeters = 6371000.0;
    final dLat = _toRadians(b.latitude - a.latitude);
    final dLng = _toRadians(b.longitude - a.longitude);
    final lat1 = _toRadians(a.latitude);
    final lat2 = _toRadians(b.latitude);

    final haversine = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLng / 2) * sin(dLng / 2);
    return earthRadiusMeters * 2 * atan2(sqrt(haversine), sqrt(1 - haversine));
  }

  double _toRadians(double degrees) => degrees * pi / 180;
}
