import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreTest {
  static Future<void> testConnection() async {
    try {
      print('🧪 Testing Firestore connection...');
      
      // Try to write a test document
      await FirebaseFirestore.instance
          .collection('test')
          .doc('connection_test')
          .set({
        'message': 'Firestore is working!',
        'timestamp': DateTime.now().toIso8601String(),
        'test': true,
      });
      
      print('✅ Firestore write test successful!');
      
      // Try to read the document back
      final doc = await FirebaseFirestore.instance
          .collection('test')
          .doc('connection_test')
          .get();
      
      if (doc.exists) {
        print('✅ Firestore read test successful!');
        print('📄 Data: ${doc.data()}');
        
        // Clean up test document
        await doc.reference.delete();
        print('🧹 Test document cleaned up');
        
        return;
      } else {
        throw Exception('Document was not found after writing');
      }
    } catch (e) {
      print('❌ Firestore test failed: $e');
      print('💡 Make sure you:');
      print('   1. Created Firestore database in Firebase Console');
      print('   2. Set security rules to allow read/write');
      print('   3. Have internet connection');
      rethrow;
    }
  }
}