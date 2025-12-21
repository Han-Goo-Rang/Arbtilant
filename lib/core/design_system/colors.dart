import 'package:flutter/material.dart';

/// Arbtilant Design System - Color Palette
/// 
/// This file defines all colors used throughout the Arbtilant application.
/// All colors follow the design system specification and should be used
/// consistently across all pages and components.

class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ============================================================================
  // PRIMARY COLORS
  // ============================================================================

  /// Primary Green - Main brand color used for primary actions and branding
  /// Used for: Primary buttons, active states, main CTAs
  static const Color primaryGreen = Color(0xFF2D6A4F);

  /// Light Green - Secondary actions and hover states
  /// Used for: Secondary buttons, hover effects, light backgrounds
  static const Color lightGreen = Color(0xFF40916C);

  /// Bright Green - Accents, highlights, and success states
  /// Used for: Badges, highlights, success indicators, active tabs
  static const Color brightGreen = Color(0xFF52B788);

  // ============================================================================
  // NEUTRAL COLORS - BACKGROUNDS
  // ============================================================================

  /// Dark Background - Main page background color
  /// Used for: Page backgrounds, main container backgrounds
  static const Color darkBackground = Color(0xFF1B1B1B);

  /// Surface - Card and surface backgrounds
  /// Used for: Cards, dialogs, elevated surfaces
  static const Color surface = Color(0xFF2D2D2D);

  /// Light Surface - Elevated surface backgrounds
  /// Used for: Elevated cards, secondary surfaces, chip backgrounds
  static const Color lightSurface = Color(0xFF3D3D3D);

  // ============================================================================
  // TEXT COLORS
  // ============================================================================

  /// Text Primary - Main text color
  /// Used for: Primary text, headings, main content
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Text Secondary - Secondary text color
  /// Used for: Secondary content, captions, descriptions
  static const Color textSecondary = Color(0xFFB0B0B0);

  /// Text Tertiary - Disabled and hint text color
  /// Used for: Disabled text, hints, placeholders
  static const Color textTertiary = Color(0xFF808080);

  // ============================================================================
  // SEMANTIC COLORS
  // ============================================================================

  /// Success - Positive actions and confirmations
  /// Used for: Success messages, positive indicators, confirmations
  static const Color success = Color(0xFF52B788);

  /// Warning - Warnings and caution messages
  /// Used for: Warning messages, caution indicators
  static const Color warning = Color(0xFFFFB703);

  /// Error - Errors and destructive actions
  /// Used for: Error messages, destructive actions, error states
  static const Color error = Color(0xFFD62828);

  /// Info - Informational messages
  /// Used for: Info messages, informational indicators
  static const Color info = Color(0xFF457B9D);

  // ============================================================================
  // UTILITY COLORS
  // ============================================================================

  /// Transparent - Fully transparent color
  static const Color transparent = Color(0x00000000);

  /// Black - Pure black color
  static const Color black = Color(0xFF000000);

  /// White - Pure white color
  static const Color white = Color(0xFFFFFFFF);

  /// Backdrop - Semi-transparent black for dialogs and overlays
  /// Used for: Dialog backdrops, overlay backgrounds
  static const Color backdrop = Color(0x99000000); // 60% opacity

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get color with custom opacity
  /// 
  /// Example:
  /// ```dart
  /// AppColors.withOpacity(AppColors.primaryGreen, 0.5)
  /// ```
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Get color with custom alpha value (0-255)
  /// 
  /// Example:
  /// ```dart
  /// AppColors.withAlpha(AppColors.primaryGreen, 128)
  /// ```
  static Color withAlpha(Color color, int alpha) {
    return color.withAlpha(alpha);
  }
}

/// Deprecated: Use AppColors instead
/// This is kept for backward compatibility
class AppColorsOld {
  static const Color darkGreen = Color(0xFF006400);
  static const Color mediumGreen = Color(0xFF32CD32);
  static const Color darkBg = Color(0xFF1B1B1B);
  static const Color darkBgSecondary = Color(0xFF2D2D2D);
  static const Color darkBgTertiary = Color(0xFF3D3D3D);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGray = Color(0xFFB0B0B0);
}
