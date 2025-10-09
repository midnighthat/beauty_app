import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_models.dart';

class SephoraApiService {
  static const String _baseUrl = 'https://sephora.p.rapidapi.com/us/products/v2/list';
  static const String _categoriesUrl = 'https://sephora.p.rapidapi.com/categories/v2/list-root';
  static const String _apiKey = '8b7b562f00msh2545b5cd0eb8e40p17a880jsn755f8249e12f';
  static const String _apiHost = 'sephora.p.rapidapi.com';

  static const Map<String, String> _headers = {
    'x-rapidapi-key': _apiKey,
    'x-rapidapi-host': _apiHost,
  };

  // Main categories we want for beauty app (from categories API)
  static const List<String> _targetCategories = [
    'cat150006',   // Skincare
    'cat140006',   // Makeup  
    'cat160006',   // Fragrance
    'cat130038',   // Hair
    'cat130042',   // Tools & Brushes
    'cat140014',   // Bath & Body
  ];

  /// Fetch all categories from Sephora
  static Future<CategoriesResponse> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse(_categoriesUrl),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return CategoriesResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Fetch products from a specific category
  static Future<SephoraResponse> fetchProducts({
    required String categoryId,
    int pageSize = 60,
    int currentPage = 1,
  }) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'pageSize': pageSize.toString(),
      'currentPage': currentPage.toString(),
      'categoryId': categoryId,
    });

    try {
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('📊 Raw API response structure: ${jsonData.keys}');
        
        // Log first product structure if available
        if (jsonData['products'] != null && jsonData['products'].isNotEmpty) {
          print('📝 First product structure: ${jsonData['products'][0].keys}');
          if (jsonData['products'][0]['currentSku'] != null) {
            print('📝 CurrentSku structure: ${jsonData['products'][0]['currentSku'].keys}');
          }
        }
        
        return SephoraResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Detailed API error: $e');
      throw Exception('Network error: $e');
    }
  }

  /// Fetch all categories and their products for the app (one-time setup)
  static Future<Map<String, dynamic>> fetchAllCategoriesAndProducts() async {
    Map<String, SephoraResponse> allProducts = {};
    List<Category> categories = [];

    try {
      // First, fetch all categories
      print('🏷️ Fetching categories...');
      final categoriesResponse = await fetchCategories();
      
      // Filter to only the categories we want
      categories = categoriesResponse.rootCategories
          .where((cat) => _targetCategories.contains(cat.categoryId))
          .toList();
      
      print('✅ Found ${categories.length} target categories');

      // Then fetch products for each category
      for (Category category in categories) {
        try {
          print('📦 Fetching products for ${category.displayName}...');
          final response = await fetchProducts(
            categoryId: category.categoryId,
            pageSize: 20, // Limit for free tier
          );
          allProducts[category.categoryId] = response;
          
          // Add delay to respect rate limits
          await Future.delayed(const Duration(milliseconds: 500));
        } catch (e) {
          print('❌ Error fetching ${category.displayName}: $e');
        }
      }

      return {
        'categories': categories,
        'products': allProducts,
      };
    } catch (e) {
      print('❌ Error fetching categories: $e');
      rethrow;
    }
  }

  /// Extract clean product data for Firebase
  static Map<String, dynamic> productToFirebaseJson(Product product) {
    return {
      'id': product.productId,
      'brand': product.brandName,
      'name': product.displayName,
      'image': product.heroImage,
      'rating': double.tryParse(product.rating) ?? 0.0,
      'reviewCount': int.tryParse(product.reviews) ?? 0,
      'price': _extractPrice(product.currentSku.listPrice),
      'salePrice': product.currentSku.salePrice != null 
          ? _extractPrice(product.currentSku.salePrice!) 
          : null,
      'isNew': product.currentSku.isNew,
      'isExclusive': product.currentSku.isSephoraExclusive,
      'isLimited': product.currentSku.isLimitedEdition,
      'targetUrl': product.targetUrl,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  static double _extractPrice(String priceString) {
    // Extract number from "$199.00" format
    final cleaned = priceString.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }
}