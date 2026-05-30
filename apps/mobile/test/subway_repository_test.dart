// 지하철 repository가 API client 결과와 예외를 UI 경계에 전달하는지 검증한다.
import 'package:flutter_test/flutter_test.dart';
import 'package:subway_push/api/subway_repository.dart';
import 'package:subway_push/data/stations.dart';
import 'package:subway_push/models/station.dart';
import 'package:subway_push/models/subway_alert.dart';

class FakeSubwayApiClient implements SubwayApiPort {
  Object? error;

  @override
  Future<List<Station>> fetchStations({String? query}) async {
    if (error != null) {
      throw error!;
    }
    return [stationByName('강남')];
  }

  @override
  Future<List<SubwayAlert>> fetchAlerts({
    required Station Function(String name) findStation,
  }) async {
    return [SubwayAlert(station: stationByName('잠실'))];
  }

  @override
  Future<SubwayAlert> createAlert(
    SubwayAlert alert, {
    required Station Function(String name) findStation,
  }) async {
    return alert;
  }

  @override
  Future<SubwayAlert> updateAlert(
    int id,
    SubwayAlert alert, {
    required Station Function(String name) findStation,
  }) async {
    return alert;
  }

  @override
  Future<void> deleteAlert(int id) async {}
}

void main() {
  test('loads stations through the API port', () async {
    final repository = SubwayRepository(client: FakeSubwayApiClient());

    final stations = await repository.fetchStations();

    expect(stations.single.name, '강남');
  });

  test('surfaces API failures to the caller', () async {
    final client = FakeSubwayApiClient()..error = StateError('offline');
    final repository = SubwayRepository(client: client);

    expect(repository.fetchStations(), throwsStateError);
  });
}
