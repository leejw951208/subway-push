# Plan. Mobile Local Alert Storage

## 단계 구성

| Phase | 이름        | 목표                                   |
| ----- | ----------- | -------------------------------------- |
| P1    | 모델 직렬화 | 알림 설정을 저장 가능한 JSON으로 변환 |
| P2    | 저장소 연결 | 앱 시작/변경 시 로컬 저장소와 동기화 |
| P3    | 검증        | 저장/복원/손상 데이터 처리 검증       |

## 구현 태스크

### P1. 모델 직렬화

- [ ] **T001** `Station`/`SubwayAlert` 직렬화 정책 결정
    - 선행. 없음 · 예상. 0.5h
- [ ] **T002** `SubwayAlert` JSON encode/decode 유틸 추가
    - 선행. T001 · 예상. 1h
- [ ] **T003** station name으로 `Station`을 복원하는 lookup 추가
    - 선행. T001 · 예상. 0.5h

### P2. 저장소 연결

- [ ] **T004** 로컬 저장 dependency 선택 및 pubspec 반영
    - 선행. T001 · 예상. 0.5h
- [ ] **T005** alert storage repository 추가
    - 선행. T002, T004 · 예상. 1.5h
- [ ] **T006** `HomeScreen` 초기화 시 저장된 알림 로드
    - 선행. T005 · 예상. 1h
- [ ] **T007** 알림 추가/수정/삭제 후 저장 호출
    - 선행. T006 · 예상. 1h

### P3. 검증

- [ ] **T008** 직렬화/역직렬화 unit test 추가
    - 선행. T002 · 예상. 1h
- [ ] **T009** 저장소 복원/손상 데이터 test 추가
    - 선행. T005 · 예상. 1h
- [ ] **T010** `flutter analyze`, `flutter test` 실행
    - 선행. T008, T009 · 예상. 0.5h

## 아키텍처 다이어그램

```
HomeScreen
  └─ AlertStorage
       ├─ encode List<SubwayAlert>
       ├─ decode saved JSON
       └─ SharedPreferences/local key-value store
```

## 테스트 매트릭스

| #   | 케이스 | 입력 | 기대 결과 |
| --- | ------ | ---- | --------- |
| 1   | 정상 저장/복원 | 잠실 알림 push=true | 앱 시작 시 잠실 알림 표시 |
| 2   | 삭제 저장 | 기존 알림 삭제 | 재시작 후 삭제된 알림 미표시 |
| 3   | 손상 데이터 | invalid JSON | 앱 크래시 없이 기본 상태 표시 |
