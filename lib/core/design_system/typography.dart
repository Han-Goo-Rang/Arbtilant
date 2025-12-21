import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Arbtilant Design System - Typography
///
/// This file defines all typography styles used throughout the Arbtilant application.
/// All text styles follow the design system specification using Poppins font.

class AppTypography {
  // Private constructor to prevent instantiation
  AppTypography._();

  // ============================================================================
  // DISPLAY STYLES
  // ============================================================================

  /// Display Large - 32px, weight 700
  /// Used for: Page titles, hero text, main headings
  static TextStyle displayLarge({Color color = AppColors.textPrimary}) {
    return GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: color,
      height: 1.2,
      letterSpacing: -0.5,
    );
  }

  /// Display Medium - 28px, weight 700
  /// Used for: Section titles, large headings
  static TextStyle displayMedium({Color color = AppColors.textPrimary}) {
    return GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: color,
      height: 1.2,
      letterSpacing: -0.3,
    );
  }

  // ============================================================================
  // HEADLINE STYLES
  // ============================================================================

  /// Headline - 24px, weight 600
  /// Used for: Card titles, subsection titles, important headings
  static TextStyle headline({Color color = AppColors.textPrimary}) {
    return GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: color,
      height: 1.3,
      letterSpacing: 0,
    );
  }

  /// Title - 20px, weight 600
  /// Used for: Subsection titles, dialog titles
  static TextStyle title({Color color = AppColors.textPrimary}) {
    return GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: color,
      height: 1.4,
      letterSpacing: 0.1,
    );
  }

  // ============================================================================
  // BODY STYLES
  // ============================================================================

  /// Body Large - 16px, weight 400
  /// Used for: Main content, body text, descriptions
  static TextStyle bodyLarge({Color color = AppColors.textPrimary}) {
    return GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color,
      height: 1.5,
      letterSpacing: 0.2,
    );
  }

  /// Body Medium - 14px, weight 400
  /// Used for: Secondary content, descriptions, helper text
  static TextStyle bodyMedium({Color color = AppColors.textSecondary}) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color,
      height: 1.5,
      letterSpacing: 0.2,
    );
  }

  /// Body Small - 12px, weight 400
  /// Used for: Captions, hints, small text
  static TextStyle bodySmall({Color color = AppColors.textTertiary}) {
    return GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: color,
      height: 1.5,
      letterSpacing: 0.3,
    );
  }

  // ============================================================================
  // LABEL STYLES
  // ============================================================================

  /// Label - 12px, weight 600
  /// Used for: Button labels, chip labels, tags
  static TextStyle label({Color color = AppColors.textPrimary}) {
    return GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: color,
      height: 1.3,
      letterSpacing: 0.4,
    );
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Create custom text style with Poppins font
  ///
  /// Example:
  /// ```dart
  /// AppTypography.custom(
  ///   fontSize: 18,
  ///   fontWeight: FontWeight.w500,
  ///   color: AppColors.primaryGreen,
  /// )
  /// ```
  static TextStyle custom({
    required double fontSize,
    required FontWeight fontWeight,
    Color color = AppColors.textPrimary,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Create text style with custom opacity
  ///
  /// Example:
  /// ```dart
  /// AppTypography.bodyLarge().copyWith(
  ///   color: AppColors.withOpacity(AppColors.textPrimary, 0.5),
  /// )
  /// ```
  static TextStyle withOpacity(TextStyle style, double opacity) {
    return style.copyWith(color: style.color?.withOpacity(opacity));
  }
}

/// Deprecated: Use AppTypography instead
/// This is kept for backward compatibility
class AppTypographyOld {
  static TextStyle poppinsDisplayLarge = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );

  static TextStyle poppinsHeadline = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static TextStyle poppinsBodyLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
}
