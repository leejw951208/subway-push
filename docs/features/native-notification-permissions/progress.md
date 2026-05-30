# Progress. Native Notification Permissions

## 현재 단계

구현

## 상태

✅ 완료

## 완료 항목

- `flutter_local_notifications`와 `permission_handler` 의존성을 추가했다.
- Android 알림 권한, 진동 권한, 인터넷 권한을 manifest에 추가했다.
- 알림 초기화, 권한 요청, 권한 상태 조회, Android channel 생성, 테스트 알림 발송을 `NotificationService`로 분리했다.
- 홈 헤더에 테스트 알림 아이콘을 추가해 권한 요청과 로컬 알림 발송을 직접 실행할 수 있게 했다.
- README에 Android 수동 확인 절차를 추가했다.
- 알림 초기화/발송 실패를 UI 안내로 처리하고 권한 거부/실패 widget test를 추가했다.

## 검증

- 2026-05-30 `rtk mise exec -- flutter analyze`.
- 2026-05-30 `rtk mise exec -- flutter test`.
- 2026-05-30 보강 후 `rtk mise exec -- flutter analyze`, `rtk mise exec -- flutter test`.

## 최근 업데이트

2026-05-30
