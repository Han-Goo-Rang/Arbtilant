# Implementation Plan - Arbtilant UI/UX Redesign

## Overview

Implementasi redesign UI/UX Arbtilant akan dilakukan secara bertahap, dimulai dari setup design system, kemudian redesign setiap halaman, dan terakhir menambahkan fitur scan detail page.

## 📊 Mockup Reference

Semua mockup sudah tersedia di `.kiro/specs/mockup/`:

- Home Page: `arbtilant_home_page/screen.png`
- Scan Page: `arbtilant_scan_page/screen.png`
- Disease Library: `arbtilant_disease_library_page/screen.png`
- Disease Detail: `arbtilant_disease_detail_page/screen.png`
- Scan Result: `arbtilant_scan_result_page/screen.png`
- Scan Detail (NEW): `arbtilant_scan_detail_page/screen.png`
- History: `arbtilant_history_page/screen.png`
- Onboarding: `Onborading/onboarding_screen*.png` (3 screens)

**Mockup Analysis:** `.kiro/specs/mockup/MOCKUP_ANALYSIS.md`

- Overall Compliance: 94% ✅
- All Requirements Fulfilled: 100% ✅
- Ready for Implementation: YES ✅

---

## Phase 1: Design System & Core Components

- [ ] 1. Setup Design System Foundation

  - Create `lib/core/design_system/` folder structure
  - Define color constants in `colors.dart`
  - Define typography constants in `typography.dart`
  - Define spacing constants in `spacing.dart`
  - Define theme data in `theme.dart`
  - _Requirements: 1.1, 1.2, 1.3_

- [ ] 2. Create Reusable Button Components

  - Implement `PrimaryButton` widget (filled variant)
  - Implement `SecondaryButton` widget (outlined variant)
  - Implement `TextButton` widget (text variant)
  - Support all sizes (large, medium, small)
  - Support all states (default, hover, pressed, disabled)
  - _Requirements: 1.4_

- [ ]\* 2.1 Write unit tests for button components

  - Test button rendering with different variants
  - Test button states and visual feedback
  - Test button sizes and padding
  - _Requirements: 1.4_

- [ ] 3. Create Reusable Card Components

  - Implement `BaseCard` widget with customizable content
  - Implement `DiseaseCard` widget for library
  - Implement `ScanResultCard` widget for results
  - Implement `HistoryCard` widget for history
  - Support elevation and shadow effects
  - _Requirements: 1.1, 1.3_

- [ ]\* 3.1 Write unit tests for card components

  - Test card rendering and layout
  - Test card elevation and shadows
  - Test card content rendering
  - _Requirements: 1.1_

- [ ] 4. Create Reusable Chip Components

  - Implement `FilterChip` widget for category filtering
  - Implement `SeverityChip` widget for disease severity
  - Implement `TagChip` widget for affected plants
  - Support selected/unselected states
  - _Requirements: 1.4_

- [ ]\* 4.1 Write unit tests for chip components

  - Test chip rendering and states
  - Test chip selection behavior
  - _Requirements: 1.4_

- [ ] 5. Create Dialog Components

  - Implement `BaseDialog` widget with customizable content
  - Implement `ConfirmationDialog` for delete actions
  - Implement `FeedbackDialog` for feedback submission
  - Support backdrop and animations
  - _Requirements: 9.1, 9.5_

- [ ]\* 5.1 Write unit tests for dialog components

  - Test dialog rendering and layout
  - Test dialog actions (confirm, cancel)
  - Test dialog backdrop
  - _Requirements: 9.1_

- [ ] 6. Create Bottom Navigation Component

  - Implement `CustomBottomNav` with 4 tabs (Home, Scan, Library, History)
  - Support active tab indication
  - Support smooth transitions
  - Support responsive sizing
  - _Requirements: 8.1, 8.2, 8.3, 8.4_

- [ ]\* 6.1 Write unit tests for bottom navigation

  - Test navigation rendering
  - Test tab switching
  - Test active indicator
  - _Requirements: 8.1, 8.3_

- [ ] 7. Checkpoint - Ensure all design system tests pass
  - Ensure all tests pass, ask the user if questions arise.

---

## Phase 2: Home Page Redesign

- [ ] 8. Redesign Home Page Layout

  - Create new `HomePage` with hero section
  - Implement hero section with gradient background
  - Implement feature cards (Scan, Library, History)
  - Implement quick stats section
  - Implement bottom navigation integration
  - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5_

- [ ]\* 8.1 Write unit tests for home page

  - Test page layout and rendering
  - Test feature cards display
  - Test navigation buttons
  - _Requirements: 2.1, 2.2_

- [ ]\* 8.2 Write property test for home page responsiveness

  - **Property 2: Responsive Layout Adaptation**
  - **Validates: Requirements 10.1, 10.2, 10.4, 10.5**

- [ ] 9. Checkpoint - Ensure home page looks good
  - Ensure all tests pass, ask the user if questions arise.

