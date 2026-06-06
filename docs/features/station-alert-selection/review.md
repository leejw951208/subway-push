# Review: station-alert-selection

## 리뷰 개요

- 일자: 2026-06-06
- Spec: docs/features/station-alert-selection/spec.md
- Plan: docs/features/station-alert-selection/plan.md

---

## 1. Spec 일치 여부

| 처리상태 | 심각도 | 판정 | #   | 요구사항 | 근거 | 보강 지시 |
| -------- | ------ | ---- | --- | -------- | ---- | --------- |
| CLOSED | - | DONE | S001 | 사용자는 검색 또는 추천 역 목록에서 내릴 역을 직접 선택한다. | apps/mobile/lib/widgets/search_pebble.dart:38, apps/mobile/lib/screens/home_screen.dart:287, apps/mobile/lib/screens/search_overlay.dart:51, apps/mobile/lib/screens/search_overlay.dart:151 | - |
| CLOSED | - | DONE | S002 | 선택한 역의 알림 설정 시트에서 알림 시점과 알림 방식을 분리해 설정한다. | apps/mobile/lib/sheets/alert_sheet.dart:107, apps/mobile/lib/sheets/alert_sheet.dart:117, apps/mobile/lib/sheets/alert_sheet.dart:129, apps/mobile/lib/sheets/alert_sheet.dart:163 | - |
| CLOSED | - | DONE | S003 | 저장된 `SubwayAlert`는 내릴 역, 알림 시점, 알림 방식을 보존해야 한다. | apps/mobile/lib/models/subway_alert.dart:47, apps/mobile/lib/models/subway_alert.dart:59, apps/mobile/test/alert_storage_test.dart:23, apps/api/src/alerts/alerts.dto.ts:14, apps/api/src/alerts/alerts.dto.ts:45, apps/api/prisma/schema.prisma:24 | - |
| CLOSED | - | DONE | S004 | 기존 저장 데이터는 알림 시점이 없어도 기본값 `도착할 때`로 복구한다. | apps/mobile/lib/models/subway_alert.dart:13, apps/mobile/lib/models/subway_alert.dart:19, apps/mobile/test/alert_storage_test.dart:29 | - |
| CLOSED | - | DONE | S005 | 제품 문구는 `내릴 역`을 선택 대상으로 쓰고, 알림은 방식과 시점 옵션으로 분리한다. | apps/mobile/lib/widgets/search_pebble.dart:38, apps/mobile/lib/widgets/alert_widgets.dart:202, docs/features/station-alert-selection/spec.md:146 | - |
| CLOSED | - | DONE | S006 | 위치 권한을 요청하거나 위치 좌표를 저장하지 않는다. | apps/mobile/android/app/src/main/AndroidManifest.xml:1, `rtk rg -n "Permission\\.location|ACCESS_FINE_LOCATION|ACCESS_COARSE_LOCATION|NSLocationWhenInUseUsageDescription|NSLocationAlways|geolocator|location" apps/mobile` 결과 위치 권한 요청 없음 | - |

**요약:** DONE 6 / PARTIAL 0 / NOT DONE 0 / CHANGED 0

---

## 2. Plan 일치 여부

| 처리상태 | 심각도 | 판정 | 태스크 | 근거 | 보강 지시 |
| -------- | ------ | ---- | ------ | ---- | --------- |
| CLOSED | - | DONE | T001 `location-permissions` 계획 문서 제거 또는 대체 상태 정리 | docs/features/station-alert-selection/progress.md:21, `rtk rg --files docs/features/location-permissions` 결과 없음 | - |
| CLOSED | - | DONE | T002 `station-alert-selection` 기능 문서 추가 | docs/features/station-alert-selection/spec.md:1, docs/features/station-alert-selection/plan.md:1, docs/features/station-alert-selection/phase.md:1 | - |
| CLOSED | - | DONE | T003 위키나 기능 backlog에 위치 권한 기본 전략이 남아 있는지 확인 | docs/features/README.md:206, docs/wiki/wiki/architecture.md:64, docs/wiki/wiki/features.md:25 | - |
| CLOSED | - | DONE | T004 홈 화면과 알림 시트가 위치 권한 없이 역 선택만으로 동작하는지 확인 | apps/mobile/lib/screens/home_screen.dart:96, apps/mobile/lib/sheets/alert_sheet.dart:107, apps/mobile/lib/sheets/alert_sheet.dart:129 | - |
| CLOSED | - | DONE | T005 위치 권한 요청 UI 또는 문구가 있다면 제거 | apps/mobile/lib/widgets/search_pebble.dart:38, apps/mobile/lib/screens/home_screen.dart:383, apps/mobile/test/widget_test.dart:44 | - |
| CLOSED | - | DONE | T006 내릴 역 선택 흐름의 테스트 기대값을 유지 또는 보강 | apps/mobile/test/widget_test.dart:42, apps/mobile/test/widget_test.dart:46 | - |
| CLOSED | - | DONE | T007 `SubwayAlert.station`이 내릴 역 의미로 쓰이는지 코드와 문서에서 확인 | apps/mobile/lib/state/alert_controller.dart:29, docs/wiki/wiki/architecture.md:68, docs/features/station-alert-selection/progress.md:37 | - |
| CLOSED | - | DONE | T008 수동 탑승 모드가 후속 기능임을 wiki 또는 feature backlog에 기록 | docs/features/README.md:215, docs/wiki/wiki/architecture.md:69 | - |
| CLOSED | - | DONE | T009 `flutter test apps/mobile` 실행 | `rtk flutter test apps/mobile` 결과 19개 테스트 통과 | - |
| CLOSED | - | DONE | T010 `npm run api:test` 실행 | `rtk npm run api:test` 결과 6개 suite, 16개 테스트 통과 | - |
| CLOSED | - | DONE | T011 iOS 시뮬레이터에서 위치 권한 없이 역 선택과 알림 설정 흐름을 수동 확인 | docs/features/station-alert-selection/progress.md:40 | - |

