# Review: station-alert-selection

## 리뷰 개요

- 일자: 2026-06-06
- Spec: docs/features/station-alert-selection/spec.md
- Plan: docs/features/station-alert-selection/plan.md

---

## 1. Spec 일치 여부

| 처리상태 | 심각도 | 판정 | #   | 요구사항 | 근거 | 보강 지시 |
| -------- | ------ | ---- | --- | -------- | ---- | --------- |
| CLOSED | - | DONE | S001 | 사용자는 검색 또는 추천 역 목록에서 알림 받을 역을 직접 선택한다. | apps/mobile/lib/widgets/search_pebble.dart:38, apps/mobile/lib/screens/home_screen.dart:287, apps/mobile/lib/screens/home_screen.dart:306, apps/mobile/lib/screens/search_overlay.dart:51, apps/mobile/lib/screens/search_overlay.dart:151 | - |
| CLOSED | - | DONE | S002 | 선택한 역의 알림 설정 시트를 열고 push, vibration, voice 옵션을 저장한다. | apps/mobile/lib/screens/home_screen.dart:94, apps/mobile/lib/screens/home_screen.dart:106, apps/mobile/lib/sheets/alert_sheet.dart:112, apps/mobile/lib/sheets/alert_sheet.dart:120, apps/mobile/lib/sheets/alert_sheet.dart:128, apps/mobile/lib/sheets/alert_sheet.dart:136 | - |
| CLOSED | - | DONE | S003 | 위치 권한 요청 없이 역 선택만으로 알림을 설정하고 위치 기반 표현을 직접 선택 기반 표현으로 정리한다. | apps/mobile/lib/widgets/search_pebble.dart:38, apps/mobile/lib/screens/home_screen.dart:383, apps/mobile/test/widget_test.dart:42, apps/mobile/test/widget_test.dart:44 | - |
| CLOSED | - | DONE | S004 | 수동 탑승 모드는 후속 기능으로 기록하고 `SubwayAlert.station`을 내릴 역으로 재사용할 수 있게 정리한다. | docs/features/README.md:210, docs/features/README.md:214, docs/wiki/wiki/architecture.md:66, docs/wiki/wiki/architecture.md:68, docs/wiki/wiki/features.md:29 | - |
| CLOSED | - | DONE | S005 | iOS/Android 위치 권한 설정을 추가하지 않고 위치 좌표, 위치 기록, 탑승 경로를 저장하지 않는다. | apps/mobile/android/app/src/main/AndroidManifest.xml:1, docs/wiki/wiki/overview.md:33, docs/features/station-alert-selection/progress.md:34 | - |
| CLOSED | - | DONE | S006 | 기존 알림 권한 요청과 도착 알림 엔진은 삭제하지 않는다. | apps/mobile/lib/screens/home_screen.dart:351, apps/mobile/lib/screens/home_screen.dart:149, apps/mobile/lib/notifications/notification_service.dart:34, apps/mobile/lib/arrival/arrival_alert_engine.dart:1 | - |

**요약:** DONE 6 / PARTIAL 0 / NOT DONE 0 / CHANGED 0

---

## 2. Plan 일치 여부

| 처리상태 | 심각도 | 판정 | 태스크 | 근거 | 보강 지시 |
| -------- | ------ | ---- | ------ | ---- | --------- |
| CLOSED | - | DONE | T001 `location-permissions` 계획 문서 제거 또는 대체 상태 정리 | docs/features/station-alert-selection/progress.md:20, `rtk rg --files docs/features/location-permissions` 결과 없음 | - |
| CLOSED | - | DONE | T002 `station-alert-selection` 기능 문서 추가 | docs/features/station-alert-selection/spec.md:1, docs/features/station-alert-selection/plan.md:1, docs/features/station-alert-selection/phase.md:1 | - |
| CLOSED | - | DONE | T003 위키나 기능 backlog에 위치 권한 기본 전략이 남아 있는지 확인 | docs/features/README.md:206, docs/wiki/wiki/overview.md:33, docs/wiki/wiki/architecture.md:64, docs/wiki/wiki/features.md:25 | - |
| CLOSED | - | DONE | T004 홈 화면과 알림 시트가 위치 권한 없이 역 선택만으로 동작하는지 확인 | apps/mobile/lib/screens/home_screen.dart:87, apps/mobile/lib/screens/home_screen.dart:94, apps/mobile/lib/sheets/alert_sheet.dart:136 | - |
| CLOSED | - | DONE | T005 위치 권한 요청 UI 또는 문구가 있다면 제거 | apps/mobile/lib/widgets/search_pebble.dart:38, apps/mobile/lib/screens/home_screen.dart:383, apps/mobile/test/widget_test.dart:44 | - |
| CLOSED | - | DONE | T006 알림 받을 역 선택 흐름의 테스트 기대값을 유지 또는 보강 | apps/mobile/test/widget_test.dart:42, apps/mobile/test/widget_test.dart:43, apps/mobile/test/widget_test.dart:44 | - |
| CLOSED | - | DONE | T007 `SubwayAlert.station`이 내릴 역 의미로 쓰이는지 코드와 문서에서 확인 | apps/mobile/lib/state/alert_controller.dart:29, docs/wiki/wiki/architecture.md:68, docs/wiki/wiki/features.md:29 | - |
| CLOSED | - | DONE | T008 수동 탑승 모드가 후속 기능임을 wiki 또는 feature backlog에 기록 | docs/features/README.md:214, docs/wiki/wiki/architecture.md:69 | - |
| CLOSED | - | DONE | T009 `flutter test apps/mobile` 실행 | `rtk flutter test apps/mobile` 결과 18개 테스트 통과 | - |
| CLOSED | - | DONE | T010 `npm run api:test` 실행 | `rtk npm run api:test` 결과 6개 suite, 15개 테스트 통과 | - |
| CLOSED | - | DONE | T011 iOS 시뮬레이터에서 위치 권한 없이 역 선택과 알림 설정 흐름을 수동 확인 | docs/features/station-alert-selection/progress.md:37, /tmp/station-alert-selection.png 캡처 확인 | - |

