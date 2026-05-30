// UI 상태 계층에서 사용하는 지하철 API 데이터 접근 경계를 제공한다.
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/stations.dart';
import '../models/station.dart';
import '../models/subway_alert.dart';
import 'subway_api_client.dart';
import 'subway_api_port.dart';

export 'subway_api_port.dart';

final subwayApiClientProvider =
    Provider<SubwayApiPort>((ref) => SubwayApiClient());

final subwayRepositoryProvider = Provider<SubwayRepository>((ref) {
  return SubwayRepository(client: ref.watch(subwayApiClientProvider));
});

final remoteStationsProvider = FutureProvider<List<Station>>((ref) {
  return ref.watch(subwayRepositoryProvider).fetchStations();
});

class SubwayRepository {
  const SubwayRepository({required SubwayApiPort client}) : _client = client;

  final SubwayApiPort _client;

  Future<List<Station>> fetchStations({String? query}) {
    return _client.fetchStations(query: query);
  }

  Future<List<SubwayAlert>> fetchAlerts() {
    return _client.fetchAlerts(findStation: stationByName);
  }

  Future<SubwayAlert> createAlert(SubwayAlert alert) {
    return _client.createAlert(alert, findStation: stationByName);
  }

  Future<SubwayAlert> updateAlert(int id, SubwayAlert alert) {
    return _client.updateAlert(id, alert, findStation: stationByName);
  }

  Future<void> deleteAlert(int id) {
    return _client.deleteAlert(id);
  }
}
