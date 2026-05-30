// 알림 CRUD API 엔드포인트를 제공한다.
import {
    Body,
    Controller,
    Delete,
    Get,
    Param,
    Patch,
    Post,
} from "@nestjs/common"
import { AlertsService } from "./alerts.service.js"
import type { AlertBody } from "./alerts.dto.js"

@Controller("alerts")
export class AlertsController {
    constructor(private readonly alertsService: AlertsService) {}

    @Get()
    findAll() {
        return this.alertsService.findAll()
    }

    @Post()
    create(@Body() body: AlertBody) {
        return this.alertsService.create(body)
    }

    @Patch(":id")
    update(@Param("id") id: string, @Body() body: AlertBody) {
        return this.alertsService.update(Number(id), body)
    }

    @Delete(":id")
    remove(@Param("id") id: string) {
        return this.alertsService.remove(Number(id))
    }
}
