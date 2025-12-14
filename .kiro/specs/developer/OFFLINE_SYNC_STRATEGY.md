# 🛡️ Offline & Sync Strategy - Arbtilant Enhancement

## Overview

Strategi offline-first dengan cloud sync untuk memastikan aplikasi tetap berfungsi tanpa internet.

---

## 🏗️ Architecture

### Local-First Approach

```
┌─────────────────────────────────────┐
│         Flutter App                 │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│      Local SQLite (Primary)         │
│  - Diseases                         │
│  - Scan Results                     │
│  - Feedback                         │
│  - Model Metadata                   │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│      Sync Queue (Pending)           │
│  - Unsync feedback                  │
│  - Unsync scan results              │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│    Supabase (Cloud - Secondary)     │
│  - Diseases (read-only)             │
│  - Scan Results (append-only)       │
│  - Feedback (append-only)           │
│  - Model Versions (read-only)       │
└─────────────────────────────────────┘
```

---

## 📊 Local SQLite Schema

### diseases_local

```sql
CREATE TABLE diseases_local (
  id TEXT PRIMARY KEY,
  slug TEXT UNIQUE,
  name TEXT,
  english_name TEXT,
  scientific_names TEXT,
  description TEXT,
  symptoms TEXT,
  causes TEXT,
  treatment TEXT,
  prevention TEXT,
  severity TEXT,
  category TEXT,
  affected_plants TEXT,
  image_url TEXT,
  synced BOOLEAN DEFAULT TRUE,
  created_at TEXT,
  updated_at TEXT
);
```

### scan_results_local

```sql
CREATE TABLE scan_results_local (
  id TEXT PRIMARY KEY,
  disease_id TEXT,
  image_path TEXT,
  predicted_label TEXT,
  confidence REAL,
  top_3_predictions TEXT,
  model_version TEXT,
  synced BOOLEAN DEFAULT FALSE,
  created_at TEXT
);
```

### user_feedback_local

```sql
CREATE TABLE user_feedback_local (
  id TEXT PRIMARY KEY,
  scan_result_id TEXT,
  disease_id TEXT,
  is_correct BOOLEAN,
  corrected_disease_id TEXT,
  feedback_text TEXT,
  synced BOOLEAN DEFAULT FALSE,
  created_at TEXT
);
```

### model_versions_local

```sql
CREATE TABLE model_versions_local (
  id TEXT PRIMARY KEY,
  version TEXT UNIQUE,
  model_path TEXT,
  labels_path TEXT,
  accuracy REAL,
  is_active BOOLEAN,
  is_fallback BOOLEAN,
  synced BOOLEAN DEFAULT TRUE,
  created_at TEXT
);
```

### sync_queue

```sql
CREATE TABLE sync_queue (
  id TEXT PRIMARY KEY,
  table_name TEXT NOT NULL,
  operation TEXT NOT NULL,
  record_id TEXT NOT NULL,
  data TEXT NOT NULL,
  retry_count INT DEFAULT 0,
  created_at TEXT,
  synced BOOLEAN DEFAULT FALSE
);
```

---

## 🔄 Sync Scenarios

### Scenario 1: Online Mode

```
User Action (e.g., Save Feedback)
    ↓
Save to Local SQLite
    ↓
Immediately Sync to Supabase
    ├─ Success → Mark as synced
    └─ Fail → Add to sync queue
    ↓
Show Confirmation
```

**Implementation:**

```dart
Future<void> saveFeedback(Feedback feedback) async {
  // 1. Save to local
  await storage.saveFeedback(feedback);

  // 2. Try to sync
  try {
    await supabase.from('user_feedback').insert(feedback.toJson());
    await storage.markAsSynced('user_feedback', feedback.id);
  } catch (e) {
    // Add to queue for later
    await storage.addToSyncQueue('user_feedback', 'INSERT', feedback);
  }
}
```

---

### Scenario 2: Offline Mode

```
User Action (e.g., Save Feedback)
    ↓
Save to Local SQLite
    ↓
Add to Sync Queue
    ↓
Show "Offline" Badge
    ↓
Mark as Pending
```

**Implementation:**

```dart
Future<void> saveFeedbackOffline(Feedback feedback) async {
  // 1. Save to local
  await storage.saveFeedback(feedback);

  // 2. Add to queue
  await storage.addToSyncQueue('user_feedback', 'INSERT', feedback);

  // 3. Update UI
  _syncStatusController.add(SyncStatus.pending);
}
```

---

### Scenario 3: Sync When Online

