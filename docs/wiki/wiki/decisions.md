# 결정 기록

## 2026-06-06. 역 데이터는 공식 원천 기반 코드 생성 방식으로 갱신한다

### 상태

채택.

### 맥락

모바일과 API에 정적 역 데이터가 각각 존재하므로, 신규역, 역명 변경, 노선 변경을 놓치거나 두 데이터가 어긋날 수 있다.

### 결정

공식 데이터 원천을 주기적으로 가져와 단일 JSON으로 정규화하고, 그 JSON을 기준으로 API용 TypeScript 데이터와 모바일용 Dart 데이터를 생성한다.

### 이유

완전 수동 관리보다 누락 위험이 작고, 실시간 API를 상시 호출하는 방식보다 안정적이다. 또한 생성 결과를 사람이 diff로 검토할 수 있어 역 데이터 변경이 사용자 경험에 미치는 영향을 통제할 수 있다.

### 영향

- `data/stations.json` 같은 단일 원본 파일을 둔다.
- `apps/api/src/stations/stations.data.ts`와 `apps/mobile/lib/data/stations.dart`는 생성 대상으로 본다.
- 업데이트 스크립트는 수동 실행을 기본으로 한다.
- 생성 후 diff를 검토한 뒤 커밋한다.
- API와 모바일의 역 데이터가 같은 원본에서 파생되도록 관리한다.

### 검토한 대안

- 사람이 정적 파일을 직접 수정한다.
- 서버 DB에 역 테이블을 두고 배치로 갱신한다.
- 실시간 API를 앱이나 API에서 직접 호출한다.

### 근거 자료

- `../raw/notes/2026-06-06-station-data-update-strategy.md`
- `../raw/references/2026-06-06-station-data-sources.md`
- `../../../apps/api/src/stations/stations.data.ts`
- `../../../apps/mobile/lib/data/stations.dart`

## 마지막 검토일

2026-06-06
