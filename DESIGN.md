# DESIGN.md — GroceryNotes AI
> Design system reference untuk Flutter developer & AI agent. Semua keputusan visual bersifat opinionated dan final kecuali ada catatan "OPTIONAL".

---

## 1. Filosofi Visual

**Satu kalimat:** GroceryNotes terasa seperti aplikasi perbankan premium yang pindah ke dapur — elegan, tipis, dan presisi, dengan sentuhan hijau organik yang hidup di balik layar, bukan di depannya.

**Prinsip:**
- White space adalah fitur, bukan kekosongan
- Warna hijau tidak pernah menjerit — dia berbisik dari belakang
- Setiap interaksi terasa ada bobotnya (haptic + micro-motion)
- Typography yang ketat adalah satu-satunya dekorasi yang diizinkan

---

## 2. Color Tokens

```dart
// lib/core/theme/app_colors.dart

// === BACKGROUND SYSTEM ===
const Color bgBase         = Color(0xFFFFFFFF); // Putih murni — canvas utama
const Color bgSurface      = Color(0xFFF7F9F7); // Off-white hijau sangat tipis — card background
const Color bgElevated     = Color(0xFFFFFFFF); // Card floating / modal
const Color bgOverlay      = Color(0x0A1A2E16); // Overlay scrim, 4% hitam

// === GREEN GRADIENT ORBS (background only) ===
// Dua orb gradasi — satu di kiri atas, satu di kanan bawah
// Jangan pernah gunakan warna ini sebagai solid fill UI element
const Color orbPrimary     = Color(0xFF4CAF6E); // Hijau segar, medium saturation
const Color orbSecondary   = Color(0xFF81C784); // Hijau muda, lebih terang
const Color orbTertiary    = Color(0xFFA5D6A7); // Hijau pale — fade edge orb

// === BRAND GREEN (UI elements) ===
const Color green500       = Color(0xFF2E7D52); // CTA button, active state, price positive
const Color green400       = Color(0xFF43A066); // Icon active, badge
const Color green100       = Color(0xFFE8F5EE); // Chip background, tag background
const Color green50        = Color(0xFFF1FAF5); // Subtle row highlight

// === NEUTRALS ===
const Color ink900         = Color(0xFF0D1412); // Heading utama
const Color ink700         = Color(0xFF374240); // Body text
const Color ink500         = Color(0xFF6B7775); // Placeholder, label sekunder
const Color ink300         = Color(0xFFB5BFBC); // Divider, border inactive
const Color ink100         = Color(0xFFE8EDEB); // Skeleton loader, disabled background

// === SEMANTIC ===
const Color success        = Color(0xFF2E7D52); // sama dengan green500
const Color warning        = Color(0xFFF59E0B); // harga naik, item hampir habis
const Color error          = Color(0xFFDC2626); // item tidak ditemukan, error
const Color warningBg      = Color(0xFFFEF3C7);
const Color errorBg        = Color(0xFFFEE2E2);
```

---

## 3. Background Orb System

Ini adalah **signature visual** GroceryNotes. Dua orb gaussian blur mengambang di background — tidak pernah bergerak agresif, hanya breathe.

```dart
// lib/widgets/background/orb_background.dart

// Orb 1 — Kiri Atas
// Position: top: -80px, left: -60px
// Size: 280x280
// Color: orbPrimary → orbSecondary (radial gradient)
// Opacity: 0.12
// Blur: sigma 60

// Orb 2 — Kanan Bawah  
// Position: bottom: -100px, right: -40px
// Size: 240x240
// Color: orbSecondary → orbTertiary (radial gradient)
// Opacity: 0.10
// Blur: sigma 50

// ATURAN KETAT:
// - Orb TIDAK boleh ada di dalam card/modal, hanya di Scaffold background
// - Opacity maksimum 0.15, jangan lebih
// - Jangan animate orb kecuali saat page transition (scale 0.95→1.0, 600ms ease)
// - Di dark mode (OPTIONAL): opacity turun ke 0.08
```

**Implementasi:**
```dart
Stack(
  children: [
    // Layer 1: Base white background
    Container(color: bgBase),
    
    // Layer 2: Orb kiri atas
    Positioned(
      top: -80, left: -60,
      child: _GreenOrb(size: 280, colors: [orbPrimary, orbSecondary], opacity: 0.12, blur: 60),
    ),
    
    // Layer 3: Orb kanan bawah
    Positioned(
      bottom: -100, right: -40,
      child: _GreenOrb(size: 240, colors: [orbSecondary, orbTertiary], opacity: 0.10, blur: 50),
    ),
    
    // Layer 4: Konten
    child,
  ],
)
```

---

## 4. Typography

Font: **Plus Jakarta Sans** (sudah terpasang di project)

