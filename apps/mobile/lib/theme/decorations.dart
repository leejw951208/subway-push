import 'package:flutter/material.dart';

import 'app_colors.dart';

BoxDecoration pebbleDecoration({
  required double radius,
  Color shadowColor = appInk,
  double shadowOpacity = 0.06,
  Color borderColor = const Color(0x0A0F172A),
  double borderWidth = 1,
}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: borderColor, width: borderWidth),
    boxShadow: [
      BoxShadow(
          color: shadowColor.withValues(alpha: shadowOpacity),
          blurRadius: 8,
          offset: const Offset(0, 2)),
    ],
  );
}

BoxDecoration stackLayerDecoration(Color color, double radius) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
          color: appBlue.withValues(alpha: 0.10),
          blurRadius: 16,
          offset: const Offset(0, 6))
    ],
  );
}
