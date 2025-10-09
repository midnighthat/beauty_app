import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem {
  final String id;
  final String name;
  final String brand;
  final String image;
  final double price;
  final double? salePrice;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.image,
    required this.price,
    this.salePrice,
    this.quantity = 1,
  });

  double get effectivePrice => salePrice ?? price;
  double get totalPrice => effectivePrice * quantity;

  CartItem copyWith({
    String? id,
    String? name,
    String? brand,
    String? image,
    double? price,
    double? salePrice,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      image: image ?? this.image,
      price: price ?? this.price,
      salePrice: salePrice ?? this.salePrice,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(Map<String, dynamic> product) {
    final productId = product['id'] as String;
    final existingIndex = state.indexWhere((item) => item.id == productId);

    if (existingIndex >= 0) {
      // Item already exists, increase quantity
      final updatedItems = [...state];
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
      state = updatedItems;
    } else {
      // Add new item
      final newItem = CartItem(
        id: productId,
        name: product['name'] ?? 'Unknown Product',
        brand: product['brand'] ?? 'Unknown Brand',
        image: product['image'] ?? '',
        price: (product['price'] as num?)?.toDouble() ?? 0.0,
        salePrice: (product['salePrice'] as num?)?.toDouble(),
      );
      state = [...state, newItem];
    }
  }

  void removeItem(String productId) {
    state = state.where((item) => item.id != productId).toList();
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final updatedItems = state.map((item) {
      if (item.id == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
    state = updatedItems;
  }

  void clearCart() {
    state = [];
  }

  double get totalAmount {
    return state.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItems {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }
}

// Providers
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0.0, (sum, item) => sum + item.totalPrice);
});

final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.quantity);
});