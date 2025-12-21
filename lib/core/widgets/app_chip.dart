import 'package:flutter/material.dart';
import '../design_system/index.dart';

/// Arbtilant Chip Component
///
/// A customizable chip component that follows the design system.
///
/// Example:
/// ```dart
/// AppChip(
///   label: 'All',
///   isSelected: true,
///   onTap: () => setState(() => selectedCategory = 'All'),
/// )
/// ```
class AppChip extends StatelessWidget {
  /// Chip label text
  final String label;

  /// Whether chip is selected
  final bool isSelected;

  /// Callback when chip is tapped
  final VoidCallback? onTap;

  /// Chip icon (optional)
  final IconData? icon;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom text color
  final Color? textColor;

  /// Custom border color
  final Color? borderColor;

  /// Custom border width
  final double borderWidth;

  /// Custom padding
  final EdgeInsets? padding;

  /// Custom border radius
  final double? borderRadius;

  /// Whether chip is disabled
  final bool isDisabled;

  const AppChip({
    Key? key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderWidth = 0,
    this.padding,
    this.borderRadius,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? AppSpacing.chipBorderRadius;
    final padding =
        this.padding ??
        const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        );

    final bgColor = isSelected
        ? (backgroundColor ?? AppColors.primaryGreen)
        : (backgroundColor ?? AppColors.lightSurface);

    final textColor = isSelected
        ? (this.textColor ?? AppColors.textPrimary)
        : (this.textColor ?? AppColors.textSecondary);

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDisabled ? AppColors.textTertiary : bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: borderWidth)
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isDisabled ? null : onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Padding(
              padding: padding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16, color: textColor),
                    const SizedBox(width: 4),
                  ],
                  Text(label, style: AppTypography.label(color: textColor)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Arbtilant Filter Chip Component
///
/// A specialized chip for filtering.
///
/// Example:
/// ```dart
/// AppFilterChip(
///   label: 'All',
///   isSelected: true,
///   onSelected: (selected) => setState(() => selectedCategory = 'All'),
/// )
/// ```
class AppFilterChip extends StatelessWidget {
  /// Chip label text
  final String label;

  /// Whether chip is selected
  final bool isSelected;

  /// Callback when chip selection changes
  final ValueChanged<bool>? onSelected;

  /// Chip icon (optional)
  final IconData? icon;

  const AppFilterChip({
    Key? key,
    required this.label,
    this.isSelected = false,
    this.onSelected,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style: AppTypography.label(
          color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
        ),
      ),
      avatar: icon != null
          ? Icon(
              icon,
              size: 16,
              color: isSelected
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            )
          : null,
      backgroundColor: isSelected
          ? AppColors.primaryGreen
          : AppColors.lightSurface,
      selectedColor: AppColors.primaryGreen,
      onSelected: onSelected,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.chipBorderRadius),
      ),
    );
  }
}

/// Arbtilant Severity Chip Component
///
/// A specialized chip for displaying disease severity.
///
/// Example:
/// ```dart
/// AppSeverityChip(severity: 'High')
/// ```
class AppSeverityChip extends StatelessWidget {
  /// Severity level
  final String severity;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom text color
  final Color? textColor;

  const AppSeverityChip({
    Key? key,
    required this.severity,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final (bgColor, txtColor) = _getSeverityColors();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.chipBorderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_rounded, size: 14, color: textColor ?? txtColor),
          const SizedBox(width: 4),
          Text(
            severity,
            style: AppTypography.label(color: textColor ?? txtColor),
          ),
        ],
      ),
    );
  }

  (Color, Color) _getSeverityColors() {
    switch (severity.toLowerCase()) {
      case 'high':
      case 'severe':
        return (AppColors.error.withOpacity(0.2), AppColors.error);
      case 'medium':
      case 'moderate':
        return (AppColors.warning.withOpacity(0.2), AppColors.warning);
      case 'low':
      case 'mild':
        return (AppColors.success.withOpacity(0.2), AppColors.success);
      default:
        return (AppColors.info.withOpacity(0.2), AppColors.info);
    }
  }
}
