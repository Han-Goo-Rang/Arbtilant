# Design Document - Arbtilant UI/UX Redesign

## Overview

Redesign UI/UX Arbtilant bertujuan untuk meningkatkan visual consistency, user experience, dan menambahkan fitur scan detail page. Desain akan mengikuti Material Design 3 principles dengan customization untuk brand Arbtilant (green theme). Semua halaman akan di-redesign dengan fokus pada clarity, hierarchy, dan responsiveness.

## Architecture

### Design System Foundation

```
┌─────────────────────────────────────────────────────┐
│              Design System Layer                    │
├─────────────────────────────────────────────────────┤
│  Color Palette │ Typography │ Spacing │ Components  │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│           Component Library Layer                   │
├─────────────────────────────────────────────────────┤
│  Buttons │ Cards │ Chips │ Dialogs │ Navigation     │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│              Page Layer                             │
├─────────────────────────────────────────────────────┤
│  Home │ Scan │ Library │ History │ Detail Pages     │
└─────────────────────────────────────────────────────┘
```

### Color Palette

**Primary Colors:**

- Primary Green: `#2D6A4F` (main brand color)
- Light Green: `#40916C` (secondary actions)
- Bright Green: `#52B788` (accents, highlights)

**Neutral Colors:**

- Dark Background: `#1B1B1B` (main background)
- Surface: `#2D2D2D` (cards, surfaces)
- Light Surface: `#3D3D3D` (elevated surfaces)
- Text Primary: `#FFFFFF` (main text)
- Text Secondary: `#B0B0B0` (secondary text)
- Text Tertiary: `#808080` (disabled, hints)

**Semantic Colors:**

- Success: `#52B788` (positive actions)
- Warning: `#FFB703` (warnings, caution)
- Error: `#D62828` (errors, destructive)
- Info: `#457B9D` (informational)

### Typography

**Font Family:** Poppins (Google Fonts)

**Scale:**

- Display Large: 32px, weight 700 (page titles)
- Display Medium: 28px, weight 700 (section titles)
- Headline: 24px, weight 600 (card titles)
- Title: 20px, weight 600 (subsection titles)
- Body Large: 16px, weight 400 (main content)
- Body Medium: 14px, weight 400 (secondary content)
- Body Small: 12px, weight 400 (captions, hints)
- Label: 12px, weight 600 (buttons, labels)

### Spacing System (8px Grid)

- xs: 4px
- sm: 8px
- md: 16px
- lg: 24px
- xl: 32px
- 2xl: 48px

### Component Specifications

#### Button Component

**States:**

- Default: Primary Green background, white text
- Hover: Light Green background
- Pressed: Dark Green background
- Disabled: Gray background, disabled text

**Sizes:**

- Large: 48px height, 16px padding horizontal
- Medium: 40px height, 12px padding horizontal
- Small: 32px height, 8px padding horizontal

**Variants:**

- Filled (primary action)
- Outlined (secondary action)
- Text (tertiary action)

#### Card Component

**Specifications:**

- Background: Surface color
- Border Radius: 12px
- Padding: 16px
- Shadow: Elevation 1 (subtle shadow)
- Hover: Elevation 2 (slight lift)

#### Chip Component

**Specifications:**

- Background: Light Surface
- Border Radius: 20px
- Padding: 8px 12px
- Selected: Primary Green background
- Disabled: Gray background

#### Dialog Component

**Specifications:**

- Background: Surface color
- Border Radius: 16px
- Padding: 24px
- Backdrop: Semi-transparent black (60% opacity)
- Max Width: 90% of screen width (max 500px)

## Components and Interfaces

### Page Structure

#### 1. Home Page

**Layout:**

```
┌─────────────────────────────────┐
│  Status Bar                     │
├─────────────────────────────────┤
│  Hero Section                   │
│  - Background image/gradient    │
│  - Welcome text                 │
│  - CTA Button (Scan Plant)      │
├─────────────────────────────────┤
│  Feature Cards (3 columns)      │
│  - Scan                         │
│  - Library                      │
│  - History                      │
├─────────────────────────────────┤
│  Quick Stats / Recent Activity  │
├─────────────────────────────────┤
│  Bottom Navigation              │
└─────────────────────────────────┘
```

**Components:**

- Hero section dengan gradient background
- 3 feature cards dengan icon, title, description
- Quick stats card (total scans, recent activity)
- Bottom navigation bar