**스코프 이탈:** 없음

---

## 3. 테스트 커버리지

| 처리상태 | 심각도 | 판정 | 요구사항 | 테스트 | 보강 지시 |
| -------- | ------ | ---- | -------- | ------ | --------- |
| CLOSED | - | TESTED | 홈 화면에서 내릴 역 선택 문구와 알림 시점 표시 | apps/mobile/test/widget_test.dart:42, apps/mobile/test/widget_test.dart:46, `rtk flutter test apps/mobile` 통과 | - |
| CLOSED | - | TESTED | 로컬 저장소가 알림 시점을 저장하고 legacy 데이터를 기본값으로 복구 | apps/mobile/test/alert_storage_test.dart:13, apps/mobile/test/alert_storage_test.dart:25, apps/mobile/test/alert_storage_test.dart:29, `rtk flutter test apps/mobile` 통과 | - |
| CLOSED | - | TESTED | API 알림 생성, 수정, 조회에서 알림 시점 보존 | apps/mobile/test/subway_api_client_test.dart:40, apps/mobile/test/subway_api_client_test.dart:56, apps/api/src/alerts/alerts.dto.spec.ts:9, apps/api/src/alerts/alerts.service.spec.ts:30 | - |
| CLOSED | - | TESTED | 위치 권한 미추가 | `rtk rg -n "Permission\\.location|ACCESS_FINE_LOCATION|ACCESS_COARSE_LOCATION|NSLocationWhenInUseUsageDescription|NSLocationAlways|geolocator|location" apps/mobile` 결과 위치 권한 요청 없음 | - |
| CLOSED | - | TESTED | 정적 분석, Prisma schema, 전체 회귀 | `rtk flutter analyze apps/mobile`, `rtk npm run api:test`, `rtk npx prisma validate --schema apps/api/prisma/schema.prisma`, `rtk git diff --check` 통과 | - |

**미테스트:** 0건

---

## 4. 발견 항목

| 처리상태 | 심각도 | 신뢰도 | 분류 | 위치 | 내용 | 보강 지시 |
| -------- | ------ | ------ | ---- | ---- | ---- | --------- |
| CLOSED | - | 9 | BUG | apps/api/src/alerts/alerts.dto.ts:14, apps/api/prisma/schema.prisma:24, apps/mobile/lib/api/subway_api_client.dart:54 | API DTO, Prisma schema, migration, API 테스트, 모바일 API 테스트에 `timing` 보존 경로를 추가했다. | - |
| CLOSED | - | 9 | QA | apps/mobile/lib/sheets/alert_sheet.dart:107 | 알림 시점 선택 UI가 알림 방식과 분리되어 표시된다. | - |
| CLOSED | - | 9 | SECURITY | apps/mobile/android/app/src/main/AndroidManifest.xml:1 | 위치 권한이나 위치 좌표 저장은 추가되지 않았다. | - |

### Appendix (confidence 5 미만)

| 처리상태 | 심각도 | 신뢰도 | 분류 | 위치 | 내용 | 보강 지시 |
| -------- | ------ | ------ | ---- | ---- | ---- | --------- |

---

## 5. 기능 검증

`qa-only` 관점으로 홈 화면, 알림 시트, 로컬 저장소, API 경로를 점검했다.

- `rtk flutter test apps/mobile` 결과 19개 테스트가 모두 통과했다.
- `rtk flutter analyze apps/mobile` 결과 정적 분석 이슈가 없었다.
- `rtk npm run api:test` 결과 6개 suite와 16개 테스트가 모두 통과했다.
- 로컬 저장소는 `timing` 저장과 legacy 기본값 복구를 테스트한다.
- API 경로는 `timing` 요청, 응답, Prisma 위임을 테스트한다.

---

## 6. 보안 감사

`cso` 관점으로 위치 정보 수집, 권한 확장, 민감 데이터 저장 여부를 점검했다.

- 기기 위치 권한 요청 코드와 Android/iOS 위치 권한 설정은 발견되지 않았다.
- 위치 좌표, 위치 기록, 탑승 경로를 저장하는 신규 코드는 추가되지 않았다.
- `timing`은 사용자가 선택한 알림 설정 값이며 위치 좌표나 실시간 이동 기록이 아니다.
- API와 DB가 `timing`을 저장하도록 보강됐으며, 이는 보안 민감 정보 저장을 추가하지 않는다.
