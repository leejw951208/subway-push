# Spec. API Alerts

> 한 줄 요약. 사용자의 역 알림 설정을 NestJS API와 Prisma로 CRUD할 수 있게 한다.

## 배경

현재 알림 설정은 Flutter 앱 메모리 상태에만 존재한다. 서버 저장소가 없으면 기기 간 동기화, 장기 보관, 향후 푸시 발송을 구현할 수 없다.

이 기능은 실제 푸시 발송이 아니라 알림 설정 데이터를 서버에 저장하고 수정하는 API 계약을 만든다. 인증은 아직 없으므로 초기 구현은 단일 개발 사용자 또는 임시 owner-less alert 모델로 시작한다.

## 기능 목록

### 알림 CRUD API

클라이언트가 알림 설정을 생성, 조회, 수정, 삭제한다.

**동작 방식**

- `GET /alerts`는 저장된 알림 목록을 반환한다.
- `POST /alerts`는 station과 알림 방식을 저장한다.
- `PATCH /alerts/:id`는 알림 방식을 수정한다.
- `DELETE /alerts/:id`는 알림을 삭제한다.

**포함 범위**

- alerts controller/service/dto
- Prisma model 정리
- push/vibration/voice 필드
- API test

**제외 범위**

- 인증. 사용자 계정 기능이 없다.
- 실제 푸시 발송. 이 기능은 설정 저장만 다룬다.
- 위치 기반 도착 판정. 별도 엔진에서 처리한다.

## 입출력

**입력**

- `stationName`. 문자열. 알림 대상 역.
- `lines`. 문자열 배열. 표시용 노선 정보.
- `push`, `vibration`, `voice`. boolean.

**출력**

- `Alert`. `{ id, stationName, lines, push, vibration, voice, createdAt, updatedAt }`.
- 목록 조회 시 `Alert[]`.

## 제약 조건

- 최소 하나 이상의 알림 방식이 true여야 한다.
- 같은 stationName에 대한 중복 정책을 결정해야 한다. 초기 정책은 upsert 또는 중복 허용 중 하나로 명시한다.
- Prisma schema와 DTO가 일치해야 한다.

## 예외 케이스

- 모든 알림 방식 false → 400 응답.
- 없는 id 수정/삭제 → 404 응답.
- stationName 누락 → 400 응답.

## 채택 근거

**핵심 이유**

- API 기반 앱으로 확장하려면 알림 설정의 서버 CRUD가 필요하다.

**보조 이유**

- 모바일 API client 기능의 핵심 의존성이다.
- 향후 사용자/디바이스/푸시 발송 모델의 기반이 된다.

**기각된 대안**

- 로컬 저장만 유지. 서버 기반 확장이 어렵다.
- 인증 먼저 구현. 현재 제품 검증에는 알림 도메인 API가 더 직접적이다.

## 비기능 요건

**성능**

- 알림 목록은 개발/초기 사용자 규모에서 100ms 이내 응답을 목표로 한다.

**보안**

- 위협 모델. 인증 전에는 개인화된 운영 데이터로 사용하지 않는다.
- 입력 DTO validation으로 잘못된 payload를 거부한다.

**확장성**

- 사용자 인증이 도입되면 `ownerId` 또는 `deviceId` 기준으로 scope를 제한한다.

## 용어 정의

- **Alert.** 사용자가 특정 역에 대해 설정한 알림 방식 조합.
- **DTO.** API 요청/응답 경계의 데이터 형식.
