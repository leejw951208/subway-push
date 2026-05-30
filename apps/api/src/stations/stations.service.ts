// 지하철 역 목록 조회와 검색 필터링을 담당한다.
import { Injectable } from "@nestjs/common"
import { lineColors, stations } from "./stations.data.js"

@Injectable()
export class StationsService {
    findAll(query?: string) {
        const normalized = query?.trim()
        const filtered = normalized
            ? stations.filter((station) => station.name.includes(normalized))
            : stations

        return {
            stations: filtered,
            lineColors,
        }
    }
}
