import '../services/product_service.dart';

/// One-time script to import products from Sephora API to Firebase
/// 
/// Usage:
/// 1. Run this once during development
/// 2. Comment out or remove after import
/// 3. Your app will then read from Firebase only!
class ProductImporter {
  
  static Future<void> runImport() async {
    print('🚀 Starting Sephora product import...');
    print('📱 This will use your RapidAPI free tier calls');
    print('💾 Products will be saved to Firebase for free access');
    
    try {
      await ProductService.loadProductsToFirebase();
      print('✅ Import completed! Your app now has real product data.');
      print('🎉 You can now comment out this import and use Firebase only!');
    } catch (e) {
      print('❌ Import failed: $e');
    }
  }
}