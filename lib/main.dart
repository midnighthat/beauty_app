import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'themes/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/discovery/skin_discovery_screen.dart';
import 'screens/quiz/skin_quiz_screen.dart';
import 'screens/quiz/quiz_results_screen.dart';
import 'screens/main/main_navigation_screen.dart';
import 'models/quiz_models.dart';
import 'widgets/auth/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
  
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beauty Care',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (context) => const SplashScreen());
          case '/onboarding':
            return MaterialPageRoute(builder: (context) => const OnboardingScreen());
          case '/signin':
            return MaterialPageRoute(builder: (context) => const SignInScreen());
          case '/discovery':
            return MaterialPageRoute(builder: (context) => const SkinDiscoveryScreen());
          case '/quiz':
            return MaterialPageRoute(builder: (context) => const SkinQuizScreen());
          case '/quiz-results':
            final skinProfile = settings.arguments as SkinProfile;
            return MaterialPageRoute(
              builder: (context) => QuizResultsScreen(skinProfile: skinProfile),
            );
          case '/main':
            return MaterialPageRoute(builder: (context) => const MainNavigationScreen());
          case '/book-appointment':
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Appointment Booking - Coming Soon!')),
              ),
            );
          case '/marketplace':
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Product Marketplace - Coming Soon!')),
              ),
            );
          default:
            return MaterialPageRoute(builder: (context) => const SplashScreen());
        }
      },
    );
  }
}
