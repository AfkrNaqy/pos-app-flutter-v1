import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../cart/data/models/cart_model.dart';
import '../../../product/data/models/product_model.dart';

class PaymentRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Nama koleksi
  final String _productsCollection = 'products';
  final String _ordersCollection = 'orders';

  /// Mengambil daftar produk secara real-time melalui Stream
  Stream<List> getProductsStream() {
    return _firestore.collection(_productsCollection).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromJson(doc.id, doc.data());
      }).toList();
    });
  }

  /// Proses Checkout / Simpan Transaksi POS
  /// Menggunakan WriteBatch untuk memastikan transaksi order tersimpan
  /// dan stok produk berkurang secara atomik (bersamaan).
  Future processCheckout({
    required List<CartModel> cartItems,
    required double totalPrice,
    required double paymentAmount,
    required double changeAmount,
    required String cashierName,
    String? customerName,
    String? paymentMethod,
  }) async {
    try {
      final batch = _firestore.batch();

      // 1. Buat Dokumen Order Baru
      final orderDocRef = _firestore.collection(_ordersCollection).doc();

      final orderData = {
        'order_id': orderDocRef.id,
        'cashier_name': cashierName,
        'customer_name': customerName ?? 'Walk-in Customer',
        'payment_method': paymentMethod ?? 'Cash',
        'total_price': totalPrice,
        'payment_amount': paymentAmount,
        'change_amount': changeAmount,
        'total_items': cartItems.fold<int>(
          0,
          (sum, item) => sum + item.quantity,
        ),
        'created_at': FieldValue.serverTimestamp(),
        'items': cartItems.map((item) {
          return {
            'product_id': item.product.id,
            'product_name': item.product.name,
            'category': item.product.category,
            'category_id': item.product.categoryId,
            'type': item.type,
            'price': item.product.price,
            'quantity': item.quantity,
            'subtotal': item.totalPrice,
            'image_url': item.product.imageUrl,
          };
        }).toList(),
      };

      batch.set(orderDocRef, orderData);

      // 2. Kurangi Stok Produk di Koleksi Products
      for (final item in cartItems) {
        if (item.product.id != null && item.product.id!.isNotEmpty) {
          final productDocRef = _firestore
              .collection(_productsCollection)
              .doc(item.product.id);

          // Gunakan FieldValue.increment dengan nilai negatif untuk mengurangi stok
          batch.update(productDocRef, {
            'quantity': FieldValue.increment(-item.quantity),
          });
        }
      }

      // 3. Eksekusi Batch
      await batch.commit();

      return orderDocRef.id;
    } catch (e) {
      throw Exception('Gagal memproses transaksi: $e');
    }
  }

  /// Memverifikasi ketersediaan stok sebelum pembayaran
  Future checkStockAvailability(List cartItems) async {
    for (final item in cartItems) {
      if (item.product.id != null) {
        final doc = await _firestore
            .collection(_productsCollection)
            .doc(item.product.id)
            .get();

        if (doc.exists) {
          final currentStock = (doc.data()?['quantity'] as num?)?.toInt() ?? 0;
          if (currentStock < item.quantity) {
            return false; // Stok tidak mencukupi
          }
        }
      }
    }
    return true;
  }
}
