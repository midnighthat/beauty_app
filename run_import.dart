import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'lib/services/product_service.dart';

/// Script to re-import products with updated schema including skuId
void main() async {
  print('🚀 Starting product re-import with updated schema...');
  
  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");
    print('✅ Environment variables loaded');
    
    // Initialize Firebase
    await Firebase.initializeApp();
    print('✅ Firebase initialized');
    
    print('');
    print('📋 This will:');
    print('   - Fetch fresh data from Sephora API');
    print('   - Include skuId field for product details API');
    print('   - Overwrite existing Firebase products');
    print('');
    
    // Run the import
    await ProductService.loadProductsToFirebase();
    
    print('');
    print('🎉 Re-import completed successfully!');
    print('💾 All products now include skuId for product details API');
    print('🔧 Product detail pages should now work correctly');
    
  } catch (e) {
    print('');
    print('❌ Re-import failed: $e');
    print('🔍 Please check your API key in .env file');
  }
}