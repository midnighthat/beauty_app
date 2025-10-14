import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/preferences_service.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super(<String>{}) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await PreferencesService.getFavoriteProducts();
    state = favorites.toSet();
  }

  Future<void> toggleFavorite(String productId) async {
    final newState = Set<String>.from(state);
    
    if (newState.contains(productId)) {
      newState.remove(productId);
    } else {
      newState.add(productId);
    }
    
    state = newState;
    await PreferencesService.setFavoriteProducts(newState.toList());
  }

  bool isFavorite(String productId) {
    return state.contains(productId);
  }

  List<String> get favoritesList => state.toList();
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});

final favoriteProductsListProvider = Provider<List<String>>((ref) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.toList();
});