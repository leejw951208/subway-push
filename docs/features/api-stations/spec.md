# Spec. API Stations

> 한 줄 요약. Flutter 앱의 정적 역 데이터를 NestJS API에서 조회할 수 있게 한다.

## 배경

현재 역 목록은 Flutter 코드의 정적 데이터로만 존재한다. 모바일 앱과 서버가 같은 역 데이터를 사용하려면 API가 기준 데이터를 제공해야 한다.

초기 단계에서는 외부 공공 API나 DB 저장 없이 정적 데이터 endpoint를 만드는 것이 가장 작고 안정적인 경로다. 이후 실시간 도착 정보나 DB 기반 역 관리가 필요해지면 이 API 계약을 확장할 수 있다.

## 기능 목록

### 역 목록 조회 API

클라이언트가 전체 역 목록 또는 검색어에 맞는 역 목록을 조회한다.

**동작 방식**

- `GET /stations`는 전체 역 목록을 반환한다.
- `GET /stations?query=강남`은 역명에 query가 포함된 항목만 반환한다.
- 응답에는 역명, 설명, 노선 목록, 노선 색상 메타데이터를 포함한다.

**포함 범위**

- stations controller/service
- 정적 station dataset
- query filter
- controller/service test

**제외 범위**

- 외부 지하철 공공 API 연동. 실시간 정보와 별도 문제다.
- DB 저장. 초기 기준 데이터는 코드로 관리한다.
- 실시간 도착 정보. 이 기능은 역 기준 데이터 조회만 제공한다.

## 입출력

**입력**

- `query`. 선택 문자열. 역명 부분검색에 사용.

**출력**

- `Station[]`. `{ name, description, lines }`.
- `lineColors`. `{ [line: string]: hexColor }` 또는 station별 line metadata.

## 제약 조건

- Flutter의 현재 station 데이터와 의미상 동일해야 한다.
- API 응답은 JSON이어야 한다.
- query가 없으면 전체 목록을 반환한다.

## 예외 케이스

- query 결과 없음 → 빈 배열 반환.
- 공백 query → 전체 목록 반환.
- 알 수 없는 query parameter → 무시.

## 채택 근거

**핵심 이유**

- 모바일과 서버가 공유할 역 데이터의 첫 API 계약이 필요하다.

**보조 이유**

- DB 없이 작게 구현 가능하다.
- Flutter API client 기능의 선행 조건이다.

**기각된 대안**

- Flutter 정적 데이터 유지. 서버 연동 단계에서 중복이 커진다.
- DB부터 설계. 현재 데이터는 작고 변경 빈도가 낮다.

## 비기능 요건

**성능**

- 전체 역 목록은 메모리 정적 배열에서 즉시 반환한다.

**보안**

- 위협 모델. 공개 역 데이터만 반환하므로 인증은 요구하지 않는다.
- 사용자 입력 query는 문자열 필터에만 사용하고 DB query로 전달하지 않는다.

**확장성**

- 역 수가 수천 개 이상으로 늘어나면 DB/index 기반 검색으로 교체한다.

## 용어 정의

- **Station.** 역명, 노선 목록, 설명을 가진 기준 데이터.
- **Line color.** 지하철 노선 표시용 hex 색상.
