# AGENTS.md — GroceryNotes

## Tech Stack

- **Flutter 3.x** (Dart SDK ^3.11.5) — Android mobile app
- **Riverpod** with code generation (`riverpod_annotation` + `riverpod_generator`)
- **Firebase** — Auth (Google Sign-In), Firestore, Cloud Functions (Node.js 18)
- **Vercel Serverless** — Gemini AI API endpoint (`server/api/gemini.ts`)
- **Hive** — Local offline persistence

## Commands

```bash
# Flutter app
flutter pub get                    # Install deps
flutter run                        # Run on device/emulator
dart format .                      # Format code
flutter analyze                    # Static analysis
flutter test                       # Run tests
flutter build apk --release        # Build release APK

# Code generation (Riverpod)
dart run build_runner build --delete-conflicting-outputs

# Firebase emulators
firebase emulators:start           # Start auth, firestore, functions emulators

# Server (Vercel API)
cd server && npm install           # Install server deps
vercel dev                         # Run Vercel dev server locally
```

## Project Structure

```
lib/
├── core/             # Themes, constants, routing (empty — not yet created)
├── features/         # Feature modules (ai_link, auth, discover, my_notes, profile, today)
├── models/           # Data models (GroceryItem)
├── providers/        # Riverpod providers with code generation (.g.dart files)
├── screens/          # UI screens (GroceryNotesScreen)
├── services/         # API services (GroceryApiService)
├── data/             # (empty)
├── assets/           # fonts/, images/
└── main.dart         # Entry point — ProviderScope wraps app

functions/            # Firebase Cloud Functions (Node.js, stub implementation)
server/               # Vercel serverless API (TypeScript + Gemini)
```

## Architecture Notes

- **Entry point**: `lib/main.dart` — wraps app in `ProviderScope`, uses `MaterialApp` (not `GoRouter` yet)
- **State management**: Riverpod with `@riverpod` annotation pattern; generated files are `*.g.dart`
- **API flow**: Flutter → `GroceryApiService` → Vercel `/api/gemini` → Gemini AI → JSON response
- **Firebase functions** are stubs only (return sample data); real AI is in Vercel serverless
- **Offline-first** strategy planned but not implemented; Hive dependency exists but unused

## Code Conventions

- Classes: `CamelCase` | Files: `snake_case` | Variables: `camelCase`
- Use `AsyncNotifier`/`Notifier` from Riverpod for feature states
- Dark theme only (black scaffold, white primary, `#1C1C1E` surface)
- UI language: Indonesian (button labels, error messages)

## Key Gotchas

- **Generated code**: Never edit `*.g.dart` files manually; regenerate with `build_runner`
- **Android emulator**: Use `10.0.2.2` instead of `localhost` for API calls
- **Gemini model**: Server uses `gemini-3.1-flash-lite` — check `server/api/gemini.ts:80`
- **API endpoint**: `GroceryApiService` points to `localhost:3000` — update for production
- **Env vars**: `.env` file required at root with `GEMINI_API_KEY` and `YOUTUBE_API_KEY`
- **Core directory**: `lib/core/` exists but is empty; create as needed

## PRD Reference

Full requirements in `docs/PRD_GroceryNotes_App.md` (Indonesian). Key features:
- YouTube link → AI ingredient extraction
- Manual grocery notes
- Offline-first checklist
- Recipe recommendations
