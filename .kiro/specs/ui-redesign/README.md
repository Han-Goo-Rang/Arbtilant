# 🎨 Arbtilant UI/UX Redesign Specification

## 📋 Overview

Folder ini berisi spesifikasi lengkap untuk redesign UI/UX aplikasi Arbtilant. Redesign ini bertujuan untuk meningkatkan visual consistency, user experience, dan menambahkan fitur scan detail page.

---

## 📁 File Structure

```
.kiro/specs/ui-redesign/
├── README.md                    ← You are here
├── requirements.md              ← Feature requirements & acceptance criteria
├── design.md                    ← Design system & architecture
├── tasks.md                     ← Implementation plan & task list
└── STITCH_DESIGN_GUIDE.md       ← Guide for generating design in Stitch
```

---

## 📚 File Descriptions

### 1. requirements.md

**Purpose:** Mendefinisikan semua requirement dan acceptance criteria untuk redesign

**Contains:**

- Introduction & glossary
- 10 requirement dengan user stories
- Acceptance criteria untuk setiap requirement
- Focus pada fitur dan behavior

**Read Time:** 15-20 minutes

**When to Read:** Sebelum mulai design atau implementation

---

### 2. design.md

**Purpose:** Mendefinisikan design system, architecture, dan spesifikasi detail

**Contains:**

- Design system foundation (colors, typography, spacing)
- Component specifications (buttons, cards, chips, dialogs)
- Page structure & layout untuk setiap halaman
- Data models
- Correctness properties
- Error handling & testing strategy

**Read Time:** 30-40 minutes

**When to Read:** Sebelum mulai implementation

---

### 3. tasks.md

**Purpose:** Mendefinisikan implementation plan dengan task list yang actionable

**Contains:**

- 11 phase implementation plan
- 35 tasks dengan sub-tasks
- Task dependencies & ordering
- Requirements reference untuk setiap task
- Optional tasks (marked with \*)

**Read Time:** 20-30 minutes

**When to Read:** Sebelum mulai coding

---

### 4. STITCH_DESIGN_GUIDE.md

**Purpose:** Panduan khusus untuk generate design menggunakan Stitch (Google AI Studio)

**Contains:**

- Design objectives & constraints
- Color palette (WAJIB DIGUNAKAN)
- Typography scale (WAJIB DIGUNAKAN)
- Spacing system (WAJIB DIGUNAKAN)
- Component specifications
- Responsive design constraints
- Page structure constraints
- Animation & transition constraints
- Design checklist
- Example prompts untuk Stitch
- Design iteration process

**Read Time:** 25-35 minutes

**When to Read:** Sebelum generate design di Stitch

---

## 🎯 Quick Start

### Untuk Project Manager / Stakeholder

1. Baca **requirements.md** (15 min)
2. Baca **design.md** Overview & Architecture (10 min)
3. Review **tasks.md** untuk timeline (10 min)

**Total:** ~35 minutes

---

### Untuk Designer / UI/UX

1. Baca **requirements.md** (15 min)
2. Baca **design.md** (40 min)
3. Baca **STITCH_DESIGN_GUIDE.md** (30 min)
4. Generate design di Stitch menggunakan guide
5. Iterate sampai design sesuai constraint

**Total:** ~2 hours

---

### Untuk Developer / Flutter Engineer

1. Baca **requirements.md** (15 min)
2. Baca **design.md** (40 min)
3. Baca **tasks.md** (30 min)
4. Follow **tasks.md** untuk implementation
5. Reference **design.md** untuk spesifikasi detail

**Total:** ~2 hours (reading) + implementation time

---

## 🚀 Implementation Phases

### Phase 1: Design System & Core Components (Week 1)

- Setup design system (colors, typography, spacing)
- Create reusable components (buttons, cards, chips, dialogs)
- Create bottom navigation

### Phase 2: Home Page Redesign (Week 1-2)

- Redesign home page layout
- Implement hero section
- Implement feature cards

### Phase 3: Library Page Redesign (Week 2)

- Redesign library page layout
- Improve search & filter
- Redesign disease cards

### Phase 4: Disease Detail Page Redesign (Week 2-3)

- Redesign disease detail page
- Improve information hierarchy
- Add visual improvements

### Phase 5: Scan Result Page Redesign (Week 3)

- Redesign scan result page
- Improve result presentation
- Add comparison bars

### Phase 6: Scan Detail Page (NEW FEATURE) (Week 3-4)

- Create scan detail data model
- Create scan detail repository & service
- Create scan detail page UI
- Integrate with scan result page

### Phase 7: History Page Redesign (Week 4)

- Redesign history page layout
- Improve scan item display
- Add delete functionality

### Phase 8: Feedback Dialog Redesign (Week 4)

- Redesign feedback dialog
- Improve form layout
- Add validation

