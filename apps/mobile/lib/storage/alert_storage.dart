// 사용자 알림 설정을 로컬 저장소에 저장하고 불러온다.
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/stations.dart';
import '../models/subway_alert.dart';

class AlertStorage {
  static const _alertsKey = 'subway_push.alerts';

  Future<List<SubwayAlert>?> loadAlerts() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_alertsKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .cast<Map<String, dynamic>>()
          .map(_alertFromJson)
          .whereType<SubwayAlert>()
          .toList();
    } on Object {
      return null;
    }
  }

  SubwayAlert? _alertFromJson(Map<String, dynamic> json) {
    try {
      return SubwayAlert.fromJson(json, findStation: stationByName);
    } on Object {
      return null;
    }
  }

  Future<void> saveAlerts(List<SubwayAlert> alerts) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _alertsKey,
      jsonEncode(alerts.map((alert) => alert.toJson()).toList()),
    );
  }
}
