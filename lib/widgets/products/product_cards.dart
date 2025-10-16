import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/currency_provider.dart';
import '../../screens/product/product_details_screen.dart';

class ProductCard extends ConsumerWidget {
  final Map<String, dynamic> product;
  final bool showSuggestedBadge;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.showSuggestedBadge = false,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () => _navigateToDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: showSuggestedBadge ? Border.all(
            color: AppColors.primaryBrown.withOpacity(0.3),
            width: 1.5,
          ) : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBrown.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Section
            Expanded(
              child: _ProductImage(
                product: product,
                showSuggestedBadge: showSuggestedBadge,
              ),
            ),
            // Product Info Section
            _ProductInfo(product: product, isDark: isDark),
          ],
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          productId: product['id'].toString(),
        ),
      ),
    );
  }
}

class _ProductImage extends ConsumerWidget {
  final Map<String, dynamic> product;
  final bool showSuggestedBadge;

  const _ProductImage({
    required this.product,
    required this.showSuggestedBadge,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBrown.withOpacity(0.15),
            AppColors.primaryBrown.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: _buildProductImage(),
          ),
          // Badges and buttons overlay
          ..._buildOverlayWidgets(ref),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return product['images'] != null
        ? Image.asset(
            product['images'],
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: AppColors.primaryBrown.withOpacity(0.5),
                  size: 40,
                ),
              );
            },
          )
        : Center(
            child: Icon(
              Icons.shopping_bag,
              color: AppColors.primaryBrown.withOpacity(0.5),
              size: 40,
            ),
          );
  }

  List<Widget> _buildOverlayWidgets(WidgetRef ref) {
    final widgets = <Widget>[];

    // Suggested badge
    if (showSuggestedBadge) {
      widgets.add(
        const Positioned(
          top: 8,
          left: 8,
          child: _SuggestedBadge(),
        ),
      );
    }

    // Favorite button
    widgets.add(
      Positioned(
        top: 12,
        right: 12,
        child: _FavoriteButton(product: product),
      ),
    );

    return widgets;
  }
}

class _SuggestedBadge extends StatelessWidget {
  const _SuggestedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryBrown,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Suggested',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  final Map<String, dynamic> product;

  const _FavoriteButton({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productId = product['id']?.toString() ?? '';
    final isFavorite = ref.watch(favoritesProvider.select((favorites) => favorites.contains(productId)));

    return GestureDetector(
      onTap: () => ref.read(favoritesProvider.notifier).toggleFavorite(productId),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkText.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : AppColors.primaryBrown,
          size: 18,
        ),
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isDark;

  const _ProductInfo({
    required this.product,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            product['name'] ?? 'Product Name',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.creamBackground : AppColors.darkText,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 6),
          
          // Rating Stars
          _RatingStars(rating: product['rating']),
          
          const SizedBox(height: 6),
          
          // Price
          Consumer(
            builder: (context, ref, child) {
              final currency = ref.watch(currencyProvider);
              final price = (product['price'] as num?)?.toDouble() ?? 0.0;
              final convertedPrice = CurrencyUtils.convertPrice(price, currency);
              return Text(
                CurrencyUtils.formatPrice(convertedPrice, currency),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBrown,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RatingStars extends StatelessWidget {
  final dynamic rating;

  const _RatingStars({required this.rating});

  @override
  Widget build(BuildContext context) {
    final numericRating = (rating is num) ? rating.toDouble() : 4.5;
    final starCount = numericRating.floor();
    
    return Row(
      children: [
        ...List.generate(5, (index) => 
          Icon(
            index < starCount ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 12,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          numericRating.toString(),
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.lightText,
          ),
        ),
      ],
    );
  }
}

// Horizontal Product Item for recent products list
class ProductListItem extends ConsumerWidget {
  final Map<String, dynamic> product;
  final VoidCallback? onAddToCart;

  const ProductListItem({
    super.key,
    required this.product,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () => _navigateToDetails(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkText.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product Image
            _ProductThumbnail(product: product),
            const SizedBox(width: 16),
            // Product Info
            Expanded(
              child: _ProductListInfo(product: product, isDark: isDark),
            ),
            // Add to Cart Button
            _AddToCartButton(
              onPressed: onAddToCart ?? () => _defaultAddToCart(ref),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          productId: product['id'].toString(),
        ),
      ),
    );
  }

  void _defaultAddToCart(WidgetRef ref) {
    ref.read(cartProvider.notifier).addItem({
      'id': product['id'].toString(),
      'name': product['name'],
      'brand': 'K-Beauty Pro',
      'image': product['images'] ?? '',
      'price': product['price'],
    });
  }
}

class _ProductThumbnail extends StatelessWidget {
  final Map<String, dynamic> product;

  const _ProductThumbnail({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBrown.withOpacity(0.1),
            AppColors.primaryBrown.withOpacity(0.05),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: product['images'] != null
            ? Image.asset(
                product['images'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.image_not_supported,
                    color: AppColors.primaryBrown.withOpacity(0.5),
                    size: 24,
                  );
                },
              )
            : Icon(
                Icons.shopping_bag,
                color: AppColors.primaryBrown.withOpacity(0.5),
                size: 24,
              ),
      ),
    );
  }
}

class _ProductListInfo extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isDark;

  const _ProductListInfo({
    required this.product,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product['name'] ?? 'Product Name',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.creamBackground : AppColors.darkText,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        
        const SizedBox(height: 4),
        
        // Rating Stars
        _RatingStars(rating: product['rating']),
        
        const SizedBox(height: 8),
        
        // Price
        Consumer(
          builder: (context, ref, child) {
            final currency = ref.watch(currencyProvider);
            final price = (product['price'] as num?)?.toDouble() ?? 0.0;
            final convertedPrice = CurrencyUtils.convertPrice(price, currency);
            return Text(
              CurrencyUtils.formatPrice(convertedPrice, currency),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBrown,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddToCartButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primaryBrown,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.add,
          color: AppColors.white,
          size: 20,
        ),
      ),
    );
  }
}