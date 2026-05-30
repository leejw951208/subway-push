# Progress. Arrival Alert Engine

## 현재 단계

구현

## 상태

✅ 완료

## 완료 항목

- 위치 값 객체, 역 좌표 모델, 알림 이벤트 모델을 추가했다.
- Haversine 거리 계산과 도착 임계값 정책을 구현했다.
- 역 반경 진입 시 알림 이벤트를 한 번만 발생시키는 중복 방지 상태를 추가했다.
- 현재 알림 설정 모델의 push/vibration/voice 옵션을 엔진 이벤트로 매핑했다.
- 도메인 단위 테스트를 추가했다.
- 현재 위치 또는 역 좌표가 없을 때 이벤트가 발생하지 않는 테스트를 추가했다.

## 검증

- 2026-05-30 `rtk mise exec -- flutter analyze`.
- 2026-05-30 `rtk mise exec -- flutter test`.
- 2026-05-30 보강 후 `rtk mise exec -- flutter analyze`, `rtk mise exec -- flutter test`.

## 최근 업데이트

2026-05-30
