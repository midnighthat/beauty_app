import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../screens/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/sign_in_screen.dart';
import '../../screens/main/main_navigation_screen.dart';
import '../../services/preferences_service.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  bool? _hasSeenOnboarding;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  void _checkOnboardingStatus() async {
    try {
      final hasSeenOnboarding = await PreferencesService.getHasSeenOnboarding();
      if (mounted) {
        setState(() {
          _hasSeenOnboarding = hasSeenOnboarding;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasSeenOnboarding = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show splash while loading preferences
    if (_isLoading) {
      return const SplashScreen();
    }

    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (state) {
        switch (state) {
          case AuthState.authenticated:
            // User is signed in, go directly to main app
            return const MainNavigationScreen();
          case AuthState.unauthenticated:
            // User is not signed in
            if (_hasSeenOnboarding == true) {
              // Returning user who has seen onboarding, go directly to sign in
              return const SignInScreen();
            } else {
              // First time user, show onboarding
              return const OnboardingScreen();
            }
          case AuthState.loading:
            // Show splash while determining auth state
            return const SplashScreen();
        }
      },
      loading: () => const SplashScreen(),
      error: (error, stack) {
        // On error, show appropriate screen based on onboarding status
        if (_hasSeenOnboarding == true) {
          return const SignInScreen();
        } else {
          return const OnboardingScreen();
        }
      },
    );
  }
}