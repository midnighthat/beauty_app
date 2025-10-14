import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/currency_provider.dart';
import '../../services/product_service.dart';
import '../products/product_detail_screen.dart';

class LikedProductsScreen extends ConsumerWidget {
  const LikedProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final favoriteIds = ref.watch(favoriteProductsListProvider);
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
        foregroundColor: isDark ? AppColors.creamBackground : AppColors.darkText,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.creamBackground : AppColors.darkText,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Liked Products',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.creamBackground : AppColors.darkText,
          ),
        ),
        centerTitle: true,
      ),
      body: favoriteIds.isEmpty
          ? _buildEmptyState(isDark, context)
          : _buildProductsList(favoriteIds, isDark),
    );
  }

  Widget _buildEmptyState(bool isDark, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryBrown.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border,
                size: 60,
                color: AppColors.primaryBrown.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Liked Products Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.creamBackground : AppColors.darkText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Start exploring our products and tap the heart icon on products you love to see them here.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.lightText,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBrown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                'Explore Products',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsList(List<String> favoriteIds, bool isDark) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: ProductService.getProductsByCategory('cat150006'), // Default to face products
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryBrown),
          );
        }

        final allProducts = snapshot.data ?? [];
        final likedProducts = allProducts.where((product) {
          final productId = product['id'] ?? product['productId'] ?? '';
          return favoriteIds.contains(productId);
        }).toList();

        if (likedProducts.isEmpty) {
          return Builder(
            builder: (context) => _buildEmptyState(isDark, context),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: likedProducts.length,
          itemBuilder: (context, index) {
            final product = likedProducts[index];
            return _buildLikedProductItem(product, isDark);
          },
        );
      },
    );
  }

  Widget _buildLikedProductItem(Map<String, dynamic> product, bool isDark) {
    return Consumer(
      builder: (context, ref, child) {
        final currency = ref.watch(currencyProvider);
        final usdPrice = double.tryParse(product['price']?.toString() ?? '0') ?? 0.0;
        final convertedPrice = CurrencyUtils.convertPrice(usdPrice, currency);
        final formattedPrice = CurrencyUtils.formatPrice(convertedPrice, currency);
        final productId = product['id'] ?? product['productId'] ?? '';
        
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: product),
              ),
            );
          },
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
                Container(
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
                    child: product['image'] != null
                        ? Image.network(
                            product['image'],
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
                ),
                
                const SizedBox(width: 16),
                
                // Product Info
                Expanded(
                  child: Column(
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
                      
                      Text(
                        product['brand'] ?? 'Premium Brand',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.lightText,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Price
                      Text(
                        formattedPrice,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryBrown,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Remove from favorites button
                GestureDetector(
                  onTap: () {
                    ref.read(favoritesProvider.notifier).toggleFavorite(productId);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}