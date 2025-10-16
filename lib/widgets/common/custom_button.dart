import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

enum ButtonType { primary, secondary, outline, text }
enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final bool enabled;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.width,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: width,
      height: _getButtonHeight(),
      child: ElevatedButton(
        onPressed: enabled && !isLoading ? onPressed : null,
        style: _getButtonStyle(theme, isDark),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getTextColor(theme, isDark),
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      text,
                      style: _getTextStyle(theme, isDark),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  double _getButtonHeight() {
    switch (size) {
      case ButtonSize.small:
        return 40;
      case ButtonSize.medium:
        return 48;
      case ButtonSize.large:
        return 56;
    }
  }

  ButtonStyle _getButtonStyle(ThemeData theme, bool isDark) {
    Color backgroundColor;
    Color borderColor;
    double elevation;

    switch (type) {
      case ButtonType.primary:
        backgroundColor = AppColors.primaryBrown;
        borderColor = AppColors.primaryBrown;
        elevation = 2;
        break;
      case ButtonType.secondary:
        backgroundColor = isDark ? AppColors.darkSurface : AppColors.white;
        borderColor = isDark ? AppColors.darkSurface : AppColors.white;
        elevation = 1;
        break;
      case ButtonType.outline:
        backgroundColor = Colors.transparent;
        borderColor = AppColors.primaryBrown;
        elevation = 0;
        break;
      case ButtonType.text:
        backgroundColor = Colors.transparent;
        borderColor = Colors.transparent;
        elevation = 0;
        break;
    }

    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: _getTextColor(theme, isDark),
      elevation: elevation,
      shadowColor: AppColors.primaryBrown.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        side: BorderSide(color: borderColor, width: type == ButtonType.outline ? 2 : 0),
      ),
      padding: _getPadding(),
    );
  }

  Color _getTextColor(ThemeData theme, bool isDark) {
    switch (type) {
      case ButtonType.primary:
        return AppColors.white;
      case ButtonType.secondary:
        return isDark ? AppColors.creamBackground : AppColors.darkText;
      case ButtonType.outline:
      case ButtonType.text:
        return AppColors.primaryBrown;
    }
  }

  TextStyle _getTextStyle(ThemeData theme, bool isDark) {
    double fontSize;
    FontWeight fontWeight;

    switch (size) {
      case ButtonSize.small:
        fontSize = 14;
        fontWeight = FontWeight.w500;
        break;
      case ButtonSize.medium:
        fontSize = 16;
        fontWeight = FontWeight.w600;
        break;
      case ButtonSize.large:
        fontSize = 18;
        fontWeight = FontWeight.w600;
        break;
    }

    return theme.textTheme.labelLarge!.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: _getTextColor(theme, isDark),
    );
  }

  double _getBorderRadius() {
    switch (size) {
      case ButtonSize.small:
        return 8;
      case ButtonSize.medium:
        return 12;
      case ButtonSize.large:
        return 16;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }
}

// Specific button types for common use cases
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final bool isLoading;
  final Widget? icon;
  final double? width;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.primary,
      size: size,
      isLoading: isLoading,
      icon: icon,
      width: width,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final bool isLoading;
  final Widget? icon;
  final double? width;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.secondary,
      size: size,
      isLoading: isLoading,
      icon: icon,
      width: width,
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final bool isLoading;
  final Widget? icon;
  final double? width;

  const OutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      type: ButtonType.outline,
      size: size,
      isLoading: isLoading,
      icon: icon,
      width: width,
    );
  }
}