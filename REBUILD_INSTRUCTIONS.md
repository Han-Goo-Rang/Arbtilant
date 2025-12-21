# Rebuild Instructions - UI Redesign Update

## Untuk Melihat Perubahan UI di Hape

Karena ada perubahan signifikan di home_page.dart, Anda perlu melakukan rebuild lengkap:

### Step 1: Bersihkan Build Cache

```bash
flutter clean
```

### Step 2: Hapus Aplikasi dari Hape

- Buka Settings → Apps
- Cari "Arbtilant"
- Tap "Uninstall"
- Atau: Long press app icon → Uninstall

### Step 3: Rebuild dan Deploy

```bash
flutter pub get
flutter run
```

Atau jika menggunakan Android Studio:

- Build → Clean Project
- Run → Run 'main.dart'

---

## Apa yang Berubah di Home Page

### Sebelumnya:

- Hero section dengan gradient besar
- 3 feature cards (Scan, Library, History)
- Quick Stats dengan 3 items

### Sekarang (Sesuai Mockup):

- Welcome section dengan user profile
- Greeting card "Good Morning, Green Thumb"
- Stats cards: SAVED (12), ACTIVITY (5), PEND (2)
- Quick Actions section dengan 3 cards:
  - Diagnose Disease (full width)
  - Encyclopedia (half width)
  - My Garden (half width)

---

## Troubleshooting

### Jika masih tidak berubah:

1. Pastikan sudah `flutter clean`
2. Pastikan sudah hapus app dari hape
3. Cek di Android Studio: Build → Rebuild Project
4. Restart emulator/hape

### Jika ada error saat run:

```bash
flutter pub get
flutter pub upgrade
flutter run --verbose
```

---

## Verifikasi Perubahan

Setelah rebuild, Anda akan melihat:

- ✅ Welcome section di atas
- ✅ Greeting card dengan gradient hijau
- ✅ 3 stat cards (SAVED, ACTIVITY, PEND)
- ✅ Quick Actions section dengan 3 cards
- ✅ Bottom navigation dengan 4 tabs

Semua sesuai dengan mockup di `.kiro/specs/mockup/arbtilant_home_page/screen.png`

---

**Last Updated:** December 21, 2025
