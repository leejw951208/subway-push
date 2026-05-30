# Plan. PostgreSQL Docker Prisma Migrations

## 단계 구성

| Phase | 이름        | 목표                                   |
| ----- | ----------- | -------------------------------------- |
| P1    | Compose     | 로컬 PostgreSQL 실행 환경 제공        |
| P2    | Migration   | Prisma schema를 DB migration으로 고정 |
| P3    | 문서/검증   | README와 명령 검증 완료               |

## 구현 태스크

### P1. Compose

- [ ] **T001** `docker-compose.yml` 추가
    - 선행. 없음 · 예상. 0.5h
- [ ] **T002** Postgres env와 `.env.example` 정합성 확인
    - 선행. T001 · 예상. 0.5h
- [ ] **T003** compose volume/port 정책 결정
    - 선행. T001 · 예상. 0.5h

### P2. Migration

- [ ] **T004** 현재 Prisma schema 검토
    - 선행. 없음 · 예상. 0.5h
- [ ] **T005** `prisma migrate dev`로 첫 migration 생성
    - 선행. T001, T004 · 예상. 1h
- [ ] **T006** Prisma client generate 확인
    - 선행. T005 · 예상. 0.5h

### P3. 문서/검증

- [ ] **T007** README DB setup 섹션 업데이트
    - 선행. T001, T005 · 예상. 1h
- [ ] **T008** `docker compose up -d`, `prisma migrate dev` 검증
    - 선행. T007 · 예상. 1h
- [ ] **T009** `npm run api:build`, `npm run api:test` 실행
    - 선행. T008 · 예상. 0.5h

## 아키텍처 다이어그램

```
docker compose
  └─ postgres: local db
       └─ Prisma migrate
            └─ apps/api PrismaClient
```

## 테스트 매트릭스

| #   | 케이스 | 입력 | 기대 결과 |
| --- | ------ | ---- | --------- |
| 1   | DB 시작 | docker compose up -d | postgres healthy/running |
| 2   | migration 적용 | prisma migrate dev | migration 성공 |
| 3   | schema/client | prisma generate | client 생성 |
