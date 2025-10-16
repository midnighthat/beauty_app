import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/product_service.dart';
import 'skin_profile_provider.dart';

// State class for products
class ProductsState {
  final List<Map<String, dynamic>> products;
  final bool isLoading;
  final String? error;

  const ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.error,
  });

  ProductsState copyWith({
    List<Map<String, dynamic>>? products,
    bool? isLoading,
    String? error,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Products notifier
class ProductsNotifier extends StateNotifier<ProductsState> {
  ProductsNotifier() : super(const ProductsState());

  Future<void> loadProductsByCategory(String category) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await for (final products in ProductService.getProductsByCategory(category)) {
        state = state.copyWith(
          products: products,
          isLoading: false,
        );
        break; // Take first emission
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

// Provider for products by category
final productsProvider = StateNotifierProvider.family<ProductsNotifier, ProductsState, String>(
  (ref, category) {
    final notifier = ProductsNotifier();
    notifier.loadProductsByCategory(category);
    return notifier;
  },
);

// Provider for suggested products based on skin profile
final suggestedProductsProvider = Provider<AsyncValue<List<Map<String, dynamic>>>>((ref) {
  final skinProfile = ref.watch(skinProfileProvider);
  
  // Determine category based on skin type
  String suggestedCategory;
  if (skinProfile != null) {
    switch (skinProfile.skinType.toLowerCase()) {
      case 'dry':
      case 'very dry':
        suggestedCategory = 'Moisturizer';
        break;
      case 'oily':
      case 'very oily':
        suggestedCategory = 'Cleanser';
        break;
      case 'sensitive':
        suggestedCategory = 'Moisturizer';
        break;
      case 'combination':
        suggestedCategory = 'Serum';
        break;
      default:
        suggestedCategory = 'Cleanser';
    }
  } else {
    suggestedCategory = 'Cleanser';
  }
  
  return ref.watch(asyncProductsByCategoryProvider(suggestedCategory));
});

// Async provider for products by category (for FutureBuilder replacement)
final asyncProductsByCategoryProvider = FutureProvider.family<List<Map<String, dynamic>>, String>(
  (ref, category) async {
    final completer = Completer<List<Map<String, dynamic>>>();
    
    await for (final products in ProductService.getProductsByCategory(category)) {
      completer.complete(products);
      break;
    }
    
    return completer.future;
  },
);

// Provider for category mapping
final categoryMappingProvider = Provider<Map<String, String>>((ref) {
  return {
    'All': 'All', // Show all products
    'Cleanser': 'Cleanser',
    'Moisturizer': 'Moisturizer',
    'Sunscreen': 'Sunscreen',
    'Serum': 'Serum',
    'Toner': 'Toner',
    'Exfoliator': 'Exfoliator',
    'Face Mask': 'Face Mask',
  };
});

// Provider for selected category
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

// Provider for recent products limit
final recentProductsLimitProvider = StateProvider<int>((ref) => 3);