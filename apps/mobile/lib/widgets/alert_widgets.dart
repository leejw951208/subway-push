import 'package:flutter/material.dart';

import '../models/subway_alert.dart';
import '../theme/app_colors.dart';
import '../theme/decorations.dart';
import 'common.dart';
import 'station_widgets.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({required this.alert, required this.onTap, super.key});

  final SubwayAlert alert;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pebble(
        active: true, onTap: onTap, child: AlertCardBody(alert: alert));
  }
}

class AlertStack extends StatelessWidget {
  const AlertStack({required this.alerts, required this.onTap, super.key});

  final List<SubwayAlert> alerts;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final extras = (alerts.length - 1).clamp(0, 2);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: extras * 8),
        child: Stack(
          children: [
            if (extras >= 2)
              Positioned(
                left: 24,
                right: 24,
                top: 16,
                height: 60,
                child: DecoratedBox(
                    decoration:
                        stackLayerDecoration(const Color(0xFFC7DBFD), 24)),
              ),
            if (extras >= 1)
              Positioned(
                left: 12,
                right: 12,
                top: 8,
                height: 68,
                child: DecoratedBox(
                    decoration:
                        stackLayerDecoration(const Color(0xFFDCEAFE), 26)),
              ),
            Pebble(
              active: true,
              child: Row(
                children: [
                  Expanded(child: AlertCardBody(alert: alerts.first)),
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 7, 10, 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                          colors: [Color(0xFFDBEAFE), Color(0xFFBFDBFE)]),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '+${alerts.length - 1}',
                          style: const TextStyle(
                              color: Color(0xFF1D4ED8),
                              fontSize: 13,
                              fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.chevron_right_rounded,
                            color: Color(0xFF1D4ED8), size: 17),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlertCardBody extends StatelessWidget {
  const AlertCardBody({required this.alert, super.key});

  final SubwayAlert alert;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: appBlue.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Center(
              child: LineBadge(line: alert.station.lines.first, size: 26)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${alert.station.name}역',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: appInk, fontSize: 17, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              AlertMethods(alert: alert),
            ],
          ),
        ),
      ],
    );
  }
}

class AlertListTile extends StatelessWidget {
  const AlertListTile({required this.alert, required this.onTap, super.key});

  final SubwayAlert alert;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Pebble(
      active: true,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: appBlue.withValues(alpha: 0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Center(
                child: LineBadge(line: alert.station.lines.first, size: 24)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${alert.station.name}역',
                  style: const TextStyle(
                      color: appInk, fontSize: 16, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                AlertMethods(alert: alert, small: true),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }
}

class AlertMethods extends StatelessWidget {
  const AlertMethods({required this.alert, this.small = false, super.key});

  final SubwayAlert alert;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      if (alert.push)
        _Method(icon: Icons.notifications_rounded, label: '푸시', small: small),
      if (alert.vibration)
        _Method(icon: Icons.vibration_rounded, label: '진동', small: small),
      if (alert.voice)
        _Method(icon: Icons.volume_up_rounded, label: '음성', small: small),
    ];

    return Wrap(spacing: 6, runSpacing: 2, children: items);
  }
}

class _Method extends StatelessWidget {
  const _Method({required this.icon, required this.label, required this.small});

  final IconData icon;
  final String label;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: small ? 12 : 14, color: const Color(0xFF3B82F6)),
        const SizedBox(width: 2),
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF3B82F6),
            fontSize: small ? 11.5 : 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
