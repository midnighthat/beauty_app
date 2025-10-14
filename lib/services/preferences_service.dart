import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/quiz_models.dart';
import '../models/budget_models.dart';

class PreferencesService {
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';
  static const String _hasCompletedQuizKey = 'has_completed_quiz';
  static const String _skinProfileKey = 'skin_profile';
  static const String _budgetProfileKey = 'budget_profile';
  static const String _wellnessDataKey = 'wellness_data_';
  static const String _currencyKey = 'selected_currency';
  static const String _favoriteProductsKey = 'favorite_products';
  
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
  
  // Budget profile methods
  static Future<BudgetProfile?> getBudgetProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final budgetJson = prefs.getString(_budgetProfileKey);
      if (budgetJson != null) {
        final budgetMap = json.decode(budgetJson) as Map<String, dynamic>;
        return BudgetProfile.fromJson(budgetMap);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  static Future<void> saveBudgetProfile(BudgetProfile budget) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final budgetJson = json.encode(budget.toJson());
      await prefs.setString(_budgetProfileKey, budgetJson);
    } catch (e) {
      // Ignore errors in preference saving
    }
  }
  
  // Wellness data methods
  static Future<WellnessData?> getWellnessData(DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateKey = _wellnessDataKey + _formatDateKey(date);
      final wellnessJson = prefs.getString(dateKey);
      if (wellnessJson != null) {
        final wellnessMap = json.decode(wellnessJson) as Map<String, dynamic>;
        return WellnessData.fromJson(wellnessMap);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  static Future<void> saveWellnessData(WellnessData wellness) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateKey = _wellnessDataKey + _formatDateKey(wellness.date);
      final wellnessJson = json.encode(wellness.toJson());
      await prefs.setString(dateKey, wellnessJson);
    } catch (e) {
      // Ignore errors in preference saving
    }
  }
  
  static String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  
  // Currency preference methods
  static Future<String> getCurrency() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_currencyKey) ?? 'USD'; // Default to USD
    } catch (e) {
      return 'USD';
    }
  }
  
  static Future<void> setCurrency(String currency) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currencyKey, currency);
    } catch (e) {
      // Ignore errors in preference saving
    }
  }

  // Favorite products methods
  static Future<List<String>> getFavoriteProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString(_favoriteProductsKey);
      if (favoritesJson != null) {
        final favoritesList = json.decode(favoritesJson) as List<dynamic>;
        return favoritesList.cast<String>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
  
  static Future<void> setFavoriteProducts(List<String> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = json.encode(favorites);
      await prefs.setString(_favoriteProductsKey, favoritesJson);
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