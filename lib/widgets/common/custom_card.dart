import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

enum CardType { basic, elevated, outlined, filled }
enum CardSize { small, medium, large }

class CustomCard extends StatelessWidget {
  final Widget child;
  final CardType type;
  final CardSize size;
  final VoidCallback? onTap;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final bool showShadow;

  const CustomCard({
    super.key,
    required this.child,
    this.type = CardType.basic,
    this.size = CardSize.medium,
    this.onTap,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: margin ?? _getDefaultMargin(),
      child: Material(
        color: _getBackgroundColor(isDark),
        borderRadius: BorderRadius.circular(borderRadius ?? _getBorderRadius()),
        elevation: _getElevation(),
        shadowColor: showShadow ? AppColors.primaryPink.withOpacity(0.1) : Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius ?? _getBorderRadius()),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius ?? _getBorderRadius()),
              border: _getBorder(isDark),
            ),
            padding: _getPadding(),
            child: child,
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(bool isDark) {
    if (backgroundColor != null) return backgroundColor!;

    switch (type) {
      case CardType.basic:
      case CardType.elevated:
        return isDark ? AppColors.darkSurface : AppColors.white;
      case CardType.outlined:
        return Colors.transparent;
      case CardType.filled:
        return isDark ? AppColors.darkCream : AppColors.creamBackground;
    }
  }

  Border? _getBorder(bool isDark) {
    if (type == CardType.outlined) {
      return Border.all(
        color: borderColor ?? (isDark ? AppColors.creamBackground.withOpacity(0.2) : AppColors.lightText.withOpacity(0.3)),
        width: 1,
      );
    }
    return null;
  }

  double _getElevation() {
    if (!showShadow) return 0;
    
    switch (type) {
      case CardType.basic:
        return 1;
      case CardType.elevated:
        return 4;
      case CardType.outlined:
      case CardType.filled:
        return 0;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case CardSize.small:
        return 8;
      case CardSize.medium:
        return 12;
      case CardSize.large:
        return 16;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case CardSize.small:
        return const EdgeInsets.all(12);
      case CardSize.medium:
        return const EdgeInsets.all(16);
      case CardSize.large:
        return const EdgeInsets.all(20);
    }
  }

  EdgeInsets _getDefaultMargin() {
    switch (size) {
      case CardSize.small:
        return const EdgeInsets.all(4);
      case CardSize.medium:
        return const EdgeInsets.all(8);
      case CardSize.large:
        return const EdgeInsets.all(12);
    }
  }
}

// Specific card types for common use cases
class ProductCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? margin;

  const ProductCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      type: CardType.elevated,
      size: CardSize.medium,
      onTap: onTap,
      margin: margin,
      child: child,
    );
  }
}

class InfoCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? margin;

  const InfoCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      type: CardType.filled,
      size: CardSize.medium,
      onTap: onTap,
      margin: margin,
      child: child,
    );
  }
}

class MessageCard extends StatelessWidget {
  final Widget child;
  final bool isUser;
  final EdgeInsets? margin;

  const MessageCard({
    super.key,
    required this.child,
    this.isUser = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return CustomCard(
      type: CardType.basic,
      size: CardSize.small,
      margin: margin,
      backgroundColor: isUser 
          ? AppColors.primaryPink.withOpacity(0.1)
          : (isDark ? AppColors.darkSurface : AppColors.white),
      borderRadius: 16,
      child: child,
    );
  }
}