import 'package:flutter/material.dart';

import '../data/stations.dart';
import '../models/station.dart';
import '../models/subway_alert.dart';
import '../theme/app_colors.dart';
import '../theme/decorations.dart';
import '../widgets/common.dart';
import '../widgets/station_widgets.dart';

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
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focusNode.requestFocus());
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
        color: appSoft,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  children: [
                    PebbleIconButton(
                        icon: Icons.chevron_left_rounded, onTap: widget.onBack),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: pebbleDecoration(
                          radius: 24,
                          shadowColor: appBlue,
                          shadowOpacity: 0.08,
                          borderColor: const Color(0xFFDBEAFE),
                          borderWidth: 2,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search_rounded,
                                color: Color(0xFF3B82F6), size: 21),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: widget.controller,
                                focusNode: _focusNode,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '역 이름 입력',
                                  hintStyle:
                                      TextStyle(color: Color(0xFF94A3B8)),
                                ),
                                style: const TextStyle(
                                  color: appInk,
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
                                  child: const Icon(Icons.close_rounded,
                                      color: appMuted, size: 15),
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
                    final active = widget.alerts
                        .any((alert) => alert.station.name == station.name);
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
          Text('검색 결과가 없어요',
              style: TextStyle(
                  color: Color(0xFF94A3B8), fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