---

## Phase 3: Library Page Redesign

- [ ] 10. Redesign Library Page Layout

  - Update `LibraryPageNew` with new design
  - Improve search bar styling and functionality
  - Redesign disease cards with better visual hierarchy
  - Implement category filter chips
  - Implement infinite scroll or pagination
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

- [ ]\* 10.1 Write unit tests for library page

  - Test page layout and rendering
  - Test search functionality
  - Test filter functionality
  - Test disease card display
  - _Requirements: 3.1, 3.2, 3.5_

- [ ]\* 10.2 Write property test for library page responsiveness

  - **Property 2: Responsive Layout Adaptation**
  - **Validates: Requirements 10.1, 10.2, 10.4, 10.5**

- [ ] 11. Checkpoint - Ensure library page looks good
  - Ensure all tests pass, ask the user if questions arise.

---

## Phase 4: Disease Detail Page Redesign

- [ ] 12. Redesign Disease Detail Page Layout

  - Update `DiseaseDetailPage` with new design
  - Implement hero image section
  - Implement disease info section with proper hierarchy
  - Implement symptoms, causes, treatment, prevention sections
  - Implement affected plants chips
  - Implement "Scan Similar" CTA button
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_

- [ ]\* 12.1 Write unit tests for disease detail page

  - Test page layout and rendering
  - Test section display
  - Test button functionality
  - _Requirements: 4.1, 4.2, 4.3_

- [ ]\* 12.2 Write property test for disease detail page responsiveness

  - **Property 2: Responsive Layout Adaptation**
  - **Validates: Requirements 10.1, 10.2, 10.4, 10.5**

- [ ] 13. Checkpoint - Ensure disease detail page looks good
  - Ensure all tests pass, ask the user if questions arise.

---

## Phase 5: Scan Result Page Redesign

- [ ] 14. Redesign Scan Result Page Layout

  - Update `ScanPage` result display with new design
  - Implement primary result card with confidence score
  - Implement top 3 predictions with comparison bars
  - Implement treatment recommendations section
  - Implement action buttons (View Details, View Disease Info, Feedback, Save)
  - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_

- [ ]\* 14.1 Write unit tests for scan result page

  - Test result display
  - Test prediction bars
  - Test action buttons
  - _Requirements: 5.1, 5.2, 5.3_

- [ ]\* 14.2 Write property test for scan result page responsiveness

  - **Property 2: Responsive Layout Adaptation**
  - **Validates: Requirements 10.1, 10.2, 10.4, 10.5**

- [ ] 15. Checkpoint - Ensure scan result page looks good
  - Ensure all tests pass, ask the user if questions arise.

---

## Phase 6: Scan Detail Page (NEW FEATURE)

- [ ] 16. Create Scan Detail Data Model

  - Create `ScanDetailModel` class with all required fields
  - Implement serialization/deserialization methods
  - Create `PredictionModel` for top predictions
  - _Requirements: 6.1, 6.2, 6.3_

- [ ]\* 16.1 Write unit tests for scan detail model

  - Test model creation and serialization
  - Test data validation
  - _Requirements: 6.1, 6.2_

- [ ] 17. Create Scan Detail Repository

  - Create `ScanDetailRepository` interface
  - Implement repository with local storage (Hive)
  - Implement methods: getScanDetail, saveScanDetail, deleteScanDetail
  - _Requirements: 6.1, 6.2, 6.3_

- [ ]\* 17.1 Write unit tests for scan detail repository

  - Test repository methods
  - Test data persistence
  - _Requirements: 6.1, 6.2_

- [ ] 18. Create Scan Detail Service

  - Create `ScanDetailService` class
  - Implement business logic for scan detail operations
  - Implement methods: getScanDetail, saveScanDetail, deleteScanDetail, getFeedbacks
  - _Requirements: 6.1, 6.2, 6.3, 6.4_

- [ ]\* 18.1 Write unit tests for scan detail service

  - Test service methods
  - Test business logic
  - _Requirements: 6.1, 6.2_

- [ ]\* 18.2 Write property test for scan detail data integrity

  - **Property 4: Scan Detail Data Integrity**
  - **Validates: Requirements 6.1, 6.2, 6.3**

- [ ] 19. Create Scan Detail Page UI

  - Create new `ScanDetailPage` widget
  - Implement image display section
  - Implement metadata section (date, time, confidence)
  - Implement detection result section
  - Implement treatment recommendations section
  - Implement feedback section
  - Implement related disease info section
  - Implement action buttons (share, delete, etc)
  - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5_

- [ ]\* 19.1 Write unit tests for scan detail page

  - Test page layout and rendering
  - Test section display
  - Test button functionality
  - _Requirements: 6.1, 6.2, 6.3_

- [ ]\* 19.2 Write property test for scan detail page responsiveness

  - **Property 2: Responsive Layout Adaptation**
  - **Validates: Requirements 10.1, 10.2, 10.4, 10.5**

