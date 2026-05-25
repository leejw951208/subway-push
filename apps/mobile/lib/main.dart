import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
    runApp(const SubwayPushApp());
}

const _ink = Color(0xFF0F172A);
const _muted = Color(0xFF64748B);
const _soft = Color(0xFFF4F7FC);
const _blue = Color(0xFF2563EB);

const Map<String, Color> lineColors = {
    '1': Color(0xFF0052A4),
    '2': Color(0xFF00A84D),
    '3': Color(0xFFEF7C1C),
    '4': Color(0xFF00A5DE),
    '5': Color(0xFF996CAC),
    '6': Color(0xFFCD7C2F),
    '7': Color(0xFF747F00),
    '8': Color(0xFFE6186C),
    '9': Color(0xFFBDB092),
    '경의중앙': Color(0xFF77C4A3),
    '공항': Color(0xFF0090D2),
    '분당': Color(0xFFFABE00),
    '신분당': Color(0xFFD4003B),
    '경춘': Color(0xFF0C8E72),
};

const stations = <Station>[
    Station('강남', ['2', '신분당'], '강남구 · 환승역'),
    Station('홍대입구', ['2', '경의중앙', '공항'], '마포구 · 환승역'),
    Station('잠실', ['2', '8'], '송파구 · 환승역'),
    Station('사당', ['2', '4'], '관악구 · 환승역'),
    Station('서울역', ['1', '4', '경의중앙', '공항'], '용산구 · 환승역'),
    Station('시청', ['1', '2'], '중구 · 환승역'),
    Station('종로3가', ['1', '3', '5'], '종로구 · 환승역'),
    Station('명동', ['4'], '중구'),
    Station('신도림', ['1', '2'], '구로구 · 환승역'),
    Station('신촌', ['2'], '서대문구'),
    Station('이태원', ['6'], '용산구'),
    Station('건대입구', ['2', '7'], '광진구 · 환승역'),
    Station('합정', ['2', '6'], '마포구 · 환승역'),
    Station('여의도', ['5', '9'], '영등포구 · 환승역'),
    Station('압구정', ['3'], '강남구'),
    Station('성수', ['2'], '성동구'),
    Station('신사', ['3', '신분당'], '강남구 · 환승역'),
    Station('교대', ['2', '3'], '서초구 · 환승역'),
    Station('선릉', ['2', '분당'], '강남구 · 환승역'),
    Station('삼성', ['2'], '강남구'),
    Station('역삼', ['2'], '강남구'),
    Station('양재', ['3', '신분당'], '서초구 · 환승역'),
    Station('왕십리', ['2', '5', '경의중앙', '분당'], '성동구 · 환승역'),
    Station('동대문', ['1', '4'], '종로구 · 환승역'),
    Station('광화문', ['5'], '종로구'),
    Station('을지로입구', ['2'], '중구'),
    Station('안국', ['3'], '종로구'),
    Station('혜화', ['4'], '종로구'),
    Station('서울대입구', ['2'], '관악구'),
    Station('강변', ['2'], '광진구'),
];

class Station {
    const Station(this.name, this.lines, this.description);

    final String name;
    final List<String> lines;
    final String description;
}

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

class SubwayPushApp extends StatelessWidget {
    const SubwayPushApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Subway Push',
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: _blue),
                fontFamily: 'Pretendard',
                useMaterial3: true,
            ),
            home: const HomeScreen(),
        );
    }
}

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
            backgroundColor: _soft,
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
                _alerts = _alerts.where((alert) => alert.station.name != station.name).toList();
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
                    backgroundColor: _ink,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    content: Text(message, style: const TextStyle(fontWeight: FontWeight.w700)),
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
                    colors: [Color(0xFFE0EBFE), _soft],
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
                                    _SectionHeader(title: '내 알림', action: '${alerts.length}개 활성'),
                                    const SizedBox(height: 14),
                                    if (alerts.isEmpty)
                                        const EmptyAlertPebble()
                                    else if (alerts.length == 1)
                                        AlertCard(alert: alerts.first, onTap: () => onStationTap(alerts.first.station))
                                    else
                                        AlertStack(alerts: alerts, onTap: onAlertStackTap),
                                    const SizedBox(height: 30),
                                    const _SectionHeader(title: '자주 검색하는 역'),
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
                            decoration: _pebbleDecoration(radius: 16, shadowOpacity: 0.04),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                    Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 7),
                                    const Text('현재', style: TextStyle(color: _muted, fontSize: 12, fontWeight: FontWeight.w700)),
                                    const SizedBox(width: 6),
                                    LineBadge(line: nearby.lines.first, size: 14),
                                    const SizedBox(width: 5),
                                    Text(nearby.name, style: const TextStyle(color: _ink, fontSize: 12, fontWeight: FontWeight.w900)),
                                ],
                            ),
                        ),
                    ],
                ),
                const SizedBox(height: 14),
                const Text(
                    '푹 자도 괜찮아요,\n제가 깨워드릴게요',
                    style: TextStyle(
                        color: _ink,
                        fontSize: 30,
                        height: 1.18,
                        fontWeight: FontWeight.w900,
                    ),
                ),
            ],
        );
    }
}

