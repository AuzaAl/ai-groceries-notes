# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Quick commands (Flutter)

- Install deps:
  - `flutter pub get`
- Run the app (pick a device first):
  - `flutter run`
- Format:
  - `dart format .`
- Static analysis / lint:
  - `flutter analyze`
- Run tests:
  - `flutter test`
- Run a single test file:
  - `flutter test test/<file>_test.dart`
- Build release artifacts:
  - Android APK: `flutter build apk --release`
  - Android App Bundle: `flutter build appbundle --release`
  - iOS (on macOS): `flutter build ios --release`

## High-level architecture

This is a minimal Flutter app scaffolded from the standard template.

- Entry point: `lib/main.dart`
  - `main()` calls `runApp(const MainApp())`.
  - `MainApp` currently renders a `MaterialApp` with a single `Scaffold` and a `Hello World!` `Text` widget.

## Notable dependencies (currently unused in code)

`pubspec.yaml` includes common app building blocks that are not yet wired into `lib/`:

- `flutter_riverpod`: state management / DI
- `go_router`: declarative routing
- `dio`: HTTP client
- `hive`: local storage
- `cached_network_image`: image caching
- `flutter_animate`: animations
- `flutter_inappwebview`: in-app webview

Before implementing new features, check whether these are intended for the upcoming architecture (Riverpod + GoRouter, persistence with Hive, networking with Dio), and match existing patterns once they appear.
