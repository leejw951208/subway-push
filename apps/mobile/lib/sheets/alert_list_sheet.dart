import 'package:flutter/material.dart';

import '../models/subway_alert.dart';
import '../theme/app_colors.dart';
import '../widgets/alert_widgets.dart';
import '../widgets/common.dart';

class AlertListSheet extends StatelessWidget {
  const AlertListSheet({required this.alerts, super.key});

  final List<SubwayAlert> alerts;

  @override
  Widget build(BuildContext context) {
    return SheetShell(
      maxHeightFactor: 0.78,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SheetGrabber(),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('설정된 알림',
                  style: TextStyle(
                      color: appInk,
                      fontSize: 22,
                      fontWeight: FontWeight.w900)),
              Text('${alerts.length}개',
                  style: const TextStyle(
                      color: Color(0xFF3B82F6),
                      fontSize: 13,
                      fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 14),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: alerts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return AlertListTile(
                  alert: alert,
                  onTap: () => Navigator.of(context).pop(alert),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 4),
        ],
      ),
    );
  }
}
