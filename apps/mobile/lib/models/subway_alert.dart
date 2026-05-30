import 'station.dart';

class SubwayAlert {
  const SubwayAlert({
    required this.station,
    this.push = true,
    this.vibration = true,
    this.voice = false,
  });

  final Station station;
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
      'push': push,
      'vibration': vibration,
      'voice': voice,
    };
  }

  SubwayAlert copyWith({
    Station? station,
    bool? push,
    bool? vibration,
    bool? voice,
  }) {
    return SubwayAlert(
      station: station ?? this.station,
      push: push ?? this.push,
      vibration: vibration ?? this.vibration,
      voice: voice ?? this.voice,
    );
  }
}
