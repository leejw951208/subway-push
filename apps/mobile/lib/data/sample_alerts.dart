// 홈 화면 초기 표시용 예시 알림 데이터를 제공한다.
import '../models/subway_alert.dart';
import 'stations.dart';

List<SubwayAlert> sampleAlerts() {
  return [
    SubwayAlert(station: stationByName('잠실')),
    SubwayAlert(
      station: stationByName('강남'),
      vibration: false,
    ),
    SubwayAlert(
      station: stationByName('서울역'),
      voice: true,
    ),
  ];
}
