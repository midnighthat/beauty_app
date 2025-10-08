import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';
  
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
  
  static Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      // Ignore errors
    }
  }
}