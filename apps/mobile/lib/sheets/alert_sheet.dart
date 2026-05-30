import 'package:flutter/material.dart';

import '../models/station.dart';
import '../models/subway_alert.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import '../widgets/station_widgets.dart';
import '../widgets/toggle_row.dart';
import 'alert_sheet_result.dart';

class AlertSheet extends StatefulWidget {
  const AlertSheet({required this.station, required this.existing, super.key});

  final Station station;
  final SubwayAlert? existing;

  @override
  State<AlertSheet> createState() => _AlertSheetState();
}

class _AlertSheetState extends State<AlertSheet> {
  late bool _push = widget.existing?.push ?? true;
  late bool _vibration = widget.existing?.vibration ?? true;
  late bool _voice = widget.existing?.voice ?? false;

  bool get _hasAny => _push || _vibration || _voice;

  @override
  Widget build(BuildContext context) {
    return SheetShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SheetGrabber(),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: appBlue.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Center(
                    child:
                        LineBadge(line: widget.station.lines.first, size: 34)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                            color: appInk, fontWeight: FontWeight.w900),
                        children: [
                          TextSpan(
                              text: widget.station.name,
                              style: const TextStyle(fontSize: 24)),
                          const TextSpan(
                              text: '역',
                              style: TextStyle(color: appMuted, fontSize: 18)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        LineRow(lines: widget.station.lines, size: 16),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            widget.station.description,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: appMuted,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '도착 알림 방식',
              style: TextStyle(
                  color: appMuted, fontSize: 13, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 10),
          ToggleRow(
            icon: Icons.notifications_rounded,
            label: '푸시 알림',
            sub: '잠금화면과 알림센터에 표시',
            value: _push,
            onChanged: (value) => setState(() => _push = value),
          ),
          const SizedBox(height: 10),
          ToggleRow(
            icon: Icons.vibration_rounded,
            label: '진동',
            sub: '3회 길게 진동해요',
            value: _vibration,
            onChanged: (value) => setState(() => _vibration = value),
          ),
          const SizedBox(height: 10),
          ToggleRow(
            icon: Icons.record_voice_over_rounded,
            label: '음성 안내',
            sub: '"잠실역에 도착했습니다" 음성 재생',
            value: _voice,
            onChanged: (value) => setState(() => _voice = value),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: widget.existing == null ? '알림 설정 완료' : '변경사항 저장',
            enabled: _hasAny,
            onPressed: () => Navigator.of(context).pop(
              AlertSheetResult(
                  push: _push, vibration: _vibration, voice: _voice),
            ),
          ),
          if (widget.existing != null) ...[
            const SizedBox(height: 10),
            DangerButton(
              label: '알림 해제하기',
              onPressed: () => Navigator.of(context).pop(
                const AlertSheetResult(
                    push: false, vibration: false, voice: false, remove: true),
              ),
            ),
          ],
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 4),
        ],
      ),
    );
  }
}
