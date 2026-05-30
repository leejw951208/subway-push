# Review: api-alerts

## 리뷰 개요

- 일자: 2026-05-30
- Spec: docs/features/api-alerts/spec.md
- Plan: docs/features/api-alerts/plan.md

---

## 1. Spec 일치 여부

| 처리상태 | 심각도 | 판정 | #   | 요구사항 | 근거 | 보강 지시 |
| -------- | ------ | ---- | --- | -------- | ---- | --------- |
| CLOSED | - | DONE | S001 | `GET /alerts`는 저장된 알림 목록을 반환한다. | `AlertsController.findAll()`과 `AlertsService.findAll()`이 구현되어 있다. apps/api/src/alerts/alerts.controller.ts:18, apps/api/src/alerts/alerts.service.ts:14 | - |
| CLOSED | - | DONE | S002 | `POST /alerts`는 station과 알림 방식을 저장한다. | controller create와 service create가 body를 parse 후 Prisma create에 전달한다. apps/api/src/alerts/alerts.controller.ts:23, apps/api/src/alerts/alerts.service.ts:18 | - |
| CLOSED | - | DONE | S003 | `PATCH /alerts/:id`, `DELETE /alerts/:id`를 제공한다. | controller/service에 update/remove가 구현되어 있다. apps/api/src/alerts/alerts.controller.ts:28, apps/api/src/alerts/alerts.service.ts:23 | - |
| CLOSED | - | DONE | S004 | 최소 하나 이상의 알림 방식이 true여야 한다. | `parseAlertBody()`가 push/vibration/voice가 모두 false면 Error를 던지고 service가 400으로 변환한다. apps/api/src/alerts/alerts.dto.ts:40, apps/api/src/alerts/alerts.service.ts:49 | - |
| CLOSED | - | DONE | S005 | 없는 id 수정/삭제는 404를 반환한다. | `ensureExists()`가 `findUnique` 실패 시 `NotFoundException`을 던진다. apps/api/src/alerts/alerts.service.ts:38 | - |
| CLOSED | - | CHANGED | S006 | 같은 stationName 중복 정책은 명시해야 한다. | 구현은 Prisma unique 제약을 두지 않고 중복 허용 정책으로 동작한다. schema에 stationName index만 있고 unique가 아니다. apps/api/prisma/schema.prisma:19 | - |

**요약:** DONE 5 / PARTIAL 0 / NOT DONE 0 / CHANGED 1

---

## 2. Plan 일치 여부

| 처리상태 | 심각도 | 판정 | 태스크 | 근거 | 보강 지시 |
| -------- | ------ | ---- | ------ | ---- | --------- |
| CLOSED | - | DONE | T001-T003 | Prisma `Alert` 모델, DTO/parser, validation이 구현되어 있다. apps/api/prisma/schema.prisma:19, apps/api/src/alerts/alerts.dto.ts:23 | - |
| CLOSED | - | DONE | T004-T007 | service/controller CRUD와 `AppModule` 등록이 완료되어 있다. apps/api/src/alerts/alerts.service.ts:10, apps/api/src/alerts/alerts.controller.ts:14, apps/api/src/app.module.ts:10 | - |
| CLOSED | - | DONE | T008-T010 | service/controller/parser tests가 있고 API build/test가 통과했다. apps/api/src/alerts/alerts.service.spec.ts:20, apps/api/src/alerts/alerts.controller.spec.ts:45 | - |

**스코프 이탈:** 없음

---

## 3. 테스트 커버리지

| 처리상태 | 심각도 | 판정 | 요구사항 | 테스트 | 보강 지시 |
| -------- | ------ | ---- | -------- | ------ | --------- |
| CLOSED | - | TESTED | DTO validation | `parseAlertBody` 테스트가 정상 payload, stationName 누락, 모든 방식 false를 검증한다. apps/api/src/alerts/alerts.dto.spec.ts:5 | - |
| CLOSED | - | TESTED | service create/invalid/missing update | `AlertsService` 테스트가 Prisma create, BadRequest, NotFound를 검증한다. apps/api/src/alerts/alerts.service.spec.ts:20 | - |
| CLOSED | - | TESTED | controller CRUD 위임 | `AlertsController` 테스트가 list/create/update/remove를 검증한다. apps/api/src/alerts/alerts.controller.spec.ts:45 | - |
| CLOSED | - | TESTED | 실제 API route | curl로 POST, GET, PATCH, invalid POST 400, missing PATCH 404를 확인했다. | - |

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

- `rtk npm run api:build` 통과.
- `rtk npm run api:test` 통과. 6 suites, 15 tests passed.
- 로컬 API 서버 `PORT=3100 npm run api:start` 후 `/alerts` CRUD와 예외 응답을 curl로 확인했다.

---

## 6. 보안 감사

- 인증 제외 범위에 맞게 owner-less alert 모델로 구현되어 있다.
- 입력 검증은 `parseAlertBody()`에서 수행되고 잘못된 payload는 400으로 변환된다.
