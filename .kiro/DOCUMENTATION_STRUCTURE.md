# Documentation Structure - Arbtilant

**Last Updated:** December 21, 2025

---

## 📁 Folder Organization

### `.kiro/pitching/` - Presentation Materials

**Purpose:** Ready-to-use materials for presentations, pitches, and stakeholder communication

**Contents:**

- `PROJECT_OVERVIEW.md` - High-level project overview
- `FEATURES_SHOWCASE.md` - Detailed feature showcase
- `TECHNICAL_SUMMARY.md` - Technical architecture overview
- `INDEX.md` - Navigation guide for presentation materials

**Best For:**

- Investor pitches
- Stakeholder presentations
- Product demos
- Team onboarding

**Usage:**

1. Start with `PROJECT_OVERVIEW.md`
2. Use `FEATURES_SHOWCASE.md` for demo script
3. Reference `TECHNICAL_SUMMARY.md` for credibility
4. Check `INDEX.md` for presentation flow

---

### `.kiro/documentation/` - Technical Reference

**Purpose:** Detailed technical documentation for developers and engineers

**Contents:**

- `REBUILD_INSTRUCTIONS.md` - How to rebuild app
- `TESTING_PHOTO_DISPLAY.md` - Testing guide
- `TECHNICAL_SUMMARY.md` - Complete architecture
- `ANALYSIS_HIVE_VS_POWERSYNC.md` - Storage architecture decision
- `MODEL_ACCURACY_ANALYSIS.md` - ML model analysis
- `MODEL_IMPROVEMENT_GUIDE.md` - Model improvement steps
- `FEEDBACK_SYSTEM_GUIDE.md` - Feedback system usage
- `PHOTO_DISPLAY_FIX_SUMMARY.md` - Photo display details
- `CURRENT_STATUS_SUMMARY.md` - Project status
- `INDEX.md` - Navigation guide

**Best For:**

- Developers
- ML engineers
- DevOps/deployment
- Technical leads

**Usage:**

1. Check `INDEX.md` for quick navigation
2. Find relevant document by topic or role
3. Read document for detailed information
4. Reference code examples

---

### `.kiro/archive/` - Historical Documentation

**Purpose:** Old/deprecated documentation for reference

**Contents:**

- Phase-specific docs (PHASE1, PHASE2, etc.)
- Bug fix docs (FIXES_APPLIED, HIVE_FIX, etc.)
- Analysis docs (DIAGNOSIS, PHOTO_STORAGE, etc.)
- Deprecated docs (TODO, QUICK_REFERENCE, etc.)

**Best For:**

- Historical reference
- Understanding past decisions
- Tracking project evolution

**Usage:**

- Reference only when needed
- Don't use for current development
- Check for historical context

---

### `.kiro/specs/` - Specifications & Design

**Purpose:** Design specifications and mockups

**Contents:**

- `mockup/` - UI mockups for all pages
- `ui-redesign/` - UI redesign specifications
- `steering/` - Project steering documents

**Best For:**

- Design reference
- UI implementation
- Mockup compliance verification

---

### `.kiro/steering/` - Project Steering

**Purpose:** Project guidelines and standards

**Contents:**

- `ui-redesign-plan.md` - UI redesign plan and status

**Best For:**

- Project guidelines
- Team standards
- Development practices

---

## 🎯 Quick Navigation

### I need to...

#### Give a presentation

→ Go to `.kiro/pitching/`
→ Start with `PROJECT_OVERVIEW.md`

#### Deploy the app

→ Go to `.kiro/documentation/`
→ Read `REBUILD_INSTRUCTIONS.md`

#### Understand the architecture

→ Go to `.kiro/documentation/`
→ Read `TECHNICAL_SUMMARY.md`

#### Improve model accuracy

→ Go to `.kiro/documentation/`
→ Read `MODEL_IMPROVEMENT_GUIDE.md`

#### Find something specific

→ Go to `.kiro/documentation/`
→ Check `INDEX.md` for navigation

#### Reference old decisions

→ Go to `.kiro/archive/`
→ Find relevant historical doc

---

## 📊 Documentation Summary

### Pitching Materials (4 docs)

- PROJECT_OVERVIEW.md - Project overview
- FEATURES_SHOWCASE.md - Feature details
- TECHNICAL_SUMMARY.md - Technical credibility
- INDEX.md - Navigation guide

### Technical Documentation (9 docs)

