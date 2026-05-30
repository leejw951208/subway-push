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
}
