# Spec. PostgreSQL Docker Prisma Migrations

> 한 줄 요약. 개발자가 PostgreSQL과 Prisma migration을 같은 방식으로 재현할 수 있게 한다.

## 배경

Prisma schema와 PrismaService는 있지만 실제 PostgreSQL 실행 환경과 migration 파일은 정리되어 있지 않다. 개발자가 DB를 직접 준비해야 하면 API 기능 구현과 검증이 흔들린다.

Docker Compose와 첫 migration을 제공하면 로컬 개발 환경을 빠르게 맞출 수 있고, API CRUD 기능도 실제 DB 기반으로 검증할 수 있다.

## 기능 목록

### 개발 DB 환경 구성

PostgreSQL Docker Compose와 Prisma migration 실행 절차를 제공한다.

**동작 방식**

- `docker-compose.yml`로 PostgreSQL을 실행한다.
- `.env.example`의 `DATABASE_URL`과 compose 설정을 맞춘다.
- Prisma migration을 생성하고 적용한다.
- README에 DB 실행/초기화 명령을 문서화한다.

**포함 범위**

- Docker Compose Postgres service
- DB env 문서화
- 첫 Prisma migration
- migrate/reset 명령 문서

**제외 범위**

- 운영 배포 인프라. 로컬 개발만 다룬다.
- 백업/모니터링. 운영 단계의 별도 작업이다.

## 입출력

**입력**

- `DATABASE_URL`.
- Docker Compose env: user/password/db/port.

**출력**

- 실행 중인 local PostgreSQL.
- 적용된 Prisma migration.

## 제약 조건

- 기존 npm scripts와 충돌하지 않아야 한다.
- 새 개발자가 README만 보고 실행 가능해야 한다.
- migration은 현재 schema와 일관되어야 한다.

## 예외 케이스

- Docker 미설치 → README에서 설치 필요성을 명시한다.
- 5432 포트 충돌 → 포트 변경 방법을 문서화한다.
- migration 실패 → reset 명령과 로그 확인 경로를 안내한다.

## 채택 근거

**핵심 이유**

- DB 재현성이 없으면 Prisma/API 기능 검증이 불안정하다.

**보조 이유**

- API alerts 구현의 선행 기반이다.
- 온보딩 비용을 줄인다.

**기각된 대안**

- 로컬 설치 PostgreSQL 전제. 개발자 환경 편차가 크다.
- SQLite로 임시 전환. PostgreSQL 대상 schema 검증이 약해진다.

## 비기능 요건

**성능**

- 로컬 DB 시작은 일반 개발 머신에서 수 초 내 완료되어야 한다.

**보안**

- 위협 모델. 로컬 개발 DB이며 기본 credential은 운영에 사용하지 않는다.
- `.env`는 커밋하지 않는다.

**확장성**

- 이후 Redis나 worker가 필요하면 compose service를 추가한다.

## 용어 정의

- **Migration.** Prisma schema 변경을 DB에 적용하는 버전 파일.
- **Docker Compose.** 로컬 서비스 묶음을 실행하는 개발 도구.
