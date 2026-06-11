# Progress: Latest Station Data Update

## 현재 단계

구현 완료

## 기능별 진행 현황

| 기능 | 단계 | 상태       |
| ---- | ---- | ---------- |
| 원본 데이터 모델 | 구현 | ✅ 완료 |
| 갱신 스크립트 | 구현 | ✅ 완료 |
| 코드 생성 | 구현 | ✅ 완료 |
| 검증 | 구현 | ✅ 완료 |

## 블로커 / 이슈 / 특이사항

- 서울 열린데이터광장 갱신 결과 655개 역을 생성했다.
- 노선 alias 누락 경고는 `김포도시철도`, `우이신설경전철`, `GTX-A` 매핑 추가로 해소했다.

## 구현 태스크

| ID | 내용 | 상태 |
| --- | --- | --- |
| T001 | `data/stations.json` 스키마 정의 | ✅ 완료 |
| T002 | 서울 열린데이터광장 응답 필드와 내부 station 필드 매핑 정의 | ✅ 완료 |
| T003 | 환승역 병합과 line 정렬 규칙 정의 | ✅ 완료 |
| T004 | `.env.example`에 `SEOUL_OPEN_DATA_API_KEY` 예시 추가 | ✅ 완료 |
| T005 | 루트 실행용 `scripts/update-stations.mjs` 추가 | ✅ 완료 |
| T006 | 루트 `.env`에서 `SEOUL_OPEN_DATA_API_KEY` 로드 | ✅ 완료 |
| T007 | 서울 열린데이터광장 `서울교통공사_노선별 지하철역 정보` 호출 구현 | ✅ 완료 |
| T008 | 응답 파싱, 필수 필드 검증, API 실패 처리 구현 | ✅ 완료 |
| T009 | 정규화 결과를 `data/stations.json`에 안정적인 순서로 쓰기 | ✅ 완료 |
| T010 | 루트 `package.json`에 `update:stations` script 추가 | ✅ 완료 |
| T011 | `data/stations.json`에서 `apps/api/src/stations/stations.data.ts` 생성 | ✅ 완료 |
| T012 | `data/stations.json`에서 `apps/mobile/lib/data/stations.dart` 생성 | ✅ 완료 |
| T013 | 생성 파일의 한국어 헤더 주석과 문자열 escape 처리 | ✅ 완료 |
| T014 | line color 누락 경고 또는 검증 추가 | ✅ 완료 |
| T015 | 갱신 스크립트 단위 테스트 또는 fixture 기반 검증 추가 | ✅ 완료 |
| T016 | 생성된 API station 데이터와 모바일 station 데이터 일관성 검증 | ✅ 완료 |
| T017 | `npm run update:stations` 실행 후 diff 검토 | ✅ 완료 |
| T018 | `npm run api:test`, `flutter test apps/mobile` 실행 | ✅ 완료 |
| T019 | 기능 문서에 실제 명령과 주의사항 갱신 | ✅ 완료 |

## 최근 업데이트

2026-06-06

## 다음 액션 아이템

| 담당 | 내용                        | 기한 |
| ---- | --------------------------- | ---- |
| Codex | `$feature-verify latest-station-data-update` 실행 |      |