```dart
// lib/core/theme/app_text_styles.dart

// === DISPLAY ===
// Untuk angka besar (total belanja, harga item)
displayLarge:  PlusJakartaSans, 32px, weight 700, letterSpacing -1.0, color ink900
displayMedium: PlusJakartaSans, 24px, weight 700, letterSpacing -0.8, color ink900

// === HEADING ===
headingL:  PlusJakartaSans, 20px, weight 600, letterSpacing -0.3, color ink900
headingM:  PlusJakartaSans, 17px, weight 600, letterSpacing -0.2, color ink900
headingS:  PlusJakartaSans, 15px, weight 600, letterSpacing -0.1, color ink900

// === BODY ===
bodyL:     PlusJakartaSans, 15px, weight 400, letterSpacing 0.0,  color ink700
bodyM:     PlusJakartaSans, 13px, weight 400, letterSpacing 0.0,  color ink700
bodyS:     PlusJakartaSans, 12px, weight 400, letterSpacing 0.1,  color ink500

// === LABEL (untuk tag, chip, badge) ===
labelM:    PlusJakartaSans, 12px, weight 500, letterSpacing 0.2,  color ink500
labelS:    PlusJakartaSans, 11px, weight 500, letterSpacing 0.3,  color ink500  (UPPERCASE)

// === PRICE / NUMBER (monospaced feel) ===
// Gunakan fontFeatures: [FontFeature.tabularFigures()]
priceL:    PlusJakartaSans, 20px, weight 700, tabular, color ink900
priceM:    PlusJakartaSans, 15px, weight 600, tabular, color ink900
```

**Aturan Typography:**
- Heading selalu `letterSpacing` negatif untuk kesan premium
- Harga dan angka selalu `tabular figures` agar tidak "loncat" saat update
- Jangan gunakan `weight 800` atau `weight 900` — terlalu kasar
- `UPPERCASE` hanya untuk label sekunder, bukan heading

---

## 5. Spacing & Layout

```dart
// lib/core/theme/app_spacing.dart

const double sp2  = 2.0;
const double sp4  = 4.0;
const double sp6  = 6.0;
const double sp8  = 8.0;
const double sp12 = 12.0;
const double sp16 = 16.0;
const double sp20 = 20.0;
const double sp24 = 24.0;
const double sp32 = 32.0;
const double sp40 = 40.0;
const double sp48 = 48.0;

// Screen horizontal padding: 20px (sp20)
// Section gap vertikal: 24px (sp24)
// Antar card dalam list: 10px
```

---

## 6. Border Radius

```dart
const double radiusXS  = 8.0;   // Tag, chip kecil
const double radiusS   = 12.0;  // Input field, tombol kecil
const double radiusM   = 16.0;  // Card standar, bottom sheet handle
const double radiusL   = 20.0;  // Card hero, modal
const double radiusXL  = 28.0;  // FAB, pill button besar
const double radiusFull = 999.0; // Badge, avatar, chip pill
```

---

## 7. Elevation & Shadow

GroceryNotes **tidak menggunakan drop shadow Material default**. Shadow digantikan dengan sistem berikut:

```dart
// Shadow sangat tipis, tone hijau — bukan abu-abu
// Ini yang membuat app terasa "fresh" bukan "flat Android"

// Level 1 — Card resting
BoxShadow(
  color: Color(0xFF2E7D52).withOpacity(0.06),
  blurRadius: 12,
  offset: Offset(0, 4),
)

// Level 2 — Card pressed / floating
BoxShadow(
  color: Color(0xFF2E7D52).withOpacity(0.10),
  blurRadius: 24,
  offset: Offset(0, 8),
)

// Level 3 — Modal / Bottom Sheet
BoxShadow(
  color: Color(0xFF0D1412).withOpacity(0.12),
  blurRadius: 40,
  offset: Offset(0, -4),
)
```

---

## 8. Grocery Card & List Item ⭐

Ini komponen paling penting. Dua varian:

### 8A. Grocery List Item (compact, dalam list)

```
┌─────────────────────────────────────────────────────┐
│  [checkbox]  [emoji/img]  Nama Item          Rp 0   │
│              Kategori • Qty: 1               [qty±] │
└─────────────────────────────────────────────────────┘
Height: 68px
Background: bgSurface (#F7F9F7)
Radius: radiusM (16px)
Padding: 12px horizontal, 10px vertikal
Shadow: Level 1
Margin bottom: 10px
```

**State visual:**
- **Default:** background bgSurface, checkbox border ink300
- **Checked/Done:** background white, nama item `TextDecoration.lineThrough`, opacity ink500, checkbox fill green500 dengan checkmark putih
- **Pressed:** scale 0.98, shadow Level 2, durasi 100ms
- **Swipe-left (delete):** reveal panel merah `error`, icon trash
- **Swipe-right (done):** reveal panel hijau `green100`, icon checkmark

