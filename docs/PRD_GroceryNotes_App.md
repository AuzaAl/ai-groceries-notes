# Product Requirements Document
# GroceryNotes — AI-Powered Grocery & Recipe Manager
**Platform:** Flutter (Android)
**Version:** 1.0.0
**Author:** Auza Alfarizi Ramadhan
**Status:** Draft
**Last Updated:** Mei 2026

---

## Table of Contents
1. Executive Summary
2. User Experience & Functionality
3. AI System Requirements
4. Technical Specifications
5. Sitemap & Navigation
6. Risks & Roadmap
7. Definition of Done

---

## 1. Executive Summary

### Problem Statement
Pengguna yang memasak berdasarkan resep dari YouTube atau blog sering kali harus berpindah-pindah aplikasi untuk mencatat bahan makanan secara manual — proses yang memakan waktu, rawan lupa, dan tidak terorganisir, terutama saat berbelanja.

### Proposed Solution
GroceryNotes adalah aplikasi mobile Flutter yang menggunakan AI untuk secara otomatis mengekstrak daftar bahan dari link resep (YouTube/blog), mengubahnya menjadi grocery notes harian yang terorganisir, dilengkapi fitur pencarian bahan, rekomendasi resep, dan checklist belanja offline.

### Success Criteria
| KPI | Target | Cara Ukur |
|-----|--------|-----------|
| Link parsing accuracy | ≥ 85% bahan terdeteksi dari resep valid | Manual test 20+ link resep populer |
| AI processing time | ≤ 8 detik per link | Stopwatch test per request |
| Offline notes accessibility | 100% notes terbaca tanpa internet | Airplane mode test |
| Note archive reliability | 0 data loss saat rotasi tengah malam | Automated test scheduling |
| Crash-free rate | ≥ 98% sessions | Firebase Crashlytics |

---

## 2. User Experience & Functionality

### 2.1 User Personas

**Persona A — "Kak Dina, Ibu Rumah Tangga"**
- Usia 28–45 tahun, memasak setiap hari
- Sering menonton YouTube memasak di malam hari, lalu belanja pagi
- Pain point: Sering lupa bahan, harus buka HP berkali-kali sambil belanja

**Persona B — "Rafi, Anak Kos"**
- Usia 18–25 tahun, baru belajar masak
- Sering temukan resep dari blog/Instagram
- Pain point: Tidak tahu takaran bahan, sering beli terlalu banyak/sedikit

**Persona C — "Bu Sari, Meal Prepper"**
- Usia 30–40 tahun, meal prep mingguan
- Butuh kalkulasi bahan untuk banyak porsi sekaligus
- Pain point: Bahan dari beberapa resep harus digabung manual

---

### 2.2 User Stories & Acceptance Criteria

#### EPIC 1 — Autentikasi

**US-01**: Sebagai user baru, saya ingin login dengan akun Google sehingga tidak perlu membuat akun baru.
- AC: Tombol "Login with Google" tersedia di halaman onboarding
- AC: Berhasil login dalam ≤ 3 tap
- AC: Profil nama dan foto dari Google ditampilkan di app
- AC: Jika login gagal, muncul snackbar error yang informatif

---

#### EPIC 2 — Fitur Unggulan: AI Link to Grocery Notes

**US-02**: Sebagai user, saya ingin menempelkan link YouTube/blog resep sehingga AI bisa otomatis membuat daftar bahan belanja hari ini.
- AC: Input field menerima URL YouTube dan URL blog
- AC: Validasi URL dilakukan sebelum request dikirim (format URL, bukan string biasa)
- AC: Loading state ditampilkan dengan indikator progress selama AI memproses (≤ 8 detik)
- AC: Hasil ekstraksi berupa daftar bahan dengan nama bahan, jumlah, dan satuan
- AC: Notes langsung masuk ke "Today's Notes" setelah proses selesai
- AC: User dapat edit/hapus item hasil ekstraksi AI sebelum menyimpan

**US-03**: Sebagai user, saya ingin mendapatkan pesan error yang jelas jika link tidak mengandung resep.
- AC: Jika konten tidak mengandung resep → tampil dialog: *"Link ini tidak terdeteksi sebagai resep. Coba link lain yang berisi resep makanan."*
- AC: Jika blog loading timeout (>10 detik) → tampil dialog: *"Halaman terlalu lambat dimuat. Coba buka link di browser, lalu salin teks resepnya dan paste di sini."* + fallback input teks manual
- AC: Jika YouTube tidak punya transcript → tampil dialog: *"Video tidak memiliki teks tersedia. Coba cari resep yang sama dalam format blog."* + tombol "Cari di Rekomendasi"
- AC: Semua error disertai tombol "Coba Link Lain" dan "Input Manual"

