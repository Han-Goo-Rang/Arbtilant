# Analysis: Hive vs PowerSync untuk Arbtilant

**Date:** December 21, 2025

---

## Current Issue: Foto Hasil Scan Tidak Tampil

### Root Cause Analysis

**Problem Flow:**

1. User scan tanaman → foto diambil ke temp location (`/data/user/0/com.example.test/app_flutter/TANAMAN/`)
2. Foto dipindahkan ke permanent location (`/data/user/0/com.example.test/app_flutter/scan_images/`)
3. Path disimpan di Hive
4. Dialog ditampilkan dengan `_imagePath` (temp path)
5. **ISSUE:** Dialog menggunakan temp path, bukan permanent path!

**Current Code Issue:**

```dart
// In scan_page.dart _handleScan():
_imagePath = await _takePicture();  // Temp path
// ...
final scanResult = await _scanHistoryService.saveScanResult(
  imagePath: _imagePath!,  // Temp path disimpan
  // ...
);

// Dialog ditampilkan dengan _imagePath (temp path)
_showResultBottomSheet(results, diseaseId, scanResult);
// Dialog menggunakan _imagePath, bukan scanResult.imagePath!
```

**Solution:**

```dart
// Pass scanResult ke dialog, gunakan scanResult.imagePath
_showResultBottomSheet(results, diseaseId, scanResult);

// Di dialog, gunakan scanResult.imagePath (permanent path)
if (scanResult.imagePath != null)
  _buildImagePreview(scanResult.imagePath)
```

---

## Hive vs PowerSync Comparison

### 1. HIVE (Current Solution)

**What it is:**

- Local-only database
- Stores data on device
- No cloud sync
- Fast, lightweight

**Pros:**

- ✅ Simple to implement
- ✅ Fast local access
- ✅ No internet required
- ✅ Good for offline-first
- ✅ Already integrated in Arbtilant
- ✅ Low overhead

**Cons:**

- ❌ No cloud backup
- ❌ No real-time sync
- ❌ Data lost if app uninstalled
- ❌ No multi-device sync
- ❌ Manual backup needed

**Use Case:**

- Local caching
- Offline-first apps
- Single device usage
- Simple data persistence

---

### 2. POWERSYNC (Alternative)

**What it is:**

- Sync engine for offline-first apps
- Syncs with backend (Supabase, Firebase, etc.)
- Real-time sync
- Conflict resolution

**Pros:**

- ✅ Cloud backup
- ✅ Real-time sync
- ✅ Multi-device sync
- ✅ Offline-first ready
- ✅ Automatic conflict resolution
- ✅ Data persistence across reinstalls

**Cons:**

- ❌ More complex setup
- ❌ Requires backend configuration
- ❌ Internet dependency for sync
- ❌ Higher overhead
- ❌ Learning curve
- ❌ Additional costs (PowerSync service)

**Use Case:**

- Multi-device sync
- Real-time collaboration
- Cloud backup required
- Complex offline-first scenarios

---

## Recommendation for Arbtilant

### Current Phase: STICK WITH HIVE ✅

**Why:**

1. **Foto Issue** - Bukan masalah Hive, tapi image path handling

   - Fix: Gunakan `scanResult.imagePath` di dialog, bukan `_imagePath`
   - Foto akan tampil dengan benar

2. **Arbtilant Use Case** - Single user, single device

   - User scan tanaman di satu device
   - Tidak perlu multi-device sync
   - Tidak perlu real-time collaboration
   - Hive sudah cukup

3. **Complexity** - Hive lebih simple

   - Sudah terintegrasi
   - Tidak perlu backend setup
   - Tidak perlu PowerSync account
   - Faster development

4. **Cost** - Hive gratis
   - PowerSync ada biaya
   - Supabase ada biaya
   - Hive tidak ada biaya

---

## Future: PowerSync Integration (Optional)

### When to Consider PowerSync:

1. **Multi-Device Sync**

   - User ingin akses scan history di multiple devices
   - Sync otomatis antar device

2. **Cloud Backup**

   - User ingin backup data ke cloud
   - Data tidak hilang jika app uninstalled

3. **Real-Time Collaboration**

   - Multiple users share garden data
   - Real-time updates

4. **Advanced Features**
   - Offline-first dengan sync
   - Conflict resolution
   - Data versioning

### Implementation Path (If Needed):

```
Phase 1: Current (Hive)
├─ Local storage ✅
├─ Offline-first ✅
└─ Single device ✅

Phase 2: Future (PowerSync)
├─ Add Supabase backend
├─ Setup PowerSync sync
├─ Multi-device support
└─ Cloud backup
```

---

## Action Items

### Immediate (Fix Foto Issue):

1. **Update scan_page.dart:**

   ```dart
   // Pass scanResult ke dialog
   _showResultBottomSheet(results, diseaseId, scanResult);

   // Di dialog, gunakan scanResult.imagePath
   if (scanResult.imagePath != null)
     _buildImagePreview(scanResult.imagePath)
   ```

2. **Update \_buildImagePreview:**

   ```dart
   Widget _buildImagePreview(String imagePath) {
     final file = File(imagePath);
     // ... existing error handling
   }
   ```

3. **Test:**
   - Scan tanaman
   - Foto harus tampil di dialog
   - Foto harus tersimpan di history

### Future (If PowerSync Needed):

1. Setup Supabase project
2. Configure PowerSync
3. Implement sync logic
4. Add multi-device support

---

## Summary

| Aspect         | Hive       | PowerSync   |
| -------------- | ---------- | ----------- |
| Setup          | Simple     | Complex     |
| Cost           | Free       | Paid        |
| Offline        | ✅         | ✅          |
| Sync           | ❌         | ✅          |
| Multi-Device   | ❌         | ✅          |
| Cloud Backup   | ❌         | ✅          |
| Learning Curve | Low        | High        |
| Arbtilant Fit  | ✅ Perfect | ⚠️ Overkill |

**Recommendation:** Gunakan Hive untuk sekarang. Fix foto issue dengan update image path handling. PowerSync bisa di-add nanti jika ada requirement untuk multi-device sync atau cloud backup.

---

**Next Step:** Fix foto issue di scan_page.dart dengan menggunakan `scanResult.imagePath` di dialog.
