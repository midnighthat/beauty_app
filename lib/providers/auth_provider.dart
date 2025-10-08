import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Current user provider
final currentUserProvider = StreamProvider<User?>((ref) {
  final authService = ref.read(authServiceProvider);
  return authService.authStateChanges;
});

// Auth state provider (for easier boolean checks)
final isSignedInProvider = Provider<bool>((ref) {
  final authService = ref.read(authServiceProvider);
  return authService.isSignedIn;
});

// Auth state stream provider for real-time auth status
final authStateProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  
  return authService.authStateChanges.map((user) {
    if (user != null) {
      return AuthState.authenticated;
    } else {
      return AuthState.unauthenticated;
    }
  });
});

// Auth state enum
enum AuthState {
  authenticated,
  unauthenticated,
  loading,
}

// User info providers
final userDisplayNameProvider = Provider<String?>((ref) {
  final authService = ref.read(authServiceProvider);
  return authService.userDisplayName;
});

final userEmailProvider = Provider<String?>((ref) {
  final authService = ref.read(authServiceProvider);
  return authService.userEmail;
});

final userPhotoURLProvider = Provider<String?>((ref) {
  final authService = ref.read(authServiceProvider);
  return authService.userPhotoURL;
});

// Google Sign-In method provider
final signInWithGoogleProvider = FutureProvider.family<UserCredential?, Ref>((ref, _) async {
  final authService = ref.read(authServiceProvider);
  return await authService.signInWithGoogle();
});

// Sign out method provider  
final signOutProvider = FutureProvider.family<void, Ref>((ref, _) async {
  final authService = ref.read(authServiceProvider);
  await authService.signOut();
});