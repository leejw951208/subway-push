// 알림 서비스의 Prisma 위임과 예외 처리를 검증한다.
import { BadRequestException, NotFoundException } from "@nestjs/common"
import { jest } from "@jest/globals"
import { AlertsService } from "./alerts.service.js"

const alert = {
    id: 1,
    stationName: "잠실",
    description: "송파구 · 환승역",
    lines: ["2", "8"],
    timing: "two_stations_before",
    push: true,
    vibration: true,
    voice: false,
    ownerId: null,
    createdAt: new Date("2026-01-01T00:00:00.000Z"),
    updatedAt: new Date("2026-01-01T00:00:00.000Z"),
}

describe("AlertsService", () => {
    it("creates an alert through Prisma", async () => {
        const prisma = {
            alert: {
                create: jest.fn().mockResolvedValue(alert),
            },
        }
        const service = new AlertsService(prisma as never)

        await expect(
            service.create({
                stationName: "잠실",
                description: "송파구 · 환승역",
                lines: ["2", "8"],
                timing: "two_stations_before",
                push: true,
            }),
        ).resolves.toEqual(alert)
        expect(prisma.alert.create).toHaveBeenCalledWith({
            data: {
                stationName: "잠실",
                description: "송파구 · 환승역",
                lines: ["2", "8"],
                timing: "two_stations_before",
                push: true,
                vibration: true,
                voice: false,
            },
        })
    })

    it("throws BadRequestException for invalid payloads", () => {
        const service = new AlertsService({ alert: {} } as never)

        expect(() =>
            service.create({
                stationName: "잠실",
                push: false,
                vibration: false,
                voice: false,
            }),
        ).toThrow(BadRequestException)
    })

    it("throws NotFoundException when updating a missing alert", async () => {
        const service = new AlertsService({
            alert: {
                findUnique: jest.fn().mockResolvedValue(null),
            },
        } as never)

        await expect(
            service.update(1, {
                stationName: "잠실",
                push: true,
            }),
        ).rejects.toThrow(NotFoundException)
    })
})
