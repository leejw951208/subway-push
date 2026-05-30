-- 초기 사용자와 알림 테이블을 생성한다.
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "Alert" (
    "id" SERIAL NOT NULL,
    "stationName" TEXT NOT NULL,
    "description" TEXT,
    "lines" TEXT[] NOT NULL,
    "push" BOOLEAN NOT NULL DEFAULT true,
    "vibration" BOOLEAN NOT NULL DEFAULT true,
    "voice" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "ownerId" INTEGER,

    CONSTRAINT "Alert_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "User_email_key" ON "User"("email");
CREATE INDEX "Alert_stationName_idx" ON "Alert"("stationName");

ALTER TABLE "Alert" ADD CONSTRAINT "Alert_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
