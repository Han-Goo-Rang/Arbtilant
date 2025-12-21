# Arbtilant UI Design System - Quick Reference

## Color Palette

```dart
// Primary Colors
AppColors.primaryGreen      // #2D6A4F - Main brand
AppColors.lightGreen        // #40916C - Secondary
AppColors.brightGreen       // #52B788 - Accents

// Backgrounds
AppColors.darkBackground    // #1B1B1B - Main bg
AppColors.surface           // #2D2D2D - Cards
AppColors.lightSurface      // #3D3D3D - Elevated

// Text
AppColors.textPrimary       // #FFFFFF - Main text
AppColors.textSecondary     // #B0B0B0 - Secondary
AppColors.textTertiary      // #808080 - Disabled

// Semantic
AppColors.success           // Green - Success
AppColors.warning           // Orange - Warning
AppColors.error             // Red - Error
AppColors.info              // Blue - Info
```

## Typography

```dart
// Display
AppTypography.displayLarge()    // 32px, w700
AppTypography.displayMedium()   // 28px, w700

// Headings
AppTypography.headline()        // 24px, w600
AppTypography.title()           // 20px, w600

// Body
AppTypography.bodyLarge()       // 16px, w400
AppTypography.bodyMedium()      // 14px, w400
AppTypography.bodySmall()       // 12px, w400

// Labels
AppTypography.label()           // 12px, w600

// Custom
AppTypography.custom(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  color: AppColors.primaryGreen,
)
```

## Spacing (8px Grid)

```dart
AppSpacing.xs       // 4px
AppSpacing.sm       // 8px
AppSpacing.md       // 16px
AppSpacing.lg       // 24px
AppSpacing.xl       // 32px
AppSpacing.xxl      // 48px

// Border Radius
AppSpacing.cardBorderRadius     // 12px
AppSpacing.buttonBorderRadius   // 8px
AppSpacing.chipBorderRadius     // 20px
AppSpacing.dialogBorderRadius   // 16px

// Icon Sizes
AppSpacing.iconSmall            // 16px
AppSpacing.iconMedium           // 24px
AppSpacing.iconLarge            // 32px
AppSpacing.iconXLarge           // 48px
```

## Common Components

### Button

```dart
AppButton(
  label: 'Click Me',
  size: AppButtonSize.large,
  onPressed: () {},
)

// Variants
AppButton(
  label: 'Secondary',
  variant: AppButtonVariant.outlined,
  onPressed: () {},
)
```

### Card

```dart
AppCard(
  child: Text('Content'),
  isClickable: true,
  onTap: () {},
)
```

### Chip

```dart
AppChip(
  label: 'Tag',
  isSelected: true,
  onTap: () {},
)

AppFilterChip(
  label: 'Filter',
  isSelected: false,
  onSelected: (selected) {},
)

AppSeverityChip(
  severity: 'High',
)
```

## Page Structure Template

```dart
import 'package:flutter/material.dart';
import 'package:arbtilant/core/design_system/index.dart';
import 'package:arbtilant/core/widgets/index.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text('Title', style: AppTypography.headline()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Heading', style: AppTypography.displayMedium()),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Text('Content', style: AppTypography.bodyLarge()),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}
```

## Responsive Design

```dart
// Get screen width
double screenWidth = MediaQuery.of(context).size.width;

// Responsive padding
double padding = AppSpacing.responsivePadding(screenWidth);

// Responsive section margin
double margin = AppSpacing.responsiveSectionMargin(screenWidth);

// Breakpoints
// Phone: < 480px
// Large Phone: 480-600px
// Tablet: 600-900px
// Desktop: > 900px
```

## Common Patterns

### Loading State

```dart
Center(
  child: CircularProgressIndicator(
    color: AppColors.brightGreen,
  ),
)
```

### Empty State

```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.search_off, size: AppSpacing.iconXLarge),
      const SizedBox(height: AppSpacing.md),
      Text('No results', style: AppTypography.headline()),
    ],
  ),
)
```

### Error State

```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.error_outline, color: AppColors.error),
      const SizedBox(height: AppSpacing.md),
      Text('Error occurred', style: AppTypography.bodyLarge()),
    ],
  ),
)
```

### Snackbar

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Message'),
    backgroundColor: AppColors.brightGreen,
  ),
)
```

### Dialog

```dart
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    backgroundColor: AppColors.surface,
    title: Text('Title', style: AppTypography.headline()),
    content: Text('Content', style: AppTypography.bodyLarge()),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Cancel'),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('OK'),
      ),
    ],
  ),
)
```

## File Structure

```
lib/
├── core/
│   ├── design_system/
│   │   ├── colors.dart          # Color palette
│   │   ├── typography.dart      # Text styles
│   │   ├── spacing.dart         # Spacing & sizing
│   │   ├── theme.dart           # Theme configuration
│   │   └── index.dart           # Exports
│   └── widgets/
│       ├── app_button.dart      # Button component
│       ├── app_card.dart        # Card component
│       ├── app_chip.dart        # Chip components
│       └── index.dart           # Exports
├── Pages/
│   ├── home_page.dart
│   ├── scan_page.dart
│   ├── library_page_new.dart
│   ├── disease_detail_page.dart
│   ├── scan_detail_page.dart
│   ├── history_page.dart
│   ├── onboarding_screen.dart
│   └── splash_screen.dart
├── Widgets/
│   ├── feedback_dialog.dart
│   └── custom_bottom_nav.dart
└── main.dart
```

## Import Pattern

```dart
// Always import design system first
import 'package:arbtilant/core/design_system/index.dart';

// Then widgets
import 'package:arbtilant/core/widgets/index.dart';

// Then pages/models/services
import 'package:arbtilant/Pages/...dart';
import 'package:arbtilant/Models/...dart';
import 'package:arbtilant/Services/...dart';
```

## Best Practices

1. **Always use design system tokens** - Never hardcode colors, sizes, or fonts
2. **Use AppSpacing for all spacing** - Maintains 8px grid consistency
3. **Use AppTypography for all text** - Ensures font consistency
4. **Use AppColors for all colors** - Maintains color palette
5. **Keep components reusable** - Use AppButton, AppCard, AppChip
6. **Test responsive design** - Check on multiple screen sizes
7. **Use const constructors** - Improves performance
8. **Add proper error handling** - Show meaningful error messages

## Useful Links

- Design Specs: `.kiro/specs/ui-redesign/`
- Mockups: `.kiro/specs/mockup/`
- Implementation Plan: `.kiro/steering/ui-redesign-plan.md`
- Completion Report: `UI_REDESIGN_COMPLETE.md`

---

**Last Updated:** December 21, 2025  
**Version:** 1.0  
**Status:** ✅ Complete