class SearchPebble extends StatelessWidget {
    const SearchPebble({required this.onTap, super.key});

    final VoidCallback onTap;

    @override
    Widget build(BuildContext context) {
        return Pebble(
            onTap: onTap,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Row(
                children: [
                    Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(colors: [Color(0xFF3B82F6), _blue]),
                            boxShadow: [BoxShadow(color: _blue.withValues(alpha: 0.30), blurRadius: 12, offset: const Offset(0, 4))],
                        ),
                        child: const Icon(Icons.search_rounded, color: Colors.white, size: 23),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                        child: Text(
                            '역 이름을 검색해보세요',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                    ),
                ],
            ),
        );
    }
}

class SearchOverlay extends StatefulWidget {
    const SearchOverlay({
        required this.controller,
        required this.alerts,
        required this.onBack,
        required this.onPick,
        super.key,
    });

    final TextEditingController controller;
    final List<SubwayAlert> alerts;
    final VoidCallback onBack;
    final ValueChanged<Station> onPick;

    @override
    State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
    final _focusNode = FocusNode();

    @override
    void initState() {
        super.initState();
        widget.controller.addListener(_onQueryChanged);
        WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
    }

    @override
    void dispose() {
        widget.controller.removeListener(_onQueryChanged);
        _focusNode.dispose();
        super.dispose();
    }

    void _onQueryChanged() => setState(() {});

