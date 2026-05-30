// 지하철 역 컨트롤러가 서비스 결과를 그대로 반환하는지 검증한다.
import { Test, type TestingModule } from "@nestjs/testing"
import { StationsController } from "./stations.controller.js"
import { StationsService } from "./stations.service.js"

describe("StationsController", () => {
    let controller: StationsController

    beforeEach(async () => {
        const module: TestingModule = await Test.createTestingModule({
            controllers: [StationsController],
            providers: [StationsService],
        }).compile()

        controller = module.get(StationsController)
    })

    it("returns stations from the service", () => {
        const result = controller.findAll("강남")

        expect(result.stations).toEqual(
            expect.arrayContaining([expect.objectContaining({ name: "강남" })]),
        )
        expect(result.lineColors["2"]).toBe("#00A84D")
    })
})
