import 'package:cloud_firestore/cloud_firestore.dart';
import 'sephora_api_service.dart';

class ProductService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  static const String _productsCollection = 'products';
  static const String _categoriesCollection = 'categories';
  static const String _metadataCollection = 'metadata';

  /// ONE-TIME: Load categories and products from Sephora API to Firebase
  /// Call this once during development to populate your database
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
}