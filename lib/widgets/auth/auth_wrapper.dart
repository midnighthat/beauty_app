import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/skin_profile_provider.dart';
import '../../screens/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/sign_in_screen.dart';
import '../../screens/auth/post_signin_choice_screen.dart';
import '../../screens/quiz/skin_quiz_screen.dart';
import '../../screens/main/main_navigation_screen.dart';
import '../../services/preferences_service.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  bool? _hasSeenOnboarding;
  bool? _hasCompletedQuiz;
  bool? _hasSeenPostSignInChoice;
  bool _isLoading = true;
  User? _lastUser;

  @override
  void initState() {
    super.initState();
    _checkAppStatus();
    
    // Safety timeout - if still loading after 10 seconds, force navigation
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && _isLoading) {
        print('AuthWrapper: Timeout reached, forcing navigation');
        setState(() {
          _hasSeenOnboarding = false;
          _hasCompletedQuiz = false;
          _hasSeenPostSignInChoice = false;
          _isLoading = false;
        });
      }
    });
  }


  void _checkAppStatus() async {
    print('AuthWrapper: _checkAppStatus started');
    setState(() {
      _isLoading = true;
    });
    
    try {
      print('AuthWrapper: Loading preferences...');
      final hasSeenOnboarding = await PreferencesService.getHasSeenOnboarding();
      final hasCompletedQuiz = await PreferencesService.getHasCompletedQuiz();
      final hasSeenPostSignInChoice = await PreferencesService.getHasSeenPostSignInChoice();
      
      print('AuthWrapper: Preferences loaded - onboarding: $hasSeenOnboarding, quiz: $hasCompletedQuiz, choice: $hasSeenPostSignInChoice');
      
      // Load saved skin profile if exists
      if (hasCompletedQuiz) {
        final savedProfile = await PreferencesService.getSkinProfile();
        if (savedProfile != null && mounted) {
          ref.read(skinProfileProvider.notifier).state = savedProfile;
        }
      }
      
      if (mounted) {
        setState(() {
          _hasSeenOnboarding = hasSeenOnboarding;
          _hasCompletedQuiz = hasCompletedQuiz;
          _hasSeenPostSignInChoice = hasSeenPostSignInChoice;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasSeenOnboarding = false;
          _hasCompletedQuiz = false;
          _hasSeenPostSignInChoice = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    
    // Listen to auth state changes
    ref.listen<AsyncValue<AuthState>>(authStateProvider, (previous, next) {
      next.whenData((authState) {
        final previousState = previous?.value;
        if (authState == AuthState.authenticated && previousState != AuthState.authenticated) {
          Future.microtask(() => _checkAppStatus());
        }
      });
    });

    return authState.when(
      data: (state) {
        print('AuthWrapper: authState.data = $state, _isLoading = $_isLoading');
        // Show splash while loading preferences
        if (_isLoading) {
          return const SplashScreen();
        }

        switch (state) {
          case AuthState.authenticated:
            // User is signed in, check their progress
            if (_hasCompletedQuiz == true) {
              // User has completed quiz, go to main app
              return const MainNavigationScreen();
            } else if (_hasSeenPostSignInChoice == true) {
              // User has seen choice but chose quiz, send to quiz screen
              return const SkinQuizScreen();
            } else {
              // First time after sign-in, show choice screen
              return const PostSignInChoiceScreen();
            }
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
      loading: () {
        print('AuthWrapper: authState.loading');
        return const SplashScreen();
      },
      error: (error, stack) {
        print('AuthWrapper: authState.error = $error');
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