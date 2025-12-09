# 🚀 Quick Start Guide - Arbtilant Enhancement

## ⚡ 5-Minute Overview

### What We're Building

3 fitur untuk Arbtilant:

1. **Disease Library** - Browse 3 penyakit dengan info lengkap
2. **Feedback System** - User bisa report hasil scan yang salah
3. **Model Management** - Support multiple model versions

### Tech Stack

- **Frontend:** Flutter (existing)
- **Database:** Supabase PostgreSQL
- **Local Storage:** SQLite
- **Offline:** Local-first with cloud sync

### Timeline

- **MVP:** 5 minggu (1 minggu per phase)
- **No user auth:** Anonymous access
- **3 diseases:** Hawar Daun, Bercak Daun, Busuk Buah

---

## 📋 Pre-Implementation (Do This First!)

### 1. Setup Supabase (30 min)

```bash
# 1. Go to supabase.com
# 2. Create new project
# 3. Get URL & API key
# 4. Copy to safe place
```

### 2. Create Database Tables (15 min)

Copy-paste SQL dari `DATABASE_SCHEMA.md` ke Supabase SQL Editor:

- `diseases` table
- `scan_results` table
- `user_feedback` table
- `model_versions` table
- `app_stats` table (optional)

### 3. Create Storage Buckets (5 min)

- `disease_images`
- `scan_photos`
- `models`

### 4. Insert Initial Data (10 min)

```sql
-- Insert 3 diseases
INSERT INTO diseases (slug, name, english_name, scientific_names, ...)
VALUES ('leaf_blight', 'Hawar Daun', 'Leaf Blight', ...);
-- Repeat 2x more

-- Insert model version
INSERT INTO model_versions (version, model_path, ...)
VALUES ('v1.0', 'models/v1.0/model.tflite', ...);
```

### 5. Prepare Assets (15 min)

- [ ] 3 disease reference images
- [ ] New model files (if available)
- [ ] Mockup designs

**Total Setup Time: ~1 hour**

---

## 🛠️ Development Setup (15 min)

### 1. Add Dependencies

```yaml
# pubspec.yaml
dependencies:
  sqflite: ^2.3.0
  supabase_flutter: ^1.10.0
  uuid: ^4.0.0
  intl: ^0.19.0
```

### 2. Create Folder Structure

```
lib/
├── Models/
├── Services/
├── Repositories/
├── Pages/
├── Widgets/
└── core/
    ├── constants/
    └── utils/
```

### 3. Run Flutter

```bash
flutter pub get
flutter run
```

---

## 📚 Documentation Quick Links

| Document                     | Purpose                 | Read Time |
| ---------------------------- | ----------------------- | --------- |
| **QUICK_START.md**           | This file               | 10 min    |
| **ARCHITECTURE.md**          | Architecture & planning | 30 min    |
| **DATABASE_SCHEMA.md**       | Database setup          | 20 min    |
| **OFFLINE_SYNC_STRATEGY.md** | Offline & sync          | 15 min    |
| **IMPLEMENTATION_CHECKLIST** | Step-by-step tasks      | Reference |
| **DISEASE_DATA.md**          | Disease information     | 10 min    |

**Total Reading Time: ~1.5 hours**

---

## 🎯 Implementation Phases

### Phase 1: Foundation (Week 1)

```
Day 1-2: Data Models
  ├─ DiseaseModel
  ├─ ScanResultModel
  ├─ FeedbackModel
  └─ ModelVersionModel

Day 3-4: Local Storage
  ├─ SQLite setup
  ├─ Database schema
  └─ StorageService

Day 5: Repository Layer
  ├─ DiseaseRepository
  ├─ FeedbackRepository
  └─ ModelRepository
```

### Phase 2: Library Feature (Week 2)

```
Day 1-2: UI Components
  ├─ LibraryPage
  ├─ DiseaseDetailPage
  └─ DiseaseCard widget

Day 3-4: Service Layer
  ├─ DiseaseService
  └─ Search & filter logic

Day 5: Integration
  ├─ Wire up services
  ├─ Navigation
  └─ Testing
```

### Phase 3: Feedback System (Week 3)

```
Day 1-2: UI Components
  ├─ FeedbackDialog
  ├─ FeedbackHistoryPage
  └─ Sync indicators

Day 3-4: Service Layer
  ├─ FeedbackService
  └─ Local storage

Day 5: Integration
  ├─ Wire with ScanPage
  └─ Testing
```

### Phase 4: Model Management (Week 4)

```
Day 1-2: Model Versioning
  ├─ ModelVersionModel
  ├─ ModelRepository
  └─ Metadata storage

Day 3-4: Model Service
  ├─ Check for updates
  ├─ Download models
  └─ Validate & switch

Day 5: Testing
  ├─ Model loading
  ├─ Inference
  └─ Fallback
```

### Phase 5: Polish (Week 5)

```
Day 1-2: Integration Testing
  ├─ End-to-end flows
  ├─ Offline mode
  └─ Sync mechanism

Day 3-4: Optimization
  ├─ Performance
  ├─ UI/UX
  └─ Error handling

Day 5: Documentation
  ├─ Code comments
  ├─ README
  └─ User guide
```

---

## 🔄 Sync Strategy (Simple Version)

### Online Mode

```
User Action
    ↓
Save to Local SQLite
    ↓
Sync to Supabase
    ↓
Mark as synced
```