**Haptic:**
- Check item → `HapticFeedback.lightImpact()`
- Swipe complete → `HapticFeedback.mediumImpact()`
- Long press (reorder) → `HapticFeedback.heavyImpact()`

```dart
// Struktur widget
GroceryListItem({
  required String name,
  required String category,
  required double price,      // 0 jika belum diisi
  required int quantity,
  required bool isChecked,
  String? emoji,              // misal "🥦" "🍎"
  VoidCallback? onTap,
  VoidCallback? onCheck,
  VoidCallback? onDelete,
})
```

### 8B. Grocery Card (expanded, untuk featured/AI suggestion)

```
┌─────────────────────────────────────────────────────┐
│  🤖 AI Suggestion                          [dismiss]│
│                                                     │
│  [Large emoji 40px]                                 │
│  Nama Produk                                        │
│  Deskripsi singkat dari AI, maks 2 baris            │
│                                                     │
│  Rp 12.000          [− 1 +]        [Tambah] →      │
└─────────────────────────────────────────────────────┘
Background: white
Border: 1px solid green100
Radius: radiusL (20px)
Padding: sp16
Shadow: Level 2
```

---

## 9. Tombol (Button System)

```dart
// PRIMARY — CTA utama
// Background: green500, radius radiusXL (28px)
// Text: white, headingS, letterSpacing -0.1
// Height: 52px
// Haptic: mediumImpact on press
// Pressed state: opacity 0.85, scale 0.98

// SECONDARY — Aksi pendukung  
// Background: green100, radius radiusXL
// Text: green500, headingS
// Height: 52px
// Haptic: lightImpact

// GHOST — Aksi tersier / destructive
// Background: transparent, border 1px ink300
// Text: ink700
// Height: 48px

// ICON BUTTON — Seperti di Image 4 (arrow buttons)
// Background: bgSurface (#F7F9F7)
// Border radius: radiusFull (circle)
// Size: 44x44px
// Icon: 20px, ink700
// Haptic: lightImpact
// Pressed: background ink100

// FAB (Add Item)
// Background: green500, gradient ringan ke green400
// Size: 56px circle
// Icon: plus, 24px, white
// Shadow: Level 2 + hijau
// Haptic: mediumImpact
```

---

## 10. Input Field

```dart
// Style: outlined dengan border tipis, bukan filled
// Background: white
// Border default: 1.5px solid ink300, radius radiusS (12px)
// Border focused: 1.5px solid green500
// Border error: 1.5px solid error

// Label: bodyS, ink500, animasi float ke atas saat focused
// Helper text: bodyS, ink500
// Error text: bodyS, error color

// Search field (khusus):
// Background: bgSurface
// No border — hanya shadow Level 1
// Prefix: search icon ink300
// Suffix: mic icon (AI voice input) green400
// Radius: radiusFull (pill shape)
// Height: 48px
```

---

## 11. Bottom Navigation Bar

Referensi: Image 1 & Image 3

```dart
// Background: white dengan blur backdrop (frosted glass)
// Border top: 1px solid ink100
// Height: 60px + safe area bottom
// Items: 4 (Home, Lists, AI Scan, Profile)

// Item INACTIVE:
// Icon: 22px, ink300
// Label: labelS, ink300

// Item ACTIVE:
// Icon: 22px, green500
// Label: labelS, green500, weight 600
// Indicator pill: green50 background, radius radiusFull
//   Width: 40px, Height: 28px (behind icon)

// Haptic saat switch tab: selectionClick
```

---

## 12. Haptic Feedback Map

```dart
// Gunakan package: flutter/services.dart HapticFeedback

// LIGHT — interaksi ringan tanpa konsekuensi
HapticFeedback.lightImpact()
// Trigger: tap icon button, switch toggle, tab navigation, dismiss chip

// MEDIUM — aksi yang mengubah state
HapticFeedback.mediumImpact()  
// Trigger: check/uncheck item, add to list, submit form, FAB tap

// HEAVY — aksi signifikan / destructive
HapticFeedback.heavyImpact()
// Trigger: delete item confirm, long-press reorder, clear all list

// SELECTION — navigasi / pilih
HapticFeedback.selectionClick()
// Trigger: bottom nav tab switch, dropdown select, date picker scroll

// VIBRATE — notifikasi / alert
HapticFeedback.vibrate()
// Trigger: AI selesai generate list, error state (pakai sparingly)

// ATURAN:
// - Jangan haptic pada animasi auto/passive (skeleton load, page enter)
// - Jangan double-haptic (jika satu aksi sudah haptic, child-nya jangan lagi)
// - iOS: HapticFeedback.* langsung mapping ke UIImpactFeedbackGenerator
// - Android: pastikan `android:hapticFeedbackEnabled="true"` di manifest
```

