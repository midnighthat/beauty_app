import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';
import '../../providers/auth_provider.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final userCredential = await authService.signInWithGoogle();
      
      if (userCredential != null && mounted) {
        // Navigate directly to quiz on successful sign-in
        Navigator.pushReplacementNamed(context, '/quiz');
      }
    } catch (error) {
      print('Sign in failed: $error');
      print('Error type: ${error.runtimeType}');
      
      String errorMessage = 'Sign in failed. ';
      
      if (error.toString().contains('ApiException: 7')) {
        errorMessage += 'Please check your internet connection and try again. Make sure Google Play Services is updated.';
      } else if (error.toString().contains('network_error')) {
        errorMessage += 'Network error. Please check your internet connection.';
      } else {
        errorMessage += error.toString();
      }
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 8),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () => _signInWithGoogle(),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              
              // Logo section with transparent background
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // Transparent background - no color specified
                ),
                child: Column(
                  children: [
                    // Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Welcome text
                    DisplayText(
                      'Welcome Back!',
                      textAlign: TextAlign.center,
                      color: isDark ? AppColors.creamBackground : AppColors.darkText,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    SubheadingText(
                      'Sign in to continue your beauty journey',
                      textAlign: TextAlign.center,
                      color: isDark ? AppColors.creamBackground.withOpacity(0.8) : AppColors.lightText,
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Google Sign In Button at the bottom
              PrimaryButton(
                text: 'Continue with Google',
                onPressed: _isLoading ? null : _signInWithGoogle,
                isLoading: _isLoading,
                width: double.infinity,
                size: ButtonSize.large,
                icon: Container(
                  width: 20,
                  height: 20,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Image.asset(
                    'assets/icons/google-icon.png',
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Terms and Privacy
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    CaptionText(
                      'By continuing, you agree to our',
                      textAlign: TextAlign.center,
                      color: AppColors.lightText,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // TODO: Show Terms of Service
                          },
                          child: const CaptionText(
                            'Terms of Service',
                            color: AppColors.primaryBrown,
                          ),
                        ),
                        const CaptionText(' and '),
                        GestureDetector(
                          onTap: () {
                            // TODO: Show Privacy Policy
                          },
                          child: const CaptionText(
                            'Privacy Policy',
                            color: AppColors.primaryBrown,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}