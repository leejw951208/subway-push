# Feature Backlog

이 문서는 `feature-*` 스킬로 계획/구현/검증하기 위한 기능 후보 목록이다.

사용 흐름:

```bash
$feature-plan <feature-slug>
$feature-implement <feature-slug>
$feature-verify <feature-slug>
```

현재 앱 상태:

- Flutter 목업 기반 UI 프로토타입 구현 완료
- Flutter 코드 구조 분리 진행 중
- NestJS API는 `/`와 `/health`만 구현
- Prisma schema 초안은 있으나 실제 도메인 API/마이그레이션은 없음
- 알림 상태는 앱 메모리에서만 유지됨

## Recommended Order

1. `mobile-local-alert-storage`
2. `mobile-state-management`
3. `api-stations`
4. `api-alerts`
5. `mobile-api-client`
6. `postgres-docker-prisma-migrations`
7. `native-notification-permissions`
8. `arrival-alert-engine`

## Features

### 1. mobile-local-alert-storage

앱 재시작 후에도 사용자가 설정한 알림 목록을 유지한다.

- 대상: Flutter
- 추천 구현: `shared_preferences` 또는 JSON 직렬화 기반 로컬 저장
- 포함 범위:
  - `SubwayAlert` 직렬화/역직렬화
  - 앱 시작 시 저장된 알림 복원
  - 알림 추가/수정/삭제 시 저장소 반영
  - 로컬 저장 실패 시 기본 상태 유지
- 제외 범위:
  - 서버 동기화
  - 사용자 계정
  - 푸시 알림 실제 발송
- 완료 기준:
  - 앱 재시작 후 알림 목록이 유지된다.
  - widget/unit test로 저장/복원 흐름을 검증한다.

### 2. mobile-state-management

현재 `HomeScreen` 내부 `StatefulWidget`에 있는 알림/검색 상태를 앱 상태 계층으로 분리한다.

- 대상: Flutter
- 추천 구현: Riverpod
- 포함 범위:
  - 알림 목록 provider
  - 검색 query/provider 또는 controller 책임 정리
  - 추가/수정/삭제 액션 분리
  - UI는 provider 상태를 구독하도록 변경
- 제외 범위:
  - 서버 API 연동
  - 로컬 저장 구현 자체
- 완료 기준:
  - `HomeScreen`이 상태 저장소 역할을 하지 않는다.
  - 알림 추가/수정/삭제 동작이 기존과 동일하다.
  - 기존 widget test가 통과하고 상태 단위 테스트가 추가된다.

### 3. api-stations

정적 역 데이터를 API에서 조회할 수 있게 한다.

- 대상: NestJS
- 포함 범위:
  - `GET /stations`
  - `GET /stations?query=강남`
  - 노선 색상/역명/설명/노선 목록 응답
  - 기본 service/controller/test
- 제외 범위:
  - 외부 지하철 공공 API 연동
  - DB 저장
  - 실시간 도착 정보
- 완료 기준:
  - Flutter의 현재 정적 `stations` 데이터와 동등한 응답을 제공한다.
  - controller/service test가 통과한다.

### 4. api-alerts

사용자 알림 설정을 서버 API로 CRUD할 수 있게 한다.

- 대상: NestJS, Prisma
- 포함 범위:
  - `GET /alerts`
  - `POST /alerts`
  - `PATCH /alerts/:id`
  - `DELETE /alerts/:id`
  - 알림 방식 필드: push/vibration/voice
  - station 식별자 또는 station name 저장 정책 결정
  - service/controller/dto/test
- 제외 범위:
  - 인증
  - 실제 푸시 발송
  - 위치 기반 도착 판정
- 완료 기준:
  - API로 알림 추가/수정/삭제/목록 조회가 가능하다.
  - Prisma schema와 API DTO가 일관된다.

### 5. mobile-api-client

Flutter 앱이 NestJS API와 통신할 수 있는 클라이언트 계층을 추가한다.

- 대상: Flutter
- 추천 구현: `http` 또는 `dio`
- 포함 범위:
  - API base URL 설정
  - stations 조회
  - alerts CRUD 호출
  - 로딩/에러 상태 최소 표시
  - Android emulator에서 localhost 접근 설정 (`10.0.2.2`)
