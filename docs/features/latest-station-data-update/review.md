# Review: latest-station-data-update

## 리뷰 개요

- 일자: 2026-06-06
- Spec: docs/features/latest-station-data-update/spec.md
- Plan: docs/features/latest-station-data-update/plan.md

---

## 1. Spec 일치 여부

| 처리상태 | 심각도 | 판정 | #   | 요구사항 | 근거 | 보강 지시 |
| -------- | ------ | ---- | --- | -------- | ---- | --------- |
| CLOSED | - | DONE | S001 | 서울 열린데이터광장 `서울교통공사_노선별 지하철역 정보`에서 역 데이터를 가져온다. | `scripts/station-data.mjs:2`, `scripts/station-data.mjs:127`, `scripts/update-stations.mjs:68` | - |
| CLOSED | - | DONE | S002 | 루트 `.env`의 `SEOUL_OPEN_DATA_API_KEY`를 읽고 키가 없으면 실패한다. | `scripts/update-stations.mjs:18`, `scripts/update-stations.mjs:21`, `scripts/station-data.mjs:101`, `.env.example:3` | - |
| CLOSED | - | DONE | S003 | 응답을 파싱하고 실패 응답이나 필수 필드 누락을 명확히 처리한다. | `scripts/station-data.mjs:131`, `scripts/station-data.mjs:139`, `scripts/station-data.mjs:285`, `scripts/station-data.test.mjs:74` | - |
| CLOSED | - | DONE | S004 | 역명, 호선, 외부 역 코드, 전철역 코드, 다국어 역명을 단일 JSON 원본에 보존한다. | `scripts/station-data.mjs:174`, `data/stations.json:1` | - |
| CLOSED | - | DONE | S005 | 환승역을 역명 기준으로 병합하고 line 목록을 안정적으로 정렬한다. | `scripts/station-data.mjs:156`, `scripts/station-data.mjs:170`, `scripts/station-data.mjs:187`, `scripts/station-data.test.mjs:87` | - |
| CLOSED | - | DONE | S006 | `data/stations.json`을 기준으로 API TypeScript 파일을 생성한다. | `scripts/station-data.mjs:215`, `scripts/update-stations.mjs:37`, `apps/api/src/stations/stations.data.ts:1` | - |
| CLOSED | - | DONE | S007 | `data/stations.json`을 기준으로 모바일 Dart 파일을 생성한다. | `scripts/station-data.mjs:243`, `scripts/update-stations.mjs:41`, `apps/mobile/lib/data/stations.dart:1` | - |
| CLOSED | - | DONE | S008 | line color 누락을 검증하고 누락 시 경고한다. | `scripts/station-data.mjs:273`, `scripts/update-stations.mjs:27` | - |
| CLOSED | - | DONE | S009 | 갱신 명령과 검증 명령을 문서화한다. | `package.json:15`, `package.json:16`, `docs/wiki/wiki/runbook.md:91` | - |

**요약:** DONE 9 / PARTIAL 0 / NOT DONE 0 / CHANGED 0

---

## 2. Plan 일치 여부

| 처리상태 | 심각도 | 판정 | 태스크 | 근거 | 보강 지시 |
| -------- | ------ | ---- | ------ | ---- | --------- |
| CLOSED | - | DONE | T001 | `data/stations.json:1` | - |
| CLOSED | - | DONE | T002 | `scripts/station-data.mjs:174`, `scripts/station-data.mjs:204` | - |
| CLOSED | - | DONE | T003 | `scripts/station-data.mjs:58`, `scripts/station-data.mjs:187`, `scripts/station-data.mjs:301` | - |
| CLOSED | - | DONE | T004 | `.env.example:3` | - |
| CLOSED | - | DONE | T005 | `scripts/update-stations.mjs:1` | - |
| CLOSED | - | DONE | T006 | `scripts/update-stations.mjs:19`, `scripts/station-data.mjs:101` | - |
| CLOSED | - | DONE | T007 | `scripts/update-stations.mjs:68`, `scripts/station-data.mjs:127` | - |
| CLOSED | - | DONE | T008 | `scripts/station-data.mjs:131`, `scripts/station-data.mjs:139`, `scripts/update-stations.mjs:71` | - |
| CLOSED | - | DONE | T009 | `scripts/update-stations.mjs:32`, `data/stations.json:1` | - |
| CLOSED | - | DONE | T010 | `package.json:15` | - |
| CLOSED | - | DONE | T011 | `scripts/station-data.mjs:215`, `apps/api/src/stations/stations.data.ts:1` | - |
| CLOSED | - | DONE | T012 | `scripts/station-data.mjs:243`, `apps/mobile/lib/data/stations.dart:1` | - |
| CLOSED | - | DONE | T013 | `scripts/station-data.mjs:226`, `scripts/station-data.mjs:254`, `scripts/station-data.mjs:327` | - |
| CLOSED | - | DONE | T014 | `scripts/station-data.mjs:273`, `scripts/update-stations.mjs:27` | - |
| CLOSED | - | DONE | T015 | `scripts/station-data.test.mjs:44`, `scripts/station-data.test.mjs:59`, `scripts/station-data.test.mjs:87` | - |
| CLOSED | - | DONE | T016 | `scripts/station-data.test.mjs:120`, `scripts/station-data.test.mjs:130`, `npm run test:stations` 통과 | - |
| CLOSED | - | DONE | T017 | `npm run update:stations` 실행 결과 655개 역 생성 | - |
| CLOSED | - | DONE | T018 | `npm run api:test`, `flutter test apps/mobile` 통과 | - |
| CLOSED | - | DONE | T019 | `docs/wiki/wiki/runbook.md:91`, `docs/wiki/wiki/runbook.md:105` | - |

