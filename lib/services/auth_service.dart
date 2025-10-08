import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Get current user
  User? get currentUser => _auth.currentUser;
  
  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('Starting Google Sign-In...');
      
      // Sign out first to force account selection
      await GoogleSignIn().signOut();
      
      // Trigger Google Sign-In flow (will show account picker)
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      
      if (gUser == null) {
        print('User canceled sign-in');
        return null;
      }

      // Get authentication details
      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      
      print('Got Google authentication');
      print('Access Token: ${gAuth.accessToken != null ? "Present" : "Null"}');
      print('ID Token: ${gAuth.idToken != null ? "Present" : "Null"}');

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        print('Successfully signed in with Firebase!');
        print('User: ${userCredential.user!.displayName}');
        print('Email: ${userCredential.user!.email}');
        print('UID: ${userCredential.user!.uid}');
      }
      
      return userCredential;
      
    } catch (error) {
      print('Sign in failed: $error');
      print('Error type: ${error.runtimeType}');
      rethrow;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
      print('User signed out successfully');
    } catch (error) {
      print('Sign out failed: $error');
      rethrow;
    }
  }
  
  // Check if user is signed in
  bool get isSignedIn => currentUser != null;
  
  // Get user display name
  String? get userDisplayName => currentUser?.displayName;
  
  // Get user email
  String? get userEmail => currentUser?.email;
  
  // Get user photo URL
  String? get userPhotoURL => currentUser?.photoURL;
}