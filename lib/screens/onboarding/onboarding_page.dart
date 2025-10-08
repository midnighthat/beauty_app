import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';
import 'onboarding_screen.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  data.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Content
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Title
                DisplayText(
                  data.title,
                  textAlign: TextAlign.center,
                  color: isDark ? AppColors.creamBackground : AppColors.darkText,
                ),

                const SizedBox(height: 12),

                // Subtitle
                SubheadingText(
                  data.subtitle,
                  textAlign: TextAlign.center,
                  color: isDark ? AppColors.creamBackground.withOpacity(0.9) : AppColors.darkText,
                ),

                const SizedBox(height: 20),

                // Description
                BodyText(
                  data.description,
                  textAlign: TextAlign.center,
                  color: isDark ? AppColors.creamBackground.withOpacity(0.8) : AppColors.lightText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}