**스코프 이탈:** 없음

---

## 3. 테스트 커버리지

| 처리상태 | 심각도 | 판정 | 요구사항 | 테스트 | 보강 지시 |
| -------- | ------ | ---- | -------- | ------ | --------- |
| CLOSED | - | TESTED | `.env` 인증키 파싱 | `scripts/station-data.test.mjs:44`, `npm run test:stations` 통과 | - |
| CLOSED | - | TESTED | 서울 열린데이터광장 URL 생성 | `scripts/station-data.test.mjs:50`, `npm run test:stations` 통과 | - |
| CLOSED | - | TESTED | 응답 파싱과 오류 응답 처리 | `scripts/station-data.test.mjs:59`, `scripts/station-data.test.mjs:74`, `npm run test:stations` 통과 | - |
| CLOSED | - | TESTED | 환승역 병합과 호선 정규화 | `scripts/station-data.test.mjs:87`, `npm run test:stations` 통과 | - |
| CLOSED | - | TESTED | API TypeScript 생성 | `scripts/station-data.test.mjs:120`, `npm run test:stations` 통과 | - |
| CLOSED | - | TESTED | 모바일 Dart 생성 | `scripts/station-data.test.mjs:130`, `npm run test:stations` 통과 | - |
| CLOSED | - | TESTED | API station 조회 회귀 | `npm run api:test` 통과. 6 suites, 15 tests | - |
| CLOSED | - | TESTED | 모바일 station 데이터 사용 회귀 | `flutter test apps/mobile` 통과. 18 tests | - |

**미테스트:** 0건

---

## 4. 발견 항목

| 처리상태 | 심각도 | 신뢰도 | 분류 | 위치 | 내용 | 보강 지시 |
| -------- | ------ | ------ | ---- | ---- | ---- | --------- |

### Appendix (confidence 5 미만)

| 처리상태 | 심각도 | 신뢰도 | 분류 | 위치 | 내용 | 보강 지시 |
| -------- | ------ | ------ | ---- | ---- | ---- | --------- |

---

## 5. 기능 검증

- `npm run update:stations` 실행 결과 `data/stations.json`, `apps/api/src/stations/stations.data.ts`, `apps/mobile/lib/data/stations.dart`가 생성됐다.
- 생성된 역 수는 655개다.
- `강남` 역은 `2`, `신분당` 노선으로 병합되어 생성됐다.
- `GTX-A` 색상 키가 `data/stations.json`에 포함되어 노선 색상 누락 경고 없이 갱신된다.
- `npm run test:stations` 통과. 7 tests.
- `npm run api:test` 통과. 6 suites, 15 tests.
- `flutter test apps/mobile` 통과. 18 tests.

---

## 6. 보안 감사

- 실제 `SEOUL_OPEN_DATA_API_KEY` 값은 git 추적 대상에서 발견되지 않았다. 검색 결과는 `scripts/station-data.test.mjs:45`의 더미 값 `abc123`뿐이다.
- 인증키는 루트 `.env`에서 읽고 `.env.example`에는 빈 키만 기록된다. 근거는 `scripts/update-stations.mjs:19`, `.env.example:3`이다.
- 서울 열린데이터광장 endpoint는 공식 샘플과 동일한 `http://openapi.seoul.go.kr:8088` 형태를 사용한다. HTTPS 접속은 검증 중 실패했으므로 현재 구현은 공식 endpoint 제약을 따른다.
- 외부 응답 문자열은 `JSON.stringify`와 Dart 문자열 escape를 거쳐 생성 파일에 삽입된다. 근거는 `scripts/station-data.mjs:315`, `scripts/station-data.mjs:327`이다.
