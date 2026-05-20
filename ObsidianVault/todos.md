// ai read this! use '- [ ] example' for undone todos, and use '- [ x ] example' for done todo. 

//create todo below here!!

### Week 1: Foundation & Auth (Phase 1)
- [x] **Project Initialization**
    - [x] Initialize Flutter project with `flutter create`
    - [x] Configure Firebase Project (Android) and download `google-services.json`
    - [x] Setup dependencies in `pubspec.yaml` (Riverpod, Hive, GoRouter, Firebase, Dio)
    - [x] Define folder structure as per CLAUDE.md (`core/`, `features/`, `services/`, `models/`)
- [x] **Core Setup & Theme**
    - [ ] Implement `main.dart` with `ProviderScope` and Firebase initialization
    - [ ] Setup Hive boxes and type adapters for `GroceryItem` and `TodayNote`
    - [ ] Configure `GoRouter` with initial routes (`/`, `/login`, `/onboarding`)
    - [ ] Define `AppTheme` (Light/Dark mode support) and typography
- [ ] **Authentication Feature**
    - [ ] Implement `AuthService` using Firebase Auth and Google Sign-In
    - [ ] Create `AuthStateProvider` (Riverpod) to track login status
    - [ ] Build Login Screen UI as per screensguide.md (Logo, Google Button)
- [ ] **Onboarding Flow**
    - [ ] Create 3-slide Onboarding PageView with "Mulai" button
    - [ ] Add logic to skip onboarding for returning users
- [ ] **Data Models**
    - [ ] Create `GroceryItem` model with JSON serialization
    - [ ] Create `Recipe` and `IngredientHistory` models
- [ ] **Verification**
    - [ ] Run `flutter analyze` to check for static issues
    - [ ] Verify Google Sign-In flow on an emulator/device


