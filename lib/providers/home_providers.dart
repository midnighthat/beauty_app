import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/product_service.dart';

// State for routine products
class RoutineProductsState {
  final List<Map<String, dynamic>> products;
  final bool isLoading;
  final String? error;

  const RoutineProductsState({
    this.products = const [],
    this.isLoading = false,
    this.error,
  });

  RoutineProductsState copyWith({
    List<Map<String, dynamic>>? products,
    bool? isLoading,
    String? error,
  }) {
    return RoutineProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Notifier for routine products
class RoutineProductsNotifier extends StateNotifier<RoutineProductsState> {
  RoutineProductsNotifier() : super(const RoutineProductsState());

  Future<void> loadRoutineProducts(dynamic profile, String routine) async {
    if (state.isLoading) return; // Prevent duplicate loading
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final products = await _getRoutineProducts(profile, routine);
      state = state.copyWith(
        products: products,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<List<Map<String, dynamic>>> _getRoutineProducts(profile, String routine) async {
    final allProducts = <Map<String, dynamic>>[];
    
    // Get products from different categories
    final categories = ['Cleanser', 'Moisturizer', 'Serum', 'Toner', 'Sunscreen', 'Face Mask', 'Eye Care', 'Exfoliator'];
    for (final category in categories) {
      await for (final products in ProductService.getProductsByCategory(category)) {
        allProducts.addAll(products);
        break; // Take first emission
      }
    }
    
    // Filter products based on routine and user's skin type
    final routineProducts = allProducts.where((product) {
      final productRoutine = product['routine']?.toString() ?? '';
      final skinTypes = product['skinType']?.toString().toLowerCase() ?? '';
      final bestFor = product['bestFor']?.toString().toLowerCase() ?? '';
      
      // Check if product is for the specified routine
      final isRoutineMatch = productRoutine.contains(routine);
      
      // Check if product is suitable for user's skin type
      final skinTypeMatch = skinTypes.contains(profile.skinType.toLowerCase()) || 
                           skinTypes.contains('all skin types');
      
      // Check if product addresses user's concerns
      final concernMatch = profile.concerns.any((concern) => 
        bestFor.contains(concern.toLowerCase()) || 
        skinTypes.contains(concern.toLowerCase())
      );
      
      return isRoutineMatch && (skinTypeMatch || concernMatch);
    }).toList();
    
    // If we found matching products, sort and return them
    if (routineProducts.isNotEmpty) {
      // Sort by step order
      routineProducts.sort((a, b) {
        final stepA = a['step'] ?? 999;
        final stepB = b['step'] ?? 999;
        return stepA.compareTo(stepB);
      });
      
      return routineProducts.take(6).toList(); // Limit to 6 steps max
    }
    
    // If no matching products found, return random products for the routine
    print('No matching products found for ${profile.skinType} skin and $routine routine, showing random products');
    
    final randomProducts = allProducts.where((product) {
      final productRoutine = product['routine']?.toString() ?? '';
      return productRoutine.toLowerCase().contains(routine.toLowerCase());
    }).toList();
    
    // If still no products for this routine, get any random products
    if (randomProducts.isEmpty) {
      randomProducts.addAll(allProducts.take(6));
    }
    
    // Shuffle and return random products
    randomProducts.shuffle();
    return randomProducts.take(6).toList();
  }
}

// Provider for morning routine products
final morningRoutineProvider = StateNotifierProvider.family<RoutineProductsNotifier, RoutineProductsState, dynamic>(
  (ref, profile) {
    final notifier = RoutineProductsNotifier();
    if (profile != null) {
      notifier.loadRoutineProducts(profile, 'Morning');
    }
    return notifier;
  },
);

// Provider for evening routine products
final eveningRoutineProvider = StateNotifierProvider.family<RoutineProductsNotifier, RoutineProductsState, dynamic>(
  (ref, profile) {
    final notifier = RoutineProductsNotifier();
    if (profile != null) {
      notifier.loadRoutineProducts(profile, 'Evening');
    }
    return notifier;
  },
);

// Provider for recommended treatments - optimized for performance
final recommendedTreatmentsProvider = FutureProvider.family<List<Map<String, dynamic>>, dynamic>(
  (ref, profile) async {
    if (profile == null) return [];
    
    try {
      final allTreatments = <Map<String, dynamic>>[];
      await for (final treatments in ProductService.getTreatments()) {
        allTreatments.addAll(treatments);
        break; // Take first emission
      }
      
      if (allTreatments.isEmpty) {
        return [];
      }
      
      // Pre-process user profile for faster matching
      final userSkinType = profile.skinType.toLowerCase();
      final userConcerns = profile.concerns.map((c) => c.toLowerCase()).toSet();
      
      // Fast filter with early termination
      final matchedTreatments = <Map<String, dynamic>>[];
      
      for (final treatment in allTreatments) {
        final bestFor = treatment['bestFor']?.toString().toLowerCase() ?? '';
        final skinConcern = treatment['skinConcern']?.toString().toLowerCase() ?? '';
        final skinTypes = treatment['skinTypes'] as List<dynamic>? ?? [];
        
        // Quick skin type check
        bool skinTypeMatch = bestFor.contains(userSkinType) || 
                           skinTypes.any((type) => type.toString().toLowerCase().contains(userSkinType));
        
        // Quick concern check
        bool concernMatch = userConcerns.any((concern) => 
          skinConcern.contains(concern) || bestFor.contains(concern)
        );
        
        if (skinTypeMatch || concernMatch) {
          matchedTreatments.add(treatment);
          // Return first 2 matches for performance
          if (matchedTreatments.length >= 2) break;
        }
      }
      
      // Return matched treatments or fallback to first treatment
      return matchedTreatments.isNotEmpty ? matchedTreatments : [allTreatments.first];
      
    } catch (e) {
      print('Error in recommendedTreatmentsProvider: $e');
      return [];
    }
  },
);

// Provider for recommended products
final recommendedProductsProvider = FutureProvider.family<List<Map<String, dynamic>>, dynamic>(
  (ref, profile) async {
    if (profile == null) return [];
    
    final allProducts = <Map<String, dynamic>>[];
    
    // Get products from different categories
    final categories = ['Cleanser', 'Moisturizer', 'Serum', 'Toner', 'Sunscreen', 'Face Mask'];
    for (final category in categories) {
      await for (final products in ProductService.getProductsByCategory(category)) {
        allProducts.addAll(products);
        break; // Take first emission
      }
    }
    
    // Filter products based on user's skin type and concerns
    final recommendedProducts = allProducts.where((product) {
      final skinTypes = product['skinType']?.toString().toLowerCase() ?? '';
      final bestFor = product['bestFor']?.toString().toLowerCase() ?? '';
      
      // Check if product is suitable for user's skin type
      final skinTypeMatch = skinTypes.contains(profile.skinType.toLowerCase()) || 
                           skinTypes.contains('all skin types');
      
      // Check if product addresses user's concerns
      final concernMatch = profile.concerns.any((concern) => 
        bestFor.contains(concern.toLowerCase()) || 
        skinTypes.contains(concern.toLowerCase())
      );
      
      return skinTypeMatch || concernMatch;
    }).toList();
    
    // If we found matching products, sort and return them
    if (recommendedProducts.isNotEmpty) {
      // Sort by rating
      recommendedProducts.sort((a, b) {
        final ratingA = (a['rating'] as num?) ?? 0;
        final ratingB = (b['rating'] as num?) ?? 0;
        return ratingB.compareTo(ratingA);
      });
      
      return recommendedProducts.take(6).toList();
    }
    
    // If no matching products found, return random products
    print('No matching products found for ${profile.skinType} skin, showing random products');
    
    // Shuffle all products and return top 6
    allProducts.shuffle();
    return allProducts.take(6).toList();
  },
);

// Provider for skin overview text
final skinOverviewProvider = Provider.family<String, dynamic>((ref, profile) {
  if (profile == null) return '';
  
  final skinType = profile.skinType;
  final concerns = profile.concerns;
  
  String overview = 'Based on your assessment, you have $skinType skin';
  
  if (concerns.isNotEmpty) {
    if (concerns.length == 1) {
      overview += ' with ${concerns.first.toLowerCase()} concerns.';
    } else {
      overview += ' with concerns including ${concerns.take(2).join(', ').toLowerCase()}';
      if (concerns.length > 2) overview += ' and others';
      overview += '.';
    }
  } else {
    overview += ' in excellent condition.';
  }
  
  overview += ' We\'ve curated personalized treatments and products below to help you achieve your best skin.';
  
  return overview;
});

// Provider for month name
final monthNameProvider = Provider<String>((ref) {
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  final now = DateTime.now();
  return months[now.month - 1];
});