**US-04**: Sebagai user, saya ingin bisa paste teks resep manual sebagai fallback sehingga tetap bisa membuat notes jika link bermasalah.
- AC: Tersedia tombol "Input Teks Manual" di halaman add link
- AC: User dapat paste/ketik teks resep bebas
- AC: AI memproses teks manual sama seperti konten link

---

#### EPIC 3 — Fitur Premier: Manual Grocery Notes

**US-05**: Sebagai user, saya ingin membuat notes bahan makanan secara manual sehingga bisa mencatat kebutuhan belanja apapun, tidak harus dari resep.
- AC: Form input notes manual berisi field:
  - Nama bahan (teks, wajib)
  - Jumlah (angka desimal)
  - Satuan (dropdown: gram, kg, ml, liter, sdm, sdt, buah, ikat, bungkus, botol, kaleng, lembar, siung, batang, ekor, porsi)
  - Kategori bahan (dropdown: Sayuran, Buah, Daging & Seafood, Bumbu & Rempah, Susu & Olahan, Karbohidrat & Biji-bijian, Minuman, Frozen Food, Snack, Lainnya)
  - Catatan tambahan (opsional, teks bebas)
- AC: User bisa tambah multiple items dalam satu sesi sebelum save
- AC: Notes manual langsung masuk ke "Today's Notes"

**US-06**: Sebagai user, saya ingin mencari bahan makanan dan langsung menambahkannya ke notes hari ini sehingga proses pencatatan lebih cepat.
- AC: Search bar tersedia di halaman Add Manual
- AC: Hasil pencarian menampilkan bahan yang pernah diinput sebelumnya (riwayat bahan dari Firestore user)
- AC: Hasil pencarian muncul dalam ≤ 300ms untuk data lokal (SQLite/Hive cache)
- AC: Tap hasil pencarian → langsung tambah ke today's notes dengan quantity default "1"
- AC: User bisa edit quantity setelah ditambahkan

---

#### EPIC 4 — Today's Notes & Manajemen Harian

**US-07**: Sebagai user, saya ingin melihat semua bahan yang perlu dibeli hari ini dalam satu halaman sehingga mudah dibawa saat belanja.
- AC: Halaman "Today" menampilkan semua items dari notes hari ini (dari AI link maupun manual)
- AC: Setiap item punya checkbox "sudah dibeli"
- AC: Items yang sudah dicentang pindah ke bagian bawah dengan style strikethrough + warna abu
- AC: Ada progress bar atau counter "X/Y bahan sudah dibeli"
- AC: Fitur "Tambah dari sumber" (+ button → pilih: AI Link / Manual / Reuse dari arsip)

**US-08**: Sebagai user, saya ingin notes harian otomatis terarsip saat tengah malam sehingga setiap hari dimulai dengan notes bersih.
- AC: Pada pukul 00:00 waktu device, status today's note berubah jadi "archived"
- AC: Halaman Today otomatis kosong di hari baru
- AC: Proses archive tidak menghapus data (tetap bisa diakses di My Notes)
- AC: Jika app tidak dibuka saat tengah malam, archive terjadi saat app dibuka keesokan harinya (cek timestamp last session)

**US-09**: Sebagai user, saya ingin melihat riwayat notes dari hari-hari sebelumnya sehingga bisa melacak pola belanja.
- AC: Halaman "My Notes" menampilkan daftar notes terarsip diurutkan terbaru ke terlama
- AC: Setiap card arsip menampilkan: tanggal, jumlah item, judul resep (jika dari link)
- AC: Tap card → buka detail arsip (read-only + opsi "Reuse ke Today")
- AC: Fitur "Reuse" memindahkan semua items dari arsip ke today's notes (dengan konfirmasi dialog)

---

#### EPIC 5 — Fitur Sekunder: Rekomendasi Resep

**US-10**: Sebagai user, saya ingin melihat rekomendasi resep makanan sehingga mendapat inspirasi masak baru.
- AC: Halaman "Discover" menampilkan daftar resep dengan: thumbnail, judul resep, kategori, estimasi waktu memasak, sumber (YouTube/blog), rating/populer
- AC: Data resep diambil dari API (Spoonacular/MealDB atau custom Firestore kurasi)
- AC: Tap resep → halaman detail berisi: bahan lengkap, langkah memasak, link sumber (YouTube/blog)
- AC: Tombol "Buat Notes dari Resep Ini" → trigger AI ekstraksi langsung

