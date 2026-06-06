# 반복 실수

## `docs/features/README.md`를 현재 상태로 오해하는 문제

### 날짜

2026-06-06.

### 증상

에이전트가 API에 `/`와 `/health`만 있다고 잘못 판단할 수 있다.

### 원인

`docs/features/README.md`에는 오래된 backlog snapshot이 있고, 이후 feature 기록과 코드는 여러 기능이 검증 및 구현되었음을 보여준다.

### 올바른 해결

프로젝트 상태를 요약하기 전에 feature `phase.md` 파일과 현재 코드를 확인한다.

### 예방

현재 상태는 `docs/wiki/wiki/features.md`를 먼저 보고, source file과 `docs/features/*/phase.md`로 검증한다.

### 근거 자료

- `../../features/README.md`
- `../../features/api-stations/phase.md`
- `../../features/api-alerts/phase.md`
- `../../../apps/api/src/app.module.ts`

## Android emulator의 host alias 문제

### 날짜

2026-06-06.

### 증상

Android emulator에서 `localhost`를 사용하면 모바일 API 호출이 실패할 수 있다.

### 원인

Android emulator의 `localhost`는 host machine이 아니라 emulator 자신을 가리킨다.

### 올바른 해결

Android emulator에서 host API에 접근하려면 `10.0.2.2`를 사용한다.

### 예방

API base URL 동작을 바꾸기 전에 `apps/mobile/lib/api/api_config.dart`와 runbook을 확인한다.

### 근거 자료

- `../../features/mobile-api-client/plan.md`
- `../../../apps/mobile/lib/api/api_config.dart`

## 마지막 검토일

2026-06-06
