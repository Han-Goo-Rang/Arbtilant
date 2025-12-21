import 'package:flutter/material.dart';
import '../design_system/index.dart';

/// Arbtilant Card Component
///
/// A customizable card component that follows the design system.
///
/// Example:
/// ```dart
/// AppCard(
///   child: Column(
///     children: [
///       Text('Disease Name', style: AppTypography.headline()),
///       SizedBox(height: AppSpacing.md),
///       Text('Description', style: AppTypography.bodyMedium()),
///     ],
///   ),
/// )
/// ```
class AppCard extends StatefulWidget {
  /// Card content
  final Widget child;

  /// Card padding
  final EdgeInsets? padding;

  /// Card margin
  final EdgeInsets? margin;

  /// Card background color
  final Color? backgroundColor;

  /// Card border radius
  final double? borderRadius;

  /// Card elevation
  final double? elevation;

  /// Card border color
  final Color? borderColor;

  /// Card border width
  final double borderWidth;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Whether card is clickable
  final bool isClickable;

  /// Custom shadow
  final List<BoxShadow>? boxShadow;

  /// Whether to show hover effect
  final bool showHoverEffect;

  const AppCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.elevation,
    this.borderColor,
    this.borderWidth = 0,
    this.onTap,
    this.isClickable = false,
    this.boxShadow,
    this.showHoverEffect = true,
  }) : super(key: key);

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? AppSpacing.cardBorderRadius;
    final padding = widget.padding ?? const EdgeInsets.all(AppSpacing.md);
    final margin = widget.margin ?? EdgeInsets.zero;
    final backgroundColor = widget.backgroundColor ?? AppColors.surface;

    return MouseRegion(
      onEnter: widget.showHoverEffect
          ? (_) => setState(() => _isHovered = true)
          : null,
      onExit: widget.showHoverEffect
          ? (_) => setState(() => _isHovered = false)
          : null,
      child: GestureDetector(
        onTap: widget.isClickable ? widget.onTap : null,
        child: Container(
          margin: margin,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: widget.borderColor != null
                ? Border.all(
                    color: widget.borderColor!,
                    width: widget.borderWidth,
                  )
                : null,
            boxShadow:
                widget.boxShadow ??
                [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.12),
                    blurRadius: _isHovered && widget.showHoverEffect ? 8 : 2,
                    offset: Offset(
                      0,
                      _isHovered && widget.showHoverEffect ? 4 : 2,
                    ),
                  ),
                ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isClickable ? widget.onTap : null,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Padding(padding: padding, child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}

/// Arbtilant Disease Card Component
///
/// A specialized card for displaying disease information.
///
/// Example:
/// ```dart
/// AppDiseaseCard(
///   disease: diseaseModel,
///   onTap: () => Navigator.push(...),
/// )
/// ```
class AppDiseaseCard extends StatelessWidget {
  /// Disease image URL
  final String? imageUrl;

  /// Disease name
  final String name;

  /// Disease severity
  final String severity;

  /// Disease description (optional)
  final String? description;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Card height
  final double? height;

  const AppDiseaseCard({
    Key? key,
    this.imageUrl,
    required this.name,
    required this.severity,
    this.description,
    this.onTap,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard(
      isClickable: true,
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.lightSurface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.cardBorderRadius),
                  topRight: Radius.circular(AppSpacing.cardBorderRadius),
                ),
              ),
              child: imageUrl != null && imageUrl!.isNotEmpty
                  ? Image.asset(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported,
                          color: AppColors.textTertiary,
                          size: AppSpacing.iconLarge,
                        );
                      },
                    )
                  : Icon(
                      Icons.image_not_supported,
                      color: AppColors.textTertiary,
                      size: AppSpacing.iconLarge,
                    ),
            ),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headline(),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 12,
                      color: AppColors.brightGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(severity, style: AppTypography.bodySmall()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
