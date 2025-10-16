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
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Image section - flexible but constrained
          Flexible(
            flex: 3,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: screenHeight * 0.45, // Max 45% of screen height
                minHeight: 200, // Minimum height for the image
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  data.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback for missing images
                    return Container(
                      color: AppColors.primaryBrown.withOpacity(0.1),
                      child: Icon(
                        Icons.image,
                        size: 64,
                        color: AppColors.primaryBrown.withOpacity(0.5),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.03), // Responsive spacing

          // Content section - flexible and scrollable
          Flexible(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  DisplayText(
                    data.title,
                    textAlign: TextAlign.center,
                    color: isDark ? AppColors.creamBackground : AppColors.darkText,
                  ),

                  SizedBox(height: screenHeight * 0.015),

                  // Subtitle
                  SubheadingText(
                    data.subtitle,
                    textAlign: TextAlign.center,
                    color: isDark ? AppColors.creamBackground.withOpacity(0.9) : AppColors.darkText,
                  ),

                ],
              ),
            ),
          ),
          
          // Add bottom padding to account for the bottom navigation
          SizedBox(height: 100 + bottomSafeArea), // Space for indicators + button + safe area
        ],
      ),
    );
  }
}