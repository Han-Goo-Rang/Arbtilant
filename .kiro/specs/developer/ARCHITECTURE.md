# 🏗️ Architecture & Design - Arbtilant Enhancement

## System Architecture

### High-Level Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter App (UI Layer)                  │
│  ┌──────────────┬──────────────┬──────────────┐             │
│  │ Library Page │ Feedback Page│ Model Mgmt   │             │
│  └──────────────┴──────────────┴──────────────┘             │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                   Service Layer                             │
│  ┌──────────────┬──────────────┬──────────────┐             │
│  │ Disease Svc  │ Feedback Svc │ Model Svc    │             │
│  └──────────────┴──────────────┴──────────────┘             │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                 Repository Layer                            │
│  ┌──────────────┬──────────────┬──────────────┐             │
│  │ Disease Repo │ Feedback Repo│ Model Repo   │             │
│  └──────────────┴──────────────┴──────────────┘             │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                  Storage Layer                              │
│  ┌──────────────────────────────────────────┐               │
│  │ Local SQLite │ Supabase PostgreSQL       │               │
│  │ (Offline)    │ (Cloud)                   │               │
│  └──────────────────────────────────────────┘               │
└─────────────────────────────────────────────────────────────┘
```

---

## 4 Core Modules

### 1. Disease Library Module

**Purpose:** Manage disease information & display

**Components:**

- `DiseaseModel` - Data model
- `DiseaseRepository` - Data access
- `DiseaseService` - Business logic
- `LibraryPage` - UI
- `DiseaseDetailPage` - Detail UI
- `DiseaseCard` - Widget

**Responsibilities:**

- Fetch diseases from Supabase
- Cache locally in SQLite
- Search & filter
- Display disease information
- Handle offline mode

---

### 2. Feedback System Module

**Purpose:** Capture & manage user feedback

**Components:**

- `FeedbackModel` - Data model
- `FeedbackRepository` - Data access
- `FeedbackService` - Business logic
- `FeedbackDialog` - UI
- `FeedbackHistoryPage` - History UI

**Responsibilities:**

- Capture user feedback
- Store locally
- Sync to cloud
- Show feedback history
- Handle offline queue

---

### 3. Model Management Module

**Purpose:** Handle model versioning & updates

**Components:**

- `ModelVersionModel` - Data model
- `ModelRepository` - Data access
- `ModelService` - Business logic
- `ModelManager` - Model loading & switching

**Responsibilities:**

- Check for model updates
- Download new models
- Validate models
- Switch active model
- Fallback mechanism

---

### 4. Storage Module (Core)

**Purpose:** Centralized data persistence

**Components:**

- `StorageService` - Local SQLite
- `SyncService` - Cloud sync
- `SyncQueue` - Pending items
- `ConflictResolver` - Conflict resolution

**Responsibilities:**

- Local SQLite operations
- Cloud sync
- Offline queue management
- Conflict resolution
- Sync status tracking

---

## Data Flow Diagrams

### 1. Disease Library Flow

```
User Opens Library
    ↓
DiseaseService.getDiseases()
    ↓
Check Local Cache (SQLite)
    ├─ If exists & fresh → Return cached
    └─ If not → Fetch from Supabase
    ↓
Store in SQLite
    ↓
Display in UI
```

### 2. Feedback Flow

```
User Provides Feedback
    ↓
FeedbackService.saveFeedback()
    ↓
Save to Local SQLite
    ↓
If Online:
  ├─ Sync to Supabase immediately
  └─ Mark as synced
Else:
  ├─ Mark as pending
  └─ Queue for sync
    ↓
Show confirmation
```

### 3. Sync Flow

```
App Detects Online
    ↓
SyncService.syncPending()
    ↓
Get pending items from queue
    ↓
For each item:
  ├─ Try to sync to Supabase
  ├─ If success → Mark as synced
  └─ If fail → Keep in queue
    ↓
Update sync status
```

### 4. Model Update Flow

```
App Starts
    ↓
ModelService.checkForUpdates()
    ↓
Get latest model version from Supabase
    ↓
Compare with current version
    ├─ If newer → Download
    ├─ Validate model
    ├─ If valid → Switch to new model
    └─ If invalid → Keep current
    ↓
