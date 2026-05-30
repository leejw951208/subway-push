// 지하철 역 목록 API 엔드포인트를 제공한다.
import { Controller, Get, Query } from "@nestjs/common"
import { StationsService } from "./stations.service.js"

@Controller("stations")
export class StationsController {
    constructor(private readonly stationsService: StationsService) {}

    @Get()
    findAll(@Query("query") query?: string) {
        return this.stationsService.findAll(query)
    }
}