### Offline Mode

```
User Action
    ↓
Save to Local SQLite
    ↓
Mark as pending
    ↓
Show "Offline" badge
    ↓
Auto-sync when online
```

---

## 📊 Database Schema (Simplified)

### diseases

```
id | slug | name | description | symptoms[] | causes[] | treatment[] | prevention[] | severity | category | image_url
```

### scan_results

```
id | disease_id | image_path | predicted_label | confidence | top_3_predictions | model_version | created_at
```

### user_feedback

```
id | scan_result_id | disease_id | is_correct | corrected_disease_id | feedback_text | created_at
```

### model_versions

```
id | version | model_path | labels_path | accuracy | is_active | is_fallback | created_at
```

---

## 🎨 UI Flow

```
Home Page
    ↓
┌───────────────────────────────────────┐
│ Bottom Navigation                     │
├───────────────────────────────────────┤
│ Home | Scan | Library | Feedback      │
└───────────────────────────────────────┘
    ↓
Library Page ──→ Disease Detail Page
    ↓                   ↓
Search/Filter      "Scan Similar"
                        ↓
                    Scan Page
                        ↓
                    Show Result
                        ↓
                    Feedback Dialog
                        ↓
                    Feedback History
```

---

## ✅ Pre-Implementation Checklist

- [ ] Supabase project created
- [ ] Database tables created
- [ ] Storage buckets created
- [ ] Initial data inserted
- [ ] Disease images uploaded
- [ ] Model files uploaded
- [ ] Flutter dependencies added
- [ ] Folder structure created
- [ ] All documentation read
- [ ] Team aligned on approach

---

## 🚀 Start Implementation

### Step 1: Setup (1 hour)

```bash
# 1. Setup Supabase (follow DATABASE_SCHEMA.md)
# 2. Add dependencies
flutter pub get
# 3. Create folder structure
```

### Step 2: Phase 1 (Week 1)

```bash
# Follow IMPLEMENTATION_CHECKLIST.md Phase 1-2
# Create data models
# Setup local storage
# Create repository layer
```

### Step 3: Phase 2 (Week 2)

```bash
# Follow IMPLEMENTATION_CHECKLIST.md Phase 3-4
# Create UI components
# Create service layer
# Wire up components
```

### Step 4: Phase 3 (Week 3)

```bash
# Follow IMPLEMENTATION_CHECKLIST.md Phase 5-6
# Create feedback UI
# Create feedback service
# Integrate with scan
```

### Step 5: Phase 4 (Week 4)

```bash
# Follow IMPLEMENTATION_CHECKLIST.md Phase 7
# Model versioning
# Model management
# Testing
```

### Step 6: Phase 5 (Week 5)

```bash
# Follow IMPLEMENTATION_CHECKLIST.md Phase 8-9
# Integration testing
# Optimization
# Documentation
```

---

## 🎯 Success Criteria

### MVP Success

- ✅ Disease library displays 3 diseases
- ✅ Search & filter works
- ✅ Detail page shows all info
- ✅ Feedback dialog appears after scan
- ✅ Feedback stored & syncs to cloud
- ✅ Works offline with local cache
- ✅ No crashes or errors
- ✅ Performance acceptable

---

## 📞 Quick Reference

### Key Files

- `DATABASE_SCHEMA.md` - Database setup
- `IMPLEMENTATION_CHECKLIST.md` - Implementation tasks
- `OFFLINE_SYNC_STRATEGY.md` - Offline mode
- `ARCHITECTURE.md` - Visual diagrams

### Key Decisions

- Database: Supabase PostgreSQL
- Local Storage: SQLite
- Auth: None (anonymous)
- Timeline: 5 weeks MVP
- Diseases: 3 penyakit

### Key Modules

1. Disease Library Module
2. Feedback System Module
3. Model Management Module
4. Storage Module (core)

---

## 🆘 Troubleshooting

### Supabase Connection Issues

- Check URL & API key
- Check internet connection
- Check RLS policies
- Check storage bucket permissions

### SQLite Issues

- Check database path
- Check table creation
- Check schema migration
- Check data types

### Flutter Issues

- Run `flutter clean`
- Run `flutter pub get`
- Check dependencies versions
- Check platform-specific issues

---

## 📚 Next Steps

1. **Read Documentation** (1.5 hours)

   - Start with QUICK_START.md (this file)
   - Then ARCHITECTURE.md
   - Then DATABASE_SCHEMA.md

2. **Setup Supabase** (1 hour)

   - Follow DATABASE_SCHEMA.md
   - Create tables & buckets
   - Insert initial data

3. **Setup Flutter** (30 min)

   - Add dependencies
   - Create folder structure
   - Setup environment

4. **Start Implementation** (5 weeks)
   - Follow IMPLEMENTATION_CHECKLIST.md
   - Implement phase by phase
   - Test each phase

---

## 🎉 Ready?

Jika semua sudah siap, mulai dari:

1. Read ARCHITECTURE.md (30 min)
2. Follow DATABASE_SCHEMA.md (1 hour)
3. Follow IMPLEMENTATION_CHECKLIST.md Phase 1 (start coding!)

**Good luck! 🚀**

---

**Last Updated:** December 9, 2025
**Version:** 2.0 (Reorganized)
**Status:** Ready to Start
