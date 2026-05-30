// 지하철 역 서비스의 목록 조회와 검색 동작을 검증한다.
import { StationsService } from "./stations.service.js"

describe("StationsService", () => {
    let service: StationsService

    beforeEach(() => {
        service = new StationsService()
    })

    it("returns all stations with line colors", () => {
        const result = service.findAll()

        expect(result.stations.length).toBeGreaterThan(0)
        expect(result.lineColors["2"]).toBe("#00A84D")
    })

    it("filters stations by query", () => {
        const result = service.findAll("강남")

        expect(result.stations).toEqual(
            expect.arrayContaining([expect.objectContaining({ name: "강남" })]),
        )
        expect(
            result.stations.every((station) => station.name.includes("강남")),
        ).toBe(true)
    })

    it("returns an empty list when no station matches", () => {
        expect(service.findAll("없는역").stations).toEqual([])
    })
})
