import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';
import '../../services/preferences_service.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      image: 'assets/images/onboarding-1.png',
      title: 'Welcome to Hanglow',
      subtitle: 'Your Personal Beauty Assistant',
      description: 'Get personalized skincare recommendations powered by AI. Discover products that work best for your unique skin type.',
    ),
    OnboardingData(
      image: 'assets/images/onboarding-2.jpg',
      title: 'Chat with AI Expert',
      subtitle: 'Ask Anything About Skincare',
      description: 'Have questions about ingredients, routines, or products? Our AI beauty expert is here to help you 24/7.',
    ),
    OnboardingData(
      image: 'assets/images/onboarding-3.jpg',
      title: 'Track Your Journey',
      subtitle: 'Build Your Perfect Routine',
      description: 'Save your favorite products, track your progress, and build the perfect skincare routine that works for you.',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToSignIn();
    }
  }

  void _goToSignIn() async {
    // Mark that user has seen onboarding
    await PreferencesService.setHasSeenOnboarding(true);
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    text: 'Skip',
                    type: ButtonType.text,
                    size: ButtonSize.medium,
                    onPressed: _goToSignIn,
                  ),
                ],
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(
                    data: _onboardingData[index],
                  );
                },
              ),
            ),

            // Bottom section with indicators and button
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.primaryBrown
                              : AppColors.primaryBrown.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Next/Get Started button
                  PrimaryButton(
                    text: _currentPage == _onboardingData.length - 1
                        ? 'Get Started'
                        : 'Next',
                    onPressed: _nextPage,
                    width: double.infinity,
                    size: ButtonSize.large,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingData {
  final String image;
  final String title;
  final String subtitle;
  final String description;

  OnboardingData({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
  });
}