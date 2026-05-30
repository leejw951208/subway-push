class AlertSheetResult {
  const AlertSheetResult({
    required this.push,
    required this.vibration,
    required this.voice,
    this.remove = false,
  });

  final bool push;
  final bool vibration;
  final bool voice;
  final bool remove;
}