#### 2. Scan Page

**Layout:**

```
┌─────────────────────────────────┐
│  AppBar (Scan Plant)            │
├─────────────────────────────────┤
│  Camera Preview                 │
│  - Full screen camera           │
│  - Focus indicator              │
├─────────────────────────────────┤
│  Bottom Controls                │
│  - Capture button (FAB)         │
│  - Gallery button               │
│  - Flash toggle                 │
├─────────────────────────────────┤
│  Bottom Navigation              │
└─────────────────────────────────┘
```

**Components:**

- Camera preview dengan overlay
- Large capture button (FAB)
- Gallery & flash buttons
- Loading indicator saat processing

#### 3. Library Page

**Layout:**

```
┌─────────────────────────────────┐
│  AppBar (Disease Library)       │
├─────────────────────────────────┤
│  Search Bar                     │
│  - Search input                 │
│  - Filter button                │
├─────────────────────────────────┤
│  Category Filter Chips          │
│  - Horizontal scroll            │
├─────────────────────────────────┤
│  Disease Grid (3 columns)       │
│  - Disease cards                │
│  - Infinite scroll              │
├─────────────────────────────────┤
│  Bottom Navigation              │
└─────────────────────────────────┘
```

**Components:**

- Search bar dengan icon
- Horizontal scrollable category chips
- Disease cards dengan image, name, severity badge
- Loading & empty states

#### 4. Disease Detail Page

**Layout:**

```
┌─────────────────────────────────┐
│  AppBar (Back button)           │
├─────────────────────────────────┤
│  Disease Image (Hero)           │
├─────────────────────────────────┤
│  Disease Info Section           │
│  - Name, English name           │
│  - Scientific names             │
│  - Severity badge               │
├─────────────────────────────────┤
│  Symptoms Section               │
│  - List of symptoms             │
├─────────────────────────────────┤
│  Causes Section                 │
│  - List of causes               │
├─────────────────────────────────┤
│  Treatment Section              │
│  - Numbered steps               │
├─────────────────────────────────┤
│  Prevention Section             │
│  - List of prevention tips      │
├─────────────────────────────────┤
│  Affected Plants Section        │
│  - Chips/tags                   │
├─────────────────────────────────┤
│  CTA Button (Scan Similar)      │
├─────────────────────────────────┤
│  Bottom Navigation              │
└─────────────────────────────────┘
```

**Components:**

- Hero image section
- Info cards untuk setiap section
- Numbered list untuk treatment
- Chips untuk affected plants
- CTA button

#### 5. Scan Result Page (Redesigned)

**Layout:**

```
┌─────────────────────────────────┐
│  AppBar (Scan Result)           │
├─────────────────────────────────┤
│  Scanned Image                  │
├─────────────────────────────────┤
│  Primary Result Card            │
│  - Disease name                 │
│  - Confidence score (%)         │
│  - Confidence bar               │
├─────────────────────────────────┤
│  Top 3 Predictions              │
│  - Prediction cards with bars   │
├─────────────────────────────────┤
│  Treatment Recommendations      │
│  - Quick tips                   │
├─────────────────────────────────┤
│  Action Buttons                 │
│  - View Details                 │
│  - View Disease Info            │
│  - Feedback                     │
│  - Save                         │
├─────────────────────────────────┤
│  Bottom Navigation              │
└─────────────────────────────────┘
```

**Components:**

- Image preview
- Result card dengan confidence score
- Prediction comparison bars
- Action buttons
- Feedback dialog trigger

#### 6. Scan Detail Page (NEW)

**Layout:**

```
┌─────────────────────────────────┐
│  AppBar (Scan Detail)           │
├─────────────────────────────────┤
│  Scanned Image                  │
│  - Full size image              │
├─────────────────────────────────┤
│  Metadata Section               │
│  - Date, time, confidence       │
├─────────────────────────────────┤
│  Detection Result               │
│  - Disease name                 │
│  - Confidence score             │
│  - Top 3 predictions            │
├─────────────────────────────────┤
│  Treatment Recommendations      │
│  - Detailed treatment steps     │
├─────────────────────────────────┤
│  Feedback Section               │
│  - Feedback button              │
│  - Feedback history             │
├─────────────────────────────────┤
│  Related Disease Info           │
│  - Link to disease detail       │
├─────────────────────────────────┤
│  Action Buttons                 │
│  - Share, Delete, etc           │
├─────────────────────────────────┤
│  Bottom Navigation              │
└─────────────────────────────────┘
```