**US-11**: Sebagai user, saya ingin mencari resep berdasarkan nama sehingga bisa temukan resep spesifik.
- AC: Search bar tersedia di halaman Discover
- AC: Hasil muncul dalam ≤ 500ms
- AC: Pencarian case-insensitive dan mendukung partial match
- AC: Jika tidak ditemukan → tampil ilustrasi kosong + "Tidak ada resep untuk '[keyword]'"

**US-12**: Sebagai user, saya ingin memfilter resep berdasarkan kategori sehingga bisa fokus ke jenis masakan yang diinginkan.
- AC: Filter chips tersedia di atas daftar resep
- AC: Kategori yang tersedia:
  - 🍚 Masakan Indonesia
  - 🍜 Masakan Asia
  - 🍝 Masakan Barat
  - 🥗 Vegetarian & Vegan
  - 🍗 Ayam & Unggas
  - 🥩 Daging Sapi & Kambing
  - 🐟 Seafood
  - 🥘 Sup & Soto
  - 🍰 Kue & Dessert
  - ☕ Minuman & Jus
  - 🍱 Bekal & Meal Prep
  - ⚡ Masak Cepat (<30 menit)
- AC: Bisa pilih multiple kategori sekaligus
- AC: Filter dapat di-reset dengan tombol "Reset Filter"

---

### 2.3 Non-Goals (Tidak Dibangun di v1.0)

- Fitur sosial (share notes ke orang lain, following)
- Kalkulator kalori / informasi nutrisi
- Integrasi e-commerce (beli bahan langsung dari app)
- Multi-bahasa (hanya Bahasa Indonesia + English UI)
- iOS build
- Push notification jadwal belanja
- Fitur paid/subscription

---

## 3. AI System Requirements

### 3.1 AI Flow: Link → Grocery Notes

```
User Input URL
      │
      ▼
[Validator] ── URL tidak valid ──► Error: "Bukan URL yang valid"
      │
      ▼ URL valid
[Content Fetcher]
  ├── YouTube URL → YouTube Data API v3 (ambil transcript/deskripsi/judul)
  └── Blog URL → HTTP Scraping (html_content via server-side function)
      │
      ▼
[Content Classifier] ── bukan resep ──► Error: "Tidak mengandung resep"
      │
      ▼ mengandung resep
[AI Extractor] (Gemini API / OpenAI API)
  → Prompt: ekstrak ingredients dalam format JSON
      │
      ▼
[Parser & Validator]
  → Normalisasi satuan, deteksi duplikat
      │
      ▼
[Review Screen] ← user edit/hapus items
      │
      ▼
[Save to Firestore] → Today's Notes
```

### 3.2 AI Prompt Specification

**System Prompt untuk Ekstraksi:**
```
Kamu adalah asisten ekstraksi resep. Dari teks berikut, ekstrak HANYA daftar bahan makanan.
Output HARUS dalam format JSON array berikut, tanpa teks lain:
[
  {"name": "nama bahan", "quantity": 200, "unit": "gram", "notes": "opsional"},
  ...
]

Rules:
- Jika tidak ada daftar bahan yang jelas, return: {"error": "no_recipe_found"}
- Normalisasi satuan ke: gram, kg, ml, liter, sdm, sdt, buah, ikat, bungkus, siung, lembar, batang, ekor, secukupnya
- Jangan sertakan peralatan masak
- Jika quantity tidak disebutkan, gunakan "secukupnya"
```

### 3.3 Slow Blog Handling Strategy

Jika blog HTTP request timeout setelah 10 detik:
1. Tampil dialog: *"Halaman ini terlalu lambat. Kamu bisa:"*
   - **[Salin Teks Resep]** → buka browser in-app, user salin teks → paste ke input manual
   - **[Input Manual]** → buka form manual langsung
   - **[Batal]**
2. App tidak melakukan infinite retry tanpa konfirmasi user
3. Server-side function menggunakan timeout 8 detik dengan fallback ke cached version (jika pernah diakses sebelumnya)

### 3.4 Tool Requirements

| Tool | Kegunaan | Provider |
|------|----------|----------|
| LLM API | Ekstraksi bahan dari teks | Google Gemini 1.5 Flash (gratis tier) |
| YouTube Data API v3 | Ambil transcript & metadata video | Google Cloud |
| Web Scraper | Ekstraksi konten blog | Firebase Cloud Functions (Node.js + Cheerio) |
| Recipe API | Data rekomendasi resep | TheMealDB API (gratis) |

### 3.5 Evaluation Strategy

