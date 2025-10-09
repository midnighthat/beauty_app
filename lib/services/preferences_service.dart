import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/quiz_models.dart';

class PreferencesService {
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';
  static const String _hasCompletedQuizKey = 'has_completed_quiz';
  static const String _skinProfileKey = 'skin_profile';
  
  static Future<bool> getHasSeenOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_hasSeenOnboardingKey) ?? false;
    } catch (e) {
      return false;
    }
  }
  
  static Future<void> setHasSeenOnboarding(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hasSeenOnboardingKey, value);
    } catch (e) {
      // Ignore errors in preference saving
    }
  }
  
  // Quiz completion methods
  static Future<bool> getHasCompletedQuiz() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_hasCompletedQuizKey) ?? false;
    } catch (e) {
      return false;
    }
  }
  
  static Future<void> setHasCompletedQuiz(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_hasCompletedQuizKey, value);
    } catch (e) {
      // Ignore errors in preference saving
    }
  }
  
  // Skin profile methods
  static Future<SkinProfile?> getSkinProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_skinProfileKey);
      if (profileJson != null) {
        final profileMap = json.decode(profileJson) as Map<String, dynamic>;
        return SkinProfile.fromJson(profileMap);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  static Future<void> setSkinProfile(SkinProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = json.encode(profile.toJson());
      await prefs.setString(_skinProfileKey, profileJson);
      await setHasCompletedQuiz(true);
    } catch (e) {
      // Ignore errors in preference saving
    }
  }
  
  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      // Ignore errors
    }
  }
}