    @override
    Widget build(BuildContext context) {
        final query = widget.controller.text.trim();
        final results = query.isEmpty
            ? stations.take(12).toList()
            : stations.where((station) => station.name.contains(query)).toList();

        return Positioned.fill(
            child: Material(
                color: _soft,
                child: SafeArea(
                    bottom: false,
                    child: Column(
                        children: [
                            Padding(
                                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                                child: Row(
                                    children: [
                                        PebbleIconButton(icon: Icons.chevron_left_rounded, onTap: widget.onBack),
                                        const SizedBox(width: 10),
                                        Expanded(
                                            child: Container(
                                                height: 48,
                                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                                decoration: _pebbleDecoration(
                                                    radius: 24,
                                                    shadowColor: _blue,
                                                    shadowOpacity: 0.08,
                                                    borderColor: const Color(0xFFDBEAFE),
                                                    borderWidth: 2,
                                                ),
                                                child: Row(
                                                    children: [
                                                        const Icon(Icons.search_rounded, color: Color(0xFF3B82F6), size: 21),
                                                        const SizedBox(width: 10),
                                                        Expanded(
                                                            child: TextField(
                                                                controller: widget.controller,
                                                                focusNode: _focusNode,
                                                                decoration: const InputDecoration(
                                                                    border: InputBorder.none,
                                                                    hintText: '역 이름 입력',
                                                                    hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                                                                ),
                                                                style: const TextStyle(
                                                                    color: _ink,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w700,
                                                                ),
                                                            ),
                                                        ),
                                                        if (query.isNotEmpty)
                                                            GestureDetector(
                                                                onTap: widget.controller.clear,
                                                                child: Container(
                                                                    width: 22,
                                                                    height: 22,
                                                                    decoration: const BoxDecoration(
                                                                        color: Color(0xFFE2E8F0),
                                                                        shape: BoxShape.circle,
                                                                    ),
                                                                    child: const Icon(Icons.close_rounded, color: _muted, size: 15),
                                                                ),
                                                            ),
                                                    ],
                                                ),
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                            Expanded(
                                child: ListView.separated(
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 40),
                                    itemBuilder: (context, index) {
                                        if (query.isNotEmpty && results.isEmpty) {
                                            return const _NoSearchResults();
                                        }

                                        if (query.isEmpty && index == 0) {
                                            return const Padding(
                                                padding: EdgeInsets.fromLTRB(4, 8, 4, 2),
                                                child: Text(
                                                    '인기 검색역',
                                                    style: TextStyle(
                                                        color: Color(0xFF94A3B8),
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w800,
                                                    ),
                                                ),
                                            );
                                        }

                                        final offset = query.isEmpty ? 1 : 0;
                                        final station = results[index - offset];
                                        final active = widget.alerts.any((alert) => alert.station.name == station.name);
                                        return StationResultPebble(
                                            station: station,
                                            active: active,
                                            onTap: () => widget.onPick(station),
                                        );
                                    },
                                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                                    itemCount: query.isNotEmpty && results.isEmpty
                                        ? 1
                                        : results.length + (query.isEmpty ? 1 : 0),
                                ),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}

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
        return _SheetShell(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    _SheetGrabber(),
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
                                    boxShadow: [BoxShadow(color: _blue.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 4))],
                                ),
                                child: Center(child: LineBadge(line: widget.station.lines.first, size: 34)),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        RichText(
                                            text: TextSpan(
                                                style: const TextStyle(color: _ink, fontWeight: FontWeight.w900),
                                                children: [
                                                    TextSpan(text: widget.station.name, style: const TextStyle(fontSize: 24)),
                                                    const TextSpan(text: '역', style: TextStyle(color: _muted, fontSize: 18)),
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
                                                            color: _muted,
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
                            style: TextStyle(color: _muted, fontSize: 13, fontWeight: FontWeight.w800),
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
                            AlertSheetResult(push: _push, vibration: _vibration, voice: _voice),
                        ),
                    ),
                    if (widget.existing != null) ...[
                        const SizedBox(height: 10),
                        DangerButton(
                            label: '알림 해제하기',
                            onPressed: () => Navigator.of(context).pop(
                                const AlertSheetResult(push: false, vibration: false, voice: false, remove: true),
                            ),
                        ),
                    ],
                    SizedBox(height: MediaQuery.paddingOf(context).bottom + 4),
                ],
            ),
        );
    }
}

class AlertListSheet extends StatelessWidget {
    const AlertListSheet({required this.alerts, super.key});

    final List<SubwayAlert> alerts;

    @override
    Widget build(BuildContext context) {
        return _SheetShell(
            maxHeightFactor: 0.78,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    _SheetGrabber(),
                    const SizedBox(height: 18),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            const Text('설정된 알림', style: TextStyle(color: _ink, fontSize: 22, fontWeight: FontWeight.w900)),
                            Text('${alerts.length}개', style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 13, fontWeight: FontWeight.w800)),
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

class AlertCard extends StatelessWidget {
    const AlertCard({required this.alert, required this.onTap, super.key});

    final SubwayAlert alert;
    final VoidCallback onTap;

    @override
    Widget build(BuildContext context) {
        return Pebble(active: true, onTap: onTap, child: AlertCardBody(alert: alert));
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
                                child: DecoratedBox(decoration: _stackLayerDecoration(const Color(0xFFC7DBFD), 24)),
                            ),
                        if (extras >= 1)
                            Positioned(
                                left: 12,
                                right: 12,
                                top: 8,
                                height: 68,
                                child: DecoratedBox(decoration: _stackLayerDecoration(const Color(0xFFDCEAFE), 26)),
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
                                            gradient: const LinearGradient(colors: [Color(0xFFDBEAFE), Color(0xFFBFDBFE)]),
                                        ),
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                                Text(
                                                    '+${alerts.length - 1}',
                                                    style: const TextStyle(color: Color(0xFF1D4ED8), fontSize: 13, fontWeight: FontWeight.w900),
                                                ),
                                                const SizedBox(width: 2),
                                                const Icon(Icons.chevron_right_rounded, color: Color(0xFF1D4ED8), size: 17),
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
                        boxShadow: [BoxShadow(color: _blue.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Center(child: LineBadge(line: alert.station.lines.first, size: 26)),
                ),
                const SizedBox(width: 14),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                                '${alert.station.name}역',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: _ink, fontSize: 17, fontWeight: FontWeight.w900),
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
                            boxShadow: [BoxShadow(color: _blue.withValues(alpha: 0.12), blurRadius: 6, offset: const Offset(0, 2))],
                        ),
                        child: Center(child: LineBadge(line: alert.station.lines.first, size: 24)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    '${alert.station.name}역',
                                    style: const TextStyle(color: _ink, fontSize: 16, fontWeight: FontWeight.w900),
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
                                Text(station.name, style: const TextStyle(color: _ink, fontSize: 16, fontWeight: FontWeight.w900)),
                                const SizedBox(height: 2),
                                Text(station.description, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.w700)),
                            ],
                        ),
                    ),
                    if (active)
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(colors: [Color(0xFFDBEAFE), Color(0xFFBFDBFE)]),
                            ),
                            child: const Text(
                                '알림 ON',
                                style: TextStyle(color: Color(0xFF1D4ED8), fontSize: 11, fontWeight: FontWeight.w900),
                            ),
                        ),
                ],
            ),
        );
    }
}

