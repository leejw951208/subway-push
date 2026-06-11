# Plan. Latest Station Data Update

## 단계 구성

| Phase | 이름        | 목표                                   |
| ----- | ----------- | -------------------------------------- |
| P1    | 원본 데이터 모델 | 서울 열린데이터광장 응답을 저장할 단일 JSON 스키마와 검증 규칙을 정한다 |
| P2    | 갱신 스크립트 | 서울 열린데이터광장에서 역 데이터를 가져와 JSON 원본을 갱신한다 |
| P3    | 코드 생성 | JSON 원본에서 API TypeScript와 모바일 Dart 데이터를 생성한다 |
| P4    | 검증 | 생성 결과와 기존 API, 모바일 테스트를 검증한다 |

## 구현 태스크

### P1. 원본 데이터 모델

- [ ] **T001** `data/stations.json` 스키마 정의
    - 선행. 없음 · 예상. 0.5h
- [ ] **T002** 서울 열린데이터광장 응답 필드와 내부 station 필드 매핑 정의
    - 선행. T001 · 예상. 1h
- [ ] **T003** 환승역 병합과 line 정렬 규칙 정의
    - 선행. T002 · 예상. 1h
- [ ] **T004** `.env.example`에 `SEOUL_OPEN_DATA_API_KEY` 예시 추가
    - 선행. 없음 · 예상. 0.5h

### P2. 갱신 스크립트

- [ ] **T005** 루트 실행용 `scripts/update-stations.mjs` 추가
    - 선행. T001, T004 · 예상. 1h
- [ ] **T006** 루트 `.env`에서 `SEOUL_OPEN_DATA_API_KEY` 로드
    - 선행. T005 · 예상. 0.5h
- [ ] **T007** 서울 열린데이터광장 `서울교통공사_노선별 지하철역 정보` 호출 구현
    - 선행. T006 · 예상. 1.5h
- [ ] **T008** 응답 파싱, 필수 필드 검증, API 실패 처리 구현
    - 선행. T007 · 예상. 1.5h
- [ ] **T009** 정규화 결과를 `data/stations.json`에 안정적인 순서로 쓰기
    - 선행. T008 · 예상. 1h
- [ ] **T010** 루트 `package.json`에 `update:stations` script 추가
    - 선행. T005 · 예상. 0.5h

### P3. 코드 생성

- [ ] **T011** `data/stations.json`에서 `apps/api/src/stations/stations.data.ts` 생성
    - 선행. T009 · 예상. 1h
- [ ] **T012** `data/stations.json`에서 `apps/mobile/lib/data/stations.dart` 생성
    - 선행. T009 · 예상. 1h
- [ ] **T013** 생성 파일의 한국어 헤더 주석과 문자열 escape 처리
    - 선행. T011, T012 · 예상. 0.5h
- [ ] **T014** line color 누락 경고 또는 검증 추가
    - 선행. T011, T012 · 예상. 0.5h

### P4. 검증

- [ ] **T015** 갱신 스크립트 단위 테스트 또는 fixture 기반 검증 추가
    - 선행. T008, T009 · 예상. 1.5h
- [ ] **T016** 생성된 API station 데이터와 모바일 station 데이터가 같은 역명과 노선 목록을 갖는지 검증
    - 선행. T011, T012 · 예상. 1h
- [ ] **T017** `npm run update:stations` 실행 후 diff 검토
    - 선행. T010, T014 · 예상. 0.5h
- [ ] **T018** `npm run api:test`, `flutter test apps/mobile` 실행
    - 선행. T015, T016, T017 · 예상. 0.5h
- [ ] **T019** 기능 문서에 실제 명령과 주의사항 갱신
    - 선행. T010, T018 · 예상. 0.5h

## 아키텍처 다이어그램

```
npm run update:stations
  └─ scripts/update-stations.mjs
       ├─ .env SEOUL_OPEN_DATA_API_KEY
       ├─ 서울 열린데이터광장
       │    └─ 서울교통공사_노선별 지하철역 정보
       ├─ normalize / merge / sort
       ├─ data/stations.json
       ├─ apps/api/src/stations/stations.data.ts
       └─ apps/mobile/lib/data/stations.dart
```

## 테스트 매트릭스

| #   | 케이스 | 입력 | 기대 결과 |
| --- | ------ | ---- | --------- |
| 1   | 정상 갱신 | 유효한 `SEOUL_OPEN_DATA_API_KEY`와 정상 API 응답 | `data/stations.json`, TS, Dart 파일 생성 |
| 2   | 인증키 없음 | `.env`에 키 없음 | 명확한 오류 메시지와 non-zero exit |
| 3   | API 실패 | 4xx, 5xx, 네트워크 실패 | 기존 생성 파일을 덮어쓰지 않고 실패 |
| 4   | 응답 형식 변경 | 필수 필드 누락 fixture | 파싱 실패와 누락 필드 출력 |
| 5   | 환승역 병합 | 같은 역명 여러 호선 응답 | 하나의 station 항목에 line 목록 병합 |
| 6   | 생성물 일관성 | `data/stations.json` | API와 모바일 데이터의 역명, 노선 목록 일치 |
