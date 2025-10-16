import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';
import '../../services/preferences_service.dart';

class PostSignInChoiceScreen extends ConsumerWidget {
  const PostSignInChoiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Logo
              Image.asset(
                'assets/images/logo.png',
                height: 120,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if logo doesn't exist
                  return Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.primaryBrown.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.spa,
                      size: 60,
                      color: AppColors.primaryBrown,
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 40),
              
              // Welcome Text
              DisplayText(
                'Welcome to Hanglow!',
                textAlign: TextAlign.center,
                color: isDark ? AppColors.creamBackground : AppColors.darkText,
              ),
              
              const SizedBox(height: 16),
              
              BodyText(
                'How would you like to start your skin assesment journey?',
                textAlign: TextAlign.center,
                color: isDark ? AppColors.creamBackground.withOpacity(0.8) : AppColors.lightText,
              ),
              
              const SizedBox(height: 60),
              
              // Take Skin Assessment Button
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: 'Take Skin Assessment',
                  onPressed: () => _navigateToQuiz(context),
                  size: ButtonSize.large,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Book Treatment Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _navigateToBooking(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryBrown,
                    side: const BorderSide(color: AppColors.primaryBrown, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Book Treatment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Skip option
              TextButton(
                onPressed: () => _skipToMain(context),
                child: Text(
                  'I\'ll decide later',
                  style: TextStyle(
                    color: isDark ? AppColors.creamBackground.withOpacity(0.6) : AppColors.lightText,
                    fontSize: 16,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  
  void _navigateToQuiz(BuildContext context) async {
    // Mark that user has seen the choice and selected quiz
    await PreferencesService.setHasSeenPostSignInChoice(true);
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/quiz');
    }
  }
  
  void _navigateToBooking(BuildContext context) async {
    // Mark that user has seen the choice and selected booking
    await PreferencesService.setHasSeenPostSignInChoice(true);
    if (context.mounted) {
      // Navigate to main app and show booking tab (index 2)
      Navigator.pushReplacementNamed(context, '/main', arguments: {'initialTab': 2});
    }
  }
  
  void _skipToMain(BuildContext context) async {
    // Mark that user has made a choice (skip)
    await PreferencesService.setHasSeenPostSignInChoice(true);
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }
}