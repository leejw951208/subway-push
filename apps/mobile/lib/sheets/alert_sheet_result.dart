import '../models/subway_alert.dart';

class AlertSheetResult {
  const AlertSheetResult({
    required this.timing,
    required this.push,
    required this.vibration,
    required this.voice,
    this.remove = false,
  });

  final AlertTiming timing;
  final bool push;
  final bool vibration;
  final bool voice;
  final bool remove;
}
