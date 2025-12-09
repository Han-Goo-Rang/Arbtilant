# 🗄️ Database Schema - Arbtilant Enhancement

## Overview

Database schema untuk mendukung 3 fitur utama:

1. Disease Library & Glossary
2. User Feedback & Model Retraining
3. Model Management & Versioning

---

## 📊 Tables

### 1. `diseases` - Disease Glossary

**Purpose:** Menyimpan informasi lengkap tentang penyakit tanaman

```sql
CREATE TABLE diseases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug VARCHAR(100) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  english_name VARCHAR(255),
  scientific_names TEXT[] NOT NULL,
  description TEXT NOT NULL,
  symptoms TEXT[] NOT NULL,
  causes TEXT[] NOT NULL,
  treatment TEXT[] NOT NULL,
  prevention TEXT[] NOT NULL,
  severity VARCHAR(50) NOT NULL,
  category VARCHAR(100) NOT NULL,
  affected_plants TEXT[] NOT NULL,
  image_url VARCHAR(500),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_diseases_slug ON diseases(slug);
CREATE INDEX idx_diseases_category ON diseases(category);
```

---

### 2. `scan_results` - Scan History

**Purpose:** Menyimpan hasil scan untuk tracking & feedback

```sql
CREATE TABLE scan_results (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  disease_id UUID NOT NULL REFERENCES diseases(id),
  image_path VARCHAR(500) NOT NULL,
  predicted_label VARCHAR(255) NOT NULL,
  confidence FLOAT NOT NULL,
  top_3_predictions JSONB NOT NULL,
  model_version VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_scan_results_disease_id ON scan_results(disease_id);
CREATE INDEX idx_scan_results_created_at ON scan_results(created_at);
```

---

### 3. `user_feedback` - User Feedback

**Purpose:** Menyimpan feedback user untuk improve model

```sql
CREATE TABLE user_feedback (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  scan_result_id UUID NOT NULL REFERENCES scan_results(id),
  disease_id UUID NOT NULL REFERENCES diseases(id),
  is_correct BOOLEAN NOT NULL,
  corrected_disease_id UUID REFERENCES diseases(id),
  feedback_text TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_user_feedback_scan_result_id ON user_feedback(scan_result_id);
CREATE INDEX idx_user_feedback_disease_id ON user_feedback(disease_id);
```

---

### 4. `model_versions` - Model Management

**Purpose:** Menyimpan metadata model untuk versioning

```sql
CREATE TABLE model_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  version VARCHAR(50) UNIQUE NOT NULL,
  model_path VARCHAR(500) NOT NULL,
  labels_path VARCHAR(500) NOT NULL,
  accuracy FLOAT,
  is_active BOOLEAN DEFAULT FALSE,
  is_fallback BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_model_versions_version ON model_versions(version);
CREATE INDEX idx_model_versions_is_active ON model_versions(is_active);
```

---

### 5. `app_stats` - Analytics (Optional)

**Purpose:** Menyimpan statistik aplikasi

```sql
CREATE TABLE app_stats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  total_scans INT DEFAULT 0,
  total_feedback INT DEFAULT 0,
  feedback_accuracy FLOAT,
  most_common_disease UUID REFERENCES diseases(id),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

---

## 💾 Storage Buckets

### 1. `disease_images`

**Purpose:** Menyimpan foto referensi penyakit

```
disease_images/
├── leaf_blight.jpg
├── leaf_spot.jpg
└── fruit_rot.jpg
```

**Access:** Public (read-only)

---

### 2. `scan_photos`

**Purpose:** Menyimpan foto scan user

```
scan_photos/
├── 2024-12-01/
│   ├── scan_1234567890.jpg
│   └── scan_1234567891.jpg
└── 2024-12-02/
    └── scan_1234567892.jpg
```

**Access:** Private (user can read own)

---

### 3. `models`

**Purpose:** Menyimpan file model TFLite

```
models/
├── v1.0/
│   ├── model.tflite
│   └── labels.txt
└── v2.0/
    ├── model.tflite
    └── labels.txt
