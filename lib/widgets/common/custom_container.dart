import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

enum ContainerType { basic, rounded, gradient, glass }

class CustomContainer extends StatelessWidget {
  final Widget child;
  final ContainerType type;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const CustomContainer({
    super.key,
    required this.child,
    this.type = ContainerType.basic,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget container = Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? _getDefaultPadding(),
      decoration: BoxDecoration(
        color: gradient == null ? _getBackgroundColor(isDark) : null,
        gradient: gradient ?? _getGradient(isDark),
        borderRadius: BorderRadius.circular(borderRadius ?? _getBorderRadius()),
        border: border ?? _getBorder(isDark),
        boxShadow: boxShadow ?? _getBoxShadow(isDark),
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }

    return container;
  }

  Color _getBackgroundColor(bool isDark) {
    if (backgroundColor != null) return backgroundColor!;

    switch (type) {
      case ContainerType.basic:
        return isDark ? AppColors.darkSurface : AppColors.white;
      case ContainerType.rounded:
        return isDark ? AppColors.darkSurface : AppColors.creamBackground;
      case ContainerType.gradient:
        return Colors.transparent; // Gradient will handle color
      case ContainerType.glass:
        return isDark 
            ? AppColors.darkSurface.withOpacity(0.7)
            : AppColors.white.withOpacity(0.7);
    }
  }

  Gradient? _getGradient(bool isDark) {
    if (gradient != null) return gradient;
    
    if (type == ContainerType.gradient) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primaryPink.withOpacity(0.8),
          AppColors.primaryPink.withOpacity(0.6),
        ],
      );
    }
    return null;
  }

  double _getBorderRadius() {
    switch (type) {
      case ContainerType.basic:
        return 8;
      case ContainerType.rounded:
        return 16;
      case ContainerType.gradient:
        return 20;
      case ContainerType.glass:
        return 12;
    }
  }

  Border? _getBorder(bool isDark) {
    if (border != null) return border;
    
    if (type == ContainerType.glass) {
      return Border.all(
        color: isDark 
            ? AppColors.creamBackground.withOpacity(0.1)
            : AppColors.white.withOpacity(0.2),
        width: 1,
      );
    }
    return null;
  }

  List<BoxShadow>? _getBoxShadow(bool isDark) {
    if (boxShadow != null) return boxShadow;

    switch (type) {
      case ContainerType.basic:
        return null;
      case ContainerType.rounded:
        return [
          BoxShadow(
            color: AppColors.primaryPink.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ];
      case ContainerType.gradient:
        return [
          BoxShadow(
            color: AppColors.primaryPink.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ];
      case ContainerType.glass:
        return [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.2)
                : AppColors.lightText.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ];
    }
  }

  EdgeInsets _getDefaultPadding() {
    switch (type) {
      case ContainerType.basic:
        return const EdgeInsets.all(16);
      case ContainerType.rounded:
        return const EdgeInsets.all(20);
      case ContainerType.gradient:
        return const EdgeInsets.all(24);
      case ContainerType.glass:
        return const EdgeInsets.all(18);
    }
  }
}

// Specific container types for common use cases
class ImageContainer extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Widget? placeholder;

  const ImageContainer({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 12,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPink.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPlaceholder();
        },
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return placeholder ??
        Container(
          color: AppColors.creamBackground,
          child: const Center(
            child: Icon(
              Icons.image_outlined,
              color: AppColors.lightText,
              size: 48,
            ),
          ),
        );
  }
}

class GradientContainer extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;

  const GradientContainer({
    super.key,
    required this.child,
    this.colors,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      type: ContainerType.gradient,
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors ?? [
          AppColors.primaryPink.withOpacity(0.8),
          AppColors.primaryPink.withOpacity(0.6),
        ],
      ),
      child: child,
    );
  }
}