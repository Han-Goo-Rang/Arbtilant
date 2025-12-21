# Arbtilant UI/UX Design Guide for Stitch (Google AI Studio)

## 📋 Overview

Panduan ini dirancang untuk membantu generate UI/UX design Arbtilant menggunakan Stitch (Google AI Studio). Dokumen ini berisi constraint, guidelines, dan spesifikasi detail untuk memastikan design yang dihasilkan sesuai dengan visi dan kebutuhan aplikasi.

---

## 🎯 Design Objectives

1. **Meningkatkan Visual Consistency** - Semua halaman menggunakan design system yang unified
2. **Meningkatkan User Experience** - Interface yang intuitif dan mudah digunakan
3. **Menambah Fitur** - Scan detail page untuk tracking history
4. **Responsive Design** - Optimal di berbagai ukuran layar
5. **Modern Aesthetic** - Mengikuti Material Design 3 dengan customization green theme

---

## 🎨 Design System Constraints

### Color Palette (WAJIB DIGUNAKAN)

**Primary Colors:**

```
Primary Green: #2D6A4F (main brand color, use for primary actions)
Light Green: #40916C (secondary actions, hover states)
Bright Green: #52B788 (accents, highlights, success states)
```

**Neutral Colors:**

```
Dark Background: #1B1B1B (main background, use for page backgrounds)
Surface: #2D2D2D (cards, surfaces, use for card backgrounds)
Light Surface: #3D3D3D (elevated surfaces, use for elevated cards)
Text Primary: #FFFFFF (main text, use for primary text)
Text Secondary: #B0B0B0 (secondary text, use for captions)
Text Tertiary: #808080 (disabled text, hints)
```

**Semantic Colors:**

```
Success: #52B788 (positive actions, confirmations)
Warning: #FFB703 (warnings, caution messages)
Error: #D62828 (errors, destructive actions)
Info: #457B9D (informational messages)
```

**CONSTRAINT:** Semua warna harus dari palette di atas. Jangan tambah warna baru.

---

### Typography (WAJIB DIGUNAKAN)

**Font Family:** Poppins (Google Fonts)

**Typography Scale:**

```
Display Large: 32px, weight 700 (page titles, hero text)
Display Medium: 28px, weight 700 (section titles)
Headline: 24px, weight 600 (card titles, subsection titles)
Title: 20px, weight 600 (subsection titles)
Body Large: 16px, weight 400 (main content, body text)
Body Medium: 14px, weight 400 (secondary content)
Body Small: 12px, weight 400 (captions, hints, labels)
Label: 12px, weight 600 (button labels, chip labels)
```

**CONSTRAINT:** Gunakan typography scale di atas. Jangan buat ukuran custom.

---

### Spacing System (8px Grid - WAJIB DIGUNAKAN)

**Spacing Values:**

```
xs: 4px (minimal spacing)
sm: 8px (small spacing, padding dalam komponen)
md: 16px (medium spacing, padding card, margin section)
lg: 24px (large spacing, margin antar section)
xl: 32px (extra large spacing, margin halaman)
2xl: 48px (double extra large spacing, hero section)
```

**CONSTRAINT:** Semua spacing harus kelipatan 8px. Jangan gunakan nilai arbitrary.

---

### Component Specifications

#### Button Component

**Sizes:**

- Large: 48px height, 16px padding horizontal, 16px font size
- Medium: 40px height, 12px padding horizontal, 14px font size
- Small: 32px height, 8px padding horizontal, 12px font size

**Variants:**

- Filled: Primary Green background, white text (primary action)
- Outlined: Transparent background, Primary Green border, Primary Green text (secondary action)
- Text: Transparent background, Primary Green text (tertiary action)

**States:**

- Default: Normal appearance
- Hover: Light Green background (filled), Light Green border (outlined)
- Pressed: Dark Green background (filled), Dark Green border (outlined)
- Disabled: Gray background, disabled text color

