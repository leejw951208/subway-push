// 알림 로컬 저장소의 직렬화와 복구 동작을 검증한다.
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subway_push/data/stations.dart';
import 'package:subway_push/models/subway_alert.dart';
import 'package:subway_push/storage/alert_storage.dart';

void main() {
  test('saves and loads alerts', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = AlertStorage();

    await storage.saveAlerts([
      SubwayAlert(station: stationByName('잠실'), vibration: false),
    ]);

    final loaded = await storage.loadAlerts();

    expect(loaded, hasLength(1));
    expect(loaded!.first.station.name, '잠실');
    expect(loaded.first.vibration, false);
  });

  test('returns null for invalid stored data', () async {
    SharedPreferences.setMockInitialValues({
      'subway_push.alerts': 'not-json',
    });
    final storage = AlertStorage();

    expect(await storage.loadAlerts(), isNull);
  });

  test('skips alerts with unknown station names', () async {
    SharedPreferences.setMockInitialValues({
      'subway_push.alerts':
          '[{"stationName":"없는역","push":true},{"stationName":"잠실","push":true,"vibration":false,"voice":false}]',
    });
    final storage = AlertStorage();

    final loaded = await storage.loadAlerts();

    expect(loaded, hasLength(1));
    expect(loaded!.first.station.name, '잠실');
  });
}
