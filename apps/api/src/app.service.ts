import { Injectable } from "@nestjs/common"

@Injectable()
export class AppService {
    getRoot() {
        return {
            name: "subway-push-api",
            status: "ok",
        }
    }

    getHealth() {
        return {
            status: "ok",
            timestamp: new Date().toISOString(),
        }
    }
}
