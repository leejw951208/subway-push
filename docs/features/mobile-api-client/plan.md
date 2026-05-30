# Plan. Mobile API Client

## 단계 구성

| Phase | 이름        | 목표                                   |
| ----- | ----------- | -------------------------------------- |
| P1    | Client 기반 | HTTP client와 DTO 변환 계층 준비      |
| P2    | API 연결    | stations/alerts API 호출 연결         |
| P3    | UI 상태     | 로딩/에러/성공 상태를 화면에 반영     |

## 구현 태스크

### P1. Client 기반

- [ ] **T001** HTTP dependency 선택 및 추가
    - 선행. 없음 · 예상. 0.5h
- [ ] **T002** API config/base URL 정의
    - 선행. T001 · 예상. 0.5h
- [ ] **T003** station/alert DTO 변환 코드 추가
    - 선행. T001 · 예상. 1h

### P2. API 연결

- [ ] **T004** stations API client 구현
    - 선행. T003 · 예상. 1h
- [ ] **T005** alerts API client CRUD 구현
    - 선행. T003 · 예상. 2h
- [ ] **T006** repository 계층 추가
    - 선행. T004, T005 · 예상. 1h

### P3. UI 상태

- [ ] **T007** 홈 화면 데이터 로딩 연결
    - 선행. T006 · 예상. 1.5h
- [ ] **T008** API 실패 UI 추가
    - 선행. T007 · 예상. 1h
- [ ] **T009** client/repository test 추가
    - 선행. T004, T005 · 예상. 1.5h
- [ ] **T010** `flutter analyze`, `flutter test` 실행
    - 선행. T009 · 예상. 0.5h

## 아키텍처 다이어그램

```
Flutter UI
  └─ Repository
       └─ ApiClient
            └─ NestJS API
                 ├─ /stations
                 └─ /alerts
```

## 테스트 매트릭스

| #   | 케이스 | 입력 | 기대 결과 |
| --- | ------ | ---- | --------- |
| 1   | 역 목록 조회 | API 200 | Station 목록 변환 |
| 2   | 알림 생성 | POST /alerts | 생성된 alert 반영 |
| 3   | 서버 실패 | connection refused | 에러 상태 표시 |
