import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';
import '../../services/product_service.dart';
import '../../providers/cart_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/currency_provider.dart';
import '../../widgets/products/cart_utils.dart';
import '../cart/cart_screen.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String productId;
  
  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  Map<String, dynamic>? product;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  Future<void> _loadProductDetails() async {
    try {
      final productData = await ProductService.getProductById(widget.productId);
      if (mounted) {
        setState(() {
          product = productData;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Failed to load product details';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (isLoading) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? AppColors.creamBackground : AppColors.darkText,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (error != null || product == null) {
      return Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? AppColors.creamBackground : AppColors.darkText,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: isDark ? AppColors.creamBackground.withOpacity(0.5) : AppColors.lightText,
              ),
              const SizedBox(height: 16),
              BodyText(
                error ?? 'Product not found',
                color: isDark ? AppColors.creamBackground.withOpacity(0.7) : AppColors.lightText,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
      body: CustomScrollView(
        slivers: [
          // App Bar with Product Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? AppColors.creamBackground : AppColors.darkText,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: isDark ? AppColors.creamBackground : AppColors.darkText,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                  ),
                  // Cart counter badge
                  Consumer(
                    builder: (context, ref, child) {
                      final itemCount = ref.watch(cartItemCountProvider);
                      if (itemCount > 0) {
                        return Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              '$itemCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryBrown.withOpacity(0.1),
                ),
                child: product!['images'] != null
                    ? Image.asset(
                        product!['images'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.primaryBrown.withOpacity(0.1),
                            child: Icon(
                              Icons.image,
                              size: 80,
                              color: AppColors.primaryBrown.withOpacity(0.5),
                            ),
                          );
                        },
                      )
                    : Icon(
                        Icons.image,
                        size: 80,
                        color: AppColors.primaryBrown.withOpacity(0.5),
                      ),
              ),
            ),
          ),
          
          // Product Details Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name & Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DisplayText(
                          product!['name'] ?? '',
                          color: isDark ? AppColors.creamBackground : AppColors.darkText,
                          isLarge: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBrown,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final currency = ref.watch(currencyProvider);
                            final price = (product!['price'] as num?)?.toDouble() ?? 0.0;
                            final convertedPrice = CurrencyUtils.convertPrice(price, currency);
                            return Text(
                              CurrencyUtils.formatPrice(convertedPrice, currency),
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Rating & Category
                  Row(
                    children: [
                      ..._buildStarRating(product!['rating']?.toDouble() ?? 0.0),
                      const SizedBox(width: 8),
                      Text(
                        '(${product!['rating'] ?? 0})',
                        style: TextStyle(
                          color: isDark ? AppColors.creamBackground.withOpacity(0.7) : AppColors.lightText,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBrown.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CaptionText(
                          product!['categories'] ?? '',
                          color: AppColors.primaryBrown,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Description Section
                  _buildSection(
                    'Description',
                    product!['description'] ?? 'No description available.',
                    isDark,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Skin Type Section
                  _buildSection(
                    'Best For',
                    product!['bestFor'] ?? product!['skinType'] ?? 'All skin types',
                    isDark,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Ingredients Section
                  if (product!['ingredient'] != null) ...[
                    HeadingText(
                      'Key Ingredients',
                      color: isDark ? AppColors.creamBackground : AppColors.darkText,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (product!['ingredient'] as List<dynamic>)
                          .map((ingredient) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurface : AppColors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.primaryBrown.withOpacity(0.3),
                                  ),
                                ),
                                child: CaptionText(
                                  ingredient.toString(),
                                  color: isDark ? AppColors.creamBackground : AppColors.darkText,
                                ),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Add to Cart Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBrown.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleText(
                                    'Add to Cart',
                                    color: isDark ? AppColors.creamBackground : AppColors.darkText,
                                  ),
                                  const SizedBox(height: 4),
                                  CaptionText(
                                    'Free shipping on orders over \$50',
                                    color: isDark ? AppColors.creamBackground.withOpacity(0.7) : AppColors.lightText,
                                  ),
                                ],
                              ),
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                final currency = ref.watch(currencyProvider);
                                final price = (product!['price'] as num?)?.toDouble() ?? 0.0;
                                final convertedPrice = CurrencyUtils.convertPrice(price, currency);
                                return Text(
                                  CurrencyUtils.formatPrice(convertedPrice, currency),
                                  style: TextStyle(
                                    color: AppColors.primaryBrown,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Action buttons row
                        Row(
                          children: [
                            // Like button
                            Consumer(
                              builder: (context, ref, child) {
                                final favorites = ref.watch(favoritesProvider);
                                final isFavorite = favorites.contains(product!['id'].toString());
                                
                                return Container(
                                  width: 60,
                                  height: 56,
                                  margin: const EdgeInsets.only(right: 12),
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      await ref.read(favoritesProvider.notifier).toggleFavorite(product!['id'].toString());
                                      
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(isFavorite 
                                            ? '${product!['name']} removed from favorites' 
                                            : '${product!['name']} added to favorites!'),
                                          backgroundColor: isFavorite ? Colors.grey : Colors.red,
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: isFavorite ? Colors.red : AppColors.lightText,
                                      side: BorderSide(
                                        color: isFavorite ? Colors.red : AppColors.lightText.withOpacity(0.3),
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : AppColors.lightText,
                                      size: 24,
                                    ),
                                  ),
                                );
                              },
                            ),
                            
                            // Add to cart button
                            Expanded(
                              child: PrimaryButton(
                                text: 'Add to Cart',
                                onPressed: () {
                                  CartUtils.addProductToCart(ref, context, product!);
                                },
                                size: ButtonSize.large,
                                icon: const Icon(Icons.shopping_cart, color: AppColors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 100), // Bottom padding for tab bar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingText(
          title,
          color: isDark ? AppColors.creamBackground : AppColors.darkText,
        ),
        const SizedBox(height: 12),
        BodyText(
          content,
          color: isDark ? AppColors.creamBackground.withOpacity(0.9) : AppColors.darkText,
          height: 1.5,
        ),
      ],
    );
  }

  List<Widget> _buildStarRating(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    
    // Add full stars
    for (int i = 0; i < fullStars && i < 5; i++) {
      stars.add(const Icon(
        Icons.star,
        color: Colors.amber,
        size: 16,
      ));
    }
    
    // Add half star if needed
    if (hasHalfStar && fullStars < 5) {
      stars.add(const Icon(
        Icons.star_half,
        color: Colors.amber,
        size: 16,
      ));
    }
    
    // Add empty stars to complete 5 stars
    int totalShownStars = fullStars + (hasHalfStar ? 1 : 0);
    for (int i = totalShownStars; i < 5; i++) {
      stars.add(Icon(
        Icons.star_border,
        color: Colors.grey.shade400,
        size: 16,
      ));
    }
    
    return stars;
  }
}