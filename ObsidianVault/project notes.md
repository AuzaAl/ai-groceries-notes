|Layer|Teknologi|Kegunaan & alasan pilih|Status|
|---|---|---|---|
|📱 FRONTEND — FLUTTER|   |   |   |
|Framework|Flutter 3.x (Dart)|Cross-platform base, Android target. Cocok untuk portofolio karena mature dan banyak dipakai industri.|Core|
|State Management|Riverpod 2.x|Type-safe, compile-time safe, tidak butuh BuildContext. Lebih scalable dari Provider atau Bloc untuk skala project ini.|Core|
|Navigation|GoRouter|Deep linking ready, declarative routing, cocok dengan Riverpod. Official recommendation dari Flutter team.|Core|
|HTTP Client|Dio|Interceptors untuk auth token, retry logic, timeout handling. Lebih powerful dari http package bawaan.|Core|
|Local Storage|Hive 2.x|NoSQL lokal super cepat untuk offline notes & ingredient cache. Tidak butuh native dependency seperti SQLite.|Core|
|In-app Browser|flutter_inappwebview|Buka link resep YouTube/blog tanpa keluar app. Lebih kaya fitur dari url_launcher WebView.|UX|
|UI Components|Flutter Material 3|Built-in. Dynamic color theming, dark mode support. Tidak perlu library tambahan untuk komponen dasar.|Core|
|Animasi|flutter_animate|Animasi masuk/keluar elemen dengan sintaks chaining yang ringkas. Buat UI terasa polished tanpa coding animasi manual.|UX|
|Image Caching|cached_network_image|Cache thumbnail resep dari API. Mencegah re-fetch gambar yang sama berulang kali.|UX|
|Haptic Feedback|HapticFeedback (built-in)|Gunakan dart:ui bawaan Flutter saat user centang checklist. Tidak perlu package tambahan.|UX|
|🔐 AUTH & DATABASE|   |   |   |
|Authentication|Firebase Auth|Google Sign-In one-tap. SDK resmi tersedia di Flutter (firebase_auth + google_sign_in).|Free|
|Cloud Database|Cloud Firestore|Realtime sync, offline persistence bawaan, struktur JSON fleksibel untuk notes & ingredient history. Free tier cukup untuk personal project.|Free|
|⚙️ BACKEND — CLOUD FUNCTIONS|   |   |   |
|Backend Runtime|Firebase Cloud Functions (Node.js 20)|Serverless, gratis untuk 2jt invocation/bulan. Tempat menyimpan API keys agar tidak exposed di client Flutter.|Free|
|Web Scraper|Cheerio (Node.js)|Parse HTML blog resep di server-side. Ringan, tidak butuh headless browser, cepat untuk konten statis.|Infra|
|HTTP (server-side)|Axios (Node.js)|Fetch konten blog dan hit external API dari Cloud Functions. Mendukung timeout config yang penting untuk slow blog handling.|Infra|
|🤖 AI & EXTERNAL API|   |   |   |
|LLM / AI|Google Gemini 1.5 Flash|Gratis tier 15 RPM / 1jt token per hari. Diakses via Cloud Functions (bukan langsung dari Flutter). Ideal untuk ekstraksi bahan dari teks resep.|AI|
|YouTube Data|YouTube Data API v3|Ambil judul, deskripsi, dan transcript video resep. Gratis 10.000 unit/hari via Google Cloud Console.|AI|
|Recipe Data|TheMealDB API|Database resep gratis dengan endpoint search, filter kategori, dan detail resep lengkap. Untuk fitur Discover.|Free|
|📊 MONITORING & DEVTOOLS|   |   |   |
|Crash Reporting|Firebase Crashlytics|Real-time crash log dari device user. Penting untuk portfolio — menunjukkan production-readiness awareness.|Infra|
|Analytics|Firebase Analytics|Track screen views dan event usage (fitur mana yang paling sering dipakai). Gratis, terintegrasi dengan Firebase.|Infra|
|Version Control|Git + GitHub|Wajib untuk portofolio. Commit history yang rapi menunjukkan development process ke recruiter.|Infra|
|Code Quality|flutter_lints + dart format|Linting rules resmi Dart. Jalankan dart format sebelum commit. Menunjukkan coding standard yang baik.|Infra|
|Desain / Wireframe|Figma|Buat mockup screen sebelum coding. Kamu sudah familiar dan ini nilai plus di portofolio sebagai full-stack dev.|UX|

Legend:Corewajib adaAIfitur unggulan AIFreegratis / free tierInfradevops & toolingUX


using agile principles and software development life cycles (sldc)
