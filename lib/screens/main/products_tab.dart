import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';
import '../../services/product_service.dart';
import '../../providers/cart_provider.dart';
import '../cart/cart_screen.dart';

class ProductsTab extends ConsumerStatefulWidget {
  const ProductsTab({super.key});

  @override
  ConsumerState<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends ConsumerState<ProductsTab> {
  String selectedCategoryId = 'cat150006'; // Default to Skincare

  // Target categories we want to show (same order as before)
  final List<String> targetCategories = [
    'cat150006', // Skincare
    'cat140006', // Makeup
    'cat160006', // Fragrance
    'cat130038', // Hair
    'cat130042', // Tools
    'cat140014', // Bath & Body
  ];

  void _addToCart(Map<String, dynamic> product) {
    ref.read(cartProvider.notifier).addItem(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart!'),
        backgroundColor: AppColors.primaryPink,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title - centered and positioned to start
                  Expanded(
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Get the Best ',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.creamBackground : AppColors.darkText,
                                height: 1.2,
                              ),
                            ),
                            TextSpan(
                              text: 'Beauty.',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryPink,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Cart Icon with badge
                  CartIconWidget(isDark: isDark),
                ],
              ),
            ),

            // Categories
            Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: ProductService.getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primaryPink));
                  }
                  
                  final allCategories = snapshot.data ?? [];
                  // Filter to only show our target categories in the specified order
                  final filteredCategories = targetCategories
                      .map((categoryId) => allCategories.firstWhere(
                            (cat) => cat['id'] == categoryId,
                            orElse: () => {'id': categoryId, 'name': 'Unknown'},
                          ))
                      .toList();
                  
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final category = filteredCategories[index];
                      final isSelected = category['id'] == selectedCategoryId;
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategoryId = category['id'];
                          });
                        },
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Category Image
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: isSelected
                                      ? Border.all(color: AppColors.primaryPink, width: 3)
                                      : null,
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primaryPink.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: ClipOval(
                                  child: category['thumbImage'] != null
                                      ? Image.network(
                                          'https://www.sephora.com${category['thumbImage']}',
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: AppColors.primaryPink.withOpacity(0.1),
                                              child: Icon(
                                                Icons.category,
                                                color: AppColors.primaryPink,
                                                size: 30,
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          color: AppColors.primaryPink.withOpacity(0.1),
                                          child: Icon(
                                            Icons.category,
                                            color: AppColors.primaryPink,
                                            size: 30,
                                          ),
                                        ),
                                ),
                              ),
                              
                              const SizedBox(height: 8),
                              
                              // Category Name
                              CustomText(
                                category['name'] ?? 'Unknown',
                                type: TextType.caption,
                                color: isSelected
                                    ? AppColors.primaryPink
                                    : (isDark ? AppColors.creamBackground : AppColors.darkText),
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Products Grid
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: ProductService.getProductsByCategory(selectedCategoryId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryPink,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    print('Product loading error: ${snapshot.error}');
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.primaryPink,
                          ),
                          const SizedBox(height: 16),
                          CustomText(
                            'Error loading products',
                            type: TextType.bodyLarge,
                            color: isDark ? AppColors.creamBackground : AppColors.darkText,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            'Database setup in progress...',
                            type: TextType.bodySmall,
                            color: AppColors.lightText,
                          ),
                          const SizedBox(height: 16),
                          CustomText(
                            '${snapshot.error}',
                            type: TextType.caption,
                            color: AppColors.lightText,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  final products = snapshot.data ?? [];

                  if (products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                            size: 64,
                            color: AppColors.primaryPink,
                          ),
                          const SizedBox(height: 16),
                          CustomText(
                            'No products found',
                            type: TextType.bodyLarge,
                            color: isDark ? AppColors.creamBackground : AppColors.darkText,
                          ),
                          const SizedBox(height: 8),
                          CustomText(
                            'Import products to see them here',
                            type: TextType.bodySmall,
                            color: AppColors.lightText,
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return _buildProductCard(product, isDark);
                      },
                    ),
                  );
                },
              ),
            ),

            // Bottom padding for tab bar
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, bool isDark) {
    final price = product['price']?.toString() ?? '0';
    final salePrice = product['salePrice']?.toString();
    final isOnSale = salePrice != null;

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: product['image'] != null
                        ? Image.network(
                            product['image'],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.primaryPink.withOpacity(0.1),
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: AppColors.primaryPink,
                                    size: 32,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: AppColors.primaryPink.withOpacity(0.1),
                            child: const Center(
                              child: Icon(
                                Icons.shopping_bag,
                                color: AppColors.primaryPink,
                                size: 32,
                              ),
                            ),
                          ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: AppColors.primaryPink,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                CustomText(
                  product['name'] ?? 'Product Name',
                  type: TextType.bodyMedium,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.creamBackground : AppColors.darkText,
                  maxLines: 2,
                ),
                
                const SizedBox(height: 4),
                
                // Brand
                if (product['brand'] != null)
                  CustomText(
                    product['brand'],
                    type: TextType.caption,
                    color: AppColors.lightText,
                  ),

                const SizedBox(height: 8),

                // Price and Add Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isOnSale) ...[
                          CustomText(
                            '\$$salePrice',
                            type: TextType.bodyMedium,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryPink,
                          ),
                          CustomText(
                            '\$$price',
                            type: TextType.caption,
                            color: AppColors.lightText,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ] else ...[
                          CustomText(
                            '\$$price',
                            type: TextType.bodyMedium,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryPink,
                          ),
                        ],
                      ],
                    ),
                    
                    // Add to Cart Button
                    GestureDetector(
                      onTap: () => _addToCart(product),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primaryPink,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: AppColors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartIconWidget extends ConsumerWidget {
  final bool isDark;
  
  const CartIconWidget({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemCount = ref.watch(cartItemCountProvider);
    
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            // Navigate to cart screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartScreen(),
              ),
            );
          },
          icon: Icon(
            Icons.shopping_cart_outlined,
            size: 28,
            color: isDark ? AppColors.creamBackground : AppColors.darkText,
          ),
        ),
        // Cart item count badge
        if (cartItemCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.primaryPink,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                cartItemCount.toString(),
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}