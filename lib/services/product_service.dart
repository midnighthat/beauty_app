import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product_models.dart';

class ProductService {
  // Simple memory cache to avoid reloading during same session
  static KBeautyData? _memoryCache;
  static DateTime? _cacheTime;
  static const cacheDuration = Duration(minutes: 5); // Cache for 5 minutes

  /// Load K-beauty data from unified JSON file
  static Future<KBeautyData> _loadKBeautyData() async {
    // Check memory cache first
    if (_memoryCache != null && _cacheTime != null) {
      final cacheAge = DateTime.now().difference(_cacheTime!);
      if (cacheAge < cacheDuration) {
        print('Using memory cached K-beauty data (${cacheAge.inSeconds}s old)');
        return _memoryCache!;
      }
    }
    try {
      print('Loading K-beauty data from assets/data/kbeauty_data.json');
      final String jsonString = await rootBundle.loadString('assets/data/kbeauty_data.json');
      print('JSON string length: ${jsonString.length}');
      
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      print('JSON decoded successfully');
      print('JSON keys: ${jsonData.keys.toList()}');
      
      final kbeautyData = KBeautyData.fromJson(jsonData);
      print('K-beauty data parsed successfully!');
      print('Treatments count: ${kbeautyData.treatments.length}');
      print('Products count: ${kbeautyData.products.length}');
      if (kbeautyData.treatments.isNotEmpty) {
        print('First treatment: ${kbeautyData.treatments.first.name}');
      }
      
      // Cache the data
      _memoryCache = kbeautyData;
      _cacheTime = DateTime.now();
      
      return kbeautyData;
    } catch (e, stackTrace) {
      print('Error loading K-beauty data: $e');
      print('Stack trace: $stackTrace');
      // Return empty data if file doesn't exist
      return const KBeautyData(
        skinTypes: [],
        categories: [],
        products: [],
        treatments: [],
      );
    }
  }

  /// Load mock products from JSON file
  static Future<List<Map<String, dynamic>>> _loadMockProducts() async {
    try {
      final kbeautyData = await _loadKBeautyData();
      return kbeautyData.products.map((product) {
        final productMap = product.toJson();
        // Override with correct image path
        productMap['images'] = _getProductImagePath(product.id);
        return productMap;
      }).toList();
    } catch (e) {
      print('Error loading mock products: $e');
      // Return empty list if file doesn't exist yet
      return [];
    }
  }

  /// Load mock categories from JSON file
  static Future<List<String>> _loadMockCategories() async {
    try {
      final kbeautyData = await _loadKBeautyData();
      return kbeautyData.categories;
    } catch (e) {
      print('Error loading mock categories: $e');
      // Return default categories if file doesn't exist yet
      return _getDefaultCategories();
    }
  }

  /// Load mock treatments from JSON file
  static Future<List<Map<String, dynamic>>> _loadMockTreatments() async {
    try {
      final kbeautyData = await _loadKBeautyData();
      return kbeautyData.treatments.map((treatment) => treatment.toJson()).toList();
    } catch (e) {
      print('Error loading mock treatments: $e');
      return [];
    }
  }

  /// Get default categories for initial setup
  static List<String> _getDefaultCategories() {
    return [
      'Cleanser',
      'Moisturizer',
      'Sunscreen',
      'Serum',
      'Toner',
      'Exfoliator',
      'Face Mask'
    ];
  }

  /// Get products by category from JSON mock data
  static Stream<List<Map<String, dynamic>>> getProductsByCategory(String categoryId) async* {
    final products = await _loadMockProducts();
    
    // Handle "All" category to show all products
    List<Map<String, dynamic>> filteredProducts;
    if (categoryId == 'All') {
      filteredProducts = products;
    } else {
      filteredProducts = products
          .where((product) => product['categories'] == categoryId)
          .toList();
    }
    
    // Sort by rating in descending order
    filteredProducts.sort((a, b) {
      final ratingA = (a['rating'] as num?) ?? 0;
      final ratingB = (b['rating'] as num?) ?? 0;
      return ratingB.compareTo(ratingA);
    });
    
    yield filteredProducts;
  }

