// 지하철 역과 알림 API를 호출하는 HTTP 클라이언트이다.
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/station.dart';
import '../models/subway_alert.dart';
import 'api_config.dart';
import 'subway_api_port.dart';

class SubwayApiClient implements SubwayApiPort {
  SubwayApiClient({
    this.config = ApiConfig.emulator,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final ApiConfig config;
  final http.Client _client;

  @override
  Future<List<Station>> fetchStations({String? query}) async {
    final uri = _uri(
        '/stations', query == null || query.isEmpty ? null : {'query': query});
    final response = await _client.get(uri);
    _ensureSuccess(response);
    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final items = decoded['stations'] as List<dynamic>;
    return items.cast<Map<String, dynamic>>().map(Station.fromJson).toList();
  }

  @override
  Future<List<SubwayAlert>> fetchAlerts({
    required Station Function(String name) findStation,
  }) async {
    final response = await _client.get(_uri('/alerts'));
    _ensureSuccess(response);
    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>().map((json) {
      return SubwayAlert.fromJson(json, findStation: findStation);
    }).toList();
  }

  @override
  Future<SubwayAlert> createAlert(
    SubwayAlert alert, {
    required Station Function(String name) findStation,
  }) async {
    final response = await _client.post(
      _uri('/alerts'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode(alert.toJson()),
    );
    _ensureSuccess(response);
    return SubwayAlert.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
        findStation: findStation);
  }

  @override
  Future<SubwayAlert> updateAlert(
    int id,
    SubwayAlert alert, {
    required Station Function(String name) findStation,
  }) async {
    final response = await _client.patch(
      _uri('/alerts/$id'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode(alert.toJson()),
    );
    _ensureSuccess(response);
    return SubwayAlert.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
        findStation: findStation);
  }

  @override
  Future<void> deleteAlert(int id) async {
    final response = await _client.delete(_uri('/alerts/$id'));
    _ensureSuccess(response);
  }

  Uri _uri(String path, [Map<String, String>? query]) {
    return Uri.parse('${config.baseUrl}$path').replace(queryParameters: query);
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiClientException(response.statusCode, response.body);
    }
  }
}

class ApiClientException implements Exception {
  const ApiClientException(this.statusCode, this.body);

  final int statusCode;
  final String body;

  @override
  String toString() => 'ApiClientException($statusCode): $body';
}
