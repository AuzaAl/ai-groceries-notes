// ai read this! use '- [ ] example' for undone todos, and use '- [ x ] example' for done todo. 

//create todo below here!!

## GroceryNotes — Project TODOs
A project-scoped checklist for GroceryNotes (Flutter + Firebase + Riverpod). Mark items done as you complete them.

### Week 1: Foundation & Auth (Phase 1)
- [x] **Project Initialization**
    - [x] Initialize Flutter project with `flutter create`
    - [x] Configure Firebase Project (Android) and download `google-services.json`
    - [x] Setup dependencies in `pubspec.yaml` (riverpod, hive, go_router, firebase, dio)
    - [x] Define folder structure as per CLAUDE.md (`core/`, `features/`, `services/`, `models/`)
- [x] **Core Setup & Theme (partial)**
    - [x] Add core folders and placeholder files
    - [ ] Implement `main.dart` with `ProviderScope` and Firebase initialization
    - [ ] Setup Hive boxes and type adapters for `GroceryItem` and `TodayNote`
    - [ ] Configure `GoRouter` with initial routes (`/`, `/login`, `/onboarding`)
    - [ ] Define `AppTheme` (light/dark) and responsive typography
- [ ] **Authentication Feature**
    - [ ] Implement `AuthService` using Firebase Auth and Google Sign-In
    - [ ] Create `auth_state_provider` (Riverpod AsyncNotifier) to track login status
    - [ ] Build Login Screen UI as per screensguide.md (Logo, Google Button)
    - [ ] Add sign-out and session persistence logic
- [ ] **Onboarding Flow**
    - [ ] Create 3-slide Onboarding PageView with localized copy and "Mulai" button
    - [ ] Add logic to skip onboarding for returning users (persist flag in Hive)
    - [ ] Add analytics event for onboarding completion
- [ ] **Data Models & Serialization**
    - [ ] Create `GroceryItem` model with Hive type adapter + JSON serialization
    - [ ] Create `Recipe`, `IngredientHistory`, `TodayNote` models and adapters
    - [ ] Add unit tests for model (serialization roundtrip)
- [ ] **Verification**
    - [ ] Run `flutter analyze` and fix all issues
    - [ ] Verify Google Sign-In flow on emulator and a physical device

---

### Week 2: Today’s Notes & Local Persistence
- [ ] **Today Note UI**
    - [ ] Implement Today screen: header, note editor, checklist
    - [ ] Save drafts locally to Hive on every change (offline-first guarantee)
    - [ ] Add optimistic UI when syncing to Firestore
- [ ] **Checklist / Grocery List**
    - [ ] Implement add/edit/delete for grocery checklist items
    - [ ] Support reordering and quick-add (via natural language / quick input)
    - [ ] Persist items in Hive and mirror to Firestore when online
- [ ] **Sync & Conflict Resolution**
    - [ ] Implement Firestore sync service (background sync + retry)
    - [ ] Define simple conflict resolution rules (last-write-wins with merge hints)
    - [ ] Add tests for offline -> online sync cases
- [ ] **Hive maintenance**
    - [ ] Add migrations for type changes
    - [ ] Document box names and type IDs in `core/constants.dart`

---

### Week 3: AI Link & Extraction (Cloud Functions + Gemini)
- [ ] **Cloud Functions**
    - [ ] Create Firebase Cloud Function endpoint to fetch URL contents and extract text
    - [ ] Integrate Google Gemini (via secure server-side key) for extraction/summary
    - [ ] Add retry and error classification for rate limits / API failures
- [ ] **App Integration**
    - [ ] Add UI to paste/link a URL and show extraction progress
    - [ ] Save extraction results to `TodayNote` and mark source metadata
    - [ ] Implement failure dialog per PRD (US-03)
- [ ] **Privacy & Quotas**
    - [ ] Ensure sensitive content is not logged
    - [ ] Add rate-limiting and quota handling on the function

---

### Week 4: Discover / Recipes / YouTube Integration
- [ ] **Recipe Discovery**
    - [ ] Add Discover screen with recommended recipes
    - [ ] Integrate TheMealDB API (or fallback) via Dio service
    - [ ] Add recipe detail page with ingredients and steps
- [ ] **YouTube Integration**
    - [ ] Add YouTube Data API v3 client (search for recipe videos)
    - [ ] Show embedded video thumbnails and link to play in external app
