// 알림 상태 컨트롤러의 추가와 삭제 동작을 검증한다.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subway_push/data/stations.dart';
import 'package:subway_push/models/subway_alert.dart';
import 'package:subway_push/state/alert_controller.dart';
import 'package:subway_push/storage/alert_storage.dart';

class FakeAlertStorage extends AlertStorage {
  List<SubwayAlert>? saved;
  List<SubwayAlert>? initial;
  bool failSave = false;

  @override
  Future<List<SubwayAlert>?> loadAlerts() async => initial;

  @override
  Future<void> saveAlerts(List<SubwayAlert> alerts) async {
    if (failSave) {
      throw StateError('save failed');
    }
    saved = alerts;
  }
}

void main() {
  test('upserts alerts by station name', () async {
    final storage = FakeAlertStorage();
    final container = ProviderContainer(
      overrides: [alertStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    await container.read(alertControllerProvider.notifier).upsertAlert(
          SubwayAlert(station: stationByName('강남'), voice: true),
        );

    final alerts = container.read(alertControllerProvider);
    expect(alerts.where((alert) => alert.station.name == '강남'), hasLength(1));
    expect(alerts.first.station.name, '강남');
    expect(storage.saved, isNotNull);
  });

  test('removes alerts by station', () async {
    final storage = FakeAlertStorage();
    final container = ProviderContainer(
      overrides: [alertStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);

    await container
        .read(alertControllerProvider.notifier)
        .removeAlert(stationByName('강남'));

    expect(
      container
          .read(alertControllerProvider)
          .any((alert) => alert.station.name == '강남'),
      false,
    );
  });

  test('keeps previous state when saving an upsert fails', () async {
    final storage = FakeAlertStorage()..failSave = true;
    final container = ProviderContainer(
      overrides: [alertStorageProvider.overrideWithValue(storage)],
    );
    addTearDown(container.dispose);
    final before = container.read(alertControllerProvider);

    await expectLater(
      container.read(alertControllerProvider.notifier).upsertAlert(
            SubwayAlert(station: stationByName('강남'), voice: true),
          ),
      throwsStateError,
    );

    final after = container.read(alertControllerProvider);
    expect(
      after.map((alert) => alert.station.name),
      before.map((alert) => alert.station.name),
    );
    expect(
      after.map((alert) => alert.voice),
      before.map((alert) => alert.voice),
    );
  });
}
