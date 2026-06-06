-- 알림 시점 필드를 저장한다.
ALTER TABLE "Alert" ADD COLUMN "timing" TEXT NOT NULL DEFAULT 'on_arrival';
