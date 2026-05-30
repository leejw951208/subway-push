// 도착 알림 엔진의 반경 진입 판정을 검증한다.
import 'package:flutter_test/flutter_test.dart';
import 'package:subway_push/arrival/arrival_alert_engine.dart';
import 'package:subway_push/data/stations.dart';
import 'package:subway_push/models/subway_alert.dart';

void main() {
  test('emits an alert event when entering station radius once', () {
    final engine = ArrivalAlertEngine(thresholdMeters: 300);
    final alert = SubwayAlert(station: stationByName('잠실'), voice: true);
    final target = StationLocation(
      stationName: '잠실',
      point: const GeoPoint(latitude: 37.5133, longitude: 127.1002),
    );

    final first = engine.evaluate(
      current: const GeoPoint(latitude: 37.5133, longitude: 127.1002),
      alert: alert,
      target: target,
    );
    final second = engine.evaluate(
      current: const GeoPoint(latitude: 37.5133, longitude: 127.1002),
      alert: alert,
      target: target,
    );

    expect(first, isNotNull);
    expect(first!.stationName, '잠실');
    expect(first.voice, true);
    expect(second, isNull);
  });

  test('does not emit outside the threshold', () {
    final engine = ArrivalAlertEngine(thresholdMeters: 100);
    final alert = SubwayAlert(station: stationByName('잠실'));
    final target = StationLocation(
      stationName: '잠실',
      point: const GeoPoint(latitude: 37.5133, longitude: 127.1002),
    );

    final event = engine.evaluate(
      current: const GeoPoint(latitude: 37.5233, longitude: 127.1002),
      alert: alert,
      target: target,
    );

    expect(event, isNull);
  });

  test('does not emit when current location or target station is missing', () {
    final engine = ArrivalAlertEngine();
    final alert = SubwayAlert(station: stationByName('잠실'));
    final target = StationLocation(
      stationName: '잠실',
      point: const GeoPoint(latitude: 37.5133, longitude: 127.1002),
    );

    expect(
      engine.evaluate(current: null, alert: alert, target: target),
      isNull,
    );
    expect(
      engine.evaluate(
        current: const GeoPoint(latitude: 37.5133, longitude: 127.1002),
        alert: alert,
        target: null,
      ),
      isNull,
    );
  });
}