### Phase 9: Responsive Design & Mobile Optimization (Week 4-5)

- Test responsive design
- Optimize performance
- Fix any issues

### Phase 10: Design Consistency & Polish (Week 5)

- Verify design system compliance
- Verify navigation consistency
- Verify visual feedback

### Phase 11: Documentation & Handoff (Week 5)

- Create design system documentation
- Create UI/UX guidelines
- Final review & handoff

---

## 📊 Key Metrics

### Design System

- **Colors:** 13 colors (3 primary, 5 neutral, 5 semantic)
- **Typography:** 8 sizes (Display Large to Label)
- **Spacing:** 6 values (xs to 2xl, 8px grid)
- **Components:** 8 reusable components

### Pages

- **Total Pages:** 8 pages (Home, Scan, Library, Disease Detail, Scan Result, Scan Detail, History, Feedback)
- **New Pages:** 1 page (Scan Detail)
- **Redesigned Pages:** 7 pages

### Tasks

- **Total Tasks:** 35 tasks
- **Core Tasks:** 25 tasks (non-optional)
- **Optional Tasks:** 10 tasks (testing, documentation)

---

## ✅ Success Criteria

### Design System

- ✅ All pages use consistent color palette
- ✅ All pages use consistent typography
- ✅ All pages use consistent spacing (8px grid)
- ✅ All components follow specification

### User Experience

- ✅ All pages are responsive (mobile, tablet, desktop)
- ✅ All touch targets are minimum 48px
- ✅ All transitions are smooth (300ms)
- ✅ All interactive elements provide visual feedback

### Features

- ✅ Scan detail page displays all metadata
- ✅ Scan detail page shows treatment recommendations
- ✅ Scan detail page allows feedback submission
- ✅ History page shows all scans with thumbnails

### Quality

- ✅ All unit tests pass
- ✅ All property tests pass
- ✅ No crashes or errors
- ✅ Performance is acceptable

---

## 🔄 Design Iteration Process

1. **Generate Initial Design** (Stitch)

   - Use STITCH_DESIGN_GUIDE.md
   - Follow example prompts
   - Generate design for each page

2. **Review Against Constraints** (Designer)

   - Check color palette compliance
   - Check typography compliance
   - Check spacing compliance
   - Check component compliance

3. **Identify Issues** (Designer)

   - Note any constraint violations
   - Document feedback
   - Prioritize fixes

4. **Revise Design** (Stitch)

   - Update prompt based on feedback
   - Generate revised design
   - Iterate until compliant

5. **Approve Design** (Stakeholder)

   - Review final design
   - Approve for implementation
   - Sign off

6. **Implement Design** (Developer)
   - Follow tasks.md
   - Reference design.md for specifications
   - Implement page by page

---

## 📞 FAQ

### Q: Berapa lama redesign ini akan selesai?

**A:** Diperkirakan 5 minggu untuk MVP (1 minggu per phase). Bisa lebih cepat atau lambat tergantung resources dan kompleksitas.

---

### Q: Apakah fitur existing akan berubah?

**A:** Tidak. Redesign hanya mengubah UI/UX, fitur tetap sama. Hanya menambah fitur scan detail page.

---

### Q: Apakah backend akan berubah?

**A:** Minimal. Hanya perlu menambah scan detail repository & service untuk fitur baru. Existing backend tetap sama.

---

### Q: Bagaimana dengan backward compatibility?

**A:** Tidak ada masalah. Redesign hanya mengubah UI, data model tetap compatible.

---

### Q: Apakah perlu update database?

**A:** Tidak perlu. Scan detail data sudah ada di scan_results table. Hanya perlu tambah repository & service.

---

### Q: Bagaimana dengan testing?

**A:** Testing dilakukan di setiap phase. Unit tests untuk components, property tests untuk design consistency, integration tests untuk end-to-end flows.

---

## 📝 Notes

- Dokumentasi ini comprehensive dan terstruktur
- Setiap file bisa dibaca independently
- Namun recommended untuk membaca dalam urutan: requirements → design → tasks
- Update dokumentasi jika ada perubahan design
- Share dokumentasi dengan team

---

## 🎉 Ready to Start?

### Untuk Designer

👉 Buka **STITCH_DESIGN_GUIDE.md** dan mulai generate design di Stitch

### Untuk Developer

👉 Buka **tasks.md** dan mulai dari Phase 1 (Design System)

### Untuk Project Manager

👉 Buka **requirements.md** dan **tasks.md** untuk tracking progress

---

## 📚 Related Documents

- `.kiro/specs/developer/ARCHITECTURE.md` - Overall app architecture
- `.kiro/specs/developer/QUICK_START.md` - Quick start guide
- `.kiro/specs/general/PROJECT_SUMMARY.md` - Project overview

---

**Last Updated:** December 21, 2025
**Version:** 1.0
**Status:** Ready for Design & Implementation