**CONSTRAINT:** Button harus mengikuti spesifikasi di atas. Jangan buat button custom.

---

#### Card Component

**Specifications:**

- Background: Surface color (#2D2D2D)
- Border Radius: 12px
- Padding: 16px (md spacing)
- Shadow: Elevation 1 (subtle shadow)
- Hover: Elevation 2 (slight lift effect)

**CONSTRAINT:** Semua card harus menggunakan spesifikasi ini.

---

#### Chip Component

**Specifications:**

- Background: Light Surface (#3D3D3D)
- Border Radius: 20px (pill shape)
- Padding: 8px horizontal, 4px vertical
- Selected: Primary Green background, white text
- Unselected: Light Surface background, text secondary color
- Disabled: Gray background, disabled text color

**CONSTRAINT:** Chip harus mengikuti spesifikasi ini.

---

#### Dialog Component

**Specifications:**

- Background: Surface color (#2D2D2D)
- Border Radius: 16px
- Padding: 24px (lg spacing)
- Backdrop: Semi-transparent black (60% opacity)
- Max Width: 90% of screen width (max 500px on desktop)
- Animation: Fade in/out

**CONSTRAINT:** Dialog harus mengikuti spesifikasi ini.

---

## 📱 Responsive Design Constraints

### Breakpoints (WAJIB DIGUNAKAN)

```
Mobile: 320px - 480px (small phones)
Mobile+: 480px - 600px (large phones)
Tablet: 600px - 900px (tablets)
Desktop: 900px+ (desktop/web)
```

### Responsive Rules

**Mobile (320px - 480px):**

- Single column layout
- Full width cards with 8px margin
- Smaller font sizes (reduce by 2px)
- Larger touch targets (minimum 48px)
- Bottom navigation always visible

**Mobile+ (480px - 600px):**

- Single column layout
- Cards with 12px margin
- Standard font sizes
- Standard touch targets

**Tablet (600px - 900px):**

- 2-3 column layout where applicable
- Cards with 16px margin
- Standard font sizes
- Better spacing

**Desktop (900px+):**

- 3-4 column layout where applicable
- Cards with 24px margin
- Standard font sizes
- Optimal spacing

**CONSTRAINT:** Design harus responsive di semua breakpoint. Jangan buat design yang hanya untuk satu ukuran.

---

### Touch Target Constraints

- Minimum touch target size: 48px x 48px
- Minimum spacing between touch targets: 8px
- Buttons harus mudah di-tap dengan thumb

**CONSTRAINT:** Semua interactive element harus memenuhi constraint ini.

---

## 🏗️ Page Structure Constraints

### Home Page

**Required Sections:**

1. Hero Section (2xl spacing, gradient background)
2. Feature Cards (3 cards, md spacing between)
3. Quick Stats Section (optional)
4. Bottom Navigation

**CONSTRAINT:** Home page harus memiliki semua section di atas.

---

### Library Page

**Required Sections:**

1. AppBar dengan title
2. Search Bar (prominent, md spacing)
3. Category Filter Chips (horizontal scroll, md spacing)
4. Disease Grid (3 columns on mobile, 4 on tablet, 5 on desktop)
5. Bottom Navigation

**CONSTRAINT:** Library page harus memiliki semua section di atas.

---

### Disease Detail Page

**Required Sections:**

1. AppBar dengan back button
2. Disease Image (hero section, 2xl height)
3. Disease Info Section (name, english name, scientific names, severity)
4. Symptoms Section (list format)
5. Causes Section (list format)
6. Treatment Section (numbered list)
7. Prevention Section (list format)
8. Affected Plants Section (chips)
9. CTA Button (Scan Similar)
10. Bottom Navigation

**CONSTRAINT:** Disease detail page harus memiliki semua section di atas dalam urutan ini.

---

### Scan Result Page

**Required Sections:**

1. AppBar dengan title
2. Scanned Image (preview)
3. Primary Result Card (disease name, confidence score, confidence bar)
4. Top 3 Predictions (cards with comparison bars)
5. Treatment Recommendations (quick tips)
6. Action Buttons (View Details, View Disease Info, Feedback, Save)
7. Bottom Navigation

**CONSTRAINT:** Scan result page harus memiliki semua section di atas.

---

### Scan Detail Page (NEW)

**Required Sections:**

1. AppBar dengan back button
2. Scanned Image (full size)
3. Metadata Section (date, time, confidence)
4. Detection Result (disease name, confidence, top 3 predictions)
5. Treatment Recommendations (detailed steps)
6. Feedback Section (feedback button, feedback history)
7. Related Disease Info (link to disease detail)
8. Action Buttons (share, delete, etc)
9. Bottom Navigation

**CONSTRAINT:** Scan detail page harus memiliki semua section di atas.

---

### History Page

**Required Sections:**

1. AppBar dengan title
2. Filter/Sort Options (chips)
3. Scan Items List (cards with thumbnail, name, date)
4. Pagination / Infinite Scroll
5. Empty State (jika tidak ada scan)
6. Bottom Navigation

**CONSTRAINT:** History page harus memiliki semua section di atas.

---

## 🎬 Animation & Transition Constraints

### Page Transitions

- **Navigation**: Slide transition (300ms)
- **Dialog**: Fade in/out (200ms)
- **Snackbar**: Slide up (200ms)

**CONSTRAINT:** Gunakan transition di atas. Jangan buat custom animation.

---

### Interactive Feedback

- **Button Press**: Color change (100ms)
- **Card Hover**: Elevation change (150ms)
- **Chip Selection**: Color change (100ms)

**CONSTRAINT:** Feedback harus instant dan smooth.

---

## 📐 Layout Constraints

### Padding & Margin Rules

- **Page Padding**: 16px (md spacing) on mobile, 24px (lg spacing) on tablet+
- **Section Margin**: 24px (lg spacing) between sections
- **Card Padding**: 16px (md spacing) inside cards
- **Component Spacing**: 8px (sm spacing) between components

**CONSTRAINT:** Semua padding dan margin harus mengikuti spacing system.

---

### Image Constraints

- **Hero Images**: Aspect ratio 16:9 or 4:3
- **Card Images**: Aspect ratio 1:1 or 4:3
- **Thumbnail Images**: Aspect ratio 1:1
- **Image Border Radius**: 12px (match card border radius)

**CONSTRAINT:** Semua image harus mengikuti aspect ratio di atas.

---

## ✅ Design Checklist

Sebelum generate design di Stitch, pastikan:

- [ ] Semua warna dari color palette
- [ ] Semua typography dari typography scale
- [ ] Semua spacing kelipatan 8px
- [ ] Semua button mengikuti button specification
- [ ] Semua card mengikuti card specification
- [ ] Semua chip mengikuti chip specification
- [ ] Semua dialog mengikuti dialog specification
- [ ] Design responsive di semua breakpoint
- [ ] Semua touch target minimum 48px
- [ ] Semua page memiliki required section
- [ ] Semua animation smooth dan konsisten
- [ ] Semua image mengikuti aspect ratio

---

## 🚀 How to Use This Guide in Stitch

### Step 1: Copy Design System

Ketika prompt Stitch untuk generate design, copy-paste section berikut:

```
Design System:
- Color Palette: [copy dari section Color Palette]
- Typography: [copy dari section Typography]
- Spacing System: [copy dari section Spacing System]
- Component Specifications: [copy dari section Component Specifications]
```

### Step 2: Specify Page Requirements

Untuk setiap halaman, specify:

```
Page: [Page Name]
Required Sections: [list sections]
Responsive Breakpoints: [list breakpoints]
Constraints: [list constraints]
```

### Step 3: Provide Examples

Jika memungkinkan, provide screenshot atau reference design untuk setiap halaman.

### Step 4: Iterate & Refine

Jika design tidak sesuai constraint, revise prompt dan generate ulang.

---

## 📝 Example Prompts for Stitch

### Prompt 1: Design System

```
Create a comprehensive design system for a plant disease detection app called "Arbtilant" with the following specifications:

Color Palette:
- Primary Green: #2D6A4F
- Light Green: #40916C
- Bright Green: #52B788
- Dark Background: #1B1B1B
- Surface: #2D2D2D
- Light Surface: #3D3D3D
- Text Primary: #FFFFFF
- Text Secondary: #B0B0B0
- Text Tertiary: #808080
- Success: #52B788
- Warning: #FFB703
- Error: #D62828
- Info: #457B9D

Typography (Poppins font):
- Display Large: 32px, weight 700
- Display Medium: 28px, weight 700
- Headline: 24px, weight 600
- Title: 20px, weight 600
- Body Large: 16px, weight 400
- Body Medium: 14px, weight 400
- Body Small: 12px, weight 400
- Label: 12px, weight 600

Spacing System (8px grid):
- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px
- 2xl: 48px

Create design system documentation with:
1. Color palette with usage guidelines
2. Typography scale with examples
3. Spacing system with examples
4. Button component (filled, outlined, text variants)
5. Card component
6. Chip component
7. Dialog component
8. Bottom navigation component
```

### Prompt 2: Home Page

```
Design a home page for Arbtilant plant disease detection app with:

Required Sections:
1. Hero Section (gradient background, welcome text, CTA button)
2. Feature Cards (3 cards: Scan, Library, History)
3. Quick Stats Section
4. Bottom Navigation (Home, Scan, Library, History)

Constraints:
- Use color palette: Primary Green #2D6A4F, Dark Background #1B1B1B, Surface #2D2D2D
- Use typography: Poppins font, Display Large for title, Body Large for content
- Use spacing: 8px grid system
- Responsive: Mobile (320px), Tablet (600px), Desktop (900px)
- Touch targets: minimum 48px
- Animations: smooth transitions (300ms)

Design should be modern, clean, and follow Material Design 3 principles.
```

### Prompt 3: Library Page

```
Design a library page for Arbtilant with:

Required Sections:
1. AppBar with title "Disease Library"
2. Search Bar (prominent, with filter button)
3. Category Filter Chips (horizontal scroll)
4. Disease Grid (3 columns on mobile, 4 on tablet, 5 on desktop)
5. Bottom Navigation

Each Disease Card should show:
- Disease image (1:1 aspect ratio)
- Disease name
- Severity badge
- Short description

Constraints:
- Use color palette: Primary Green #2D6A4F, Dark Background #1B1B1B, Surface #2D2D2D
- Use typography: Poppins font
- Use spacing: 8px grid system
- Responsive: Mobile (320px), Tablet (600px), Desktop (900px)
- Touch targets: minimum 48px
- Card border radius: 12px
- Infinite scroll or pagination

Design should be modern, clean, and follow Material Design 3 principles.
```

---

## 🔄 Design Iteration Process

1. **Generate Initial Design** - Use Stitch with constraint prompt
2. **Review Against Checklist** - Check if design meets all constraints
3. **Identify Issues** - Note any constraint violations
4. **Revise Prompt** - Update prompt to address issues
5. **Generate Revised Design** - Generate design again
6. **Repeat** - Until design meets all constraints

---

## 📞 Support & Questions

Jika ada pertanyaan tentang constraint atau design system:

1. Refer ke section yang relevan di dokumen ini
2. Check design checklist
3. Review example prompts
4. Iterate dengan Stitch sampai design sesuai

---

## 📚 Additional Resources

- Material Design 3: https://m3.material.io/
- Google Fonts - Poppins: https://fonts.google.com/specimen/Poppins
- Flutter Material Design: https://flutter.dev/docs/development/ui/widgets/material
- Responsive Design Best Practices: https://web.dev/responsive-web-design-basics/

---

**Last Updated:** December 21, 2025
**Version:** 1.0
**Status:** Ready for Stitch Design Generation