---

## 13. Animation & Motion

```dart
// DURASI STANDAR
const Duration durationFast   = Duration(milliseconds: 100); // Pressed state
const Duration durationNormal = Duration(milliseconds: 200); // State change, toggle
const Duration durationSlow   = Duration(milliseconds: 350); // Page transition, modal
const Duration durationXSlow  = Duration(milliseconds: 500); // Onboarding, hero

// CURVE STANDAR
// Masuk (enter): Curves.easeOut
// Keluar (exit): Curves.easeIn
// Spring (bounce kecil): Curves.elasticOut dengan tension rendah
// Emphasis: Curves.easeInOutCubic

// MICRO-INTERACTIONS WAJIB:
// 1. Card press: scale 0.98, 100ms easeIn → scale 1.0, 150ms easeOut
// 2. Checkbox check: scale 0→1 pada ikon centang, 200ms elasticOut
// 3. FAB: scale 1.0→1.08→1.0 saat item berhasil ditambah (200ms)
// 4. Swipe reveal: friction curve, tidak linear
// 5. Number update (quantity/price): AnimatedSwitcher, slide up

// PAGE TRANSITIONS:
// Push: slide kanan ke kiri + fade (300ms easeOut)
// Pop: slide kiri ke kanan + fade (250ms easeIn)
// Modal/Bottom sheet: slide bawah ke atas + fade (350ms easeOut)

// JANGAN gunakan:
// - Bounce besar (terasa mainan)
// - Rotation animation pada item list
// - Parallax yang dalam pada scroll biasa
```

---

## 14. AI-Specific Components

### AI Thinking Indicator
```
Bukan spinner biasa. Tiga titik hijau dengan pulse staggered:
● ● ●  → titik 1 pulse → titik 2 pulse → titik 3 pulse (loop)
Color: green400
Size titik: 6px
Gap: 4px
Durasi satu siklus: 900ms
```

### AI Suggestion Banner
```
Background: linear gradient horizontal, green50 → white
Border left: 3px solid green400
Radius: radiusM
Icon: sparkle ✨ atau robot icon, green500
Text: bodyM, ink700
Dismiss button: X, ink300
```

### AI Voice Input (saat aktif)
```
Mic icon berubah menjadi waveform animasi
Background tombol: green500 (dari bgSurface)
Waveform: 5 bar hijau muda dengan height animasi random
Haptic: lightImpact setiap 0.5 detik selama recording
```

---

## 15. Empty States

```
Jangan gunakan ilustrasi generik sedih.
Gunakan emoji besar (64px) + heading + bodytext + CTA button.

Empty list:
  🛒 "Belum ada belanjaan"
  "Tambah item manual atau minta AI buatkan list untuk kamu."
  [Tanya AI] [Tambah Manual]

No results search:
  🔍 "Tidak ketemu"
  "Coba kata kunci lain, atau tambahkan sendiri."
  [Tambah "[keyword]"]

List selesai semua:
  ✅ "Semua item sudah dibeli!"
  "Kerja bagus. Simpan list ini sebagai template?"
  [Simpan Template] [Tutup]
```

---

## 16. Dark Mode (OPTIONAL — implementasi belakangan)

```dart
// Jika diimplementasi, jangan inversi semua warna.
// Prinsip: background gelap tapi orb tetap ada, lebih tipis.

bgBase dark:    Color(0xFF0E1512)  // hijau sangat gelap, bukan hitam murni
bgSurface dark: Color(0xFF161E19)
ink900 dark:    Color(0xFFF0F5F2)  // teks utama di dark
orbOpacity dark: 0.08 (lebih tipis dari light mode)
```

---

## 17. Do's & Don'ts

**DO:**
- ✅ Gunakan whitespace agresif antar section
- ✅ Konsisten gunakan radiusM untuk semua card
- ✅ Selalu pair haptic dengan aksi yang mengubah state
- ✅ Gunakan tabular figures untuk semua angka/harga
- ✅ Orb hanya di Scaffold background layer paling bawah

**DON'T:**
- ❌ Jangan gunakan Material default `elevation` (pakai shadow custom)
- ❌ Jangan animasi orb secara terus-menerus (hanya saat transition)
- ❌ Jangan gunakan `Colors.green` built-in Flutter — selalu pakai token
- ❌ Jangan border radius kurang dari 8px pada elemen interaktif
- ❌ Jangan stack lebih dari 2 warna hijau berbeda dalam satu screen section
- ❌ Jangan haptic pada gesture scroll biasa

---

*DESIGN.md v1.0 — GroceryNotes AI*  
*Font: Plus Jakarta Sans | Maintained by: AI Agent*
