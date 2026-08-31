import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class ProductRemoteDataSource{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> getProducts() async {
    try {
      final snap = await _firestore.collection('products').get();
      return snap.docs
          .map((doc) => Product.fromJson(doc.id, doc.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future addProduct(Product product) {
    try {
      return _firestore.collection('products').add(product.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future updateProduct(Product product) {
    try {
      return _firestore
          .collection('products')
          .doc(product.id)
          .update(product.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future deleteProduct(String productId) {
    try {
      return _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      rethrow;
    }
  }
}