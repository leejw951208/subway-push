# Progress. PostgreSQL Docker Prisma Migrations

## 현재 단계

구현

## 상태

✅ 완료

## 완료 항목

- `docker-compose.yml`에 PostgreSQL 17 서비스를 추가했다.
- 로컬 PostgreSQL 충돌을 피하도록 host port를 `5433`으로 설정했다.
- `.env.example`과 `apps/api/.env.example`의 `DATABASE_URL`을 compose 포트와 맞췄다.
- Prisma schema와 첫 migration을 추가했다.
- README에 DB setup 절차를 추가했다.
- Prisma 7.8.0 기준 `@hono/node-server` audit 항목을 확인했으나, npm이 제안하는 자동 수정은 Prisma 6.19.3으로의 강제 downgrade라 이번 보강에서는 적용하지 않았다.

## 검증

- 2026-05-30 `rtk docker compose up -d`.
- 2026-05-30 `rtk docker inspect --format '{{.State.Health.Status}}' subway-push-postgres-1`.
- 2026-05-30 `rtk npm run prisma:migrate`.
- 2026-05-30 `rtk npm run prisma:generate`.
- 2026-05-30 `rtk npm run api:build`.
- 2026-05-30 `rtk npm run api:test`.

## 최근 업데이트

2026-05-30
