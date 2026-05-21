// ai read this! use '- [ ] example' for undone todos, and use '- [ x ] example' for done todo. 

//create todo below here!!

## Setup & Providers — Manual Steps (required actions you must perform)
This file lists all manual setup, credential, and provider steps required to run GroceryNotes end-to-end. These require account access or billing and cannot be completed by the assistant.

### Firebase / Google Cloud
- [x] Create a Firebase project in Google Cloud Console.
    - [x] Enable Firestore (Native mode).
    - [ ] Enable Firebase Authentication and enable Google Sign-In.
    - [ ] Enable Cloud Functions (or Cloud Run) for server-side AI calls.
    - [x] Download platform config files and store securely:
        - [ ] Android: `google-services.json` → place in `android/app/`
        - [ ] iOS: `GoogleService-Info.plist` → place in `ios/Runner/`
    - [x] Note: keep these files out of source control; add to .gitignore if needed.
- [ ] Create OAuth 2.0 Client IDs for each platform in Google Cloud Console (Credentials → OAuth 2.0 Client IDs):
    - [x] Android: package name + SHA-1 fingerprint
    - [ ] iOS: bundle id
    - [ ] Web (if used): authorized redirect URIs (for web sign-in / emulator testing)
    - [ ] Record the Client IDs and place them in a secure location (or GH Secrets).
- [x] Configure OAuth consent screen (External/Internal) and submit for verification if you request sensitive scopes.
- [ ] Enable billing on the Google Cloud project if required for Gemini usage or increased quotas.

### YouTube Data API (for captions/transcripts)
- [ ] Create or enable YouTube Data API v3 for the project.
- [x] Create an API key (or OAuth credential if needed) and restrict it to your app + referrers.
- [x] Add the key to secrets as `YOUTUBE_API_KEY`.

### Google Gemini / Vertex AI (server-side LLM)
- [ ] Create a Google Cloud service account for server-side AI calls.
    - [ ] Grant minimum necessary roles (e.g., Vertex AI User or custom role with invoke access).
    - [ ] Create and download the service account key JSON file.
    - [ ] Store the JSON securely — do NOT commit it to git.
- [ ] Set environment variables for functions / server runtime pointing to the service account or place the JSON on the server and set `GOOGLE_APPLICATION_CREDENTIALS`.
    - [ ] Example secret names: `GEMINI_SA_JSON` (stored in secret manager or CI secrets)
- [ ] Note: ask your cloud admin about quotas/costs for Gemini; enable billing if necessary.
	
### TikTok / Instagram / Reels (optional short-form sources)
- [ ] Register developer apps for TikTok and Instagram (if you plan to use their APIs).
- [ ] Request necessary API access and scopes for fetching video metadata or transcripts (if available).
- [ ] Store client id / secret in secrets as `TIKTOK_CLIENT_ID`, `TIKTOK_CLIENT_SECRET`, `IG_CLIENT_ID`, `IG_CLIENT_SECRET`.
- [ ] If official APIs don't provide captions, you will need server-side scraping or audio extraction + speech-to-text (STT) — plan for increased complexity and TOS compliance.

### Speech-to-Text (if needed)
- [ ] If captions are unavailable, provision an STT provider (Google Speech-to-Text, Whisper on server, or another provider).
- [ ] Create credentials, store in secrets (e.g., `STT_API_KEY`), and plan for batch processing costs.

### Firebase Cloud Functions / Server Deployment
- [ ] Deploy a Cloud Function endpoint (e.g., `extract_video_summary`) that:
    - [ ] Accepts a video URL or video id and platform type
    - [ ] Fetches captions/transcript (YouTube API or other)
    - [ ] Optionally downloads audio and runs STT if captions are missing
    - [ ] Calls Gemini (Vertex AI) with the transcript to extract key points/timestamps
    - [ ] Returns structured JSON { keyPoints: [{text, start, end}], transcript, metadata }
- [ ] Add environment variables for the function (use Firebase Functions config or Cloud Run env vars):
    - [ ] `YOUTUBE_API_KEY`, `GEMINI_SERVICE_ACCOUNT` (or rely on Compute default SA), any `STT` keys
- [ ] Ensure the function is secured (e.g., require an API key, IAM policy, or signed tokens) and not publicly writable.

### Secrets and CI/CD (GitHub Actions example)
- [ ] Add the following secrets to GitHub repository settings (Actions → Secrets):
    - [ ] `FIREBASE_TOKEN` (for deploys)
    - [ ] `GCM_SERVICE_ACCOUNT_JSON` or `GEMINI_SA_JSON` (store as plain text or use encrypted secret manager)
    - [ ] `YOUTUBE_API_KEY`
    - [ ] `TIKTOK_CLIENT_ID`, `TIKTOK_CLIENT_SECRET` (if used)
    - [ ] `STT_API_KEY` (if used)
- [ ] Do not store service account JSON in plaintext in the repo; prefer GitHub Secrets or Cloud Secret Manager.

### Local Development / Emulator Steps
- [ ] Install and configure Firebase CLI and sign in (`firebase login`).
- [ ] Initialize functions locally (`firebase init functions`) and set local env with `firebase functions:config:set key=\"value\"` or use `.env` for local dev (do NOT commit `.env`).
- [ ] For Android local testing: add SHA-1 fingerprint to Firebase console (used for Google Sign-In to work on device/emulator).
- [ ] For iOS: configure reversed client id in Info.plist if using Google Sign-In.

### App-side config and expected env variable names
- [ ] Add placeholder entries in your app configuration (documented locations):
    - [ ] `YOUTUBE_API_KEY` — used by server function and optionally client for lightweight calls
    - [ ] `VIDEO_EXTRACTOR_ENDPOINT` — URL of your Cloud Function / API
    - [ ] `GEMINI_SERVICE_ACCOUNT` or server-side config — not stored in app
- [ ] Document exact expected payloads and header names for the extractor endpoint (e.g., `Authorization: Bearer <API_KEY>`).

### Verification & Testing (manual)
- [ ] Manual test: paste a YouTube video URL into the app and confirm that:
    - [ ] The app sends the URL to the extractor endpoint.
    - [ ] The function returns a transcript and key points with timestamps.
    - [ ] The app saves a VideoNote and/or TodayNote with extracted key points.
- [ ] Manual test for platforms without captions: upload a small test video to a temp bucket and verify the STT extraction and Gemini summary flow.
- [ ] Security test: ensure no secrets leak to logs; rotate keys if they were accidentally exposed.

---

If you want, I can:
- Add step-by-step, click-by-click instructions for any specific console (Firebase Console, Google Cloud, YouTube Developer Console, TikTok/IG)
- Scaffold the Cloud Function stub and app-side call sites now (you'll still need to provide the secrets and deploy)
- Generate GitHub Actions workflow templates that reference the secret names above

// end of setup todos
