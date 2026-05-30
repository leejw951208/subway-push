// 지하철 API 클라이언트가 제공해야 하는 호출 계약을 정의한다.
import '../models/station.dart';
import '../models/subway_alert.dart';

abstract interface class SubwayApiPort {
  Future<List<Station>> fetchStations({String? query});

  Future<List<SubwayAlert>> fetchAlerts({
    required Station Function(String name) findStation,
  });

  Future<SubwayAlert> createAlert(
    SubwayAlert alert, {
    required Station Function(String name) findStation,
  });

  Future<SubwayAlert> updateAlert(
    int id,
    SubwayAlert alert, {
    required Station Function(String name) findStation,
  });

  Future<void> deleteAlert(int id);
}