  /// Get all categories
  static Stream<List<Map<String, dynamic>>> getCategories() async* {
    final categories = await _loadMockCategories();
    final categoryData = categories.map((category) => {
      'id': category.toLowerCase(),
      'key': category.toLowerCase(),
      'name': category,
      'hasChildren': false,
      'targetUrl': '/category/${category.toLowerCase()}',
      'thumbImage': 'https://via.placeholder.com/150x150/8B4513/FFFFFF?text=${Uri.encodeComponent(category)}',
      'selectedThumbImage': 'https://via.placeholder.com/150x150/A0522D/FFFFFF?text=${Uri.encodeComponent(category)}',
      'showInApp': true,
      'productCount': 0, // Could be calculated dynamically if needed
    }).toList();
    
    yield categoryData;
  }

  /// Search products
  static Stream<List<Map<String, dynamic>>> searchProducts(String query) async* {
    final products = await _loadMockProducts();
    final searchResults = products
        .where((product) {
          final name = (product['name'] ?? '').toString().toLowerCase();
          final description = (product['description'] ?? '').toString().toLowerCase();
          final searchQuery = query.toLowerCase();
          return name.contains(searchQuery) || description.contains(searchQuery);
        })
        .take(20)
        .toList();
    
    yield searchResults;
  }

  /// Get featured products (high rated)
  static Stream<List<Map<String, dynamic>>> getFeaturedProducts() async* {
    final products = await _loadMockProducts();
    final featuredProducts = products
        .where((product) {
          final rating = (product['rating'] as num?) ?? 0;
          return rating >= 4.5;
        })
        .take(10)
        .toList();
    
    // Sort by rating in descending order
    featuredProducts.sort((a, b) {
      final ratingA = (a['rating'] as num?) ?? 0;
      final ratingB = (b['rating'] as num?) ?? 0;
      return ratingB.compareTo(ratingA);
    });
    
    yield featuredProducts;
  }