**Components:**

- Full image display
- Metadata card
- Result card
- Treatment card
- Feedback section
- Related info card

#### 7. History Page

**Layout:**

```
┌─────────────────────────────────┐
│  AppBar (Scan History)          │
├─────────────────────────────────┤
│  Filter/Sort Options            │
│  - Date range, disease type     │
├─────────────────────────────────┤
│  Scan Items List                │
│  - Thumbnail, name, date        │
│  - Swipe to delete              │
├─────────────────────────────────┤
│  Pagination / Infinite Scroll   │
├─────────────────────────────────┤
│  Empty State (if no scans)      │
├─────────────────────────────────┤
│  Bottom Navigation              │
└─────────────────────────────────┘
```

**Components:**

- Filter/sort chips
- Scan item cards
- Thumbnail images
- Delete confirmation dialog
- Empty state illustration

#### 8. Bottom Navigation

**Layout:**

```
┌─────────────────────────────────┐
│  Home Icon + Label              │
│  Scan Icon + Label              │
│  Library Icon + Label           │
│  History Icon + Label           │
└─────────────────────────────────┘
```

**Specifications:**

- Height: 64px (including safe area)
- Active indicator: Color change + underline
- Icons: 24px
- Labels: 12px, weight 500
- Spacing: Equal distribution

## Data Models

### ScanDetailModel

```dart
class ScanDetailModel {
  final String id;
  final String imagePath;
  final String detectedDisease;
  final double confidence;
  final List<PredictionModel> topPredictions;
  final DateTime scanDate;
  final String? location;
  final String? notes;
  final List<FeedbackModel> feedbacks;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class PredictionModel {
  final String label;
  final double confidence;
  final int rank;
}
```

## Correctness Properties

A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.

### Property 1: Design Consistency Across Pages

_For any_ page in the Arbtilant System, all text elements should use typography from the defined typography scale, all colors should come from the defined color palette, and all spacing should be multiples of 8px.

**Validates: Requirements 1.1, 1.2, 1.3**

### Property 2: Responsive Layout Adaptation

_For any_ screen size (phone, tablet, landscape), the layout should adapt appropriately without overflow, text should remain readable, and touch targets should be at least 48px.

**Validates: Requirements 10.1, 10.2, 10.4, 10.5**

### Property 3: Navigation Consistency

_For any_ navigation action (tab tap, button click), the app should navigate to the correct page with smooth transition and the active tab should be visually indicated.

**Validates: Requirements 2.5, 8.2, 8.3**

### Property 4: Scan Detail Data Integrity

_For any_ scan result, when user navigates to scan detail page, all metadata (image, date, confidence, predictions) should be displayed correctly and match the original scan data.

**Validates: Requirements 6.1, 6.2, 6.3**

### Property 5: Visual Feedback on Interaction

_For any_ interactive element (button, card, chip), when user interacts with it, the element should provide immediate visual feedback (color change, elevation, animation).

**Validates: Requirements 1.4, 9.1**

## Error Handling

### Network Errors

- Display error banner with retry button
- Show cached data if available
- Log error for debugging

### Image Loading Errors

- Show placeholder image
- Display error icon
- Provide retry option

### Data Validation Errors

- Show validation error message
- Highlight invalid field
- Provide clear guidance

### State Management Errors

- Show error dialog
- Provide recovery options
- Log error for debugging

## Testing Strategy

### Unit Testing

- Test color palette consistency
- Test typography scale calculations
- Test spacing system calculations
- Test responsive breakpoints
- Test data model serialization/deserialization

### Widget Testing

- Test page layouts at different screen sizes
- Test navigation between pages
- Test component rendering
- Test interactive elements (buttons, chips, dialogs)
- Test loading and empty states

### Integration Testing

- Test end-to-end user flows
- Test navigation flows
- Test data persistence
- Test offline functionality
- Test sync mechanism

### Property-Based Testing

- **Property 1**: Design consistency - generate random pages and verify design compliance
- **Property 2**: Responsive adaptation - test layouts at various screen sizes
- **Property 3**: Navigation consistency - test all navigation paths
- **Property 4**: Scan detail integrity - test scan data round-trip
- **Property 5**: Visual feedback - test interaction states