```

**Access:** Private (app only)

---

## 🔐 RLS Policies

### diseases

```sql
-- Anyone can read diseases
CREATE POLICY "Enable read access for all users" ON diseases
  FOR SELECT USING (true);

-- Only admin can insert/update/delete
CREATE POLICY "Enable admin access" ON diseases
  FOR ALL USING (auth.role() = 'authenticated' AND auth.jwt() ->> 'role' = 'admin');
```

### scan_results

```sql
-- Anyone can insert
CREATE POLICY "Enable insert for all users" ON scan_results
  FOR INSERT WITH CHECK (true);

-- Anyone can read
CREATE POLICY "Enable read access for all users" ON scan_results
  FOR SELECT USING (true);
```

### user_feedback

```sql
-- Anyone can insert
CREATE POLICY "Enable insert for all users" ON user_feedback
  FOR INSERT WITH CHECK (true);

-- Anyone can read
CREATE POLICY "Enable read access for all users" ON user_feedback
  FOR SELECT USING (true);
```

### model_versions

```sql
-- Anyone can read
CREATE POLICY "Enable read access for all users" ON model_versions
  FOR SELECT USING (true);

-- Only admin can insert/update/delete
CREATE POLICY "Enable admin access" ON model_versions
  FOR ALL USING (auth.role() = 'authenticated' AND auth.jwt() ->> 'role' = 'admin');
```

---

## 📝 SQL Setup Queries

### Create Tables

```sql
-- 1. Create diseases table
CREATE TABLE diseases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  slug VARCHAR(100) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  english_name VARCHAR(255),
  scientific_names TEXT[] NOT NULL,
  description TEXT NOT NULL,
  symptoms TEXT[] NOT NULL,
  causes TEXT[] NOT NULL,
  treatment TEXT[] NOT NULL,
  prevention TEXT[] NOT NULL,
  severity VARCHAR(50) NOT NULL,
  category VARCHAR(100) NOT NULL,
  affected_plants TEXT[] NOT NULL,
  image_url VARCHAR(500),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 2. Create scan_results table
