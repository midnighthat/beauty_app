import 'package:cloud_firestore/cloud_firestore.dart';
import 'sephora_api_service.dart';

class ProductService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  static const String _productsCollection = 'products';
  static const String _productDetailsCollection = 'product_details';
  static const String _categoriesCollection = 'categories';
  static const String _metadataCollection = 'metadata';

  /// ONE-TIME: Load categories and products from Sephora API to Firebase
  /// Call this once during development to populate your database
  /// Updated to include skuId field for product details API
  static Future<void> loadProductsToFirebase() async {
    try {
      print('🚀 Starting product import from Sephora API...');
      
      // Fetch all categories and products from API
      final allData = await SephoraApiService.fetchAllCategoriesAndProducts();
      final categories = allData['categories'] as List<dynamic>;
      final allProducts = allData['products'] as Map<String, dynamic>;
      
      print('📊 Processing ${categories.length} categories...');
      
      // Store categories first
      for (var category in categories) {
        final categoryData = {
          'id': category.categoryId,
          'name': category.displayName,
          'hasChildren': category.hasChildCategories,
          'targetUrl': category.targetUrl,
          'thumbImage': category.thumbImage,
          'selectedThumbImage': category.selectedThumbImage,
          'showInApp': category.showInAppJaBsDropdown,
          'lastUpdated': DateTime.now().toIso8601String(),
        };
        
        await _firestore
            .collection(_categoriesCollection)
            .doc(category.categoryId)
            .set(categoryData);
        
        print('✅ Saved category: ${category.displayName}');
      }
      
      // Store products by category
      for (String categoryId in allProducts.keys) {
        final categoryData = allProducts[categoryId];
        final categoryName = categories
            .firstWhere((cat) => cat.categoryId == categoryId)
            .displayName;
        
        print('📦 Importing ${categoryData.products.length} products for $categoryName');
        
        // Create batch for efficient writes
        WriteBatch batch = _firestore.batch();
        int batchCount = 0;
        
        for (var product in categoryData.products) {
          final productJson = SephoraApiService.productToFirebaseJson(product);
          productJson['categoryId'] = categoryId;
          productJson['categoryName'] = categoryName;
          
          final docRef = _firestore
              .collection(_productsCollection)
              .doc(product.productId);
          
          batch.set(docRef, productJson);
          batchCount++;
          
          // Commit batch every 500 writes (Firestore limit)
          if (batchCount >= 500) {
            await batch.commit();
            batch = _firestore.batch();
            batchCount = 0;
          }
        }
        
        // Commit remaining writes
        if (batchCount > 0) {
          await batch.commit();
        }
        
        // Update category with product count
        await _firestore
            .collection(_categoriesCollection)
            .doc(categoryId)
            .update({
          'productCount': categoryData.products.length,
        });
      }
      
      // Store import metadata
      await _firestore.collection(_metadataCollection).doc('import_info').set({
        'lastImport': DateTime.now().toIso8601String(),
        'totalCategories': categories.length,
        'totalProducts': allProducts.values.fold<int>(0, (total, cat) => total + (cat.products.length as int)),
        'importedBy': 'sephora_api_v2',
      });
      
      print('✅ Import completed successfully!');
      print('📊 Final stats:');
      print('   - Categories: ${categories.length}');
      print('   - Total products: ${allProducts.values.fold<int>(0, (total, cat) => total + (cat.products.length as int))}');
      
    } catch (e) {
      print('❌ Import failed: $e');
      rethrow;
    }
  }

  /// Get products by category from Firebase
  static Stream<List<Map<String, dynamic>>> getProductsByCategory(String categoryId) {
    return _firestore
        .collection(_productsCollection)
        .where('categoryId', isEqualTo: categoryId)
        .limit(50)
        .snapshots()
        .map((snapshot) {
          final docs = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id; // Include document ID
            return data;
          }).toList();
          
          // Sort by rating in memory (temporary solution)
          docs.sort((a, b) {
            final ratingA = (a['rating'] as num?) ?? 0;
            final ratingB = (b['rating'] as num?) ?? 0;
            return ratingB.compareTo(ratingA); // Descending order
          });
          
          return docs;
        });
  }

  /// Get all categories
  static Stream<List<Map<String, dynamic>>> getCategories() {
    return _firestore
        .collection(_categoriesCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['key'] = doc.id; // Include document ID as key
              return data;
            }).toList());
  }

  /// Search products
  static Stream<List<Map<String, dynamic>>> searchProducts(String query) {
    return _firestore
        .collection(_productsCollection)
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .limit(20)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  /// Get featured products (high rated + exclusive)
  static Stream<List<Map<String, dynamic>>> getFeaturedProducts() {
    return _firestore
        .collection(_productsCollection)
        .where('rating', isGreaterThan: 4.0)
        .orderBy('rating', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  /// Get product by ID
  static Future<Map<String, dynamic>?> getProductById(String productId) async {
    final doc = await _firestore
        .collection(_productsCollection)
        .doc(productId)
        .get();
    
    if (doc.exists) {
      final data = doc.data()!;
      data['id'] = doc.id;
      return data;
    }
    return null;
  }

  /// Get detailed product information (Firebase first, API fallback)
  static Future<Map<String, dynamic>?> getProductDetails(String productId, String preferredSku) async {
    try {
      // First try to get from Firebase cache
      final cachedDetails = await _getCachedProductDetails(productId);
      if (cachedDetails != null) {
        print('✅ Using cached product details for $productId');
        return cachedDetails;
      }

      // If not cached, fetch from API
      print('🔍 Fetching fresh product details from API for $productId');
      final apiDetails = await SephoraApiService.fetchProductDetails(productId, preferredSku);
      
      if (apiDetails != null) {
        // Cache the result for future use
        await _cacheProductDetails(productId, preferredSku, apiDetails);
        return apiDetails;
      }
      
      return null;
    } catch (e) {
      print('❌ Failed to fetch product details: $e');
      return null;
    }
  }

  /// Get cached product details from Firebase
  static Future<Map<String, dynamic>?> _getCachedProductDetails(String productId) async {
    try {
      final doc = await _firestore
          .collection(_productDetailsCollection)
          .doc(productId)
          .get();
      
      if (doc.exists) {
        final data = doc.data()!;
        // Check if cache is not too old (e.g., 7 days)
        final cachedAt = DateTime.parse(data['cachedAt']);
        final isStale = DateTime.now().difference(cachedAt).inDays > 7;
        
        if (!isStale) {
          return data['details'] as Map<String, dynamic>;
        } else {
          print('⚠️ Cached data is stale for $productId, will fetch fresh data');
        }
      }
      return null;
    } catch (e) {
      print('❌ Error reading cached product details: $e');
      return null;
    }
  }

  /// Cache product details in Firebase
  static Future<void> _cacheProductDetails(String productId, String skuId, Map<String, dynamic> details) async {
    try {
      await _firestore.collection(_productDetailsCollection).doc(productId).set({
        'productId': productId,
        'skuId': skuId,
        'details': details,
        'cachedAt': DateTime.now().toIso8601String(),
        'lastUpdated': DateTime.now().toIso8601String(),
      });
      print('✅ Cached product details for $productId');
    } catch (e) {
      print('❌ Failed to cache product details: $e');
      // Don't throw error - caching failure shouldn't break the app
    }
  }

  /// ONE-TIME: Bulk import product details for all products
  static Future<void> loadProductDetailsToFirebase() async {
    try {
      print('🚀 Starting bulk product details import...');
      
      // Get all products from Firebase
      final productsSnapshot = await _firestore.collection(_productsCollection).get();
      final products = productsSnapshot.docs;
      
      print('📊 Found ${products.length} products to process');
      
      int processed = 0;
      int cached = 0;
      int errors = 0;
      
      for (final productDoc in products) {
        try {
          final productData = productDoc.data();
          final productId = productData['id'];
          final skuId = productData['skuId'];
          
          if (productId != null && skuId != null) {
            // Check if already cached
            final existingCache = await _getCachedProductDetails(productId);
            if (existingCache != null) {
              print('⏭️ Skipping $productId (already cached)');
              processed++;
              continue;
            }
            
            print('🔍 Fetching details for $productId...');
            final details = await SephoraApiService.fetchProductDetails(productId, skuId);
            
            if (details != null) {
              await _cacheProductDetails(productId, skuId, details);
              cached++;
              print('✅ Cached details for $productId');
            } else {
              print('⚠️ No details found for $productId');
            }
            
            // Rate limiting - wait between requests
            await Future.delayed(const Duration(milliseconds: 1000));
          }
          
          processed++;
          if (processed % 10 == 0) {
            print('📈 Progress: $processed/${products.length} processed, $cached cached, $errors errors');
          }
          
        } catch (e) {
          errors++;
          print('❌ Error processing product ${productDoc.id}: $e');
          // Continue with next product
        }
      }
      
      // Update metadata
      await _firestore.collection(_metadataCollection).doc('product_details_import').set({
        'lastImport': DateTime.now().toIso8601String(),
        'totalProcessed': processed,
        'totalCached': cached,
        'totalErrors': errors,
        'importedBy': 'bulk_import_v1',
      });
      
      print('✅ Bulk import completed!');
      print('📊 Final stats:');
      print('   - Processed: $processed');
      print('   - Cached: $cached');
      print('   - Errors: $errors');
      
    } catch (e) {
      print('❌ Bulk import failed: $e');
      rethrow;
    }
  }
}