# RoomKeeper

RoomKeeper is an Android-first Flutter app for keeping a practical local record
of a boarding house room. It tracks belongings by room area, food stock,
laundry counters, and rent and utilities payments.

The app is intentionally local-first. It has no account system, backend, or
cloud sync.

## Features

- Room item inventory grouped by area, with quantity, condition, notes, and an
  optional local photo.
- Food stock tracker with quantity, unit, storage area, category, expiry date,
  and low-stock threshold.
- Laundry basket counters for everyday clothing categories.
- Rent and utilities payment logs with PHP amounts, billing month, and optional
  next-payment reminder.

## Tech Stack

- Flutter and Dart
- Material 3 UI
- Riverpod for app state and dependency injection
- GoRouter for navigation
- Drift with SQLite for local structured storage
- flutter_local_notifications with Asia/Manila timezone defaults
- image_picker for optional inventory photos

## Android Details

- App name: `RoomKeeper`
- Android package id: `com.shiningshell.roomkeeper`
- Primary target: Android
- Local data is stored in the app documents directory and SQLite database.
- Scheduled reminders use local Android notifications and are also stored in
  the local database for in-app upcoming/overdue views.

## Project Structure

```text
lib/
  main.dart
  src/
    app.dart
    providers.dart
    data/
      database.dart
      roomkeeper_repository.dart
    features/
      home/
      inventory/
      food/
      laundry_bills/
    services/
      image_storage_service.dart
      notification_gateway.dart
      reminder_service.dart
    shared/
      formatters.dart
test/
  data/
  services/
  widgets/
```

## Getting Started

Install dependencies:

```sh
flutter pub get
```

Generate Drift database code after changing `lib/src/data/database.dart`:

```sh
dart run build_runner build
```

Run the app on a connected Android device or emulator:

```sh
flutter run
```

Build a debug APK:

```sh
flutter build apk --debug
```

The debug APK is generated at:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

## Verification

Run static analysis:

```sh
flutter analyze
```

Run tests:

```sh
flutter test -r expanded --concurrency=1
```

The serial test command avoids a Windows native-asset copy race that can occur
when SQLite native assets are prepared concurrently.

Current test coverage includes:

- Default area seeding and core repository persistence.
- Reminder scheduling and cancellation through a fake notification gateway.
- Dashboard rendering with provider overrides.

## Notes

- This MVP does not include login, cloud sync, encryption, or app lock.
- Food photos and payment receipt attachments are out of scope for the first
  version.
- If notification permission is denied, reminders remain visible inside the app
  but Android system notifications will not appear.