**스코프 이탈:** 없음

---

## 3. 테스트 커버리지

| 처리상태 | 심각도 | 판정 | 요구사항 | 테스트 | 보강 지시 |
| -------- | ------ | ---- | -------- | ------ | --------- |
| CLOSED | - | TESTED | 역 선택 UX 문구와 위치 전제 문구 제거 | apps/mobile/test/widget_test.dart:42, apps/mobile/test/widget_test.dart:43, apps/mobile/test/widget_test.dart:44, `rtk flutter test apps/mobile` 통과 | - |
| CLOSED | - | TESTED | 역 검색, 알림 설정, 저장 흐름 유지 | apps/mobile/test/alert_controller_test.dart, apps/mobile/test/alert_storage_test.dart, apps/mobile/test/widget_test.dart, `rtk flutter test apps/mobile` 통과 | - |
| CLOSED | - | TESTED | API 연동 회귀 없음 | apps/mobile/test/subway_api_client_test.dart, apps/mobile/test/subway_repository_test.dart, `rtk npm run api:test` 통과 | - |
| CLOSED | - | TESTED | 위치 권한 요청 미추가 | `rtk rg -n "Permission\\.location|ACCESS_FINE_LOCATION|ACCESS_COARSE_LOCATION|NSLocationWhenInUseUsageDescription|NSLocationAlways|geolocator|location" apps/mobile` 결과 권한 요청 없음 | - |
| CLOSED | - | TESTED | 정적 분석과 문서 diff 품질 | `rtk flutter analyze apps/mobile` 통과, `rtk git diff --check` 통과 | - |

**미테스트:** 0건

---

## 4. 발견 항목

| 처리상태 | 심각도 | 신뢰도 | 분류 | 위치 | 내용 | 보강 지시 |
| -------- | ------ | ------ | ---- | ---- | ---- | --------- |
| CLOSED | - | 9 | QA | apps/mobile/lib/screens/home_screen.dart:383 | 위치처럼 읽히던 `현재` 표시가 `추천`으로 바뀌었고 위젯 테스트가 이를 고정한다. | - |
| CLOSED | - | 9 | SECURITY | apps/mobile/android/app/src/main/AndroidManifest.xml:1 | Android manifest에 위치 권한이 추가되지 않았고, 기존 알림 관련 권한만 남아 있다. | - |
| CLOSED | - | 8 | OTHER | docs/wiki/wiki/architecture.md:64 | 위키가 직접 역 선택 흐름과 수동 탑승 모드 확장 방향을 설명한다. | - |

### Appendix (confidence 5 미만)

| 처리상태 | 심각도 | 신뢰도 | 분류 | 위치 | 내용 | 보강 지시 |
| -------- | ------ | ------ | ---- | ---- | ---- | --------- |

---

## 5. 기능 검증

`qa-only` 관점으로 홈 화면, 검색 진입점, 알림 시트, 저장 흐름, 알림 권한 거부 상태를 점검했다.

- `rtk flutter test apps/mobile` 결과 18개 테스트가 모두 통과했다.
- `rtk npm run api:test` 결과 6개 테스트 suite와 15개 테스트가 모두 통과했다.
- `rtk flutter analyze apps/mobile` 결과 정적 분석 이슈가 없었다.
- iPhone 17 시뮬레이터에서 홈 화면의 `알림 받을 역을 선택하세요` 문구와 `추천` 칩을 확인했다.
- API 오류 상태와 알림 권한 거부 상태는 기존 widget test가 유지한다.

---

## 6. 보안 감사

`cso` 관점으로 위치 정보 수집, 권한 확장, 민감 데이터 저장 여부를 점검했다.

- 기기 위치 권한 요청 코드와 Android/iOS 위치 권한 설정은 발견되지 않았다.
- 위치 좌표, 위치 기록, 탑승 경로를 저장하는 신규 코드는 추가되지 않았다.
- 남아 있는 `permission_handler` 사용은 알림 권한 요청용이며, 이번 기능 범위의 위치 권한과 분리되어 있다.
- 변경은 UI 문구, 테스트, 문서에 집중되어 있어 네트워크, 인증, DB, secret 취급면의 신규 공격면은 없다.
