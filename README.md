# Subway Push

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

When Flutter is installed:

```bash
flutter pub get
flutter run -d chrome --web-renderer canvaskit
```

To create native Flutter platform folders after installing the Flutter SDK:

```bash
flutter create apps/mobile --platforms=ios,android,web
```