- 제외 범위:
  - 인증 토큰
  - 오프라인 동기화
  - 백그라운드 작업
- 완료 기준:
  - 앱에서 서버의 역 목록과 알림 목록을 읽고 쓴다.
  - API 서버 미실행 시 사용자에게 실패 상태가 표시된다.

### 6. postgres-docker-prisma-migrations

개발자가 같은 DB 환경을 재현할 수 있게 PostgreSQL Docker Compose와 Prisma migration을 정리한다.

- 대상: Infra, Prisma
- 포함 범위:
  - `docker-compose.yml`
  - Postgres service/env
  - `DATABASE_URL` 문서화
  - 첫 Prisma migration 생성
  - DB reset/migrate 명령 README 업데이트
- 제외 범위:
  - 운영 배포 인프라
  - 백업/모니터링
- 완료 기준:
  - `docker compose up -d` 후 `prisma migrate dev`가 성공한다.
  - 새 개발자가 README대로 DB를 띄울 수 있다.

### 7. native-notification-permissions

Android/iOS 알림 권한과 로컬 알림 표시 기반을 추가한다.

- 대상: Flutter, Android/iOS 플랫폼 설정
- 추천 구현: `flutter_local_notifications`, `permission_handler`
- 포함 범위:
  - 알림 권한 요청
  - Android notification channel
  - 테스트용 로컬 알림 발송 버튼 또는 dev-only trigger
  - 권한 거부 상태 UI
- 제외 범위:
  - 서버 푸시
  - 실제 지하철 도착 판정
  - 백그라운드 위치 추적
- 완료 기준:
  - Android emulator/device에서 테스트 알림이 표시된다.
  - 권한 상태별 UI가 확인 가능하다.

### 8. arrival-alert-engine

선택한 역에 가까워졌다고 판단했을 때 설정한 방식으로 알림을 트리거하는 핵심 엔진을 만든다.

- 대상: Flutter
- 포함 범위:
  - 현재 위치/역 위치 모델 결정
  - 거리 기반 도착 판정 기준
  - 중복 알림 방지
  - push/vibration/voice 옵션별 실행 경로
  - 테스트 가능한 순수 도메인 로직 분리
- 제외 범위:
  - 외부 실시간 지하철 API
  - 서버 기반 푸시
  - 장시간 백그라운드 위치 정책 최적화
- 완료 기준:
  - 도메인 테스트로 “역 근처 진입 시 1회 알림”을 검증한다.
  - UI에서 알림 설정과 엔진 입력이 연결된다.

### 9. lightweight-android-emulator-profile

개발용 Android 에뮬레이터가 너무 느린 문제를 줄이기 위한 경량 AVD 프로필을 문서화/생성한다.

- 대상: DevEx
- 포함 범위:
  - 추천 AVD 스펙 문서화
  - 낮은 해상도 기기 권장
  - `flutter devices`, `flutter run` 실행 절차
  - 기존 `Pixel_10_Pro_XL` 병목 원인 기록
- 제외 범위:
  - 앱 기능 변경
  - CI 디바이스 팜
- 완료 기준:
  - 개발자가 빠른 에뮬레이터를 선택해 앱을 실행할 수 있다.

### 10. ui-regression-screenshots

목업 기반 UI가 깨지는지 확인할 수 있는 스크린샷 검증 기반을 추가한다.

- 대상: Flutter test/DevEx
- 포함 범위:
  - 주요 화면 golden test 또는 screenshot test
  - 홈/검색/알림시트 기준 이미지
  - 폰트/디바이스 크기 고정
- 제외 범위:
  - 완전한 E2E 테스트
  - 모든 Android 기기 대응
- 완료 기준:
  - 홈 화면 주요 레이아웃 변화가 테스트에서 감지된다.

## Notes

- 각 기능은 바로 구현하지 말고 먼저 `$feature-plan <feature-slug>`로 `spec.md`, `plan.md`를 만든다.
- 이미 요구사항이 명확한 기능은 `feature-plan` 단계에서 “요구사항 명확”으로 진행한다.
- 기능 구현 후에는 `$feature-verify <feature-slug>`로 검증 문서를 남긴다.
