# 프로젝트 개요

## 요약

Subway Push는 Flutter 모바일 앱과 Prisma, PostgreSQL 기반 NestJS API로 구성된 모노레포다. 사용자가 선택한 지하철역에 대해 도착 알림을 설정하고, push, vibration, voice 같은 알림 옵션을 관리하는 제품이다.

## 목표

사용자가 역 기반 지하철 알림을 설정하고, 향후 도착 판정과 백엔드 기반 알림 관리로 확장할 수 있는 앱을 만든다.

## 현재 상태

개발 중이다.

저장소에는 Flutter 앱, NestJS API, Prisma 스키마와 마이그레이션, 로컬 PostgreSQL Docker 설정, API 클라이언트, 로컬 알림 저장소, 상태 관리, 알림 권한 처리, 도착 알림 엔진이 있다. `docs/features/` 아래 여러 기능 기록은 `verified` 상태다.

## 핵심 기능

- Flutter 앱에서 지하철역을 검색하고 선택한다.
- 역 알림 설정을 추가, 수정, 삭제한다.
- 로컬 저장소에 알림 설정을 저장한다.
- NestJS API 클라이언트 경로로 역과 알림 데이터를 조회한다.
- `GET /stations`로 역 데이터를 제공한다.
- `GET /alerts`, `POST /alerts`, `PATCH /alerts/:id`, `DELETE /alerts/:id`로 알림 CRUD를 제공한다.
- 알림 권한을 요청하고 로컬 테스트 알림을 보낸다.
- 도착 알림 엔진으로 알림 발생 조건을 평가한다.

## 제외 범위

- 사용자 인증은 현재 범위가 아니다.
- 운영 배포 절차는 아직 문서화되지 않았다.
- 외부 실시간 지하철 API 연동은 구현되지 않았다.
- 장시간 백그라운드 위치 정책은 확정되지 않았다.

## 중요한 맥락

- 루트 npm workspace는 `apps/api`를 포함한다.
- 루트 Dart workspace는 `apps/mobile`을 포함한다.
- API는 TypeScript ESM 기반 NestJS 11을 사용한다.
- Prisma Client 출력 경로는 `apps/api/src/generated/prisma`다.
- 로컬 PostgreSQL은 로컬 설치 DB와 충돌을 피하기 위해 호스트 포트 `5433`을 사용한다.

## 근거 자료

- `../../../README.md`
- `../../../package.json`
- `../../../pubspec.yaml`
- `../../../apps/api/package.json`
- `../../../apps/api/prisma/schema.prisma`
- `../../../apps/mobile/pubspec.yaml`
- `../../features/README.md`

## 마지막 검토일

2026-06-06