- [ ] **Ingredient History**
    - [ ] Track ingredient usage across notes to surface reorder suggestions
    - [ ] Build small UI to quickly add past ingredients to today’s list

---

### Week 5: Profile, Settings & Sync Improvements
- [ ] **Profile & Settings**
    - [ ] Implement Profile screen (avatar, display name, email)
    - [ ] Allow account unlink / delete local data flow
    - [ ] Settings: theme, language, onboarding toggle
- [ ] **Sync Robustness**
    - [ ] Add exponential backoff for sync failures
    - [ ] Add background sync on app resume and network reconnect
    - [ ] Create end-to-end test for sync behavior
- [ ] **Analytics & Crash Reporting**
    - [ ] Integrate Firebase Analytics events for key flows
    - [ ] Integrate Crashlytics and verify error reporting

---

### Week 6: Tests, CI, Accessibility & Release Prep
- [ ] **Testing**
    - [ ] Unit tests for models and services
    - [ ] Widget tests for critical screens (Login, Today, Discover)
    - [ ] Integration tests for login + sync flow
- [ ] **CI**
    - [ ] Add GitHub Actions: flutter analyze, flutter test, build matrix
    - [ ] Add linting and format check step (`dart format --set-exit-if-changed`)
- [ ] **Accessibility & Localization**
    - [ ] Verify semantic labels and large-font support
    - [ ] Add localization (ID + EN) placeholders and export strings
- [ ] **Release**
    - [ ] Build and smoke test APK on devices
    - [ ] Create Play Store listing draft and gather assets

---

### Ongoing / Backlog
- [ ] Add offline search across notes and recipes
- [ ] Smart suggestions using local ML or cached Gemini embeddings
- [ ] Import/export notes (Markdown / JSON)
- [ ] Share note as text or image
- [ ] Dark-mode animations and subtle motion polish
- [ ] Permissioned team / family sharing (sync across multiple accounts)

---

### Documentation & Housekeeping
- [ ] Update README with setup steps and environment variables
- [ ] Add CONTRIBUTING.md with branching and PR guidelines
- [ ] Keep CLAUDE.md and screensguide.md in sync with implementation
- [ ] Document Cloud Function endpoints and expected payloads

---

### Milestones / Releases
- Milestone 0.1 (MVP): Foundation + Auth + Today Note + Local persistence
- Milestone 0.2: Sync to Firestore + AI Link basic extraction
- Milestone 0.3: Discover + Recipes + YouTube integrations
- Milestone 1.0: Polish, tests, accessibility, and Play Store release

---

If you'd like, I can:
- Create smaller per-week checklists and create issues for each item,
- Generate GH Actions workflow scaffolding,
- Break a chosen milestone into concrete tasks and start implementing.

### Early model: Video AI Notes (MVP)
- [ ] **Goal:** Scaffold a minimal, working prototype that extracts main notes from short-form videos (YouTube, Reels, TikTok) and saves them as TodayNotes.
    - [ ] Create `VideoNote` model (video id, platform, title, duration, transcript, keyPoints, sourceUrl)
    - [ ] Implement `ai_service.dart` skeleton in `lib/services/` to call a server-side Cloud Function for extraction (Gemini).
    - [ ] Add a Cloud Function stub `functions/extract_video_summary` that: fetches captions/transcript (YouTube Data API or third-party), calls Gemini, returns key points and timestamps.
    - [ ] Add `VideoNoteProvider` (Riverpod AsyncNotifier) to manage extraction state and persistence in Hive
    - [ ] Build a simple UI screen to paste a video URL or share-from-app and show extracted key points with timestamps
    - [ ] Wire the prototype to save extraction results into `TodayNote` and mark the source metadata
    - [ ] Add basic tests for the model and provider
    - [ ] Manual verification: share a YouTube URL from mobile or paste a TikTok/Reels link in the prototype and confirm extraction result appears in TodayNotes

Notes:
- Server-side extraction is required for Gemini access and to avoid exposing API keys in the app.
- For YouTube, prefer fetching captions via YouTube Data API v3 if available; for short-form platforms without easy API access, fall back to fetching the page and extracting audio or captions server-side.

If you want me to scaffold this prototype now, approve and I'll: (1) enter plan mode, (2) create the models and service stubs under `lib/models` and `lib/services`, (3) add a small Cloud Functions stub in `functions/`, and (4) create a minimal UI screen and Riverpod provider.

// end of todo
