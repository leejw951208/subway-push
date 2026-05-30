# Plan. Mobile State Management

## 단계 구성

| Phase | 이름        | 목표                                   |
| ----- | ----------- | -------------------------------------- |
| P1    | 의존성 도입 | Riverpod 기반 앱 상태 사용 준비       |
| P2    | 상태 이전   | 알림 상태와 액션을 provider로 이전    |
| P3    | 검증        | 기존 UI 동작과 상태 로직을 테스트     |

## 구현 태스크

### P1. 의존성 도입

- [ ] **T001** `flutter_riverpod` dependency 추가
    - 선행. 없음 · 예상. 0.5h
- [ ] **T002** `SubwayPushApp`에 `ProviderScope` 추가
    - 선행. T001 · 예상. 0.5h

### P2. 상태 이전

- [ ] **T003** alert controller/provider 생성
    - 선행. T001 · 예상. 1.5h
- [ ] **T004** 초기 샘플 알림 데이터를 provider로 이동
    - 선행. T003 · 예상. 0.5h
- [ ] **T005** add/update/remove 액션을 controller로 이동
    - 선행. T003 · 예상. 1h
- [ ] **T006** `HomeScreen`을 provider 구독 방식으로 변경
    - 선행. T005 · 예상. 1.5h

### P3. 검증

- [ ] **T007** alert controller 단위 테스트 추가
    - 선행. T005 · 예상. 1h
- [ ] **T008** 기존 widget smoke test 업데이트
    - 선행. T006 · 예상. 0.5h
- [ ] **T009** `flutter analyze`, `flutter test` 실행
    - 선행. T007, T008 · 예상. 0.5h

## 아키텍처 다이어그램

```
SubwayPushApp
  └─ ProviderScope
       └─ alertControllerProvider
            ├─ List<SubwayAlert>
            ├─ upsertAlert()
            └─ removeAlert()
```

## 테스트 매트릭스

| #   | 케이스 | 입력 | 기대 결과 |
| --- | ------ | ---- | --------- |
| 1   | 알림 추가 | 강남 + push=true | 목록 첫 항목이 강남 알림 |
| 2   | 알림 수정 | 기존 강남 voice=true | 강남 항목 1개만 유지되고 옵션 변경 |
| 3   | 알림 삭제 | 강남 삭제 | 강남 항목 제거 |
