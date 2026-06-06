# 실행 절차

## 로컬 개발

### 필요 도구

- Node.js `>=20`.
- 저장소 루트에서 설치한 npm workspace 의존성.
- Dart `^3.6.0`과 호환되는 Flutter SDK.
- 로컬 PostgreSQL 실행을 위한 Docker.

### 세팅

```sh
npm install
cp .env.example apps/api/.env
npm run prisma:generate
```

### API 실행

```sh
npm run api:dev
```

### 모바일 앱 실행

```sh
flutter pub get
flutter run -d chrome --web-renderer canvaskit
```

Android emulator에서 host machine의 API를 호출해야 하면 모바일 API 설정에서 필요한 경우 `10.0.2.2`를 사용한다.

## 테스트

### API 테스트

```sh
npm run api:test
```

### 모바일 테스트

```sh
flutter test apps/mobile
```

## 데이터베이스

### 로컬 PostgreSQL 시작

```sh
docker compose up -d
cp apps/api/.env.example apps/api/.env
npm run prisma:migrate
npm run prisma:generate
```

로컬 PostgreSQL은 host port `5433`으로 노출된다.

### 로컬 DB 초기화

```sh
cd apps/api
npx prisma migrate reset
```

### Prisma Studio

```sh
npm run prisma:studio
```

## 역 데이터 갱신

### 운영 원칙

역 데이터는 공식 데이터 원천을 가져와 단일 JSON으로 정규화한 뒤, API와 모바일 정적 데이터 파일을 생성하는 방식으로 갱신한다.

### 목표 구조

```text
data/stations.json
  -> apps/api/src/stations/stations.data.ts
  -> apps/mobile/lib/data/stations.dart
```

### 갱신 절차

1. 루트 `.env`에 `SEOUL_OPEN_DATA_API_KEY`가 있는지 확인한다.
2. 아래 명령으로 서울 열린데이터광장에서 최신 역 데이터를 가져온다.

```sh
npm run update:stations
```

3. 생성 결과 diff를 사람이 검토한다.
4. 역 검색, API stations 테스트, 모바일 데이터 로딩 테스트를 실행한다.
5. 변경 내용을 커밋한다.

### 검증 명령

```sh
npm run test:stations
npm run api:test
flutter test apps/mobile
```

### 주의 사항

- 실시간 열차 위치나 도착정보 API를 역 목록 최신화의 상시 런타임 의존성으로 두지 않는다.
- 공식 데이터의 역 코드와 프로젝트 내부 station model의 식별자 정책을 명확히 맞춘다.
- Android emulator API base URL 문제와 역 데이터 갱신은 별개로 본다.

## 배포

운영 배포 절차는 아직 문서화되지 않았다.

## 문제 해결

### API가 DB에 연결하지 못한다

Docker Compose가 실행 중인지 확인하고, `apps/api/.env`가 프로젝트에서 기대하는 로컬 PostgreSQL port를 가리키는지 확인한다.

### Android emulator에서 API에 연결하지 못한다

Android emulator에서 host 접근이 필요하면 `localhost` 대신 `10.0.2.2`를 사용한다.

### 테스트 알림이 실패한다

UI 상태를 디버깅하기 전에 플랫폼 권한 상태와 네이티브 알림 설정을 확인한다.

## 근거 자료

- `../../../README.md`
- `../../../package.json`
- `../../../apps/api/package.json`
- `../../../apps/mobile/pubspec.yaml`
- `../../features/mobile-api-client/plan.md`
- `../../features/postgres-docker-prisma-migrations/plan.md`
- `../../features/native-notification-permissions/plan.md`
- `../raw/notes/2026-06-06-station-data-update-strategy.md`
- `../raw/references/2026-06-06-station-data-sources.md`

## 마지막 검토일

2026-06-06