CREATE TABLE scan_results (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  disease_id UUID NOT NULL REFERENCES diseases(id),
  image_path VARCHAR(500) NOT NULL,
  predicted_label VARCHAR(255) NOT NULL,
  confidence FLOAT NOT NULL,
  top_3_predictions JSONB NOT NULL,
  model_version VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 3. Create user_feedback table
CREATE TABLE user_feedback (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  scan_result_id UUID NOT NULL REFERENCES scan_results(id),
  disease_id UUID NOT NULL REFERENCES diseases(id),
  is_correct BOOLEAN NOT NULL,
  corrected_disease_id UUID REFERENCES diseases(id),
  feedback_text TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 4. Create model_versions table
CREATE TABLE model_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  version VARCHAR(50) UNIQUE NOT NULL,
  model_path VARCHAR(500) NOT NULL,
  labels_path VARCHAR(500) NOT NULL,
  accuracy FLOAT,
  is_active BOOLEAN DEFAULT FALSE,
  is_fallback BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 5. Create app_stats table (optional)
CREATE TABLE app_stats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  total_scans INT DEFAULT 0,
  total_feedback INT DEFAULT 0,
  feedback_accuracy FLOAT,
  most_common_disease UUID REFERENCES diseases(id),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### Create Indexes

```sql
CREATE INDEX idx_diseases_slug ON diseases(slug);
CREATE INDEX idx_diseases_category ON diseases(category);
CREATE INDEX idx_scan_results_disease_id ON scan_results(disease_id);
CREATE INDEX idx_scan_results_created_at ON scan_results(created_at);
CREATE INDEX idx_user_feedback_scan_result_id ON user_feedback(scan_result_id);
CREATE INDEX idx_user_feedback_disease_id ON user_feedback(disease_id);
CREATE INDEX idx_model_versions_version ON model_versions(version);
CREATE INDEX idx_model_versions_is_active ON model_versions(is_active);
```

### Insert Initial Data

```sql
-- Insert 3 diseases
INSERT INTO diseases (slug, name, english_name, scientific_names, description, symptoms, causes, treatment, prevention, severity, category, affected_plants, image_url)
VALUES
  ('leaf_blight', 'Hawar Daun', 'Leaf Blight', ARRAY['Helminthosporium', 'Alternaria'], 'Hawar daun adalah penyakit yang disebabkan oleh jamur...', ARRAY['Bercak coklat atau hitam pada daun', 'Daun menguning'], ARRAY['Infeksi jamur', 'Kelembaban tinggi'], ARRAY['Pangkas daun terinfeksi', 'Gunakan fungisida'], ARRAY['Jaga kelembaban optimal', 'Siram di pagi hari'], 'high', 'fungal', ARRAY['Tomat', 'Cabai'], 'https://...'),
  ('leaf_spot', 'Bercak Daun', 'Leaf Spot', ARRAY['Cercospora', 'Septoria'], 'Bercak daun adalah penyakit yang ditandai dengan munculnya bercak kecil...', ARRAY['Bercak kecil pada daun', 'Halo kuning'], ARRAY['Infeksi jamur', 'Kelembaban tinggi'], ARRAY['Pangkas daun', 'Gunakan fungisida'], ARRAY['Jaga kelembaban', 'Siram di pagi hari'], 'medium', 'fungal', ARRAY['Tomat', 'Cabai'], 'https://...'),
  ('fruit_rot', 'Busuk Buah', 'Fruit Rot', ARRAY['Phytophthora', 'Colletotrichum'], 'Busuk buah adalah penyakit yang menyerang buah...', ARRAY['Bercak lembek pada buah', 'Buah berubah warna'], ARRAY['Infeksi jamur', 'Kelembaban tinggi'], ARRAY['Buang buah terinfeksi', 'Gunakan fungisida'], ARRAY['Hindari penyiraman berlebihan', 'Jarak tanam cukup'], 'high', 'fungal', ARRAY['Tomat', 'Cabai'], 'https://...');

-- Insert model version
INSERT INTO model_versions (version, model_path, labels_path, accuracy, is_active, is_fallback)
VALUES ('v1.0', 'models/v1.0/model.tflite', 'models/v1.0/labels.txt', 0.95, true, true);
```

---

## 🔍 Query Examples

### Get All Diseases

```sql
SELECT * FROM diseases ORDER BY name;
```

### Search Diseases

```sql
SELECT * FROM diseases
WHERE name ILIKE '%hawar%' OR english_name ILIKE '%blight%'
ORDER BY name;
```

### Get Recent Scans

```sql
SELECT sr.*, d.name as disease_name
FROM scan_results sr
JOIN diseases d ON sr.disease_id = d.id
ORDER BY sr.created_at DESC
LIMIT 10;
```

### Get Feedback Statistics

```sql
SELECT
  d.name,
  COUNT(uf.id) as total_feedback,
  SUM(CASE WHEN uf.is_correct THEN 1 ELSE 0 END) as correct_feedback,
  ROUND(100.0 * SUM(CASE WHEN uf.is_correct THEN 1 ELSE 0 END) / COUNT(uf.id), 2) as accuracy
FROM user_feedback uf
JOIN diseases d ON uf.disease_id = d.id
GROUP BY d.id, d.name
ORDER BY total_feedback DESC;
```

### Get Active Model

```sql
SELECT * FROM model_versions WHERE is_active = true LIMIT 1;
```

---

## 📋 Setup Checklist

- [ ] Create Supabase project
- [ ] Create all 5 tables
- [ ] Create all indexes
- [ ] Create 3 storage buckets
- [ ] Setup RLS policies
- [ ] Insert initial disease data
- [ ] Insert initial model version
- [ ] Upload disease images to storage
- [ ] Test database connections
- [ ] Verify data integrity

---

## 🔗 Supabase Setup Steps

1. Go to [supabase.com](https://supabase.com)
2. Create new project
3. Get Project URL & API Key
4. Go to SQL Editor
5. Copy-paste SQL queries above
6. Execute each query
7. Go to Storage
8. Create 3 buckets: disease_images, scan_photos, models
9. Upload disease images
10. Test connections from Flutter app

---

**Last Updated:** December 9, 2025
**Version:** 2.0 (Reorganized)
**Status:** Ready for Setup
