import 'package:flutter/material.dart';

import '../data/stations.dart';
import '../models/station.dart';
import '../models/subway_alert.dart';
import '../sheets/alert_list_sheet.dart';
import '../sheets/alert_sheet.dart';
import '../sheets/alert_sheet_result.dart';
import '../theme/app_colors.dart';
import '../theme/decorations.dart';
import '../widgets/alert_widgets.dart';
import '../widgets/common.dart';
import '../widgets/search_pebble.dart';
import '../widgets/station_widgets.dart';
import 'search_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _queryController = TextEditingController();
  bool _searching = false;
  List<SubwayAlert> _alerts = const [
    SubwayAlert(station: Station('잠실', ['2', '8'], '송파구 · 환승역')),
    SubwayAlert(
      station: Station('강남', ['2', '신분당'], '강남구 · 환승역'),
      vibration: false,
    ),
    SubwayAlert(
      station: Station('서울역', ['1', '4', '경의중앙', '공항'], '용산구 · 환승역'),
      voice: true,
    ),
  ];

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appSoft,
      body: Stack(
        children: [
          _HomeContent(
            alerts: _alerts,
            onSearch: () => setState(() => _searching = true),
            onStationTap: _openAlertSheet,
            onAlertStackTap: _openAlertListSheet,
          ),
          if (_searching)
            SearchOverlay(
              controller: _queryController,
              alerts: _alerts,
              onBack: () {
                _queryController.clear();
                setState(() => _searching = false);
              },
              onPick: _openAlertSheet,
            ),
        ],
      ),
    );
  }

  Future<void> _openAlertListSheet() async {
    final picked = await showModalBottomSheet<SubwayAlert>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AlertListSheet(alerts: _alerts),
    );

    if (picked != null) {
      await _openAlertSheet(picked.station);
    }
  }

  Future<void> _openAlertSheet(Station station) async {
    final existing = _findAlert(station);
    final result = await showModalBottomSheet<AlertSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AlertSheet(station: station, existing: existing),
    );

    if (result == null) {
      return;
    }

    setState(() {
      _searching = false;
      _queryController.clear();
      if (result.remove) {
        _alerts = _alerts
            .where((alert) => alert.station.name != station.name)
            .toList();
      } else {
        final next = SubwayAlert(
          station: station,
          push: result.push,
          vibration: result.vibration,
          voice: result.voice,
        );
        _alerts = [
          next,
          ..._alerts.where((alert) => alert.station.name != station.name),
        ];
      }
    });

    if (!mounted) {
      return;
    }

    final message = result.remove
        ? '${station.name}역 알림이 해제됐어요'
        : '${station.name}역 알림 ${existing == null ? '설정' : '변경'} 완료';
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: appInk,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: Text(message,
              style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
      );
  }

  SubwayAlert? _findAlert(Station station) {
    for (final alert in _alerts) {
      if (alert.station.name == station.name) {
        return alert;
      }
    }
    return null;
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.alerts,
    required this.onSearch,
    required this.onStationTap,
    required this.onAlertStackTap,
  });

  final List<SubwayAlert> alerts;
  final VoidCallback onSearch;
  final ValueChanged<Station> onStationTap;
  final VoidCallback onAlertStackTap;

  @override
  Widget build(BuildContext context) {
    final popular = ['강남', '홍대입구', '잠실', '서울역', '사당', '신촌', '여의도']
        .map((name) => stations.firstWhere((station) => station.name == name));

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -1),
          radius: 1.2,
          colors: [Color(0xFFE0EBFE), appSoft],
          stops: [0, 0.62],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _Header(nearby: stations.first),
                  const SizedBox(height: 22),
                  SearchPebble(onTap: onSearch),
                  const SizedBox(height: 28),
                  SectionHeader(title: '내 알림', action: '${alerts.length}개 활성'),
                  const SizedBox(height: 14),
                  if (alerts.isEmpty)
                    const EmptyAlertPebble()
                  else if (alerts.length == 1)
                    AlertCard(
                        alert: alerts.first,
                        onTap: () => onStationTap(alerts.first.station))
                  else
                    AlertStack(alerts: alerts, onTap: onAlertStackTap),
                  const SizedBox(height: 30),
                  const SectionHeader(title: '자주 검색하는 역'),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 9,
                    children: [
                      for (final station in popular)
                        SuggestionChipPebble(
                          station: station,
                          onTap: () => onStationTap(station),
                        ),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.nearby});

  final Station nearby;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '지하철 푸시',
              style: TextStyle(
                color: Color(0xFF3B82F6),
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(9, 7, 11, 7),
              decoration: pebbleDecoration(radius: 16, shadowOpacity: 0.04),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: Color(0xFF3B82F6), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 7),
                  const Text('현재',
                      style: TextStyle(
                          color: appMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(width: 6),
                  LineBadge(line: nearby.lines.first, size: 14),
                  const SizedBox(width: 5),
                  Text(nearby.name,
                      style: const TextStyle(
                          color: appInk,
                          fontSize: 12,
                          fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text(
          '푹 자도 괜찮아요,\n제가 깨워드릴게요',
          style: TextStyle(
            color: appInk,
            fontSize: 30,
            height: 1.18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
