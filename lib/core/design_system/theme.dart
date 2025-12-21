import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';
import 'spacing.dart';

/// Arbtilant Design System - Theme
///
/// This file defines the complete theme for the Arbtilant application.
/// It combines colors, typography, and spacing into a cohesive Material theme.

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ============================================================================
  // THEME DATA
  // ============================================================================

  /// Light theme data (currently using dark theme)
  /// This is the main theme used throughout the application
  static ThemeData get lightTheme {
    return ThemeData(
      // ========================================================================
      // COLOR SCHEME
      // ========================================================================
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryGreen,
        brightness: Brightness.dark,
        primary: AppColors.primaryGreen,
        secondary: AppColors.lightGreen,
        tertiary: AppColors.brightGreen,
        surface: AppColors.surface,
        background: AppColors.darkBackground,
        error: AppColors.error,
        onPrimary: AppColors.textPrimary,
        onSecondary: AppColors.textPrimary,
        onTertiary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onError: AppColors.textPrimary,
      ),

      // ========================================================================
      // SCAFFOLD
      // ========================================================================
      scaffoldBackgroundColor: AppColors.darkBackground,

      // ========================================================================
      // APP BAR
      // ========================================================================
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headline(),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: AppSpacing.iconMedium,
        ),
      ),

      // ========================================================================
      // BUTTON THEMES
      // ========================================================================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          minimumSize: const Size(0, AppSpacing.buttonHeightMedium),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonBorderRadius),
          ),
          elevation: 0,
          textStyle: AppTypography.label(),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryGreen,
          side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          minimumSize: const Size(0, AppSpacing.buttonHeightMedium),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonBorderRadius),
          ),
          textStyle: AppTypography.label(),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryGreen,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonPaddingHorizontal,
            vertical: AppSpacing.buttonPaddingVertical,
          ),
          minimumSize: const Size(0, AppSpacing.buttonHeightMedium),
          textStyle: AppTypography.label(),
        ),
      ),

      // ========================================================================
      // INPUT DECORATION THEME
      // ========================================================================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
          borderSide: const BorderSide(color: AppColors.lightSurface),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
          borderSide: const BorderSide(color: AppColors.lightSurface),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: AppTypography.bodyMedium(),
        labelStyle: AppTypography.bodyMedium(),
        errorStyle: AppTypography.bodySmall(color: AppColors.error),
      ),

      // ========================================================================
      // CHIP THEME
      // ========================================================================
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedColor: AppColors.primaryGreen,
        disabledColor: AppColors.textTertiary,
        labelStyle: AppTypography.label(),
        secondaryLabelStyle: AppTypography.label(color: AppColors.textPrimary),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.chipPaddingHorizontal,
          vertical: AppSpacing.chipPaddingVertical,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.chipBorderRadius),
        ),
      ),

      // ========================================================================
      // DIALOG THEME
      // ========================================================================
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        elevation: AppSpacing.elevation3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.dialogBorderRadius),
        ),
        titleTextStyle: AppTypography.headline(),
        contentTextStyle: AppTypography.bodyMedium(),
      ),

      // ========================================================================
      // CARD THEME
      // ========================================================================
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: AppSpacing.elevation1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
        ),
        margin: const EdgeInsets.all(0),
      ),

      // ========================================================================
      // BOTTOM NAVIGATION BAR THEME
      // ========================================================================
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.brightGreen,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: AppTypography.label(),
        unselectedLabelStyle: AppTypography.label(
          color: AppColors.textSecondary,
        ),
        elevation: AppSpacing.elevation2,
        type: BottomNavigationBarType.fixed,
      ),

      // ========================================================================
      // FLOATING ACTION BUTTON THEME
      // ========================================================================
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textPrimary,
        elevation: AppSpacing.elevation2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonBorderRadius),
        ),
      ),

      // ========================================================================
      // SNACKBAR THEME
      // ========================================================================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surface,
        contentTextStyle: AppTypography.bodyMedium(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
        ),
        elevation: AppSpacing.elevation2,
      ),

      // ========================================================================
      // PROGRESS INDICATOR THEME
      // ========================================================================
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.brightGreen,
        linearMinHeight: 4,
      ),

      // ========================================================================
      // DIVIDER THEME
      // ========================================================================
      dividerTheme: DividerThemeData(
        color: AppColors.lightSurface,
        thickness: 1,
        space: AppSpacing.md,
      ),

      // ========================================================================
      // MATERIAL 3
      // ========================================================================
      useMaterial3: true,
    );
  }

  // ========================================================================
  // UTILITY METHODS
  // ========================================================================

  /// Get shadow for elevation 1
  static List<BoxShadow> get elevation1Shadow {
    return [
      BoxShadow(
        color: AppColors.black.withOpacity(0.12),
        blurRadius: 2,
        offset: const Offset(0, 2),
      ),
    ];
  }

  /// Get shadow for elevation 2
  static List<BoxShadow> get elevation2Shadow {
    return [
      BoxShadow(
        color: AppColors.black.withOpacity(0.12),
        blurRadius: 4,
        offset: const Offset(0, 4),
      ),
    ];
  }

  /// Get shadow for elevation 3
  static List<BoxShadow> get elevation3Shadow {
    return [
      BoxShadow(
        color: AppColors.black.withOpacity(0.15),
        blurRadius: 8,
        offset: const Offset(0, 8),
      ),
    ];
  }
}