Store metadata
```

---

## Design Patterns

### 1. Repository Pattern

**Purpose:** Abstract data access logic

```dart
abstract class DiseaseRepository {
  Future<List<Disease>> getDiseases();
  Future<Disease> getDiseaseById(String id);
  Future<void> saveDiseases(List<Disease> diseases);
}

class DiseaseRepositoryImpl implements DiseaseRepository {
  final StorageService storage;
  final SupabaseClient supabase;

  @override
  Future<List<Disease>> getDiseases() async {
    // Implementation
  }
}
```

### 2. Service Layer Pattern

**Purpose:** Business logic & orchestration

```dart
class DiseaseService {
  final DiseaseRepository repository;

  Future<List<Disease>> getDiseases() async {
    // Business logic
  }

  Future<List<Disease>> searchDiseases(String query) async {
    // Search logic
  }
}
```

### 3. Singleton Pattern

**Purpose:** Single instance of services

```dart
class StorageService {
  static final StorageService _instance = StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();
}
```

### 4. Observer Pattern

**Purpose:** Sync status updates

```dart
class SyncService {
  final _syncStatusController = StreamController<SyncStatus>();

  Stream<SyncStatus> get syncStatus => _syncStatusController.stream;

  void _updateStatus(SyncStatus status) {
    _syncStatusController.add(status);
  }
}
```

---

## State Management

### Local State (Provider)

```dart
// Disease list provider
final diseaseListProvider = FutureProvider<List<Disease>>((ref) async {
  final service = ref.watch(diseaseServiceProvider);
  return service.getDiseases();
});

