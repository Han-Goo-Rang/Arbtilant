# Debug: Scan Result Tidak Tersimpan

## Masalah

- Total Scan: 0 (tidak ada scan yang tersimpan)
- Feedback: 4 (feedback tersimpan)
- Foto: Tidak ada

## Root Cause

Error saat menyimpan scan result tidak di-rethrow di `hive_service.saveScanResult()`, sehingga error tertelan dan tidak terlihat.

## Perbaikan yang Dilakukan

### 1. Enhanced Error Handling di scan_page.dart

```dart
// Sebelumnya: Error tertelan
// Sekarang: Error ditampilkan ke user
try {
  final scanResult = await _scanHistoryService.saveScanResult(...);
} catch (e) {
  print("❌ Error saving scan result: $e");
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error saving scan: $e'))
  );
}
```

### 2. Detailed Logging di scan_history_service.dart

```dart
print("📸 Processing scan: $scanId");
print("📁 Saving image from: $imagePath");
print("✅ Image saved to: $permanentImagePath");
print("💾 Saving to Hive...");
print('✅ Scan result saved to Hive: $scanId');
```

### 3. Detailed Logging di image_storage_service.dart

```dart
print("📁 Checking temp file: $tempImagePath");
print("✅ Temp file exists, size: ${await tempFile.length()} bytes");
print("📋 Copying to: ${permanentFile.path}");
print('✅ Image saved: ${permanentFile.path} (${copiedSize} bytes)');
```

### 4. Fixed Error Handling di hive_service.dart

```dart
// Sebelumnya: Error tidak di-rethrow
Future<void> saveScanResult(ScanResultModel scanResult) async {
  try {
    await box.put(scanResult.id, scanResult.toJson());
  } catch (e) {
    print('❌ Error saving scan result: $e');
    // Error tertelan di sini!
  }
}

// Sekarang: Error di-rethrow
Future<void> saveScanResult(ScanResultModel scanResult) async {
  try {
    print('💾 Saving scan result to Hive: ${scanResult.id}');
    await box.put(scanResult.id, scanResult.toJson());
    print('✅ Scan result saved to Hive: ${scanResult.id}');
  } catch (e) {
    print('❌ Error saving scan result: $e');
    rethrow; // Error sekarang di-propagate
  }
}
```

## Flow Debugging

Sekarang saat melakukan scan, akan terlihat log:

```
✅ Image path: /data/user/0/com.app/documents/TANAMAN/1234567890.jpg
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
```

Jika ada error, akan terlihat:

```
❌ Error saving image: Permission denied
❌ Error in saveScanResult: Permission denied
❌ Error saving scan result: Permission denied
```

## Testing

1. Buka app
2. Lakukan scan
3. Lihat console log untuk debug info
4. Jika ada error, akan terlihat di snackbar
5. Buka History - scan harus muncul dengan foto

## Kemungkinan Error

1. **Permission Denied** - App tidak punya permission untuk write file
2. **Disk Full** - Storage penuh
3. **Hive Box Not Open** - Hive belum diinisialisasi
4. **Invalid Image Path** - Path foto tidak valid
