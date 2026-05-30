import 'package:flutter/material.dart';

import '../data/stations.dart';
import '../models/station.dart';
import '../theme/app_colors.dart';
import '../theme/decorations.dart';
import 'common.dart';

class StationResultPebble extends StatelessWidget {
  const StationResultPebble({
    required this.station,
    required this.active,
    required this.onTap,
    super.key,
  });

  final Station station;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pebble(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          LineRow(lines: station.lines.take(3).toList(), size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(station.name,
                    style: const TextStyle(
                        color: appInk,
                        fontSize: 16,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text(station.description,
                    style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          if (active)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                    colors: [Color(0xFFDBEAFE), Color(0xFFBFDBFE)]),
              ),
              child: const Text(
                '알림 ON',
                style: TextStyle(
                    color: Color(0xFF1D4ED8),
                    fontSize: 11,
                    fontWeight: FontWeight.w900),
              ),
            ),
        ],
      ),
    );
  }
}

class SuggestionChipPebble extends StatelessWidget {
  const SuggestionChipPebble(
      {required this.station, required this.onTap, super.key});

  final Station station;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 14, 10),
        decoration: pebbleDecoration(radius: 20, shadowOpacity: 0.05),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            LineBadge(line: station.lines.first, size: 20),
            const SizedBox(width: 8),
            Text(
              station.name,
              style: const TextStyle(
                  color: appInk, fontSize: 14, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class LineRow extends StatelessWidget {
  const LineRow({required this.lines, this.size = 22, super.key});

  final List<String> lines;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final line in lines) ...[
          LineBadge(line: line, size: size),
          if (line != lines.last) const SizedBox(width: 4),
        ],
      ],
    );
  }
}

class LineBadge extends StatelessWidget {
  const LineBadge({required this.line, this.size = 22, super.key});

  final String line;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = lineColors[line] ?? const Color(0xFF94A3B8);
    final numeric = int.tryParse(line) != null;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: color.withValues(alpha: 0.33),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Text(
        numeric ? line : line.substring(0, 1),
        style: TextStyle(
          color: Colors.white,
          fontSize: numeric ? size * 0.54 : size * 0.36,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}