- REBUILD_INSTRUCTIONS.md - Deployment
- TESTING_PHOTO_DISPLAY.md - Testing
- TECHNICAL_SUMMARY.md - Architecture
- ANALYSIS_HIVE_VS_POWERSYNC.md - Storage decision
- MODEL_ACCURACY_ANALYSIS.md - Model analysis
- MODEL_IMPROVEMENT_GUIDE.md - Model improvement
- FEEDBACK_SYSTEM_GUIDE.md - Feedback system
- PHOTO_DISPLAY_FIX_SUMMARY.md - Photo display
- CURRENT_STATUS_SUMMARY.md - Project status
- INDEX.md - Navigation guide

### Archive (18 docs)

- Historical documentation
- Phase-specific docs
- Bug fix documentation
- Deprecated docs

---

## ✅ Root Directory - Clean

**Kept in root:**

- `README.md` - Main project readme
- `pubspec.yaml` - Flutter dependencies
- `pubspec.lock` - Dependency lock file
- `.gitignore` - Git ignore rules
- `.env.example` - Environment template
- `analysis_options.yaml` - Dart analysis config

**Removed from root:**

- All markdown documentation files
- All phase-specific docs
- All bug fix docs
- All analysis docs

**Result:** Clean, professional root directory with only essential files

---

## 🎓 How to Use This Structure

### For New Team Members

1. Read `.kiro/pitching/PROJECT_OVERVIEW.md`
2. Read `.kiro/documentation/TECHNICAL_SUMMARY.md`
3. Read `.kiro/documentation/REBUILD_INSTRUCTIONS.md`
4. Check `.kiro/documentation/INDEX.md` for specific topics

### For Presentations

1. Use `.kiro/pitching/PROJECT_OVERVIEW.md` as intro
2. Use `.kiro/pitching/FEATURES_SHOWCASE.md` for demo
3. Use `.kiro/pitching/TECHNICAL_SUMMARY.md` for Q&A
4. Follow `.kiro/pitching/INDEX.md` for presentation flow

### For Development

1. Check `.kiro/documentation/INDEX.md` for topic
2. Read relevant documentation
3. Reference code examples
4. Check `.kiro/archive/` for historical context if needed

### For Deployment

1. Read `.kiro/documentation/REBUILD_INSTRUCTIONS.md`
2. Follow step-by-step instructions
3. Check `.kiro/documentation/TESTING_PHOTO_DISPLAY.md` for testing
4. Reference `.kiro/documentation/TECHNICAL_SUMMARY.md` if issues

---

## 📝 Maintenance Guidelines

### Adding New Documentation

1. Determine category (pitching, documentation, or archive)
2. Create file in appropriate folder
3. Add to INDEX.md in that folder
4. Update this file if needed

### Updating Documentation

1. Update relevant file
2. Update INDEX.md if structure changes
3. Commit to Git
4. Update version/date in file

### Archiving Documentation

1. Move file to `.kiro/archive/`
2. Remove from INDEX.md in original folder
3. Add note about why archived
4. Commit to Git

---

## 🔄 Documentation Lifecycle

### Active (Current)

- `.kiro/pitching/` - Always current
- `.kiro/documentation/` - Updated regularly
- `.kiro/specs/` - Updated as needed

### Maintained (Reference)

- `.kiro/steering/` - Updated quarterly
- `.kiro/archive/` - No updates

### Deprecated (Historical)

- Old phase docs
- Old bug fix docs
- Superseded analysis docs

---

## ✨ Benefits of This Structure

### For Users

- ✅ Easy to find what you need
- ✅ Clear navigation with INDEX files
- ✅ Organized by purpose
- ✅ Professional presentation

### For Developers

- ✅ Clean root directory
- ✅ Organized documentation
- ✅ Easy to maintain
- ✅ Clear version control

### For Project

- ✅ Professional appearance
- ✅ Easy onboarding
- ✅ Better organization
- ✅ Scalable structure

---

## 📞 Questions?

### Where do I find...?

**Presentation materials?**
→ `.kiro/pitching/`

**Technical documentation?**
→ `.kiro/documentation/`

**Old documentation?**
→ `.kiro/archive/`

**Design mockups?**
→ `.kiro/specs/mockup/`

**Project guidelines?**
→ `.kiro/steering/`

---

**Status:** ✅ DOCUMENTATION ORGANIZED

All documentation properly organized and ready for use.