- [ ] 20. Integrate Scan Detail Page with Scan Result Page

  - Update `ScanPage` to navigate to `ScanDetailPage`
  - Pass scan result data to detail page
  - Implement "View Details" button functionality
  - _Requirements: 5.4, 6.1_

- [ ] 21. Checkpoint - Ensure scan detail page works correctly
  - Ensure all tests pass, ask the user if questions arise.

---

## Phase 7: History Page Redesign

- [ ] 22. Redesign History Page Layout

  - Update `HistoryPage` with new design
  - Implement filter/sort options
  - Redesign scan item cards with thumbnails
  - Implement swipe to delete functionality
  - Implement delete confirmation dialog
  - Implement empty state
  - _Requirements: 7.1, 7.2, 7.3, 7.4, 7.5_

- [ ]\* 22.1 Write unit tests for history page

  - Test page layout and rendering
  - Test scan item display
  - Test delete functionality
  - _Requirements: 7.1, 7.2, 7.3_

- [ ]\* 22.2 Write property test for history page responsiveness

  - **Property 2: Responsive Layout Adaptation**
  - **Validates: Requirements 10.1, 10.2, 10.4, 10.5**

- [ ] 23. Checkpoint - Ensure history page looks good
  - Ensure all tests pass, ask the user if questions arise.

---

## Phase 8: Feedback Dialog Redesign

- [ ] 24. Redesign Feedback Dialog

  - Update `FeedbackDialog` with new design
  - Improve form layout and styling
  - Implement disease selection dropdown
  - Implement feedback text input
  - Implement submit and cancel buttons
  - _Requirements: 9.1, 9.2, 9.3, 9.4, 9.5_

- [ ]\* 24.1 Write unit tests for feedback dialog

  - Test dialog rendering
  - Test form submission
  - Test dialog actions
  - _Requirements: 9.1, 9.2, 9.3_

- [ ] 25. Checkpoint - Ensure feedback dialog works correctly
  - Ensure all tests pass, ask the user if questions arise.

---

## Phase 9: Responsive Design & Mobile Optimization

- [ ] 26. Test Responsive Design on Various Screen Sizes

  - Test on phone (320px - 480px)
  - Test on tablet (600px - 900px)
  - Test on landscape mode
  - Verify no overflow or layout issues
  - Verify touch targets are at least 48px
  - _Requirements: 10.1, 10.2, 10.3, 10.4, 10.5_

- [ ]\* 26.1 Write property test for responsive design

  - **Property 2: Responsive Layout Adaptation**
  - **Validates: Requirements 10.1, 10.2, 10.4, 10.5**

- [ ] 27. Optimize Performance

  - Optimize image loading and caching
  - Optimize list rendering (lazy loading)
  - Optimize animations and transitions
  - Profile and fix any performance issues
  - _Requirements: 10.3_

- [ ] 28. Checkpoint - Ensure all responsive tests pass
  - Ensure all tests pass, ask the user if questions arise.

---

## Phase 10: Design Consistency & Polish

- [ ] 29. Verify Design System Compliance

  - Audit all pages for color palette compliance
  - Audit all pages for typography compliance
  - Audit all pages for spacing compliance
  - Fix any inconsistencies
  - _Requirements: 1.1, 1.2, 1.3_

- [ ]\* 29.1 Write property test for design consistency

  - **Property 1: Design Consistency Across Pages**
  - **Validates: Requirements 1.1, 1.2, 1.3**

- [ ] 30. Verify Navigation Consistency

  - Test all navigation paths
  - Verify smooth transitions
  - Verify active tab indication
  - Fix any issues
  - _Requirements: 8.1, 8.2, 8.3_

- [ ]\* 30.1 Write property test for navigation consistency

  - **Property 3: Navigation Consistency**
  - **Validates: Requirements 8.1, 8.2, 8.3**

- [ ] 31. Verify Visual Feedback on Interactions

  - Test all interactive elements
  - Verify visual feedback (color, elevation, animation)
  - Fix any missing feedback
  - _Requirements: 1.4, 9.1_

- [ ]\* 31.1 Write property test for visual feedback

  - **Property 5: Visual Feedback on Interaction**
  - **Validates: Requirements 1.4, 9.1**

- [ ] 32. Final Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

---

## Phase 11: Documentation & Handoff

- [ ] 33. Create Design System Documentation

  - Document color palette with usage guidelines
  - Document typography scale with examples
  - Document spacing system with examples
  - Document component specifications
  - Create component showcase/storybook
  - _Requirements: 1.1, 1.2, 1.3_

- [ ] 34. Create UI/UX Guidelines Document

  - Document design principles
  - Document best practices
  - Document accessibility guidelines
  - Document responsive design guidelines
  - _Requirements: 1.1, 1.2, 1.3, 10.1, 10.2_

- [ ] 35. Final Review & Handoff
  - Review all changes with stakeholders
  - Gather feedback
  - Make final adjustments
  - Prepare for release
  - _Requirements: All_
