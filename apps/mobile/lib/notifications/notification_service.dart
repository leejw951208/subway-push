// 로컬 알림 권한과 테스트 알림 표시를 담당한다.
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const _channel = AndroidNotificationChannel(
    'arrival_alerts',
    'Arrival alerts',
    description: 'Subway arrival alert notifications',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin _plugin;

  Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: android,
        iOS: darwin,
        macOS: darwin,
      ),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  Future<PermissionStatus> requestPermission() async {
    return Permission.notification.request();
  }

  Future<PermissionStatus> permissionStatus() {
    return Permission.notification.status;
  }

  Future<void> showTestNotification() async {
    await _plugin.show(
      id: 1001,
      title: '내릴때',
      body: '테스트 알림입니다.',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'arrival_alerts',
          '내릴때 알림',
          channelDescription: '지하철 하차 알림',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
    );
  }
}
