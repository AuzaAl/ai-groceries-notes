# CLAUDE.md — GroceryNotes

AI-Powered Grocery & Recipe Manager (Flutter + Firebase + Gemini).

## Quick commands (Flutter)

- Install deps: `flutter pub get`
- Run the app: `flutter run`
- Format: `dart format .`
- Static analysis: `flutter analyze`
- Run tests: `flutter test`
- Build APK: `flutter build apk --release`

## Project Architecture & Tech Stack

- **Framework**: Flutter 3.x (Dart)
- **State Management**: Riverpod 2.x
- **Routing**: GoRouter
- **Persistence**: Hive (Local) + Firebase Firestore (Remote)
- **Networking**: Dio
- **AI**: Google Gemini 1.5 Flash (via Firebase Cloud Functions)
- **APIs**: YouTube Data API v3, TheMealDB API

### Folder Structure (Proposed)

```
lib/
├── core/             # Themes, constants, routing, common widgets
├── features/         # Feature-based modules
│   ├── auth/         # Google Sign-In logic
│   ├── today/        # Today's Notes & Checklist
│   ├── ai_link/      # AI Extraction from URL
│   ├── my_notes/     # Archive & History
│   ├── discover/     # Recipe Recommendations
│   └── profile/      # User Profile & Settings
├── services/         # Firebase, AI, Dio, Hive services
├── models/           # Data models (GroceryItem, Recipe, etc.)
└── main.dart         # Entry point & Initializations
```

## Implementation Guidelines

- **Naming**: Use `CamelCase` for classes, `snake_case` for files/folders, and `camelCase` for variables/methods.
- **State**: Prefer `AsyncNotifier` or `Notifier` from Riverpod for feature states.
- **Offline-First**: All "Today's Notes" must be saved to Hive immediately and synced to Firestore when online.
- **Error Handling**: Follow PRD error dialog specs (US-03) for AI link failures.
- **UI**: Respect system font scaling and dark mode. Use `flutter_animate` for transitions.

## Current Roadmap (Phase 1)

1. [ ] Setup Project (Firebase + Riverpod + Hive)
2. [ ] Auth Google & Onboarding UI
3. [ ] Today's Notes UI & Archive Logic
4. [ ] AI Link Feature (Cloud Functions + Gemini)

---
*Reference: docs/PRD_GroceryNotes_App.md*