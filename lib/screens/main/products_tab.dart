import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../services/product_service.dart';
import '../../providers/cart_provider.dart';
import '../../providers/currency_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/skin_profile_provider.dart';
import '../cart/cart_screen.dart';
import '../products/product_detail_screen.dart';

class ProductsTab extends ConsumerStatefulWidget {
  const ProductsTab({super.key});

  @override
  ConsumerState<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends ConsumerState<ProductsTab> {
  String selectedCategory = 'All';
  int _recentProductsLimit = 3;

  // Category filters matching the design
  final List<Map<String, String>> categories = [
    {'name': 'All', 'id': 'all'},
    {'name': 'Face', 'id': 'cat150006'},
    {'name': 'Body', 'id': 'cat140014'},
    {'name': 'Hair', 'id': 'cat130038'},
    {'name': 'Eye', 'id': 'cat140007'},
    {'name': 'Nail', 'id': 'cat130020'},
  ];

  void _addToCart(Map<String, dynamic> product) {
    ref.read(cartProvider.notifier).addItem(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart!'),
        backgroundColor: AppColors.primaryBrown,
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Menu Icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBrown.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.grid_view_rounded,
                        color: AppColors.primaryBrown,
                        size: 20,
                      ),
                    ),
                    
                    // Cart Icon with badge
                    CartIconWidget(isDark: isDark),
                  ],
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Discover Our Product',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.creamBackground : AppColors.darkText,
                    height: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Category Filter Pills
              Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = category['name'] == selectedCategory;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category['name']!;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryBrown : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryBrown : AppColors.lightText.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          category['name']!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected 
                              ? AppColors.white 
                              : (isDark ? AppColors.creamBackground : AppColors.darkText),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Suggested Products Section
              Consumer(
                builder: (context, ref, child) {
                  final skinProfile = ref.watch(skinProfileProvider);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Suggested for You',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.creamBackground : AppColors.darkText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Based on your ${skinProfile?.skinType ?? "skin"} profile',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.lightText,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'See All',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryBrown,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Suggested Products Grid
              Container(
                height: 280,
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _getSuggestedProductStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.primaryBrown),
                      );
                    }

                    final products = (snapshot.data ?? []).take(4).toList();

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Container(
                          width: 180,
                          margin: const EdgeInsets.only(right: 16),
                          child: _buildSuggestedProductCard(product, isDark),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Recent Product Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Recent Product',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.creamBackground : AppColors.darkText,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Recent Products List
              StreamBuilder<List<Map<String, dynamic>>>(
                stream: _getProductStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primaryBrown),
                    );
                  }

                  final allProducts = snapshot.data ?? [];
                  final recentProducts = allProducts.skip(4).take(_recentProductsLimit).toList();
                  final hasMoreProducts = allProducts.length > (4 + _recentProductsLimit);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        ...recentProducts.map((product) => _buildRecentProductItem(product, isDark)).toList(),
                        if (hasMoreProducts)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _recentProductsLimit += 3;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBrown.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.primaryBrown.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  'Load More Products',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryBrown,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),

              // Bottom padding for tab bar
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Stream<List<Map<String, dynamic>>> _getProductStream() {
    final categoryId = categories.firstWhere(
      (cat) => cat['name'] == selectedCategory,
      orElse: () => {'id': 'cat150006'},
    )['id'];
    
    return categoryId == 'all' 
      ? ProductService.getProductsByCategory('cat150006') // Default to face products
      : ProductService.getProductsByCategory(categoryId!);
  }

  Stream<List<Map<String, dynamic>>> _getSuggestedProductStream() {
    final skinProfile = ref.read(skinProfileProvider);
    
    // Determine category based on skin type and concerns
    String suggestedCategory;
    if (skinProfile != null) {
      switch (skinProfile.skinType.toLowerCase()) {
        case 'dry':
        case 'very dry':
          suggestedCategory = 'cat150006'; // Face products for dry skin
          break;
        case 'oily':
        case 'very oily':
          suggestedCategory = 'cat150006'; // Face products for oily skin
          break;
        case 'sensitive':
          suggestedCategory = 'cat150006'; // Gentle face products
          break;
        case 'combination':
          suggestedCategory = 'cat150006'; // Balanced face products
          break;
        default:
          suggestedCategory = 'cat150006'; // Default to face products
      }
    } else {
      suggestedCategory = 'cat150006'; // Default if no profile
    }
    
    return ProductService.getProductsByCategory(suggestedCategory);
  }

  Widget _buildSuggestedProductCard(Map<String, dynamic> product, bool isDark) {
    final usdPrice = double.tryParse(product['price']?.toString() ?? '0') ?? 0.0;
    final currency = ref.watch(currencyProvider);
    final convertedPrice = CurrencyUtils.convertPrice(usdPrice, currency);
    final formattedPrice = CurrencyUtils.formatPrice(convertedPrice, currency);
    
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
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryBrown.withOpacity(0.3),
            width: 1.5,
          ),
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
            // Product Image with "Suggested" badge
            Expanded(
              child: Container(
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
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: product['image'] != null
                          ? Image.network(
                              product['image'],
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
                            ),
                    ),
                    // "Suggested" badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBrown,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Suggested',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    // Favorite button
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Consumer(
                        builder: (context, ref, child) {
                          final productId = product['id'] ?? product['productId'] ?? '';
                          final isFavorite = ref.watch(favoritesProvider).contains(productId);
                          
                          return GestureDetector(
                            onTap: () {
                              ref.read(favoritesProvider.notifier).toggleFavorite(productId);
                            },
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
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Product Info
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product['name'] ?? 'Product Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.creamBackground : AppColors.darkText,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Price
                  Text(
                    formattedPrice,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryBrown,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularProductCard(Map<String, dynamic> product, bool isDark) {
    final usdPrice = double.tryParse(product['price']?.toString() ?? '0') ?? 0.0;
    final currency = ref.watch(currencyProvider);
    final convertedPrice = CurrencyUtils.convertPrice(usdPrice, currency);
    final formattedPrice = CurrencyUtils.formatPrice(convertedPrice, currency);
    
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
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkText.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryBrown.withOpacity(0.1),
                    AppColors.primaryBrown.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: product['image'] != null
                        ? Image.network(
                            product['image'],
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
                          ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final productId = product['id'] ?? product['productId'] ?? '';
                        final isFavorite = ref.watch(favoritesProvider).contains(productId);
                        
                        return GestureDetector(
                          onTap: () {
                            ref.read(favoritesProvider.notifier).toggleFavorite(productId);
                          },
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
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  product['name'] ?? 'Product Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.creamBackground : AppColors.darkText,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 8),
                
                // Price
                Text(
                  formattedPrice,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBrown,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildRecentProductItem(Map<String, dynamic> product, bool isDark) {
    final usdPrice = double.tryParse(product['price']?.toString() ?? '0') ?? 0.0;
    final currency = ref.watch(currencyProvider);
    final convertedPrice = CurrencyUtils.convertPrice(usdPrice, currency);
    final formattedPrice = CurrencyUtils.formatPrice(convertedPrice, currency);
    
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
                
                // Rating (placeholder)
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '5.0 (950 Reviews)',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.lightText,
                      ),
                    ),
                  ],
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
          
          // Add to Cart Button
          Container(
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
        ],
      ),
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
                color: AppColors.primaryBrown,
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