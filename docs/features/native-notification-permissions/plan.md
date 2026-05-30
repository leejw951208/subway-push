# Plan. Native Notification Permissions

## 단계 구성

| Phase | 이름        | 목표                                   |
| ----- | ----------- | -------------------------------------- |
| P1    | Plugin 설정 | 로컬 알림/권한 plugin 사용 준비       |
| P2    | 권한/채널   | OS 권한 요청과 Android 채널 생성      |
| P3    | 테스트 발송 | 테스트 알림으로 플랫폼 동작 검증      |

## 구현 태스크

### P1. Plugin 설정

- [ ] **T001** 알림/권한 plugin 선택 및 pubspec 추가
    - 선행. 없음 · 예상. 0.5h
- [ ] **T002** Android/iOS 플랫폼 설정 확인
    - 선행. T001 · 예상. 1h
- [ ] **T003** notification service 초기화 코드 추가
    - 선행. T001, T002 · 예상. 1h

### P2. 권한/채널

- [ ] **T004** 알림 권한 상태 조회 구현
    - 선행. T003 · 예상. 1h
- [ ] **T005** 권한 요청 flow 구현
    - 선행. T004 · 예상. 1h
- [ ] **T006** Android notification channel 생성
    - 선행. T003 · 예상. 0.5h

### P3. 테스트 발송

- [ ] **T007** dev/test용 로컬 알림 발송 액션 추가
    - 선행. T005, T006 · 예상. 1h
- [ ] **T008** 권한 거부 UI 처리
    - 선행. T005 · 예상. 1h
- [ ] **T009** Android emulator/device 수동 확인 절차 문서화
    - 선행. T007 · 예상. 0.5h
- [ ] **T010** `flutter analyze`, `flutter test` 실행
    - 선행. T008 · 예상. 0.5h

## 아키텍처 다이어그램

```
Flutter UI
  └─ NotificationService
       ├─ permission status/request
       ├─ Android notification channel
       └─ local notification show()
```

## 테스트 매트릭스

| #   | 케이스 | 입력 | 기대 결과 |
| --- | ------ | ---- | --------- |
| 1   | 권한 허용 | 권한 요청 승인 | 테스트 알림 표시 |
| 2   | 권한 거부 | 권한 요청 거부 | 거부 안내 UI |
| 3   | 채널 재생성 | 앱 재시작 | 중복 오류 없이 channel 유지 |
