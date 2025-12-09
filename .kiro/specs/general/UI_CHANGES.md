# 🎨 UI Changes & Features - Arbtilant Enhancement

## Overview

Dokumentasi perubahan dan penambahan fitur UI untuk Arbtilant Enhancement.

---

## 📱 Current UI Structure

### 1. Home Page

**Lokasi:** `lib/Pages/home_page.dart`

**Fitur:**

- Header dengan logo Arbtilant
- Tombol "Scan Plant" utama (hijau)
- Quick Actions (3 tombol):
  - Disease Library
  - My Plants
  - Recent
- Recent Scans Section
- Bottom Navigation Bar

**Warna:**

- Background: Dark (#1a1a1a)
- Accent: Bright Green (#4CAF50)
- Text: White & Gray

---

### 2. Disease Detail Page

**Lokasi:** `lib/Pages/disease_detail_page.dart`

**Fitur:**

- Disease image header
- Disease name & English name
- Severity badge (High/Medium/Low)
- Tab navigation:
  - Overview
  - Symptoms
  - Treatment
  - Prevention
- Action buttons:
  - Save to My Plants
  - Share Results
  - Find Products
- Affected plants chips

**Tab Content:**

- **Overview:** Description + Affected Plants
- **Symptoms:** Bullet list dengan green dots
- **Treatment:** Numbered list dengan green circles
- **Prevention:** Bullet list dengan green dots

---

### 3. History Page

**Lokasi:** `lib/Pages/history_page.dart`

**Fitur:**

- Stats card (Total Scan, Feedback, Akurasi)
- Scan history list
- Swipe to delete
- Confidence badge
- Model version info
- Empty state

**Stat Items:**

- Total Scan (dengan icon camera)
- Feedback (dengan icon feedback)
- Akurasi (dengan icon check_circle)

---

## 🎯 Planned UI Enhancements

### Phase 2: Library Feature

#### Disease Library Page

**Fitur yang akan ditambahkan:**

- [ ] Grid/List view toggle
- [ ] Search bar
- [ ] Filter by severity
- [ ] Filter by category
- [ ] Disease cards dengan:
  - Disease image
  - Name (Indonesian & English)
  - Severity badge
  - Category tag
  - Quick info

**Layout:**

```
┌─────────────────────────────────┐
│ Search Bar                      │
├─────────────────────────────────┤
│ Filter: Severity | Category     │
├─────────────────────────────────┤
│ ┌──────────┐  ┌──────────┐     │
│ │ Disease  │  │ Disease  │     │
│ │ Card 1   │  │ Card 2   │     │
│ └──────────┘  └──────────┘     │
│ ┌──────────┐  ┌──────────┐     │
│ │ Disease  │  │ Disease  │     │
│ │ Card 3   │  │ Card 4   │     │
│ └──────────┘  └──────────┘     │
└─────────────────────────────────┘
```

---

### Phase 3: Feedback System

#### Feedback Dialog

**Fitur:**

- [ ] Show scan result
- [ ] Question: "Is this correct?"
- [ ] Yes/No buttons
- [ ] If No:
  - [ ] Dropdown untuk select correct disease
  - [ ] Text field untuk feedback
- [ ] Submit button
- [ ] Success message

**Layout:**

```
┌─────────────────────────────────┐
│ Scan Result                     │
│ [Image]                         │
│ Predicted: Hawar Daun           │
│ Confidence: 95%                 │
├─────────────────────────────────┤
│ Is this correct?                │
│ [Yes]  [No]                     │
├─────────────────────────────────┤
│ (If No)                         │
│ Correct disease:                │
│ [Dropdown ▼]                    │
│ Feedback:                       │
│ [Text field]                    │
│ [Submit]                        │
└─────────────────────────────────┘
```

#### Feedback History Page

**Fitur:**

- [ ] List of all feedback
- [ ] Filter by status (Synced/Pending)
- [ ] Sync status indicator
- [ ] Feedback details:
  - Original prediction
  - Corrected disease
  - Feedback text
  - Timestamp
  - Sync status
- [ ] Delete feedback

**Sync Status Indicators:**

- ✅ Synced (green checkmark)
- ⏳ Pending (orange clock)
- ❌ Error (red X)

---

### Phase 4: Model Management

#### Model Info Widget

**Fitur:**

- [ ] Current model version
- [ ] Model accuracy
- [ ] Last update date
- [ ] Update available indicator
- [ ] Manual update button

**Layout:**

```
┌─────────────────────────────────┐
│ Model Information               │
│ Current: v1.0                   │
│ Accuracy: 95%                   │
│ Last Update: 2024-12-01         │
│ Status: Up to date ✓            │
│ [Check for Updates]             │
└─────────────────────────────────┘
```

---

## 🎨 Design System

### Colors

| Name              | Hex     | Usage                       |
| ----------------- | ------- | --------------------------- |
| Dark BG           | #1a1a1a | Main background             |
| Dark BG Secondary | #2a2a2a | Cards, secondary bg         |
| Dark BG Tertiary  | #3a3a3a | Tertiary elements           |
| Bright Green      | #4CAF50 | Accent, buttons, highlights |
| Text White        | #FFFFFF | Primary text                |
| Text Gray         | #999999 | Secondary text              |

### Typography

| Element   | Font    | Size | Weight |
| --------- | ------- | ---- | ------ |
| Heading 1 | Poppins | 24   | 700    |
| Heading 2 | Poppins | 18   | 600    |
| Heading 3 | Poppins | 16   | 600    |
| Body      | Poppins | 14   | 400    |
| Caption   | Poppins | 12   | 500    |

### Spacing

| Size | Value |
| ---- | ----- |
| XS   | 4px   |
| S    | 8px   |
| M    | 12px  |
| L    | 16px  |
| XL   | 24px  |
| XXL  | 32px  |

### Border Radius

| Size   | Value |
| ------ | ----- |
| Small  | 4px   |
| Medium | 8px   |
| Large  | 12px  |
| XL     | 24px  |

---

## 📊 Component Library

### Buttons

#### Primary Button (Green)

```
Background: #4CAF50
Text: Black
Padding: 14px vertical, 24px horizontal
Border Radius: 24px
```

#### Secondary Button (Outlined)

```
Border: 2px #4CAF50
Text: #4CAF50
Padding: 14px vertical, 24px horizontal
Border Radius: 24px
```

### Cards

#### Disease Card

```
Background: #2a2a2a
Border Radius: 12px
Padding: 12px
Shadow: None
```

#### Stats Card

```
Background: #2a2a2a
Border Radius: 12px
Padding: 16px
Shadow: None
```

### Badges

#### Severity Badge

- High: Red background
- Medium: Orange background
- Low: Green background

#### Confidence Badge

- > = 80%: Green
- 50-80%: Orange
- < 50%: Red

---

## 🔄 Navigation Flow

### Current Flow

```
Home Page
├── Scan Plant → Scan Page
├── Disease Library → Library Page → Disease Detail
├── My Plants → (Not implemented)
├── Recent → History Page
└── Bottom Nav
    ├── Home
    ├── Scan
    ├── Library
    └── History
```

### Planned Flow

```
Home Page
├── Scan Plant → Scan Page → Feedback Dialog → Feedback History
├── Disease Library → Library Page
│   ├── Search/Filter
│   └── Disease Card → Disease Detail
├── My Plants → My Plants Page
└── Recent → History Page
    ├── View Details
    └── Manage Feedback
```

---

## 📋 UI Checklist

### Phase 2: Library Feature

- [ ] Create LibraryPage with search
- [ ] Create DiseaseCard widget
- [ ] Implement search functionality
- [ ] Implement filter by severity
- [ ] Implement filter by category
- [ ] Add grid/list toggle
- [ ] Polish animations
- [ ] Test on different screen sizes

### Phase 3: Feedback System

- [ ] Create FeedbackDialog
- [ ] Create FeedbackHistoryPage
- [ ] Implement feedback form
- [ ] Add sync status indicators
- [ ] Add delete functionality
- [ ] Polish animations
- [ ] Test on different screen sizes

### Phase 4: Model Management

- [ ] Create ModelInfoWidget
- [ ] Display current model version
- [ ] Show model accuracy
- [ ] Add update button
- [ ] Show update status
- [ ] Polish UI

---

## 🎬 Animations & Transitions

### Page Transitions

- Slide transition (left to right)
- Duration: 300ms
- Curve: Ease in out

### Button Interactions

- Scale animation on tap
- Duration: 200ms
- Curve: Ease in out

### Loading States

- Circular progress indicator
- Color: Bright Green
- Size: 24px

### Empty States

- Icon + message
- Icon size: 64px
- Icon color: Gray

---

## 📱 Responsive Design

### Screen Sizes

| Device       | Width     | Breakpoint |
| ------------ | --------- | ---------- |
| Mobile       | 360-480px | Small      |
| Tablet       | 600-900px | Medium     |
| Large Tablet | 900px+    | Large      |

### Padding Adjustments

| Breakpoint | Horizontal Padding |
| ---------- | ------------------ |
| Small      | 16px               |
| Medium     | 24px               |
| Large      | 32px               |

---

## 🧪 UI Testing Checklist

- [ ] Test on different screen sizes
- [ ] Test dark mode
- [ ] Test with different text sizes
- [ ] Test with slow network
- [ ] Test with no network (offline)
- [ ] Test with long text
- [ ] Test with images
- [ ] Test animations
- [ ] Test transitions
- [ ] Test accessibility

---

## 📸 Screenshots & Mockups

### Current State

**Home Page:**

- Logo + Title
- Scan button
- Quick actions (3 buttons)
- Recent scans section

**Disease Detail:**

- Image header
- Disease info
- Tab navigation
- Action buttons

**History Page:**

- Stats card
- Scan history list
- Swipe to delete

### Planned State

**Library Page:**

- Search bar
- Filter options
- Disease grid/list
- Disease cards

**Feedback Dialog:**

- Scan result preview
- Yes/No question
- Feedback form (if No)
- Submit button

**Feedback History:**

- Feedback list
- Sync status
- Delete option

---

## 🚀 Implementation Priority

### High Priority

1. Disease Library Page (Phase 2)
2. Feedback Dialog (Phase 3)
3. Feedback History Page (Phase 3)

### Medium Priority

1. Search & Filter (Phase 2)
2. Sync Status Indicators (Phase 3)
3. Model Info Widget (Phase 4)

### Low Priority

1. Animations & Transitions
2. Responsive Design Tweaks
3. Accessibility Improvements

---

## 📞 Design Notes

- Konsisten dengan design system yang ada
- Gunakan Poppins font untuk semua text
- Gunakan Bright Green (#4CAF50) untuk accent
- Dark theme untuk semua pages
- Rounded corners untuk cards & buttons
- Smooth transitions & animations

---

**Last Updated:** December 9, 2025
**Version:** 1.0
**Status:** Ready for Implementation
