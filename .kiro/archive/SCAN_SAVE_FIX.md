# Fix: Scan Result Tidak Tersimpan - Root Cause & Solution

## Root Cause Analysis

### Masalah Utama: Missing Android Permissions

Foto tidak bisa disimpan karena **AndroidManifest.xml tidak memiliki permission** untuk:

- `WRITE_EXTERNAL_STORAGE` - Menulis file ke storage
- `READ_EXTERNAL_STORAGE` - Membaca file dari storage
- `CAMERA` - Menggunakan kamera

Tanpa permission ini, saat app mencoba menyimpan foto, akan mendapat error "Permission Denied".

### Secondary Issue: Error Handling

Error saat menyimpan tidak di-rethrow di `hive_service.saveScanResult()`, sehingga error tertelan dan tidak terlihat.

---

## Perbaikan yang Dilakukan

### 1. Added Android Permissions

**File:** `android/app/src/main/AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.INTERNET" />
```

### 2. Enhanced Error Handling & Logging

#### scan_page.dart - \_takePicture()

```dart
// Sebelumnya: Tidak ada verifikasi file
await img.saveTo(filePath);
return filePath;

// Sekarang: Verifikasi file dan logging
print("📷 Taking picture...");
await img.saveTo(filePath);

// Verify file was saved
final file = File(filePath);
if (!await file.exists()) {
  throw Exception('Failed to save picture to $filePath');
}
final fileSize = await file.length();
print("✅ Picture saved successfully (${fileSize} bytes)");
```

#### scan_page.dart - \_handleScan()

```dart
// Sebelumnya: Error tertelan
final scanResult = await _scanHistoryService.saveScanResult(...);

// Sekarang: Error ditampilkan ke user
try {
  final scanResult = await _scanHistoryService.saveScanResult(...);
  print("✅ Scan result saved: ${scanResult.id}");
} catch (e) {
  print("❌ Error saving scan result: $e");
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error saving scan: $e'))
  );
}
```

#### scan_history_service.dart

```dart
// Detailed logging di setiap step
print("📸 Processing scan: $scanId");
print("📁 Saving image from: $imagePath");
print("✅ Image saved to: $permanentImagePath");
print("💾 Saving to Hive...");
print('✅ Scan result saved to Hive: $scanId');
```

#### image_storage_service.dart

```dart
// Verifikasi file copy
print("📁 Checking temp file: $tempImagePath");
print("✅ Temp file exists, size: ${await tempFile.length()} bytes");
print("📋 Copying to: ${permanentFile.path}");

// Verify file was copied
if (!await permanentFile.exists()) {
  throw Exception('Failed to copy image to permanent location');
}
```

#### hive_service.dart

```dart
// Sebelumnya: Error tidak di-rethrow
catch (e) {
  print('❌ Error saving scan result: $e');
  // Error tertelan di sini!
}

// Sekarang: Error di-rethrow
catch (e) {
  print('❌ Error saving scan result: $e');
  rethrow; // Error sekarang di-propagate
}
```

---

## Flow Debugging

Sekarang saat melakukan scan, akan terlihat log detail:

```
✅ Image path: /data/user/0/com.app/documents/TANAMAN/1234567890.jpg
📷 Taking picture...
✅ Picture taken, saving to: /data/user/0/com.app/documents/TANAMAN/1234567890.jpg
✅ Picture saved successfully (2048576 bytes)
✅ Prediction results: 3 predictions
✅ Disease ID: disease-123
📸 Processing scan: uuid-1234
📁 Saving image from: /data/user/0/com.app/documents/TANAMAN/1234567890.jpg
📁 Checking temp file: /data/user/0/com.app/documents/TANAMAN/1234567890.jpg
✅ Temp file exists, size: 2048576 bytes
📋 Copying to: /data/user/0/com.app/documents/scan_images/uuid-1234.jpg
✅ Image saved: /data/user/0/com.app/documents/scan_images/uuid-1234.jpg (2048576 bytes)
💾 Saving to Hive...
✅ Scan result saved to Hive: uuid-1234
✅ Scan result saved: uuid-1234
```

---

## Testing Steps

1. **Clean Build**

   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Grant Permissions**

   - Saat app pertama kali buka, izinkan permission untuk camera dan storage

3. **Test Scanning**

   - Buka app
   - Tap "Scan" button
   - Ambil foto
   - Lihat console log untuk debug info
   - Jika ada error, akan terlihat di snackbar merah

4. **Verify History**
   - Buka History page
   - Scan harus muncul dengan foto
   - Feedback juga harus ada

---

## Kemungkinan Error & Solusi

| Error                  | Penyebab                   | Solusi                               |
| ---------------------- | -------------------------- | ------------------------------------ |
| Permission Denied      | Permission belum diberikan | Izinkan permission di app settings   |
| Camera not initialized | Camera belum siap          | Tunggu camera initialization selesai |
| Failed to save picture | Storage penuh              | Bersihkan storage                    |
| Hive box not open      | Hive belum diinisialisasi  | Restart app                          |
| Image file not found   | File dihapus sebelum copy  | Cek permission dan storage           |

---

## Summary

**Masalah:** Scan result tidak tersimpan (Total Scan = 0)  
**Root Cause:** Missing Android permissions + Error handling yang buruk  
**Solusi:**

1. Tambah permission di AndroidManifest.xml
2. Enhanced error handling & logging di semua service
3. Verifikasi file di setiap step

**Hasil:** Scan result sekarang akan tersimpan dengan foto dan feedback
