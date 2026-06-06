import 'station.dart';

enum AlertTiming {
  onArrival('on_arrival', '도착할 때'),
  oneStationBefore('one_station_before', '1정거장 전'),
  twoStationsBefore('two_stations_before', '2정거장 전');

  const AlertTiming(this.value, this.label);

  final String value;
  final String label;

  static AlertTiming fromJson(Object? value) {
    for (final timing in AlertTiming.values) {
      if (timing.value == value) {
        return timing;
      }
    }
    return AlertTiming.onArrival;
  }
}

class SubwayAlert {
  const SubwayAlert({
    required this.station,
    this.timing = AlertTiming.onArrival,
    this.push = true,
    this.vibration = true,
    this.voice = false,
  });

  final Station station;
  final AlertTiming timing;
  final bool push;
  final bool vibration;
  final bool voice;

  factory SubwayAlert.fromJson(
    Map<String, dynamic> json, {
    required Station Function(String name) findStation,
  }) {
    final stationName =
        json['stationName'] as String? ?? json['station'] as String;

    return SubwayAlert(
      station: findStation(stationName),
      timing: AlertTiming.fromJson(json['timing']),
      push: json['push'] as bool? ?? true,
      vibration: json['vibration'] as bool? ?? true,
      voice: json['voice'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stationName': station.name,
      'lines': station.lines,
      'description': station.description,
      'timing': timing.value,
      'push': push,
      'vibration': vibration,
      'voice': voice,
    };
  }

  SubwayAlert copyWith({
    Station? station,
    AlertTiming? timing,
    bool? push,
    bool? vibration,
    bool? voice,
  }) {
    return SubwayAlert(
      station: station ?? this.station,
      timing: timing ?? this.timing,
      push: push ?? this.push,
      vibration: vibration ?? this.vibration,
      voice: voice ?? this.voice,
    );
  }
}
