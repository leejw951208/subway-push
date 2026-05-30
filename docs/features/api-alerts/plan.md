# Plan. API Alerts

## 단계 구성

| Phase | 이름        | 목표                                   |
| ----- | ----------- | -------------------------------------- |
| P1    | 데이터 계약 | Prisma/DTO 알림 데이터 구조 확정      |
| P2    | CRUD 구현   | 알림 생성/조회/수정/삭제 API 제공     |
| P3    | 검증        | 정상/예외 API 동작을 테스트           |

## 구현 태스크

### P1. 데이터 계약

- [ ] **T001** 현재 Prisma `Push` 모델을 alert 용도에 맞게 조정할지 결정
    - 선행. 없음 · 예상. 0.5h
- [ ] **T002** alert DTO 정의
    - 선행. T001 · 예상. 1h
- [ ] **T003** validation 규칙 정의
    - 선행. T002 · 예상. 0.5h

### P2. CRUD 구현

- [ ] **T004** `AlertsService` 생성
    - 선행. T001, T002 · 예상. 1.5h
- [ ] **T005** `AlertsController` 생성
    - 선행. T004 · 예상. 1.5h
- [ ] **T006** create/list/update/delete 구현
    - 선행. T004, T005 · 예상. 2h
- [ ] **T007** `AppModule` 등록
    - 선행. T005 · 예상. 0.5h

### P3. 검증

- [ ] **T008** service test 추가
    - 선행. T006 · 예상. 1.5h
- [ ] **T009** controller test 추가
    - 선행. T006 · 예상. 1.5h
- [ ] **T010** `npm run api:build`, `npm run api:test` 실행
    - 선행. T008, T009 · 예상. 0.5h

## 아키텍처 다이어그램

```
Flutter client
  └─ /alerts
       └─ AlertsController
            └─ AlertsService
                 └─ PrismaClient
                      └─ PostgreSQL
```

## 테스트 매트릭스

| #   | 케이스 | 입력 | 기대 결과 |
| --- | ------ | ---- | --------- |
| 1   | 생성 | stationName=잠실, push=true | 201 + alert |
| 2   | 수정 | id=1, voice=true | 옵션 변경 |
| 3   | 예외 | 모든 방식 false | 400 |