class ToggleRow extends StatelessWidget {
    const ToggleRow({
        required this.icon,
        required this.label,
        required this.sub,
        required this.value,
        required this.onChanged,
        super.key,
    });

    final IconData icon;
    final String label;
    final String sub;
    final bool value;
    final ValueChanged<bool> onChanged;

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () => onChanged(!value),
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: value ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: value ? const Color(0x403B82F6) : const Color(0x0D0F172A), width: value ? 1.5 : 1),
                ),
                child: Row(
                    children: [
                        Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: value ? Colors.white : const Color(0xFFF1F5F9),
                                shape: BoxShape.circle,
                                boxShadow: value ? [BoxShadow(color: _blue.withValues(alpha: 0.15), blurRadius: 6, offset: const Offset(0, 2))] : null,
                            ),
                            child: Icon(icon, color: value ? _blue : _muted, size: 21),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text(
                                        label,
                                        style: TextStyle(
                                            color: value ? const Color(0xFF1D4ED8) : _ink,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                        ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                        sub,
                                        style: TextStyle(
                                            color: value ? const Color(0xFF3B82F6) : const Color(0xFF94A3B8),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        Switch.adaptive(value: value, onChanged: onChanged, activeThumbColor: _blue),
                    ],
                ),
            ),
        );
    }
}

class SuggestionChipPebble extends StatelessWidget {
    const SuggestionChipPebble({required this.station, required this.onTap, super.key});

    final Station station;
    final VoidCallback onTap;

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: onTap,
            child: Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 14, 10),
                decoration: _pebbleDecoration(radius: 20, shadowOpacity: 0.05),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        LineBadge(line: station.lines.first, size: 20),
                        const SizedBox(width: 8),
                        Text(
                            station.name,
                            style: const TextStyle(color: _ink, fontSize: 14, fontWeight: FontWeight.w800),
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
                    BoxShadow(color: color.withValues(alpha: 0.33), blurRadius: 6, offset: const Offset(0, 2)),
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

class AlertMethods extends StatelessWidget {
    const AlertMethods({required this.alert, this.small = false, super.key});

    final SubwayAlert alert;
    final bool small;

    @override
    Widget build(BuildContext context) {
        final items = <Widget>[
            if (alert.push) _Method(icon: Icons.notifications_rounded, label: '푸시', small: small),
            if (alert.vibration) _Method(icon: Icons.vibration_rounded, label: '진동', small: small),
            if (alert.voice) _Method(icon: Icons.volume_up_rounded, label: '음성', small: small),
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

class Pebble extends StatelessWidget {
    const Pebble({
        required this.child,
        this.onTap,
        this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        this.active = false,
        super.key,
    });

    final Widget child;
    final VoidCallback? onTap;
    final EdgeInsetsGeometry padding;
    final bool active;

    @override
    Widget build(BuildContext context) {
        return Material(
            color: Colors.transparent,
            child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(28),
                child: Ink(
                    padding: padding,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: active
                                ? const [Color(0xFFEFF6FF), Color(0xFFDBEAFE)]
                                : const [Colors.white, Color(0xFFF8FAFD)],
                        ),
                        boxShadow: [
                            BoxShadow(
                                color: (active ? _blue : _ink).withValues(alpha: active ? 0.12 : 0.06),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                                color: (active ? _blue : _ink).withValues(alpha: active ? 0.06 : 0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                            ),
                        ],
                    ),
                    child: child,
                ),
            ),
        );
    }
}

class PebbleIconButton extends StatelessWidget {
    const PebbleIconButton({required this.icon, required this.onTap, super.key});

    final IconData icon;
    final VoidCallback onTap;

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: onTap,
            child: Container(
                width: 44,
                height: 44,
                decoration: _pebbleDecoration(radius: 22, shadowOpacity: 0.05),
                child: Icon(icon, color: _ink, size: 28),
            ),
        );
    }
}

