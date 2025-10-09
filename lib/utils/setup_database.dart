import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/product_service.dart';

class DatabaseSetup {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Check if database has products and import if needed
  static Future<void> ensureProductsExist() async {
    try {
      print('🔍 Checking if products exist in database...');
      
      // Check if any products exist
      final productsSnapshot = await _firestore
          .collection('products')
          .limit(1)
          .get();
      
      if (productsSnapshot.docs.isEmpty) {
        print('📦 No products found. Starting import...');
        await ProductService.loadProductsToFirebase();
        print('✅ Products imported successfully!');
      } else {
        print('✅ Products already exist in database');
        
        // Show count of products
        final totalProductsSnapshot = await _firestore
            .collection('products')
            .count()
            .get();
        
        print('📊 Total products in database: ${totalProductsSnapshot.count}');
      }
      
    } catch (e) {
      print('❌ Error checking/importing products: $e');
      rethrow;
    }
  }
  
  /// Quick test to fetch some products
  static Future<void> testProductFetch() async {
    try {
      print('🧪 Testing product fetch...');
      
      // Test fetching skincare products
      final productsSnapshot = await _firestore
          .collection('products')
          .where('categoryId', isEqualTo: 'cat150006')
          .limit(5)
          .get();
      
      if (productsSnapshot.docs.isNotEmpty) {
        print('✅ Successfully fetched ${productsSnapshot.docs.length} skincare products');
        for (var doc in productsSnapshot.docs) {
          final data = doc.data();
          print('   - ${data['name'] ?? 'Unknown'} (${data['brand'] ?? 'No brand'})');
        }
      } else {
        print('❌ No skincare products found');
      }
      
    } catch (e) {
      print('❌ Error testing product fetch: $e');
    }
  }
}