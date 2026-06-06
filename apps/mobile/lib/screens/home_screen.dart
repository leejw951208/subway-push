import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/subway_repository.dart';
import '../data/stations.dart';
import '../models/station.dart';
import '../models/subway_alert.dart';
import '../notifications/notification_service.dart';
import '../sheets/alert_list_sheet.dart';
import '../sheets/alert_sheet.dart';
import '../sheets/alert_sheet_result.dart';
import '../state/alert_controller.dart';
import '../theme/app_colors.dart';
import '../theme/decorations.dart';
import '../widgets/alert_widgets.dart';
import '../widgets/common.dart';
import '../widgets/search_pebble.dart';
import '../widgets/station_widgets.dart';
import 'search_overlay.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({NotificationService? notificationService, super.key})
      : _notificationService = notificationService;

  final NotificationService? _notificationService;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _queryController = TextEditingController();
  late final NotificationService _notificationService =
      widget._notificationService ?? NotificationService();
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(alertControllerProvider.notifier).load());
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final alerts = ref.watch(alertControllerProvider);
    final remoteStations = ref.watch(remoteStationsProvider);

    return Scaffold(
      backgroundColor: appSoft,
      body: Stack(
        children: [
          _HomeContent(
            alerts: alerts,
            remoteStations: remoteStations,
            onSearch: () => setState(() => _searching = true),
            onStationTap: _openAlertSheet,
            onAlertStackTap: _openAlertListSheet,
            onTestNotification: _showTestNotification,
          ),
          if (_searching)
            SearchOverlay(
              controller: _queryController,
              alerts: alerts,
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
      builder: (context) =>
          AlertListSheet(alerts: ref.read(alertControllerProvider)),
    );

    if (picked != null) {
      await _openAlertSheet(picked.station);
    }
  }

  Future<void> _openAlertSheet(Station station) async {
    final controller = ref.read(alertControllerProvider.notifier);
    final existing = controller.findByStation(station);
    final result = await showModalBottomSheet<AlertSheetResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AlertSheet(station: station, existing: existing),
    );

    if (result == null) {
      return;
    }

    setState(() => _searching = false);
    _queryController.clear();
    if (result.remove) {
      await controller.removeAlert(station);
    } else {
      await controller.upsertAlert(
        SubwayAlert(
          station: station,
          push: result.push,
          vibration: result.vibration,
          voice: result.voice,
        ),
      );
    }

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

  Future<void> _showTestNotification() async {
    try {
      await _notificationService.initialize();
      final status = await _notificationService.requestPermission();

      if (!mounted) {
        return;
      }

      if (!status.isGranted) {
        _showSnackBar('알림 권한이 필요해요');
        return;
      }

      await _notificationService.showTestNotification();
    } on Object {
      if (!mounted) {
        return;
      }
      _showSnackBar('알림을 보낼 수 없어요');
    }
  }

  void _showSnackBar(String message) {
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
}

class _ApiStatusBanner extends ConsumerWidget {
  const _ApiStatusBanner({required this.remoteStations});

  final AsyncValue<List<Station>> remoteStations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return remoteStations.when(
      data: (_) => const SizedBox.shrink(),
      loading: () => const Padding(
        padding: EdgeInsets.only(bottom: 14),
        child: Text(
          '역 정보를 불러오는 중',
          style: TextStyle(
            color: appMuted,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      error: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Pebble(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  '역 정보를 불러오지 못했어요',
                  style: TextStyle(
                    color: appInk,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => ref.invalidate(remoteStationsProvider),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.alerts,
    required this.remoteStations,
    required this.onSearch,
    required this.onStationTap,
    required this.onAlertStackTap,
    required this.onTestNotification,
  });

  final List<SubwayAlert> alerts;
  final AsyncValue<List<Station>> remoteStations;
  final VoidCallback onSearch;
  final ValueChanged<Station> onStationTap;
  final VoidCallback onAlertStackTap;
  final VoidCallback onTestNotification;

  @override
  Widget build(BuildContext context) {
    const popularNames = ['강남', '홍대입구', '잠실', '서울역', '사당', '신촌', '여의도'];
    final stationSource = remoteStations.when(
      data: (value) => value,
      loading: () => stations,
      error: (_, __) => stations,
    );
    final popular = popularNames
        .map((name) =>
            stationSource.where((station) => station.name == name).firstOrNull)
        .whereType<Station>();

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
                  _Header(
                    nearby: stations.first,
                    onTestNotification: onTestNotification,
                  ),
                  const SizedBox(height: 22),
                  _ApiStatusBanner(remoteStations: remoteStations),
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
  const _Header({
    required this.nearby,
    required this.onTestNotification,
  });

  final Station nearby;
  final VoidCallback onTestNotification;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '내릴때',
              style: TextStyle(
                color: Color(0xFF3B82F6),
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Tooltip(
                  message: '테스트 알림 보내기',
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: pebbleDecoration(
                      radius: 18,
                      shadowOpacity: 0.04,
                    ),
                    child: IconButton(
                      onPressed: onTestNotification,
                      icon: const Icon(Icons.notifications_active_rounded),
                      iconSize: 18,
                      color: const Color(0xFF3B82F6),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
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
