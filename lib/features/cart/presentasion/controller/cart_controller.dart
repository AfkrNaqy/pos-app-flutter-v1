import 'package:get/get.dart';
import 'package:mini_cashier_app_v2/features/cart/data/models/cart_model.dart';
import 'package:mini_cashier_app_v2/features/payment/data/datasources/payment_remote_data_source.dart';

import '../../../product/data/models/product_model.dart';

class CartController extends GetxController {
  final paymentRemote = PaymentRemoteDataSource();
  // State Reaktif Keranjang
  final RxList<CartModel> cartItems = <CartModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Getter Perhitungan Reaktif
  int get totalQuantity =>
      cartItems.fold(0, (total, item) => total + item.quantity);

  double get subtotalPrice =>
      cartItems.fold(0.0, (total, item) => total + item.totalPrice);

  // Pajak (contoh: 10%) & Diskon
  final RxDouble taxPercent = 0.0.obs;
  final RxDouble discountAmount = 0.0.obs;

  double get taxAmount => (subtotalPrice * taxPercent.value) / 100;
  double get grandTotalPrice =>
      (subtotalPrice + taxAmount - discountAmount.value).clamp(
        0.0,
        double.infinity,
      );

  bool get isCartEmpty => cartItems.isEmpty;

  @override
  void onInit() {
    super.onInit();
  }

  void addToCart(ProductModel product, {String type = 'Regular', int qty = 1}) {
    // Validasi stok produk
    if (product.quantity != null && product.quantity! < qty) {
      Get.snackbar(
        'Stok Habis',
        'Stok produk ${product.name} tidak mencukupi.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Cari apakah kombinasi produk + tipe sudah ada di keranjang
    final existingIndex = cartItems.indexWhere(
      (item) => item.product.id == product.id && item.type == type,
    );

    if (existingIndex != -1) {
      // Periksa batas stok sebelum menambah qty
      final newQty = cartItems[existingIndex].quantity + qty;
      if (product.quantity != null && newQty > product.quantity!) {
        Get.snackbar(
          'Batas Stok Tercapai',
          'Tidak dapat menambah lebih dari ${product.quantity} item.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      cartItems[existingIndex].quantity = newQty;
      cartItems.refresh(); // Picu update UI reaktif
    } else {
      // Tambah item baru
      final newCartItem = CartModel(
        id: '${product.id}_${type}_${DateTime.now().millisecondsSinceEpoch}',
        product: product,
        type: type,
        quantity: qty,
      );
      cartItems.add(newCartItem);
    }
  }

  /// Tambah 1 Jumlah Item
  void incrementQuantity(int index) {
    if (index >= 0 && index < cartItems.length) {
      final item = cartItems[index];
      if (item.product.quantity != null &&
          item.quantity + 1 > item.product.quantity!) {
        Get.snackbar(
          'Stok Maksimal',
          'Stok ${item.product.name} hanya tersedia${item.product.quantity}.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      item.quantity++;
      cartItems.refresh();
    }
  }

  /// Kurangi 1 Jumlah Item (Otomatis Hapus jika 0)
  void decrementQuantity(int index) {
    if (index >= 0 && index < cartItems.length) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        cartItems.refresh();
      } else {
        removeItem(index);
      }
    }
  }

  /// Hapus Item Spesifik dari Keranjang
  void removeItem(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
    }
  }

  /// Hapus Item Berdasarkan Cart ID
  void removeItemById(String cartId) {
    cartItems.removeWhere((item) => item.id == cartId);
  }

  /// Kosongkan Seluruh Keranjang
  void clearCart() {
    cartItems.clear();
    discountAmount.value = 0.0;
  }

  /// Set Diskon Nominal
  void setDiscount(double amount) {
    discountAmount.value = amount;
  }

  /// Set Pajak Persentase
  void setTax(double percent) {
    taxPercent.value = percent;
  }

  /// Eksekusi Checkout ke Firestore
  Future checkout({
    required double paymentAmount,
    required String cashierName,
    String? customerName,
    String? paymentMethod = 'Cash',
  }) async {
    if (isCartEmpty) {
      Get.snackbar('Keranjang Kosong', 'Tambahkan produk sebelum checkout.');
      return false;
    }

    if (paymentAmount < grandTotalPrice) {
      Get.snackbar(
        'Pembayaran Kurang',
        'Jumlah pembayaran kurang dari total tagihan.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    try {
      isLoading.value = true;

      // 1. Verifikasi ketersediaan stok terakhir di database
      final isStockAvailable = await paymentRemote.checkStockAvailability(
        cartItems,
      );
      if (!isStockAvailable) {
        Get.snackbar(
          'Stok Berubah',
          'Sebagian stok produk telah habis atau tidak mencukupi.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      // 2. Simpan order dan kurangi stok via Firestore Batch
      final changeAmount = paymentAmount - grandTotalPrice;
      final orderId = await paymentRemote.processCheckout(
        cartItems: cartItems.toList(),
        totalPrice: grandTotalPrice,
        paymentAmount: paymentAmount,
        changeAmount: changeAmount,
        cashierName: cashierName,
        customerName: customerName,
        paymentMethod: paymentMethod,
      );

      // 3. Reset keranjang setelah berhasil
      clearCart();

      Get.snackbar(
        'Transaksi Berhasil',
        'Pesanan #$orderId berhasil diproses.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Gagal Checkout',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
