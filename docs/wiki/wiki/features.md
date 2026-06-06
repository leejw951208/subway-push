# 기능

## 모바일 알림 UI

### 요약

Flutter 앱에서 사용자는 역을 검색하고, 알림 설정 시트를 열고, 알림을 추가, 수정, 삭제할 수 있다.

### 현재 상태

완료.

### 관련 파일

- `../../../apps/mobile/lib/screens/home_screen.dart`
- `../../../apps/mobile/lib/screens/search_overlay.dart`
- `../../../apps/mobile/lib/sheets/alert_sheet.dart`
- `../../../apps/mobile/lib/sheets/alert_list_sheet.dart`
- `../../../apps/mobile/lib/models/subway_alert.dart`

### 근거 자료

- `../../features/README.md`

## 모바일 로컬 알림 저장소

### 요약

앱을 재시작해도 사용자의 알림 목록을 복원할 수 있도록 알림 설정을 로컬에 저장한다.

### 현재 상태

검증 완료.

### 관련 파일

- `../../../apps/mobile/lib/storage/alert_storage.dart`
- `../../../apps/mobile/lib/state/alert_controller.dart`
- `../../../apps/mobile/test/alert_storage_test.dart`
- `../../../apps/mobile/test/alert_controller_test.dart`

### 근거 자료

- `../../features/mobile-local-alert-storage/phase.md`

## 모바일 상태 관리

### 요약

Riverpod을 사용해 알림 상태를 메인 화면에서 분리한다.

### 현재 상태

검증 완료.

### 관련 파일

- `../../../apps/mobile/lib/state/alert_controller.dart`
- `../../../apps/mobile/lib/app.dart`
- `../../../apps/mobile/test/alert_controller_test.dart`

### 근거 자료

- `../../features/mobile-state-management/phase.md`

## API 역 조회

### 요약

API는 선택적 query filtering을 포함한 `GET /stations` 역 조회를 제공한다.

### 현재 상태

검증 완료.

### 관련 파일

- `../../../apps/api/src/stations/stations.controller.ts`
- `../../../apps/api/src/stations/stations.service.ts`
- `../../../apps/api/src/stations/stations.data.ts`
- `../../../apps/api/src/stations/stations.controller.spec.ts`
- `../../../apps/api/src/stations/stations.service.spec.ts`

### 근거 자료

- `../../features/api-stations/phase.md`

## 역 데이터 최신화

### 요약

공식 데이터 원천에서 최신 역 데이터를 가져와 단일 JSON으로 정규화하고, API와 모바일 정적 데이터 파일을 생성한다.

### 현재 상태

계획됨.

### 구현 방향

- 공식 데이터 원천을 수동 실행 스크립트로 가져온다.
- 역명, 호선, 설명, 좌표, 외부 역 코드를 정규화한다.
- 환승역과 중복 역을 병합한다.
- 단일 JSON 원본을 기준으로 TypeScript와 Dart 데이터를 생성한다.
- 생성 결과 diff를 사람이 검토한다.

### 관련 파일

- `../../../apps/api/src/stations/stations.data.ts`
- `../../../apps/mobile/lib/data/stations.dart`
- `../../../apps/api/src/stations/stations.service.ts`

### 근거 자료

- `../raw/notes/2026-06-06-station-data-update-strategy.md`
- `../raw/references/2026-06-06-station-data-sources.md`
- `decisions.md`

## API 알림 CRUD

### 요약

API는 알림 CRUD 엔드포인트를 제공하고 Prisma로 알림 설정을 저장한다.

### 현재 상태

검증 완료.

### 관련 파일

- `../../../apps/api/src/alerts/alerts.controller.ts`
- `../../../apps/api/src/alerts/alerts.service.ts`
- `../../../apps/api/src/alerts/alerts.dto.ts`
- `../../../apps/api/prisma/schema.prisma`
- `../../../apps/api/src/alerts/alerts.controller.spec.ts`
- `../../../apps/api/src/alerts/alerts.service.spec.ts`

### 근거 자료

- `../../features/api-alerts/phase.md`

## 모바일 API 클라이언트

### 요약

Flutter 앱에는 역과 알림을 다루는 API client와 repository 계층이 있다.

### 현재 상태

검증 완료.

### 관련 파일

- `../../../apps/mobile/lib/api/api_config.dart`
- `../../../apps/mobile/lib/api/subway_api_client.dart`
- `../../../apps/mobile/lib/api/subway_api_port.dart`
- `../../../apps/mobile/lib/api/subway_repository.dart`
- `../../../apps/mobile/test/subway_api_client_test.dart`
- `../../../apps/mobile/test/subway_repository_test.dart`

### 근거 자료

- `../../features/mobile-api-client/phase.md`

## 네이티브 알림 권한

### 요약

모바일 앱은 알림 권한을 요청하고 로컬 테스트 알림을 보낼 수 있다.

### 현재 상태

검증 완료.

### 관련 파일

- `../../../apps/mobile/lib/notifications/notification_service.dart`
- `../../../apps/mobile/lib/screens/home_screen.dart`
- `../../../apps/mobile/android/app/src/main/AndroidManifest.xml`
- `../../../apps/mobile/ios/Runner/AppDelegate.swift`

### 근거 자료

- `../../features/native-notification-permissions/phase.md`

## 도착 알림 엔진

### 요약

모바일 도메인 계층은 역 도착 알림을 발생시킬 시점을 판단하고 반복 알림을 방지할 수 있다.

### 현재 상태

검증 완료.

### 관련 파일

- `../../../apps/mobile/lib/arrival/arrival_alert_engine.dart`
- `../../../apps/mobile/test/arrival_alert_engine_test.dart`

### 근거 자료

- `../../features/arrival-alert-engine/phase.md`

## 오래된 내용

`docs/features/README.md`의 현재 앱 상태에는 API가 `/`와 `/health`만 구현되어 있다고 적혀 있다. 이후 기능 기록과 코드를 보면 stations, alerts, DB, mobile client, notification, arrival engine 작업이 구현되어 있다.

## 마지막 검토일

2026-06-06
