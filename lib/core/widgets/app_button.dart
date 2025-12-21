import 'package:flutter/material.dart';
import '../design_system/index.dart';

/// Button size enum
enum AppButtonSize { small, medium, large }

/// Button variant enum
enum AppButtonVariant { filled, outlined, text }

/// Arbtilant Primary Button Component
///
/// A customizable button component that follows the design system.
///
/// Example:
/// ```dart
/// AppButton(
///   label: 'Scan Plant',
///   onPressed: () => Navigator.push(...),
///   size: AppButtonSize.large,
/// )
/// ```
class AppButton extends StatefulWidget {
  /// Button label text
  final String label;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Button size (small, medium, large)
  final AppButtonSize size;

  /// Button variant (filled, outlined, text)
  final AppButtonVariant variant;

  /// Button icon (optional)
  final IconData? icon;

  /// Icon position (left or right)
  final bool iconOnLeft;

  /// Whether button is loading
  final bool isLoading;

  /// Whether button is disabled
  final bool isDisabled;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom text color
  final Color? textColor;

  /// Custom border color (for outlined variant)
  final Color? borderColor;

  /// Custom border width
  final double borderWidth;

  /// Custom border radius
  final double? borderRadius;

  /// Custom padding
  final EdgeInsets? padding;

  /// Custom minimum width
  final double? minWidth;

  /// Custom minimum height
  final double? minHeight;

  /// Loading indicator color
  final Color? loadingColor;

  /// Loading indicator size
  final double loadingSize;

  const AppButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.variant = AppButtonVariant.filled,
    this.icon,
    this.iconOnLeft = true,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderWidth = 1.5,
    this.borderRadius,
    this.padding,
    this.minWidth,
    this.minHeight,
    this.loadingColor,
    this.loadingSize = 16,
  }) : super(key: key);

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabledOrLoading = widget.isDisabled || widget.isLoading;

    return GestureDetector(
      onTapDown: isDisabledOrLoading
          ? null
          : (_) => setState(() => _isPressed = true),
      onTapUp: isDisabledOrLoading
          ? null
          : (_) => setState(() => _isPressed = false),
      onTapCancel: isDisabledOrLoading
          ? null
          : () => setState(() => _isPressed = false),
      onTap: isDisabledOrLoading ? null : widget.onPressed,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    final size = _getSize();
    final colors = _getColors();
    final borderRadius = widget.borderRadius ?? AppSpacing.buttonBorderRadius;

    return Container(
      constraints: BoxConstraints(
        minWidth: widget.minWidth ?? size['minWidth'] as double,
        minHeight: widget.minHeight ?? size['minHeight'] as double,
      ),
      decoration: BoxDecoration(
        color: colors['backgroundColor'] as Color,
        border: widget.variant == AppButtonVariant.outlined
            ? Border.all(
                color: colors['borderColor'] as Color,
                width: widget.borderWidth,
              )
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: _isPressed && widget.variant == AppButtonVariant.filled
            ? [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (widget.isDisabled || widget.isLoading)
              ? null
              : widget.onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: widget.padding ?? size['padding'] as EdgeInsets,
            child: _buildContent(colors),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> colors) {
    if (widget.isLoading) {
      return SizedBox(
        height: widget.loadingSize,
        width: widget.loadingSize,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.loadingColor ?? (colors['textColor'] as Color),
          ),
          strokeWidth: 2,
        ),
      );
    }

    final textStyle = _getTextStyle(colors);
    final textColor = colors['textColor'] as Color;

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.iconOnLeft) ...[
            Icon(widget.icon, color: textColor, size: 20),
            const SizedBox(width: 8),
          ],
          Text(widget.label, style: textStyle),
          if (!widget.iconOnLeft) ...[
            const SizedBox(width: 8),
            Icon(widget.icon, color: textColor, size: 20),
          ],
        ],
      );
    }

    return Center(child: Text(widget.label, style: textStyle));
  }

  Map<String, dynamic> _getSize() {
    switch (widget.size) {
      case AppButtonSize.small:
        return {
          'minHeight': AppSpacing.buttonHeightSmall,
          'minWidth': 0.0,
          'padding': const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
        };
      case AppButtonSize.medium:
        return {
          'minHeight': AppSpacing.buttonHeightMedium,
          'minWidth': 0.0,
          'padding': const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        };
      case AppButtonSize.large:
        return {
          'minHeight': AppSpacing.buttonHeightLarge,
          'minWidth': 0.0,
          'padding': const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        };
    }
  }

  Map<String, dynamic> _getColors() {
    final isDisabledOrLoading = widget.isDisabled || widget.isLoading;

    switch (widget.variant) {
      case AppButtonVariant.filled:
        return {
          'backgroundColor': isDisabledOrLoading
              ? AppColors.textTertiary
              : (widget.backgroundColor ?? AppColors.primaryGreen),
          'textColor': isDisabledOrLoading
              ? AppColors.textTertiary
              : (widget.textColor ?? AppColors.textPrimary),
          'borderColor': AppColors.transparent,
        };
      case AppButtonVariant.outlined:
        return {
          'backgroundColor': isDisabledOrLoading
              ? AppColors.transparent
              : AppColors.transparent,
          'textColor': isDisabledOrLoading
              ? AppColors.textTertiary
              : (widget.textColor ?? AppColors.primaryGreen),
          'borderColor': isDisabledOrLoading
              ? AppColors.textTertiary
              : (widget.borderColor ?? AppColors.primaryGreen),
        };
      case AppButtonVariant.text:
        return {
          'backgroundColor': AppColors.transparent,
          'textColor': isDisabledOrLoading
              ? AppColors.textTertiary
              : (widget.textColor ?? AppColors.primaryGreen),
          'borderColor': AppColors.transparent,
        };
    }
  }

  TextStyle _getTextStyle(Map<String, dynamic> colors) {
    final textColor = colors['textColor'] as Color;

    switch (widget.size) {
      case AppButtonSize.small:
        return AppTypography.label(color: textColor);
      case AppButtonSize.medium:
        return AppTypography.label(color: textColor);
      case AppButtonSize.large:
        return AppTypography.label(color: textColor);
    }
  }
}
