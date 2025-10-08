import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz_models.dart';

// StateProvider to store the user's skin profile
final skinProfileProvider = StateProvider<SkinProfile?>((ref) => null);

// Provider to check if user has completed the quiz
final hasCompletedQuizProvider = Provider<bool>((ref) {
  final profile = ref.watch(skinProfileProvider);
  return profile != null;
});

// Provider to get skin score (calculated from skin type and concerns)
final skinScoreProvider = Provider<int>((ref) {
  final profile = ref.watch(skinProfileProvider);
  if (profile == null) return 0;
  
  // Calculate score based on skin type and concerns
  int baseScore = 100;
  
  // Deduct points based on number of concerns
  int concernDeduction = profile.concerns.length * 5;
  
  // Adjust based on skin type severity
  switch (profile.skinType.toLowerCase()) {
    case 'oily':
      baseScore -= 10;
      break;
    case 'dry':
      baseScore -= 15;
      break;
    case 'combination':
      baseScore -= 5;
      break;
    case 'normal':
      break; // No deduction for normal skin
  }
  
  return (baseScore - concernDeduction).clamp(0, 100);
});

// Provider to estimate skin age based on concerns
final skinAgeProvider = Provider<int>((ref) {
  final profile = ref.watch(skinProfileProvider);
  if (profile == null) return 25;
  
  int baseAge = 25;
  
  // Add years based on concerns
  if (profile.concerns.contains('aging')) baseAge += 10;
  if (profile.concerns.contains('pigmentation')) baseAge += 5;
  if (profile.concerns.contains('dehydration')) baseAge += 3;
  if (profile.concerns.contains('overuse')) baseAge += 2;
  
  return baseAge.clamp(18, 65);
});

// Provider for skin statistics (mock data based on profile)
final skinStatisticsProvider = Provider<Map<String, double>>((ref) {
  final profile = ref.watch(skinProfileProvider);
  if (profile == null) {
    return {
      'elasticity': 0.0,
      'wrinkles': 0.0,
      'sensitivity': 0.0,
      'moisture': 0.0,
    };
  }
  
  Map<String, double> stats = {
    'elasticity': 0.85, // Base elasticity
    'wrinkles': 0.20,   // Base wrinkles
    'sensitivity': 0.30, // Base sensitivity
    'moisture': 0.80,   // Base moisture
  };
  
  // Adjust based on concerns
  if (profile.concerns.contains('aging')) {
    stats['elasticity'] = (stats['elasticity']! - 0.20).clamp(0.0, 1.0);
    stats['wrinkles'] = (stats['wrinkles']! + 0.30).clamp(0.0, 1.0);
  }
  
  if (profile.concerns.contains('sensitive')) {
    stats['sensitivity'] = (stats['sensitivity']! + 0.40).clamp(0.0, 1.0);
  }
  
  if (profile.concerns.contains('dehydration')) {
    stats['moisture'] = (stats['moisture']! - 0.30).clamp(0.0, 1.0);
  }
  
  // Adjust based on skin type
  switch (profile.skinType.toLowerCase()) {
    case 'oily':
      stats['moisture'] = (stats['moisture']! + 0.10).clamp(0.0, 1.0);
      break;
    case 'dry':
      stats['moisture'] = (stats['moisture']! - 0.20).clamp(0.0, 1.0);
      stats['sensitivity'] = (stats['sensitivity']! + 0.10).clamp(0.0, 1.0);
      break;
    case 'combination':
      // Balanced adjustments
      break;
  }
  
  return stats;
});