/// Arbtilant Design System - Spacing
///
/// This file defines all spacing values used throughout the Arbtilant application.
/// All spacing follows an 8px grid system for consistency and alignment.

class AppSpacing {
  // Private constructor to prevent instantiation
  AppSpacing._();

  // ============================================================================
  // SPACING VALUES (8px Grid System)
  // ============================================================================

  /// Extra Small - 4px
  /// Used for: Minimal spacing, tight layouts
  static const double xs = 4.0;

  /// Small - 8px
  /// Used for: Small spacing, padding within components
  static const double sm = 8.0;

  /// Medium - 16px
  /// Used for: Medium spacing, padding in cards, margin between components
  static const double md = 16.0;

  /// Large - 24px
  /// Used for: Large spacing, margin between sections
  static const double lg = 24.0;

  /// Extra Large - 32px
  /// Used for: Extra large spacing, margin between major sections
  static const double xl = 32.0;

  /// Double Extra Large - 48px
  /// Used for: Hero sections, large gaps
  static const double xxl = 48.0;

  // ============================================================================
  // COMMON PADDING VALUES
  // ============================================================================

  /// Padding for page content
  /// Used for: Page padding, main container padding
  static const double pagePadding = md; // 16px on mobile, lg on tablet+

  /// Padding for cards
  /// Used for: Card padding, surface padding
  static const double cardPadding = md; // 16px

  /// Padding for buttons
  /// Used for: Button padding, interactive element padding
  static const double buttonPaddingHorizontal = md; // 16px
  static const double buttonPaddingVertical = sm; // 8px

  /// Padding for chips
  /// Used for: Chip padding, tag padding
  static const double chipPaddingHorizontal = md; // 16px
  static const double chipPaddingVertical = xs; // 4px

  /// Padding for dialogs
  /// Used for: Dialog padding, modal padding
  static const double dialogPadding = lg; // 24px

  // ============================================================================
  // COMMON MARGIN VALUES
  // ============================================================================

  /// Margin between sections
  /// Used for: Section spacing, major content spacing
  static const double sectionMargin = lg; // 24px

  /// Margin between components
  /// Used for: Component spacing, item spacing
  static const double componentMargin = md; // 16px

  /// Margin between list items
  /// Used for: List item spacing, grid spacing
  static const double itemMargin = sm; // 8px

  // ============================================================================
  // BORDER RADIUS VALUES
  // ============================================================================

  /// Border radius for cards
  /// Used for: Card border radius, surface border radius
  static const double cardBorderRadius = 12.0;

  /// Border radius for buttons
  /// Used for: Button border radius, interactive element border radius
  static const double buttonBorderRadius = 8.0;

  /// Border radius for chips
  /// Used for: Chip border radius, pill-shaped elements
  static const double chipBorderRadius = 20.0;

  /// Border radius for dialogs
  /// Used for: Dialog border radius, modal border radius
  static const double dialogBorderRadius = 16.0;

  /// Border radius for small elements
  /// Used for: Small component border radius
  static const double smallBorderRadius = 4.0;

  // ============================================================================
  // ICON SIZES
  // ============================================================================

  /// Small icon size
  /// Used for: Small icons, badges
  static const double iconSmall = 16.0;

  /// Medium icon size
  /// Used for: Standard icons, navigation icons
  static const double iconMedium = 24.0;

  /// Large icon size
  /// Used for: Large icons, prominent icons
  static const double iconLarge = 32.0;

  /// Extra large icon size
  /// Used for: Hero icons, large prominent icons
  static const double iconXLarge = 48.0;

  // ============================================================================
  // TOUCH TARGET SIZES
  // ============================================================================

  /// Minimum touch target size (Material Design guideline)
  /// Used for: Buttons, interactive elements
  static const double minTouchTarget = 48.0;

  /// Standard button height
  /// Used for: Button height, interactive element height
  static const double buttonHeightLarge = 48.0;
  static const double buttonHeightMedium = 40.0;
  static const double buttonHeightSmall = 32.0;

  // ============================================================================
  // ELEVATION / SHADOW SPACING
  // ============================================================================

  /// Elevation 1 - Subtle shadow
  /// Used for: Cards, surfaces
  static const double elevation1 = 2.0;

  /// Elevation 2 - Light shadow
  /// Used for: Elevated cards, hover states
  static const double elevation2 = 4.0;

  /// Elevation 3 - Medium shadow
  /// Used for: Dialogs, modals
  static const double elevation3 = 8.0;

  // ============================================================================
  // ANIMATION DURATIONS
  // ============================================================================

  /// Fast animation duration
  /// Used for: Quick feedback, state changes
  static const Duration animationFast = Duration(milliseconds: 100);

  /// Standard animation duration
  /// Used for: Page transitions, standard animations
  static const Duration animationStandard = Duration(milliseconds: 300);

  /// Slow animation duration
  /// Used for: Slow transitions, emphasis animations
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get responsive padding based on screen width
  ///
  /// Example:
  /// ```dart
  /// double padding = AppSpacing.responsivePadding(context);
  /// ```
  static double responsivePadding(double screenWidth) {
    if (screenWidth < 480) {
      return sm; // 8px on small phones
    } else if (screenWidth < 600) {
      return md; // 16px on large phones
    } else if (screenWidth < 900) {
      return lg; // 24px on tablets
    } else {
      return xl; // 32px on desktop
    }
  }

  /// Get responsive section margin based on screen width
  ///
  /// Example:
  /// ```dart
  /// double margin = AppSpacing.responsiveSectionMargin(context);
  /// ```
  static double responsiveSectionMargin(double screenWidth) {
    if (screenWidth < 480) {
      return md; // 16px on small phones
    } else if (screenWidth < 600) {
      return lg; // 24px on large phones
    } else {
      return xl; // 32px on tablets+
    }
  }
}
