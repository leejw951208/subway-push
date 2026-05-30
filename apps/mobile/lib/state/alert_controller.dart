// 알림 목록 상태와 로컬 저장소 동기화를 관리한다.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sample_alerts.dart';
import '../models/station.dart';
import '../models/subway_alert.dart';
import '../storage/alert_storage.dart';

final alertStorageProvider = Provider<AlertStorage>((ref) => AlertStorage());

final alertControllerProvider =
    NotifierProvider<AlertController, List<SubwayAlert>>(AlertController.new);

class AlertController extends Notifier<List<SubwayAlert>> {
  late final AlertStorage _storage = ref.read(alertStorageProvider);

  @override
  List<SubwayAlert> build() {
    return sampleAlerts();
  }

  Future<void> load() async {
    final saved = await _storage.loadAlerts();
    if (saved != null) {
      state = saved;
    }
  }

  Future<void> upsertAlert(SubwayAlert alert) async {
    final previous = state;
    final next = [
      alert,
      ...state.where((item) => item.station.name != alert.station.name),
    ];
    state = next;
    try {
      await _storage.saveAlerts(next);
    } on Object {
      state = previous;
      rethrow;
    }
  }

  Future<void> removeAlert(Station station) async {
    final previous = state;
    final next =
        state.where((alert) => alert.station.name != station.name).toList();
    state = next;
    try {
      await _storage.saveAlerts(next);
    } on Object {
      state = previous;
      rethrow;
    }
  }

  SubwayAlert? findByStation(Station station) {
    for (final alert in state) {
      if (alert.station.name == station.name) {
        return alert;
      }
    }
    return null;
  }
}
