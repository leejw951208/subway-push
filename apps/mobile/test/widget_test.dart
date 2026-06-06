import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subway_push/app.dart';
import 'package:subway_push/api/subway_repository.dart';
import 'package:subway_push/data/stations.dart';
import 'package:subway_push/notifications/notification_service.dart';
import 'package:subway_push/screens/home_screen.dart';

class FakeNotificationService extends NotificationService {
  FakeNotificationService({
    this.status = PermissionStatus.granted,
    this.failInitialize = false,
  });

  final PermissionStatus status;
  final bool failInitialize;

  @override
  Future<void> initialize() async {
    if (failInitialize) {
      throw StateError('notification unavailable');
    }
  }

  @override
  Future<PermissionStatus> requestPermission() async => status;

  @override
  Future<void> showTestNotification() async {}
}

void main() {
  testWidgets('renders 내릴때 home screen', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const SubwayPushApp());

    expect(find.text('내릴때'), findsOneWidget);
    expect(find.text('역 이름을 검색해보세요'), findsOneWidget);
    expect(find.text('내 알림'), findsOneWidget);
  });

  testWidgets('renders API error state with retry action', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          remoteStationsProvider.overrideWith(
            (ref) => Future.error(StateError('offline')),
          ),
        ],
        child: const SubwayPushApp(useOwnProviderScope: false),
      ),
    );
    await tester.pump();

    expect(find.text('역 정보를 불러오지 못했어요'), findsOneWidget);
    expect(find.text('다시 시도'), findsOneWidget);
  });

  testWidgets('renders notification permission denied state', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          remoteStationsProvider.overrideWith(
            (ref) async => [stationByName('강남')],
          ),
        ],
        child: MaterialApp(
          home: HomeScreen(
            notificationService: FakeNotificationService(
              status: PermissionStatus.denied,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('테스트 알림 보내기'));
    await tester.pump();

    expect(find.text('알림 권한이 필요해요'), findsOneWidget);
  });

  testWidgets('renders notification failure state', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          remoteStationsProvider.overrideWith(
            (ref) async => [stationByName('강남')],
          ),
        ],
        child: MaterialApp(
          home: HomeScreen(
            notificationService: FakeNotificationService(
              failInitialize: true,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('테스트 알림 보내기'));
    await tester.pump();

    expect(find.text('알림을 보낼 수 없어요'), findsOneWidget);
  });
}
