# Spec. Mobile API Client

> 한 줄 요약. Flutter 앱이 NestJS API에서 역/알림 데이터를 읽고 쓸 수 있게 한다.

## 배경

현재 Flutter 앱은 정적 역 데이터와 메모리 알림 상태만 사용한다. 서버 API가 준비되더라도 앱에 API client 계층이 없으면 실제 연동이 불가능하다.

이 기능은 UI가 HTTP 구현 세부사항을 직접 알지 않도록 API client/repository 계층을 추가한다. Android emulator의 localhost 접근 방식도 함께 정리해야 한다.

## 기능 목록

### API client 계층

Flutter 앱에서 stations와 alerts API를 호출하는 클라이언트 계층을 만든다.

**동작 방식**

- base URL을 환경별로 설정한다.
- `GET /stations`로 역 목록을 조회한다.
- `/alerts` CRUD API를 호출한다.
- API 실패 시 UI에 최소한의 실패 상태를 표시한다.

**포함 범위**

- HTTP client dependency
- API base URL 설정
- stations 조회
- alerts CRUD 호출
- 로딩/에러 상태

**제외 범위**

- 인증 토큰. 아직 인증 API가 없다.
- 오프라인 동기화. 로컬 저장과 별도 기능이다.
- 백그라운드 작업. 도착 알림 엔진에서 다룬다.

## 입출력

**입력**

- API base URL. Android emulator에서는 `http://10.0.2.2:3000`.
- stations/alerts API 요청 payload.

**출력**

- `List<Station>`.
- `List<SubwayAlert>` 또는 API alert DTO.
- loading/error/data 상태.

## 제약 조건

- API 미실행 상태에서도 앱이 크래시하면 안 된다.
- UI는 HTTP client 구현체에 직접 의존하지 않아야 한다.
- 서버와 모바일 DTO 필드명이 일치해야 한다.

## 예외 케이스

- 서버 연결 실패 → 에러 상태와 재시도 가능 UI.
- JSON 파싱 실패 → 에러 상태.
- API 4xx/5xx → 실패 메시지 또는 fallback 상태.

## 채택 근거

**핵심 이유**

- 실제 서비스 기능으로 넘어가려면 클라이언트-서버 연결이 필요하다.

**보조 이유**

- repository 경계를 두면 로컬 저장과 서버 동기화를 조합하기 쉽다.
- Android emulator base URL 이슈를 초기에 고정할 수 있다.

**기각된 대안**

- 화면에서 직접 HTTP 호출. 테스트와 유지보수가 나빠진다.
- GraphQL 도입. 현재 CRUD 요구에는 REST가 단순하다.

## 비기능 요건

**성능**

- 홈 초기 API 호출은 로딩 표시와 함께 수행하고 UI thread를 막지 않는다.

**보안**

- 위협 모델. 개발용 HTTP 통신이며 인증 정보는 포함하지 않는다.
- 운영 환경에서는 HTTPS base URL로 전환 가능해야 한다.

**확장성**

- 인증/재시도/cache가 필요해지면 API client 내부에서 확장한다.

## 용어 정의

- **API client.** HTTP 요청/응답 변환을 담당하는 계층.
- **Repository.** UI/상태관리에서 사용하는 데이터 접근 추상화.
