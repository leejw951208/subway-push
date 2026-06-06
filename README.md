# 내릴때

Monorepo for a Flutter mobile app and a NestJS API backed by Prisma and PostgreSQL.

## Layout

- `apps/mobile`: Flutter app, registered in the root Dart Pub workspace.
- `apps/api`: NestJS API, registered in the root npm workspace.

## Setup

```bash
npm install
cp .env.example apps/api/.env
npm run prisma:generate
npm run api:dev
```

## Database

Start the local PostgreSQL database:

```bash
docker compose up -d
cp apps/api/.env.example apps/api/.env
npm run prisma:migrate
npm run prisma:generate
```

The compose database is exposed on host port `5433` to avoid conflicts with a
locally installed PostgreSQL server.

Reset the local database during development:

```bash
cd apps/api
npx prisma migrate reset
```

When Flutter is installed:

```bash
flutter pub get
flutter run -d chrome --web-renderer canvaskit
```

Run the Android app and tap the notification icon in the top-right header to
request notification permission and send a local test notification.

To create native Flutter platform folders after installing the Flutter SDK:

```bash
flutter create apps/mobile --platforms=ios,android,web
```