```
App Detects Online
    ↓
Get Pending Items from Queue
    ↓
For Each Item:
  ├─ Try to Sync to Supabase
  ├─ If Success → Remove from Queue
  ├─ If Fail → Increment Retry Count
  └─ If Max Retries → Log Error
    ↓
Update Sync Status
    ↓
Show Notification
```

**Implementation:**

```dart
Future<void> syncPending() async {
  final pending = await storage.getPendingItems();

  for (final item in pending) {
    try {
      // Sync to Supabase
      await _syncItem(item);

      // Remove from queue
      await storage.removeFromQueue(item.id);

      // Update status
      _syncStatusController.add(SyncStatus.synced);
    } catch (e) {
      // Increment retry count
      await storage.incrementRetryCount(item.id);

      // If max retries exceeded, log error
      if (item.retryCount >= maxRetries) {
        logger.error('Sync failed for ${item.id}: $e');
      }
    }
  }
}
```

---

## 📱 Data Sync Flow

### Initial Sync (App Start)

```
App Starts
    ↓
Check Internet Connection
    ├─ Online:
    │   ├─ Fetch diseases from Supabase
    │   ├─ Fetch model versions from Supabase
    │   ├─ Save to local SQLite
    │   └─ Sync pending items
    │
    └─ Offline:
        └─ Load from local SQLite
    ↓
Display UI
```

### Periodic Sync (Every 5 minutes)

```
Timer Triggers (Every 5 min)
    ↓
Check Internet Connection
    ├─ Online:
    │   ├─ Sync pending items
    │   ├─ Check for new diseases
    │   ├─ Check for model updates
    │   └─ Update local cache
    │
    └─ Offline:
        └─ Skip sync
    ↓
Update Sync Status
```

### Manual Sync (User Triggered)

```
User Taps "Sync" Button
    ↓
Check Internet Connection
    ├─ Online:
    │   ├─ Sync all pending items
    │   ├─ Fetch latest data
    │   └─ Show progress
    │
    └─ Offline:
        └─ Show "No Internet" message
    ↓
Show Result
```

---

## 🔀 Conflict Resolution

### Strategy: Last-Write-Wins

```dart
Future<void> resolveConflict(
  String table,
  String recordId,
  Map<String, dynamic> localData,
  Map<String, dynamic> cloudData,
) async {
  final localTimestamp = DateTime.parse(localData['updated_at']);
  final cloudTimestamp = DateTime.parse(cloudData['updated_at']);

  if (localTimestamp.isAfter(cloudTimestamp)) {
    // Local is newer - use local
    await supabase.from(table).update(localData).eq('id', recordId);
  } else {
    // Cloud is newer - use cloud
    await storage.updateLocal(table, cloudData);
  }
}
```

### Conflict Scenarios

1. **User edits offline, then online**

   - Local timestamp > Cloud timestamp
   - Use local data
   - Sync to cloud

2. **Admin updates cloud while user offline**

   - Cloud timestamp > Local timestamp
   - Use cloud data
   - Update local

3. **Both updated at same time**
   - Use cloud data (server is source of truth)
   - Log conflict for review

---

## 🔔 Sync Status Indicators

### UI Indicators

```dart
enum SyncStatus {
  synced,      // ✅ All synced
  syncing,     // 🔄 Currently syncing
  pending,     // ⏳ Pending sync
  error,       // ❌ Sync error
  offline,     // 📴 No internet
}
```

### Implementation

```dart
class SyncIndicator extends StatelessWidget {
  final SyncStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case SyncStatus.synced:
        return Icon(Icons.check_circle, color: Colors.green);
      case SyncStatus.syncing:
        return SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(),
        );
      case SyncStatus.pending:
        return Icon(Icons.schedule, color: Colors.orange);
      case SyncStatus.error:
        return Icon(Icons.error, color: Colors.red);
      case SyncStatus.offline:
        return Icon(Icons.cloud_off, color: Colors.grey);
    }
  }
}
```

---

## ⚠️ Error Handling

### Network Errors

```dart
try {
  await supabase.from('user_feedback').insert(feedback.toJson());
} on SocketException {
  // Network error - queue for later
  await storage.addToSyncQueue('user_feedback', 'INSERT', feedback);
  showSnackBar('Offline - will sync when online');
} on TimeoutException {
  // Timeout - retry later
  await storage.addToSyncQueue('user_feedback', 'INSERT', feedback);
  showSnackBar('Timeout - will retry later');
}
```

### Validation Errors

```dart
try {
  final feedback = Feedback.fromJson(json);
  await storage.saveFeedback(feedback);
} on FormatException {
  // Invalid data - log & skip
  logger.error('Invalid feedback data: $json');
  showSnackBar('Invalid data - skipped');
}
```