class _SectionHeader extends StatelessWidget {
    const _SectionHeader({required this.title, this.action});

    final String title;
    final String? action;

    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text(title, style: const TextStyle(color: _ink, fontSize: 17, fontWeight: FontWeight.w900)),
                    if (action != null)
                        Text(
                            action!,
                            style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 13, fontWeight: FontWeight.w800),
                        ),
                ],
            ),
        );
    }
}

class EmptyAlertPebble extends StatelessWidget {
    const EmptyAlertPebble({super.key});

    @override
    Widget build(BuildContext context) {
        return const Pebble(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 28),
            child: Column(
                children: [
                    Icon(Icons.bedtime_rounded, size: 34, color: _muted),
                    SizedBox(height: 10),
                    Text(
                        '아직 설정된 알림이 없어요\n위에서 역을 검색해 알림을 추가하세요',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: _muted, fontSize: 14, height: 1.5, fontWeight: FontWeight.w700),
                    ),
                ],
            ),
        );
    }
}

class _NoSearchResults extends StatelessWidget {
    const _NoSearchResults();

    @override
    Widget build(BuildContext context) {
        return const Padding(
            padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
            child: Column(
                children: [
                    Icon(Icons.search_off_rounded, color: Color(0xFF94A3B8), size: 42),
                    SizedBox(height: 12),
                    Text('검색 결과가 없어요', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w700)),
                ],
            ),
        );
    }
}

class PrimaryButton extends StatelessWidget {
    const PrimaryButton({
        required this.label,
        required this.enabled,
        required this.onPressed,
        super.key,
    });

    final String label;
    final bool enabled;
    final VoidCallback onPressed;

    @override
    Widget build(BuildContext context) {
        return SizedBox(
            width: double.infinity,
            height: 58,
            child: FilledButton(
                onPressed: enabled ? onPressed : null,
                style: FilledButton.styleFrom(
                    backgroundColor: _blue,
                    disabledBackgroundColor: const Color(0xFFCBD5E1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
            ),
        );
    }
}

class DangerButton extends StatelessWidget {
    const DangerButton({required this.label, required this.onPressed, super.key});

    final String label;
    final VoidCallback onPressed;

    @override
    Widget build(BuildContext context) {
        return SizedBox(
            width: double.infinity,
            height: 52,
            child: TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFFEE2E2),
                    foregroundColor: const Color(0xFFDC2626),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                ),
                child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
            ),
        );
    }
}

class _SheetShell extends StatelessWidget {
    const _SheetShell({required this.child, this.maxHeightFactor});

    final Widget child;
    final double? maxHeightFactor;

    @override
    Widget build(BuildContext context) {
        final height = MediaQuery.sizeOf(context).height;
        return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                    constraints: maxHeightFactor == null ? null : BoxConstraints(maxHeight: height * maxHeightFactor!),
                    padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.white, Color(0xFFF8FAFD)],
                        ),
                        boxShadow: [
                            BoxShadow(color: Color(0x260F172A), blurRadius: 40, offset: Offset(0, -10)),
                        ],
                    ),
                    child: child,
                ),
            ),
        );
    }
}

class _SheetGrabber extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Center(
            child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(color: const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(3)),
            ),
        );
    }
}

BoxDecoration _pebbleDecoration({
    required double radius,
    Color shadowColor = _ink,
    double shadowOpacity = 0.06,
    Color borderColor = const Color(0x0A0F172A),
    double borderWidth = 1,
}) {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
            BoxShadow(color: shadowColor.withValues(alpha: shadowOpacity), blurRadius: 8, offset: const Offset(0, 2)),
        ],
    );
}

BoxDecoration _stackLayerDecoration(Color color, double radius) {
    return BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [BoxShadow(color: _blue.withValues(alpha: 0.10), blurRadius: 16, offset: const Offset(0, 6))],
    );
}