Sebelum release, lakukan testing manual dengan:
- 20 link YouTube resep Indonesia populer (Devina Hermawan, Nicky Tirta, dll.)
- 20 link blog resep (Cookpad, Sajian Sedap, dll.)
- Target: ≥ 17/20 berhasil mengekstrak bahan dengan ≥ 85% akurasi item

---

## 4. Technical Specifications

### 4.1 Tech Stack

| Layer | Teknologi |
|-------|-----------|
| Framework | Flutter 3.x (Dart) |
| State Management | Riverpod 2.x |
| Local Storage (offline) | Hive (NoSQL) |
| Remote Database | Firebase Firestore |
| Auth | Firebase Auth (Google Sign-In) |
| Backend Functions | Firebase Cloud Functions (Node.js) |
| AI Integration | Google Gemini API via Cloud Functions |
| Recipe API | TheMealDB REST API |
| YouTube API | YouTube Data API v3 |
| Analytics | Firebase Analytics |
| Crash Reporting | Firebase Crashlytics |
| HTTP Client | Dio |

### 4.2 Arsitektur Data

**Firestore Collections:**

```
users/{uid}/
├── profile: { name, email, photoUrl, createdAt }
├── today_note: { date, items: [...], status: "active" }
├── notes/{noteId}: { date, items: [...], status: "archived", source: "ai|manual", recipeTitle, recipeUrl }
└── ingredient_history/{ingredientId}: { name, category, useCount, lastUsed }
```

**Hive Local Schema (offline support):**
```
today_note_box: TodayNote { date, items: List<GroceryItem>, isChecked: Map<String, bool> }
cached_recipes_box: List<Recipe>
ingredient_cache_box: List<IngredientHistory>
```

**GroceryItem Model:**
```dart
class GroceryItem {
  String id;
  String name;
  double quantity;
  String unit;
  String category;
  String? notes;
  bool isChecked;
  DateTime addedAt;
  String source; // "ai" | "manual" | "recipe"
}
```

### 4.3 Offline Strategy

- **Today's Notes**: Selalu tersimpan di Hive lokal. Sync ke Firestore saat online.
- **My Notes (Arsip)**: Cached 30 notes terakhir di Hive. Sisanya fetch dari Firestore saat online.
- **Rekomendasi Resep**: Cache 50 resep terakhir di Hive. Data baru hanya refresh saat online.
- **Ingredient History**: Fully cached di Hive untuk search cepat (≤ 300ms).
- **AI Link Feature**: Requires internet — jika offline, tampil banner "Fitur AI butuh koneksi internet."

### 4.4 Archive Scheduler

```dart
// Di main.dart, setiap kali app dibuka:
void checkAndArchiveIfNeeded() {
  final lastDate = HiveBox.get('today_note')?.date;
  final today = DateTime.now().toIso8601String().substring(0, 10);
  if (lastDate != null && lastDate != today) {
    // Archive note kemarin ke Firestore
    // Reset today_note di Hive
  }
}
```

### 4.5 Security & Privacy

- Semua data user tersimpan di Firestore dengan rules: `allow read, write: if request.auth.uid == userId;`
- API keys (Gemini, YouTube) disimpan di Firebase Cloud Functions environment variables — **tidak pernah di client**
- Tidak ada data user yang dikirim ke pihak ketiga selain Google (Firebase, Gemini)
- Ingredient history bisa dihapus user kapan saja dari Settings

---

## 5. Sitemap & Navigation

```
GroceryNotes App
│
├── [Onboarding / Login]
│   └── Google Sign-In
│
└── [Main Shell — Bottom Nav Bar]
    ├── 🏠 Today (Default)
    │   ├── Today's Notes List (checklist)
    │   ├── Progress Bar (X/Y bahan)
    │   ├── FAB (+) → Add Sheet
    │   │   ├── 🔗 Dari Link (AI)
    │   │   │   ├── Input URL
    │   │   │   ├── Loading / Processing
    │   │   │   ├── Review & Edit Hasil AI
    │   │   │   └── ✅ Tersimpan → kembali ke Today
    │   │   ├── ✏️ Input Manual
    │   │   │   ├── Search Bahan (history)
    │   │   │   ├── Form Tambah Bahan
    │   │   │   └── ✅ Tersimpan → kembali ke Today
    │   │   └── 📋 Reuse dari Arsip
    │   │       ├── Pilih Notes Arsip
    │   │       └── Konfirmasi → Tambah ke Today
    │   └── Swipe item → Edit / Hapus
    │
    ├── 📋 My Notes
    │   ├── Daftar Arsip (card per hari)
    │   └── Detail Arsip
    │       ├── Daftar Items (read-only)
    │       └── Tombol "Reuse ke Today"
    │
    ├── 🔍 Discover
    │   ├── Search Bar
    │   ├── Filter Category Chips
    │   ├── Daftar Resep (cards)
    │   └── Detail Resep
    │       ├── Thumbnail / Info
    │       ├── Daftar Bahan Lengkap
    │       ├── Langkah Memasak
    │       ├── Tombol "Buat Notes dari Resep Ini"
    │       └── Tombol "Buka Sumber (YouTube/Blog)"
    │
    └── 👤 Profile
        ├── Info Akun (nama, foto, email)
        ├── Riwayat Bahan (ingredient history)
        │   └── Hapus Riwayat
        ├── Tema (Light / Dark / System)
        └── Logout
```

