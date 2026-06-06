// 알림 API 요청 본문을 검증 가능한 데이터로 변환한다.
export type AlertDto = {
    id: number
    stationName: string
    description: string | null
    lines: string[]
    timing: string
    push: boolean
    vibration: boolean
    voice: boolean
    createdAt: Date
    updatedAt: Date
}

export type AlertBody = {
    stationName?: unknown
    description?: unknown
    lines?: unknown
    timing?: unknown
    push?: unknown
    vibration?: unknown
    voice?: unknown
}

export function parseAlertBody(body: AlertBody) {
    const stationName =
        typeof body.stationName === "string" ? body.stationName.trim() : ""
    const lines = Array.isArray(body.lines)
        ? body.lines.filter((line): line is string => typeof line === "string")
        : []
    const push = typeof body.push === "boolean" ? body.push : true
    const vibration =
        typeof body.vibration === "boolean" ? body.vibration : true
    const voice = typeof body.voice === "boolean" ? body.voice : false
    const timing =
        typeof body.timing === "string" ? body.timing.trim() : "on_arrival"
    const description =
        typeof body.description === "string" ? body.description : null

    if (!stationName) {
        throw new Error("stationName is required")
    }

    if (!push && !vibration && !voice) {
        throw new Error("At least one alert method must be enabled")
    }

    return {
        stationName,
        description,
        lines,
        timing,
        push,
        vibration,
        voice,
    }
}
