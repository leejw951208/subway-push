import { Module } from "@nestjs/common"
import { ConfigModule } from "@nestjs/config"
import { AppController } from "./app.controller.js"
import { AppService } from "./app.service.js"
import { AlertsController } from "./alerts/alerts.controller.js"
import { AlertsService } from "./alerts/alerts.service.js"
import { PrismaService } from "./prisma.service.js"
import { StationsController } from "./stations/stations.controller.js"
import { StationsService } from "./stations/stations.service.js"

@Module({
    imports: [ConfigModule.forRoot()],
    controllers: [AppController, StationsController, AlertsController],
    providers: [AppService, PrismaService, StationsService, AlertsService],
})
export class AppModule {}
