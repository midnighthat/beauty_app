import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../providers/cart_provider.dart';
import '../../providers/currency_provider.dart';
import '../../providers/favorites_provider.dart';
import '../../services/product_service.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  bool isDescriptionExpanded = false;
  Map<String, dynamic>? productDetails;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  Future<void> _loadProductDetails() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Debug: Print the full product data to see what we're working with
      print('🔍 Full product data: ${widget.product}');

      // Extract productId and skuId from the basic product data
      final productId = widget.product['id'] ?? widget.product['productId'];
      final skuId = widget.product['skuId']; // Now directly available in Firebase data
      
      print('🔍 Extracted productId: $productId');
      print('🔍 Extracted skuId: $skuId');
      
      if (productId == null) {
        throw Exception('Missing productId');
      }
      
      if (skuId == null) {
        throw Exception('Missing skuId - product may need to be re-imported with updated schema');
      }

      print('🔍 Loading details for Product ID: $productId, SKU: $skuId');

      final details = await ProductService.getProductDetails(productId, skuId);
      
      if (details != null) {
        setState(() {
          productDetails = details;
          isLoading = false;
        });
      } else {
        throw Exception('No product details found');
      }
    } catch (e) {
      print('❌ Error loading product details: $e');
      setState(() {
        errorMessage = 'Failed to load product details: $e';
        isLoading = false;
      });
    }
  }

  void _addToCart() {
    // Use original product data for cart (basic info is sufficient)
    ref.read(cartProvider.notifier).addItem(widget.product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product['name']} added to cart!'),
        backgroundColor: AppColors.primaryBrown,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
      body: SafeArea(
        child: isLoading 
          ? _buildLoadingState(isDark)
          : errorMessage != null
            ? _buildErrorState(isDark)
            : _buildProductContent(isDark),
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Column(
      children: [
        _buildHeader(isDark),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primaryBrown),
                const SizedBox(height: 16),
                Text(
                  'Loading product details...',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? AppColors.creamBackground : AppColors.darkText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(bool isDark) {
    return Column(
      children: [
        _buildHeader(isDark),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.withOpacity(0.7),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load product details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.creamBackground : AppColors.darkText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage ?? 'Unknown error occurred',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.lightText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _loadProductDetails,
                    icon: const Icon(Icons.refresh, color: AppColors.white),
                    label: const Text(
                      'Retry',
                      style: TextStyle(color: AppColors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBrown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductContent(bool isDark) {
    // Use detailed product data if available, fallback to basic product data
    final displayData = productDetails ?? widget.product;
    final usdPrice = _extractPrice(displayData);
    final currency = ref.watch(currencyProvider);
    final convertedPrice = CurrencyUtils.convertPrice(usdPrice, currency);
    final productName = _extractProductName(displayData);
    final description = _extractDescription(displayData);
    final rating = _extractRating(displayData);
    final reviewCount = _extractReviewCount(displayData);
    final imageUrl = _extractImageUrl(displayData);
    
    return Column(
      children: [
        _buildHeader(isDark),
        
        // Product Image
        Container(
          height: 300,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
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
              // Artistic background elements
              Positioned(
                top: 20,
                right: 30,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBrown.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              
              // Product Image
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // If detailed image fails, try original product image
                              final fallbackImage = widget.product['image'] ?? widget.product['imageUrl'];
                              if (fallbackImage != null && fallbackImage != imageUrl) {
                                return Image.network(
                                  fallbackImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildImageFallback();
                                  },
                                );
                              }
                              return _buildImageFallback();
                            },
                          )
                        : _buildImageFallback(),
                  ),
                ),
              ),
              
              // Volume indicator
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.darkText.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    _extractVolume(displayData),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Product Info
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Volume
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          productName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.creamBackground : AppColors.darkText,
                            height: 1.2,
                          ),
                        ),
                      ),
                      Text(
                        _extractVolume(displayData),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.lightText,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Rating
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.creamBackground : AppColors.darkText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '($reviewCount Reviews)',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.lightText,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Description
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Description:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.creamBackground : AppColors.darkText,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isDescriptionExpanded = !isDescriptionExpanded;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            isDescriptionExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: AppColors.lightText,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Text(
                    isDescriptionExpanded ? description : _truncateDescription(description),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.lightText,
                      height: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Specifications Table
                  _buildSpecificationTable(isDark, displayData),
                  
                  const SizedBox(height: 32),
                  
                  // Price and Add to Cart
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.lightText,
                            ),
                          ),
                          Text(
                            CurrencyUtils.formatPrice(convertedPrice, currency),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryBrown,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(width: 32),
                      
                      Expanded(
                        child: Container(
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: _addToCart,
                            icon: const Icon(Icons.shopping_cart, color: AppColors.white),
                            label: const Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBrown,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkText.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back,
                color: isDark ? AppColors.creamBackground : AppColors.darkText,
                size: 20,
              ),
            ),
          ),
          
          Text(
            'Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.creamBackground : AppColors.darkText,
            ),
          ),
          
          Consumer(
            builder: (context, ref, child) {
              final productId = widget.product['id'] ?? widget.product['productId'] ?? '';
              final isFavorite = ref.watch(favoritesProvider).contains(productId);
              
              return GestureDetector(
                onTap: () {
                  ref.read(favoritesProvider.notifier).toggleFavorite(productId);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.white,
                    borderRadius: BorderRadius.circular(12),
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
                    color: isFavorite ? Colors.red : (isDark ? AppColors.creamBackground : AppColors.darkText),
                    size: 20,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildSpecificationTable(bool isDark, Map<String, dynamic> data) {
    final specs = _extractSpecifications(data);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.creamBackground : AppColors.darkText,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.lightText.withOpacity(0.2),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: specs.asMap().entries.map((entry) {
              final index = entry.key;
              final spec = entry.value;
              final isLast = index == specs.length - 1;
              
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: !isLast ? Border(
                    bottom: BorderSide(
                      color: AppColors.lightText.withOpacity(0.2),
                      width: 1,
                    ),
                  ) : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      spec['label']!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.creamBackground : AppColors.darkText,
                      ),
                    ),
                    Text(
                      spec['value']!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBrown,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // Helper methods to extract data from API response
  String _extractProductName(Map<String, dynamic> data) {
    return data['displayName'] ?? data['name'] ?? widget.product['name'] ?? 'Beauty Product';
  }

  double _extractPrice(Map<String, dynamic> data) {
    // Try to get price from detailed product data first
    if (data['currentSku'] != null) {
      final sku = data['currentSku'];
      if (sku['listPrice'] != null) {
        return _parsePrice(sku['listPrice']);
      }
    }
    
    if (data['price'] != null) {
      return _parsePrice(data['price'].toString());
    }
    
    // Fallback to original product price
    if (widget.product['price'] != null) {
      return _parsePrice(widget.product['price'].toString());
    }
    
    return 25.0; // Default fallback price
  }

  double _parsePrice(dynamic price) {
    if (price is String) {
      final cleaned = price.replaceAll(RegExp(r'[^\d.]'), '');
      return double.tryParse(cleaned) ?? 0.0;
    }
    if (price is num) {
      return price.toDouble();
    }
    return 0.0;
  }

  String _extractDescription(Map<String, dynamic> data) {
    return data['longDescription'] ?? 
           data['shortDescription'] ?? 
           data['description'] ?? 
           'A premium beauty product designed to enhance your natural beauty with carefully selected ingredients and advanced formulation.';
  }

  String _truncateDescription(String description) {
    if (description.length <= 100) return description;
    return '${description.substring(0, 100)}... Read More';
  }

  double _extractRating(Map<String, dynamic> data) {
    final rating = data['rating'] ?? data['averageRating'];
    if (rating is String) {
      return double.tryParse(rating) ?? 5.0;
    }
    if (rating is num) {
      return rating.toDouble();
    }
    return 5.0;
  }

  int _extractReviewCount(Map<String, dynamic> data) {
    final reviews = data['reviews'] ?? data['reviewCount'] ?? data['totalReviews'];
    if (reviews is String) {
      return int.tryParse(reviews) ?? 750;
    }
    if (reviews is num) {
      return reviews.toInt();
    }
    return 750;
  }

  String? _extractImageUrl(Map<String, dynamic> data) {
    // Try detailed product data first
    String? detailImage = data['heroImage'] ?? 
           data['productImages']?[0]?['url'] ??
           data['imageUrl'];
    
    if (detailImage != null && detailImage.isNotEmpty) {
      return detailImage;
    }
    
    // Fallback to original product image from basic data
    return widget.product['image'] ?? 
           widget.product['imageUrl'] ??
           data['image'];
  }

  String _extractVolume(Map<String, dynamic> data) {
    // Try to extract volume information
    final volume = data['size'] ?? data['volume'];
    if (volume != null) return volume.toString();
    
    // Look in SKU data
    if (data['currentSku'] != null) {
      final sku = data['currentSku'];
      final skuSize = sku['size'] ?? sku['volume'];
      if (skuSize != null) return skuSize.toString();
    }
    
    return '250 mL'; // Default fallback
  }

  List<Map<String, String>> _extractSpecifications(Map<String, dynamic> data) {
    final specs = <Map<String, String>>[];
    
    // Add specifications based on available data
    specs.add({'label': 'Use Type', 'value': _extractUseType(data)});
    specs.add({'label': 'Fragrance', 'value': _extractFragrance(data)});
    specs.add({'label': 'Volume', 'value': _extractVolume(data)});
    specs.add({'label': 'Brand', 'value': _extractBrand(data)});
    
    return specs;
  }

  String _extractUseType(Map<String, dynamic> data) {
    // Try to determine use type from category or product type
    final category = data['categoryName'] ?? data['category'];
    if (category != null) {
      if (category.toString().toLowerCase().contains('face')) return 'Face';
      if (category.toString().toLowerCase().contains('body')) return 'Full Body';
      if (category.toString().toLowerCase().contains('hair')) return 'Hair';
    }
    return 'Full Body';
  }

  String _extractFragrance(Map<String, dynamic> data) {
    // Look for fragrance information
    final fragrance = data['fragrance'] ?? data['scent'];
    if (fragrance != null) return fragrance.toString();
    
    // Default based on product type
    return 'Unscented';
  }

  String _extractBrand(Map<String, dynamic> data) {
    return data['brandName'] ?? data['brand'] ?? widget.product['brand'] ?? 'Premium Brand';
  }

  Widget _buildImageFallback() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryBrown.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.shopping_bag,
        color: AppColors.primaryBrown.withOpacity(0.5),
        size: 60,
      ),
    );
  }
}