### Storage Errors

```dart
try {
  await storage.saveFeedback(feedback);
} on DatabaseException {
  // Database error - show error
  logger.error('Database error: $e');
  showSnackBar('Storage error - please try again');
}
```

---

## 🔐 Data Integrity

### Validation Before Sync

```dart
bool isValidFeedback(Feedback feedback) {
  return feedback.id != null &&
      feedback.scanResultId != null &&
      feedback.diseaseId != null &&
      feedback.createdAt != null;
}

Future<void> syncFeedback(Feedback feedback) async {
  if (!isValidFeedback(feedback)) {
    logger.error('Invalid feedback: $feedback');
    return;
  }

  await supabase.from('user_feedback').insert(feedback.toJson());
}
```

### Duplicate Prevention

```dart
Future<void> saveFeedback(Feedback feedback) async {
  // Check if already exists
  final existing = await storage.getFeedback(feedback.id);
  if (existing != null) {
    logger.warn('Feedback already exists: ${feedback.id}');
    return;
  }

  await storage.saveFeedback(feedback);
}
```

---

## 📊 Sync Queue Management

### Add to Queue

```dart
Future<void> addToSyncQueue(
  String tableName,
  String operation,
  Map<String, dynamic> data,
) async {
  final queueItem = SyncQueueItem(
    id: uuid.v4(),
    tableName: tableName,
    operation: operation,
    data: data,
    retryCount: 0,
    createdAt: DateTime.now(),
  );

  await storage.insertSyncQueue(queueItem);
}
```

### Process Queue

```dart
Future<void> processSyncQueue() async {
  final items = await storage.getSyncQueue();

  for (final item in items) {
    try {
      await _syncItem(item);
      await storage.removeSyncQueue(item.id);
    } catch (e) {
      if (item.retryCount < maxRetries) {
        await storage.incrementRetryCount(item.id);
      } else {
        logger.error('Max retries exceeded for ${item.id}');
      }
    }
  }
}
```

### Retry Logic

```dart
const maxRetries = 3;
const retryDelays = [1, 5, 15]; // minutes

Future<void> retrySync(SyncQueueItem item) async {
  if (item.retryCount >= maxRetries) {
    logger.error('Max retries exceeded');
    return;
  }

  final delay = retryDelays[item.retryCount];
  await Future.delayed(Duration(minutes: delay));

  await _syncItem(item);
}
```

---

## 🔄 Sync Service Implementation

### Basic Structure

```dart
class SyncService {
  final StorageService storage;
  final SupabaseClient supabase;
  final _syncStatusController = StreamController<SyncStatus>();

  Stream<SyncStatus> get syncStatus => _syncStatusController.stream;

  // Periodic sync timer
  Timer? _syncTimer;

  void startPeriodicSync() {
    _syncTimer = Timer.periodic(Duration(minutes: 5), (_) {
      syncPending();
    });
  }

  void stopPeriodicSync() {
    _syncTimer?.cancel();
  }

  Future<void> syncPending() async {
    // Implementation
  }
}
```

---

## 📋 Sync Checklist

- [ ] Local SQLite schema created
- [ ] Sync queue table created
- [ ] SyncService implemented
- [ ] Periodic sync timer setup
- [ ] Conflict resolution logic implemented
- [ ] Error handling implemented
- [ ] Sync status indicators added
- [ ] Retry logic implemented
- [ ] Data validation implemented
- [ ] Testing completed

---

## 🧪 Testing Offline Mode

### Manual Testing

1. **Test Offline Feedback**

   - Turn off internet
   - Save feedback
   - Verify saved locally
   - Turn on internet
   - Verify synced to cloud

2. **Test Offline Browse**

   - Turn off internet
   - Browse disease library
   - Verify data loaded from cache
   - Turn on internet
   - Verify fresh data loaded

3. **Test Conflict Resolution**
   - Edit data offline
   - Edit same data online (via admin)
   - Turn on internet
   - Verify conflict resolved correctly

---

## 🚀 Deployment Considerations

### Production Setup

1. **Monitoring**

   - Track sync success rate
   - Monitor queue size
   - Alert on sync failures

2. **Maintenance**

   - Regular queue cleanup
   - Archive old sync logs
   - Monitor storage usage

3. **Scaling**
   - Batch sync operations
   - Optimize database queries
   - Consider caching strategy

---

**Last Updated:** December 9, 2025
**Version:** 2.0 (Reorganized)
**Status:** Ready for Implementation
