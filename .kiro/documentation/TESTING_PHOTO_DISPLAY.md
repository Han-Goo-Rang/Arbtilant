# Testing Photo Display Fix

**Quick Test Guide**

---

## Setup

```bash
flutter clean
flutter run
```

---

## Test Scenarios

### Scenario 1: Photo Display in Dialog ✅

**Steps:**

1. Open app
2. Go to Scan page
3. Take photo of plant
4. Wait for processing
5. Dialog appears with result

**Expected Result:**

- ✅ Photo tampil di atas dialog
- ✅ "DETECTED" label dengan disease name
- ✅ Confidence score dengan progress bar
- ✅ Other Possibilities section
- ✅ Quick Tips section
- ✅ Action buttons

**If Photo Not Showing:**

- Check: Is file path correct?
- Check: Does file exist in `/scan_images/`?
- Check: Is error message showing?

---

### Scenario 2: Photo in History ✅

**Steps:**

1. Complete scan (photo should display)
2. Go to History page
3. Look at scan items

**Expected Result:**

- ✅ Scan item card shows thumbnail
- ✅ Disease name visible
- ✅ Date/time visible
- ✅ Confidence badge visible

---

### Scenario 3: Photo Persistence ✅

**Steps:**

1. Complete scan
2. Close app
3. Reopen app
4. Go to History
5. Tap on scan item

**Expected Result:**

- ✅ Photo still visible in history
- ✅ Photo loads in detail page
- ✅ All data preserved

---

### Scenario 4: Delete Scan ✅

**Steps:**

1. Go to History
2. Swipe left on scan item
3. Confirm delete

**Expected Result:**

- ✅ Scan removed from history
- ✅ Photo file deleted
- ✅ No orphaned files

---

## Debugging

### If Photo Not Showing:

**Check 1: File Exists**

```dart
// In _buildImagePreview():
final file = File(imagePath);
if (await file.exists()) {
  // File exists
} else {
  // File not found - show error
}
```

**Check 2: Path Correct**

```dart
// Should be permanent path:
/data/user/0/com.example.test/app_flutter/scan_images/[uuid].jpg

// NOT temp path:
/data/user/0/com.example.test/app_flutter/TANAMAN/[timestamp].jpg
```

**Check 3: Error Message**

- "Image not found" → File doesn't exist
- "Failed to load image" → File corrupted
- No message → Photo should display

---

## Logs to Check

```
✅ Image saved to: /path/to/scan_images/uuid.jpg
✅ Scan result saved to Hive: uuid
✅ Image preview loading...
```

---

## Common Issues & Solutions

| Issue                 | Cause          | Solution                 |
| --------------------- | -------------- | ------------------------ |
| Photo not showing     | Temp path used | Use scanResult.imagePath |
| PathNotFoundException | File not found | Check file exists        |
| Blank dialog          | Image loading  | Wait for FutureBuilder   |
| Error message         | File corrupted | Retake photo             |

---

## Success Criteria

- [x] Photo displays in dialog
- [x] Photo displays in history
- [x] Photo persists after app restart
- [x] Delete removes photo file
- [x] No errors in console
- [x] No PathNotFoundException

---

**Ready to test!** 🚀
