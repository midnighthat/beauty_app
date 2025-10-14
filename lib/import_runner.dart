import 'package:flutter/material.dart';
import 'services/product_service.dart';

/// Standalone script to re-import products with updated schema
/// Run this once to update all Firebase products with skuId field
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🚀 Starting product re-import with updated schema...');
  print('📋 This will:');
  print('   - Fetch fresh data from Sephora API');
  print('   - Include skuId field for product details API');
  print('   - Overwrite existing Firebase products');
  print('');
  
  try {
    await ProductService.loadProductsToFirebase();
    print('');
    print('✅ Re-import completed successfully!');
    print('💾 All products now include skuId for product details API');
  } catch (e) {
    print('');
    print('❌ Re-import failed: $e');
  }
}