// Search query provider
final searchQueryProvider = StateProvider<String>((ref) => '');
```

### Global State (Riverpod)

```dart
// Sync status provider
final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  final service = ref.watch(syncServiceProvider);
  return service.syncStatus;
});
```

---

## Database Schema

### diseases

```sql
CREATE TABLE diseases (
  id UUID PRIMARY KEY,
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  english_name TEXT NOT NULL,
  scientific_names TEXT[] NOT NULL,
  description TEXT NOT NULL,
  symptoms TEXT[] NOT NULL,
  causes TEXT[] NOT NULL,
  treatment TEXT[] NOT NULL,
  prevention TEXT[] NOT NULL,
  severity TEXT NOT NULL,
  category TEXT NOT NULL,
  image_url TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### scan_results

```sql
CREATE TABLE scan_results (
  id UUID PRIMARY KEY,
  disease_id UUID REFERENCES diseases(id),
  image_path TEXT NOT NULL,
  predicted_label TEXT NOT NULL,
  confidence FLOAT NOT NULL,
  top_3_predictions JSONB NOT NULL,
  model_version TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### user_feedback

```sql
CREATE TABLE user_feedback (
  id UUID PRIMARY KEY,
  scan_result_id UUID REFERENCES scan_results(id),
  disease_id UUID REFERENCES diseases(id),
  is_correct BOOLEAN NOT NULL,
  corrected_disease_id UUID REFERENCES diseases(id),
  feedback_text TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### model_versions

```sql
CREATE TABLE model_versions (
  id UUID PRIMARY KEY,
  version TEXT UNIQUE NOT NULL,
  model_path TEXT NOT NULL,
  labels_path TEXT NOT NULL,
  accuracy FLOAT,
  is_active BOOLEAN DEFAULT FALSE,
  is_fallback BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## Offline Strategy

### Local SQLite Schema

```sql
-- Mirror of cloud tables
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
  image_url TEXT,
  synced BOOLEAN DEFAULT FALSE,
  created_at TEXT,
  updated_at TEXT
);

-- Sync queue
CREATE TABLE sync_queue (
  id TEXT PRIMARY KEY,
  table_name TEXT NOT NULL,
  operation TEXT NOT NULL, -- INSERT, UPDATE, DELETE
  data TEXT NOT NULL,
  created_at TEXT,
  synced BOOLEAN DEFAULT FALSE
);
```

### Sync Strategy

```
Online Mode:
  1. Save to local SQLite
  2. Immediately sync to Supabase
  3. Mark as synced

Offline Mode:
  1. Save to local SQLite
  2. Add to sync queue
  3. Show "Offline" indicator

When Online:
  1. Check sync queue
  2. For each pending item:
     - Try to sync to Supabase
     - If success → Remove from queue
     - If fail → Keep in queue
  3. Update UI
```

---

## Error Handling

### Network Errors

```dart
try {
  await repository.syncData();
} on SocketException {
  // Network error - queue for later
  await syncQueue.add(data);
} on TimeoutException {
  // Timeout - retry later
  await syncQueue.add(data);
}
```

### Validation Errors

```dart
try {
  final disease = Disease.fromJson(json);
} on FormatException {
  // Invalid data - log & skip
  logger.error('Invalid disease data: $json');
}
```

### Conflict Resolution

```dart
// Last-write-wins strategy
if (localTimestamp > cloudTimestamp) {
  // Local is newer - use local
  await updateCloud(localData);
} else {
  // Cloud is newer - use cloud
  await updateLocal(cloudData);
}
```

---

## Performance Optimization

### Caching Strategy

```dart
// Cache diseases for 24 hours
const cacheDuration = Duration(hours: 24);

Future<List<Disease>> getDiseases() async {
  final cached = await storage.getDiseases();
  if (cached != null && !isCacheExpired()) {
    return cached;
  }

  final fresh = await supabase.getDiseases();
  await storage.saveDiseases(fresh);
  return fresh;
}
```

### Lazy Loading

```dart
// Load diseases on demand
final diseaseListProvider = FutureProvider.family<Disease, String>((ref, id) async {
  final service = ref.watch(diseaseServiceProvider);
  return service.getDiseaseById(id);
});
```

### Pagination

```dart
// Load diseases in batches
Future<List<Disease>> getDiseases({int page = 1, int limit = 20}) async {
  final offset = (page - 1) * limit;
  return supabase
    .from('diseases')
    .select()
    .range(offset, offset + limit - 1)
    .execute();
}
```

---

## Security & Privacy

### RLS Policies

```sql
-- Anyone can read diseases
CREATE POLICY "Enable read access for all users" ON diseases
  FOR SELECT USING (true);

-- Only app can insert feedback
CREATE POLICY "Enable insert for feedback" ON user_feedback
  FOR INSERT WITH CHECK (true);
```

### Data Privacy

- No user authentication required
- No personal data stored
- Feedback is anonymous
- Data encrypted in transit (HTTPS)

---

## Deployment Architecture

### Development

```
Local Machine
  ├─ Flutter App (debug)
  ├─ Local SQLite
  └─ Supabase (dev project)
```

### Production

```
App Store / Play Store
  ├─ Flutter App (release)
  ├─ Local SQLite
  └─ Supabase (prod project)
```

---

## Technology Stack

| Layer             | Technology      | Purpose             |
| ----------------- | --------------- | ------------------- |
| **UI**            | Flutter         | Cross-platform UI   |
| **State**         | Riverpod        | State management    |
| **Database**      | Supabase        | Cloud database      |
| **Local Storage** | SQLite          | Offline storage     |
| **Sync**          | Custom          | Cloud sync          |
| **ML**            | TensorFlow Lite | On-device inference |

---

## Folder Structure

```
lib/
├── models/
│   ├── disease_model.dart
│   ├── feedback_model.dart
│   ├── scan_result_model.dart
│   └── model_version_model.dart
│
├── repositories/
│   ├── disease_repository.dart
│   ├── feedback_repository.dart
│   ├── model_repository.dart
│   └── storage_repository.dart
│
├── services/
│   ├── disease_service.dart
│   ├── feedback_service.dart
│   ├── model_service.dart
│   ├── storage_service.dart
│   └── sync_service.dart
│
├── pages/
│   ├── library_page.dart
│   ├── disease_detail_page.dart
│   ├── feedback_history_page.dart
│   └── model_management_page.dart
│
├── widgets/
│   ├── disease_card.dart
│   ├── feedback_dialog.dart
│   ├── sync_indicator.dart
│   └── offline_banner.dart
│
└── core/
    ├── constants/
    │   ├── app_constants.dart
    │   └── disease_constants.dart
    │
    └── utils/
        ├── logger.dart
        └── validators.dart
```

---

## Next Steps

1. Review this architecture
2. Read DATABASE_SCHEMA.md for detailed schema
3. Read OFFLINE_SYNC_STRATEGY.md for sync details
4. Follow IMPLEMENTATION_CHECKLIST.md to start coding

---

**Last Updated:** December 9, 2025
**Version:** 2.0 (Reorganized)
**Status:** Ready for Implementation
