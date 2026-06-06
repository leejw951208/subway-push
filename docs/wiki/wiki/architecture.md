# 아키텍처

## 요약

내릴때는 Flutter 모바일 앱과 NestJS API로 나뉜다. 모바일 앱은 사용자 알림 설정 흐름과 로컬 알림 동작을 담당한다. API는 역 조회와 알림 CRUD 엔드포인트를 담당한다. Prisma와 PostgreSQL은 백엔드 알림 데이터의 영속화 경로를 제공한다.

## 시스템 맥락

```text
Flutter 앱
  -> SubwayRepository / API 클라이언트
  -> NestJS API
  -> PrismaService
  -> PostgreSQL
```

모바일 앱은 원격 역 정보 로딩이 실패하거나 진행 중일 때 번들된 로컬 역 데이터를 사용할 수 있다.

## 주요 컴포넌트

| 컴포넌트 | 책임 |
|---|---|
| `apps/mobile` | Flutter UI, 역 검색, 알림 시트, 로컬 상태, 로컬 저장소, 알림 권한, 도착 알림 로직. |
| `apps/api` | health, stations, alerts HTTP API. |
| `apps/api/prisma` | PostgreSQL 데이터용 Prisma 스키마와 마이그레이션. |
| `docs/features` | 기능 계획, 구현, 검증, 리뷰 기록. |
| `docs/wiki` | LLM 관리 프로젝트 기억과 원본 메모. |

## 모듈 책임 경계

- 모바일 UI 모듈은 렌더링과 사용자 상호작용에 집중한다.
- 모바일 상태는 `apps/mobile/lib/state` 아래에 둔다.
- 모바일 저장소는 `apps/mobile/lib/storage` 아래에 둔다.
- 모바일 API 접근은 `apps/mobile/lib/api` 아래에 둔다.
- 모바일 알림 동작은 `apps/mobile/lib/notifications` 아래에 둔다.
- API 컨트롤러는 HTTP 요청을 서비스 호출로 변환한다.
- API 서비스는 도메인 동작과 영속성 접근을 담당한다.
- Prisma 스키마는 DB 모델을 정의하지만 서비스 레벨 검증을 대체하지 않는다.
- 역 데이터는 단일 JSON 원본에서 API용 TypeScript 파일과 모바일용 Dart 파일을 생성하는 방향으로 관리한다.

## 데이터 흐름

역 조회 흐름.

1. Flutter가 `remoteStationsProvider`를 구독한다.
2. repository가 API client를 호출한다.
3. NestJS `StationsController`가 `StationsService`에 위임한다.
4. UI는 로딩 또는 에러 상태에서 번들된 역 데이터를 fallback으로 사용한다.

역 데이터 갱신 흐름.

1. 공식 데이터 원천에서 최신 역 데이터를 가져온다.
2. 단일 JSON 원본으로 정규화한다.
3. API와 모바일 정적 데이터 파일을 생성한다.
4. 생성 diff를 검토한 뒤 반영한다.

알림 관리 흐름.

1. 사용자가 역에서 알림 시트를 연다.
2. `AlertController`가 알림을 upsert 또는 remove한다.
3. 로컬 저장소가 모바일 알림 상태를 저장한다.
4. 서버 기반 관리를 위한 API 알림 CRUD 경로도 존재한다.

## 인증 흐름

사용자 인증은 아직 구현되지 않았다. Prisma에는 `User` 모델과 선택적 `Alert.owner` 관계가 있지만, 현재 API 기능 범위에서는 인증을 제외한다.

## 백그라운드 작업

스케줄러, 큐, 서버 사이드 백그라운드 작업은 문서화되어 있지 않다. 도착 알림 동작은 Flutter 도메인 로직으로 표현되어 있다.

## 외부 연동

- Prisma를 통한 PostgreSQL.
- Flutter local notifications.
- `permission_handler`를 통한 권한 처리.
- 지하철 역 데이터 최신화에는 서울 열린데이터광장, TOPIS, 공공데이터포털 같은 공식 데이터 출처를 후보로 둔다.
- 외부 지하철 실시간 데이터 API를 런타임 상시 의존성으로 사용하는 기능은 구현되어 있지 않다.

## 위험 요소

- 동기화 정책이 명확하지 않으면 모바일 로컬 알림 상태와 API 알림 상태가 달라질 수 있다.
- Android emulator는 host 접근에 `10.0.2.2`가 필요하므로 localhost 설정에 주의해야 한다.
- 알림 동작은 네이티브 권한 상태와 플랫폼 설정에 의존한다.
- 백그라운드 위치 기능이 추가되면 도착 판정 정책이 플랫폼 정책에 민감해질 수 있다.

## 근거 자료

- `../../../apps/mobile/lib/screens/home_screen.dart`
- `../../../apps/mobile/lib/state/alert_controller.dart`
- `../../../apps/mobile/lib/storage/alert_storage.dart`
- `../../../apps/mobile/lib/api/subway_repository.dart`
- `../../../apps/mobile/lib/arrival/arrival_alert_engine.dart`
- `../../../apps/api/src/app.module.ts`
- `../../../apps/api/src/stations/stations.controller.ts`
- `../../../apps/api/src/alerts/alerts.controller.ts`
- `../../../apps/api/prisma/schema.prisma`
- `../../features/README.md`
- `../raw/notes/2026-06-06-station-data-update-strategy.md`
- `../raw/references/2026-06-06-station-data-sources.md`

## 마지막 검토일

2026-06-06
