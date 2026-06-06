// 알림 컨트롤러가 CRUD 요청을 서비스로 위임하는지 검증한다.
import { Test, type TestingModule } from "@nestjs/testing"
import { jest } from "@jest/globals"
import { AlertsController } from "./alerts.controller.js"
import { AlertsService } from "./alerts.service.js"

describe("AlertsController", () => {
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

    let controller: AlertsController
    let service: {
        findAll: jest.Mock
        create: jest.Mock
        update: jest.Mock
        remove: jest.Mock
    }

    beforeEach(async () => {
        service = {
            findAll: jest.fn().mockReturnValue([alert]),
            create: jest.fn().mockReturnValue(alert),
            update: jest.fn().mockReturnValue(alert),
            remove: jest.fn().mockReturnValue({ deleted: true }),
        }

        const module: TestingModule = await Test.createTestingModule({
            controllers: [AlertsController],
            providers: [{ provide: AlertsService, useValue: service }],
        }).compile()

        controller = module.get(AlertsController)
    })

    it("lists alerts", () => {
        expect(controller.findAll()).toEqual([alert])
        expect(service.findAll).toHaveBeenCalled()
    })

    it("creates alerts", () => {
        const body = { stationName: "잠실", push: true }

        expect(controller.create(body)).toEqual(alert)
        expect(service.create).toHaveBeenCalledWith(body)
    })

    it("updates alerts", () => {
        const body = { stationName: "잠실", voice: true }

        expect(controller.update("1", body)).toEqual(alert)
        expect(service.update).toHaveBeenCalledWith(1, body)
    })

    it("removes alerts", () => {
        expect(controller.remove("1")).toEqual({ deleted: true })
        expect(service.remove).toHaveBeenCalledWith(1)
    })
})
