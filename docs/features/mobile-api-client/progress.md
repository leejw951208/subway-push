# Progress. Mobile API Client

## 현재 단계

구현

## 상태

✅ 완료

## 완료 항목

- `http` 의존성과 API base URL 설정을 추가했다.
- station/alert JSON 변환을 모델에 추가했다.
- `/stations` 조회와 `/alerts` CRUD를 호출하는 `SubwayApiClient`를 추가했다.
- 성공 응답 변환과 실패 응답 예외 처리를 테스트했다.
- API repository와 provider를 추가해 UI가 HTTP client에 직접 의존하지 않도록 보강했다.
- 홈 화면에 API loading/error/data 상태와 재시도 액션을 연결했다.

## 검증

- 2026-05-30 `rtk mise exec -- flutter analyze`.
- 2026-05-30 `rtk mise exec -- flutter test`.
- 2026-05-30 보강 후 `rtk mise exec -- flutter analyze`, `rtk mise exec -- flutter test`.

## 최근 업데이트

2026-05-30
