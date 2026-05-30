// 지하철 API 클라이언트의 HTTP 연동 동작을 검증한다.
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:subway_push/api/api_config.dart';
import 'package:subway_push/api/subway_api_client.dart';
import 'package:subway_push/data/stations.dart';
import 'package:subway_push/models/subway_alert.dart';

void main() {
  test('fetches stations from API', () async {
    final client = SubwayApiClient(
      config: const ApiConfig(baseUrl: 'http://api.test'),
      client: MockClient((request) async {
        expect(request.url.path, '/stations');
        return http.Response.bytes(
          utf8.encode(
            '{"stations":[{"name":"강남","lines":["2"],"description":"강남구"}],"lineColors":{"2":"#00A84D"}}',
          ),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }),
    );

    final stations = await client.fetchStations();

    expect(stations, hasLength(1));
    expect(stations.first.name, '강남');
  });

  test('creates alerts through API', () async {
    final client = SubwayApiClient(
      config: const ApiConfig(baseUrl: 'http://api.test'),
      client: MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/alerts');
        return http.Response.bytes(
          utf8.encode(
            '{"stationName":"잠실","lines":["2","8"],"description":"송파구 · 환승역","push":true,"vibration":true,"voice":false}',
          ),
          201,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }),
    );

    final alert = await client.createAlert(
      SubwayAlert(station: stationByName('잠실')),
      findStation: stationByName,
    );

    expect(alert.station.name, '잠실');
  });

  test('throws for non-success responses', () async {
    final client = SubwayApiClient(
      config: const ApiConfig(baseUrl: 'http://api.test'),
      client: MockClient((request) async => http.Response('nope', 500)),
    );

    expect(client.fetchStations(), throwsA(isA<ApiClientException>()));
  });
}