  /// Get product by ID
  static Future<Map<String, dynamic>?> getProductById(String productId) async {
    final products = await _loadMockProducts();
    try {
      // Convert productId to int if needed
      final id = int.tryParse(productId) ?? productId;
      return products.firstWhere((product) => product['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Get the correct image path for a product ID
  static String _getProductImagePath(int productId) {
    // Map of product IDs to their actual file extensions
    const imageExtensions = {
      1: 'jpeg', 2: 'jpeg', 3: 'jpeg', 4: 'jpeg', 5: 'jpeg',
      6: 'png', 7: 'png', 8: 'jpeg', 9: 'jpeg', 10: 'jpeg',
      101: 'JPG', 102: 'JPG', 103: 'JPG', 104: 'JPG', 105: 'JPG', 106: 'JPG', 107: 'JPG',
      108: 'WEBP', 109: 'WEBP',
      201: 'JPG', 202: 'JPG', 203: 'WEBP', 204: 'JPG', 205: 'JPG', 206: 'JPG',
      301: 'AVIF', 302: 'JPG', 303: 'JPG', 304: 'JPG', 305: 'JPG', 306: 'JPG',
      401: 'JPG', 402: 'JPG', 403: 'JPG', 404: 'JPG', 405: 'JPG',
      501: 'jpeg', 502: 'jpeg', 503: 'JPG', 504: 'jpeg', 505: 'JPG', 506: 'jpeg',
      601: 'AVIF', 602: 'JPG', 603: 'JPG', 604: 'JPG', 605: 'JPG', 606: 'JPG',
      701: 'JPG', 702: 'JPG', 703: 'JPG', 704: 'JPG', 705: 'png', 706: 'WEBP',
    };
    
    final extension = imageExtensions[productId] ?? 'jpeg';
    return 'assets/images/Product-$productId.$extension';
  }

  /// Get detailed product information
  static Future<Map<String, dynamic>?> getProductDetails(String productId, String preferredSku) async {
    final product = await getProductById(productId);
    if (product != null) {
      final id = product['id'] as int;
      final imagePath = _getProductImagePath(id);
      
      // Return the product data as-is since it already contains detailed information
      return {
        ...product,
        'detailedDescription': product['description'],
        'ingredients': product['ingredient'] ?? [],
        'heroImage': imagePath,
        'altImage': imagePath,
        'images': imagePath, // Override with correct path
        'displayName': product['name'],
        'brandName': 'K-Beauty Pro', // Default brand name
        'reviews': '${(product['rating'] as num? ?? 4.0) * 20}', // Mock review count
        'targetUrl': '/product/${product['name']?.toString().toLowerCase().replaceAll(' ', '-')}',
        'currentSku': {
          'skuId': 'sku_${product['id']}',
          'listPrice': product['price']?.toString() ?? '0.00',
          'salePrice': null,
          'valuePrice': null,
          'imageAltText': product['name'] ?? 'Product Image',
          'isNew': false,
          'isOnlineOnly': false,
          'isSephoraExclusive': false,
          'isLimitedEdition': false,
        },
        'sponsored': false,
      };
    }
    return null;
  }

  /// Get all treatments
  static Stream<List<Map<String, dynamic>>> getTreatments() async* {
    final treatments = await _loadMockTreatments();
    yield treatments;
  }

  /// Get treatment by ID
  static Future<Map<String, dynamic>?> getTreatmentById(String treatmentId) async {
    final treatments = await _loadMockTreatments();
    try {
      final id = int.tryParse(treatmentId) ?? treatmentId;
      return treatments.firstWhere((treatment) => treatment['id'] == id);
    } catch (e) {
      return null;
    }
  }

  /// Get treatments by skin concern
  static Stream<List<Map<String, dynamic>>> getTreatmentsByConcern(String concern) async* {
    final treatments = await _loadMockTreatments();
    final filteredTreatments = treatments
        .where((treatment) => 
          treatment['skinConcern']?.toString().toLowerCase().contains(concern.toLowerCase()) == true ||
          treatment['bestFor']?.toString().toLowerCase().contains(concern.toLowerCase()) == true)
        .toList();
    
    yield filteredTreatments;
  }

  /// Get products for a specific treatment
  static Future<List<Map<String, dynamic>>> getProductsForTreatment(int treatmentId) async {
    final treatment = await getTreatmentById(treatmentId.toString());
    if (treatment == null) return [];

    final recommendedProductIds = (treatment['recommendedProducts'] as List<dynamic>?)?.cast<int>() ?? [];
    final products = await _loadMockProducts();
    
    return products
        .where((product) => recommendedProductIds.contains(product['id']))
        .toList();
  }

  // No caching needed for mock data

  /// Get sample product data structure for reference
  static Map<String, dynamic> getSampleProductStructure() {
    return {
      'id': 1,
      'name': 'Sample Product Name',
      'images': 'assets/images/product-1.jpeg',
      'description': 'A sample product description for testing purposes.',
      'price': 25.50,
      'rating': 4.5,
      'categories': 'Cleanser',
      'ingredient': ['Water', 'Glycerin', 'Niacinamide'],
      'skinType': 'Normal, Dry',
      'bestFor': 'Daily Use'
    };
  }

  /// Convert new format to legacy format for compatibility
  static Map<String, dynamic> convertToLegacyFormat(Map<String, dynamic> product) {
    return {
      'id': product['id']?.toString() ?? '',
      'productId': product['id']?.toString() ?? '',
      'name': product['name'] ?? '',
      'displayName': product['name'] ?? '',
      'brandName': 'K-Beauty Pro',
      'categoryId': product['categories']?.toString().toLowerCase() ?? '',
      'categoryName': product['categories'] ?? '',
      'heroImage': product['images'] ?? 'https://via.placeholder.com/300',
      'altImage': product['images'] ?? 'https://via.placeholder.com/300',
      'rating': product['rating']?.toString() ?? '0',
      'reviews': '${(product['rating'] as num? ?? 4.0) * 20}',
      'targetUrl': '/product/${product['name']?.toString().toLowerCase().replaceAll(' ', '-')}',
      'currentSku': {
        'skuId': 'sku_${product['id']}',
        'listPrice': product['price']?.toString() ?? '0.00',
        'salePrice': null,
        'valuePrice': null,
        'imageAltText': product['name'] ?? 'Product Image',
        'isNew': false,
        'isOnlineOnly': false,
        'isSephoraExclusive': false,
        'isLimitedEdition': false,
      },
      'sponsored': false,
      'description': product['description'] ?? '',
      'skinTypes': [product['skinType'] ?? 'All Skin Types'],
      'concerns': [product['bestFor'] ?? ''],
    };
  }
}