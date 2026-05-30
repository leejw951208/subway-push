// 알림 요청 본문 파서의 유효성 검사를 검증한다.
import { parseAlertBody } from "./alerts.dto.js"

describe("parseAlertBody", () => {
    it("parses a valid alert payload", () => {
        expect(
            parseAlertBody({
                stationName: "잠실",
                lines: ["2", "8"],
                push: true,
                vibration: false,
                voice: true,
            }),
        ).toEqual({
            stationName: "잠실",
            description: null,
            lines: ["2", "8"],
            push: true,
            vibration: false,
            voice: true,
        })
    })

    it("rejects missing stationName", () => {
        expect(() => parseAlertBody({ push: true })).toThrow(
            "stationName is required",
        )
    })

    it("rejects a payload with all alert methods disabled", () => {
        expect(() =>
            parseAlertBody({
                stationName: "잠실",
                push: false,
                vibration: false,
                voice: false,
            }),
        ).toThrow("At least one alert method must be enabled")
    })
})
