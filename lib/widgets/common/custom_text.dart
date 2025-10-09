import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../themes/app_theme.dart';

enum TextType { 
  displayLarge, 
  displayMedium, 
  headlineLarge, 
  headlineMedium, 
  titleLarge, 
  titleMedium,
  bodyLarge, 
  bodyMedium, 
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
  caption 
}

class CustomText extends StatelessWidget {
  final String text;
  final TextType type;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? letterSpacing;
  final double? height;
  final TextDecoration? decoration;

  const CustomText(
    this.text, {
    super.key,
    this.type = TextType.bodyMedium,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontWeight,
    this.fontSize,
    this.letterSpacing,
    this.height,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Text(
      text,
      style: _getTextStyle(theme, isDark),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle _getTextStyle(ThemeData theme, bool isDark) {
    TextStyle baseStyle;
    Color defaultColor = isDark ? AppColors.creamBackground : AppColors.darkText;

    switch (type) {
      case TextType.displayLarge:
        baseStyle = GoogleFonts.abel(
          fontSize: fontSize ?? 32,
          fontWeight: fontWeight ?? FontWeight.bold,
        );
        break;
      case TextType.displayMedium:
        baseStyle = GoogleFonts.abel(
          fontSize: fontSize ?? 28,
          fontWeight: fontWeight ?? FontWeight.bold,
        );
        break;
      case TextType.headlineLarge:
        baseStyle = GoogleFonts.abel(
          fontSize: fontSize ?? 24,
          fontWeight: fontWeight ?? FontWeight.w600,
        );
        break;
      case TextType.headlineMedium:
        baseStyle = GoogleFonts.abel(
          fontSize: fontSize ?? 20,
          fontWeight: fontWeight ?? FontWeight.w600,
        );
        break;
      case TextType.titleLarge:
        baseStyle = GoogleFonts.abel(
          fontSize: fontSize ?? 18,
          fontWeight: fontWeight ?? FontWeight.w500,
        );
        break;
      case TextType.titleMedium:
        baseStyle = GoogleFonts.abel(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w500,
        );
        break;
      case TextType.bodyLarge:
        baseStyle = GoogleFonts.abel(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.normal,
        );
        break;
      case TextType.bodyMedium:
        baseStyle = GoogleFonts.abel(
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.normal,
        );
        break;
      case TextType.bodySmall:
        baseStyle = GoogleFonts.abel(
          fontSize: fontSize ?? 12,
          fontWeight: fontWeight ?? FontWeight.normal,
        );
        break;
      case TextType.labelLarge:
        baseStyle = GoogleFonts.abel(
          fontSize: fontSize ?? 16,
          fontWeight: fontWeight ?? FontWeight.w500,
        );
        break;
      case TextType.labelMedium:
        baseStyle = GoogleFonts.abel(
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? FontWeight.w500,
        );
        break;
      case TextType.labelSmall:
        baseStyle = GoogleFonts.abel(
          fontSize: fontSize ?? 12,
          fontWeight: fontWeight ?? FontWeight.w500,
        );
        break;
      case TextType.caption:
        baseStyle = GoogleFonts.abel(
          fontSize: fontSize ?? 12,
          fontWeight: fontWeight ?? FontWeight.normal,
        );
        defaultColor = isDark ? AppColors.creamBackground.withOpacity(0.7) : AppColors.lightText;
        break;
    }

    return baseStyle.copyWith(
      color: color ?? defaultColor,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
    );
  }
}

// Specific text components for common use cases
class HeadingText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;

  const HeadingText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      type: TextType.headlineLarge,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class SubheadingText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;

  const SubheadingText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomText(
      text,
      type: TextType.headlineMedium,
      color: color ?? (isDark ? AppColors.creamBackground.withOpacity(0.9) : AppColors.lightText),
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class BodyText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? height;

  const BodyText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      type: TextType.bodyLarge,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      height: height ?? 1.6,
    );
  }
}

class CaptionText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;

  const CaptionText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      type: TextType.caption,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}

class TitleText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final double? fontSize;

  const TitleText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      type: TextType.titleLarge,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
      fontSize: fontSize,
    );
  }
}

class DisplayText extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool isLarge;

  const DisplayText(
    this.text, {
    super.key,
    this.color,
    this.textAlign,
    this.maxLines,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      type: isLarge ? TextType.displayLarge : TextType.displayMedium,
      color: color,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }
}