### UX Details & Kenyamanan User

- **Empty State** setiap halaman ada ilustrasi + copy yang ramah (bukan teks error kering)
- **Skeleton loading** untuk list resep dan arsip (bukan spinner)
- **Swipe to delete** di Today's Notes dengan konfirmasi Snackbar + tombol "Undo"
- **Pull to refresh** di Discover dan My Notes
- **Haptic feedback** saat centang checklist
- **Bottom Sheet** untuk Add options (bukan full-screen dialog)
- **In-app browser** (WebView) untuk buka link sumber resep tanpa keluar app
- **Dark mode** support penuh
- **Font scaling** respek system font size (accessibility)
- **Onboarding screens** 3 slide untuk user baru (setelah login pertama kali)

---

## 6. Risks & Roadmap

### 6.1 Phased Roadmap (8 Minggu)

#### 🟡 Phase 1 — Foundation (Minggu 1–3) → Target 50% Progress

| Minggu | Deliverable |
|--------|-------------|
| Minggu 1 | Setup project (Flutter + Firebase + Riverpod + Hive), Auth Google, Onboarding UI |
| Minggu 2 | Today's Notes UI (checklist, add manual, search bahan, archive logic) |
| Minggu 3 | AI Link Feature (Cloud Functions, Gemini API, YouTube API, scraper, review screen) |

**Milestone Week 3**: User bisa login, buat notes manual, dan input link resep → dapat grocery notes otomatis.

#### 🟢 Phase 2 — Core Features (Minggu 4–6)

| Minggu | Deliverable |
|--------|-------------|
| Minggu 4 | My Notes (arsip, detail, reuse) + Offline support (Hive sync) |
| Minggu 5 | Discover (TheMealDB API, list resep, search, filter kategori) |
| Minggu 6 | Detail Resep + "Buat Notes dari Resep" + in-app browser |

#### 🔵 Phase 3 — Polish & Portfolio (Minggu 7–8)

| Minggu | Deliverable |
|--------|-------------|
| Minggu 7 | Profile, Dark mode, Onboarding slides, Error handling polish, Empty states, Haptic |
| Minggu 8 | Testing (manual + unit test), bug fixing, README, screenshot portfolio, APK build |

---

### 6.2 Technical Risks

| Risiko | Probabilitas | Dampak | Mitigasi |
|--------|-------------|--------|---------|
| Blog scraping gagal (anti-bot, CORS) | Tinggi | Tinggi | Gunakan Cloud Functions sebagai proxy; tambahkan fallback input manual |
| YouTube tanpa transcript | Sedang | Sedang | Fallback ke analisis judul + deskripsi video; error message jelas |
| Gemini API quota habis | Rendah | Tinggi | Set rate limit per user (maks 10 request/hari via Firestore counter) |
| TheMealDB API tidak punya resep Indonesia | Sedang | Sedang | Kurasi manual 20–30 resep Indonesia disimpan di Firestore sebagai fallback dataset |
| Hive sync conflict saat offline → online | Rendah | Sedang | Gunakan timestamp-based conflict resolution (last-write-wins) |
| Firebase Cold Start Cloud Functions | Sedang | Sedang | Keep-alive ping atau gunakan minimum instances = 1 (pertimbangkan biaya) |

---

## 7. Definition of Done

Sebuah fitur dianggap selesai jika:
- [ ] Fungsi berjalan sesuai Acceptance Criteria
- [ ] Error state dan empty state ditangani
- [ ] Berjalan offline (jika relevan)
- [ ] Tidak ada exception yang uncaught (Firebase Crashlytics clean)
- [ ] UI konsisten dengan design system (warna, font, spacing)
- [ ] Ditest di minimal 1 device Android fisik atau emulator API 30+

---

*GroceryNotes PRD v1.0 — Dibuat untuk keperluan portofolio PKL. Hak cipta milik Auza Alfarizi Ramadhan.*
