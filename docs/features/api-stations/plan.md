# Plan. API Stations

## 단계 구성

| Phase | 이름        | 목표                                   |
| ----- | ----------- | -------------------------------------- |
| P1    | 데이터 모델 | API 응답에 사용할 station 데이터 정의 |
| P2    | API 구현    | `/stations` 조회와 검색 제공          |
| P3    | 검증        | 서비스/컨트롤러 테스트 추가           |

## 구현 태스크

### P1. 데이터 모델

- [ ] **T001** API station 타입/DTO 정의
    - 선행. 없음 · 예상. 0.5h
- [ ] **T002** Flutter 정적 데이터와 동등한 station dataset 추가
    - 선행. T001 · 예상. 1h
- [ ] **T003** line color 데이터 추가
    - 선행. T002 · 예상. 0.5h

### P2. API 구현

- [ ] **T004** `StationsService` 추가
    - 선행. T002 · 예상. 1h
- [ ] **T005** `StationsController`에 `GET /stations` 구현
    - 선행. T004 · 예상. 1h
- [ ] **T006** query 부분검색 구현
    - 선행. T005 · 예상. 0.5h
- [ ] **T007** `AppModule`에 stations provider/controller 등록
    - 선행. T005 · 예상. 0.5h

### P3. 검증

- [ ] **T008** service unit test 추가
    - 선행. T004, T006 · 예상. 1h
- [ ] **T009** controller test 추가
    - 선행. T005 · 예상. 1h
- [ ] **T010** `npm run api:build`, `npm run api:test` 실행
    - 선행. T008, T009 · 예상. 0.5h

## 아키텍처 다이어그램

```
GET /stations?query=
  └─ StationsController
       └─ StationsService
            └─ static stations dataset
```

## 테스트 매트릭스

| #   | 케이스 | 입력 | 기대 결과 |
| --- | ------ | ---- | --------- |
| 1   | 전체 조회 | no query | 전체 station 배열 |
| 2   | 부분검색 | query=강남 | 강남역 포함 결과 |
| 3   | 결과 없음 | query=없는역 | 빈 배열 |
