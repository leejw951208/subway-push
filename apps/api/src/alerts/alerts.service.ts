// 알림 데이터의 생성, 조회, 수정, 삭제를 담당한다.
import {
    BadRequestException,
    Injectable,
    NotFoundException,
} from "@nestjs/common"
import { PrismaService } from "../prisma.service.js"
import { parseAlertBody, type AlertBody } from "./alerts.dto.js"

@Injectable()
export class AlertsService {
    constructor(private readonly prisma: PrismaService) {}

    findAll() {
        return this.prisma.alert.findMany({ orderBy: { createdAt: "desc" } })
    }

    create(body: AlertBody) {
        const data = this.parse(body)
        return this.prisma.alert.create({ data })
    }

    async update(id: number, body: AlertBody) {
        const data = this.parse(body)
        await this.ensureExists(id)
        return this.prisma.alert.update({
            where: { id },
            data,
        })
    }

    async remove(id: number) {
        await this.ensureExists(id)
        await this.prisma.alert.delete({ where: { id } })
        return { deleted: true }
    }

    private async ensureExists(id: number) {
        if (!Number.isInteger(id)) {
            throw new BadRequestException("Invalid alert id")
        }

        const existing = await this.prisma.alert.findUnique({ where: { id } })
        if (!existing) {
            throw new NotFoundException("Alert not found")
        }
    }

    private parse(body: AlertBody) {
        try {
            return parseAlertBody(body)
        } catch (error) {
            if (error instanceof Error) {
                throw new BadRequestException(error.message)
            }
            throw error
        }
    }
}
