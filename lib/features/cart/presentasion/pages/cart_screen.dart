import 'package:flutter/material.dart';
import 'package:mini_cashier_app_v2/core/utils/currency_formatter.dart';
import 'package:mini_cashier_app_v2/features/cart/data/models/cart_model.dart';
import 'package:mini_cashier_app_v2/features/cart/presentasion/widgets/cart_product_card.dart';
import 'package:mini_cashier_app_v2/features/receipt/presentasion/pages/receipt_summary.dart';

// Digunakan untuk memformat mata uang Rupiah


class CartScreen extends StatefulWidget {
  // PERUBAHAN: Menerima daftar item keranjang saat inisialisasi
  final List<CartItem> initialCartItems;

  const CartScreen({super.key, required this.initialCartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // PERUBAHAN: Menggunakan item yang diterima dari widget sebagai state awal
  late List<CartItem> _cartItems;

  @override
  void initState() {
    super.initState();
    // PERUBAHAN: Menyalin item awal ke state
    _cartItems = List<CartItem>.from(
      widget.initialCartItems.map(
        (item) => CartItem(
          id: item.id,
          product: item.product,
          type: item.type,
          quantity: item.quantity,
        ),
      ),
    );
  }

  // Getter untuk menghitung total harga seluruh keranjang
  double get _totalCartPrice {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Getter untuk menghitung total jumlah produk
  int get _totalProductCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // Getter untuk menghitung total jenis produk unik
  int get _totalUniqueItems {
    return _cartItems.length;
  }

  // Fungsi untuk memperbarui kuantitas item
  void _updateQuantity(String itemId, int newQuantity) {
    setState(() {
      final index = _cartItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _cartItems[index].quantity = newQuantity;
      }
    });
  }

  // Fungsi untuk menghapus item
  void _removeItem(String itemId) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == itemId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk dihapus dari keranjang.')),
      );
    });
  }

  // Fungsi untuk navigasi ke halaman summary/payment
  void _goToPayment() async {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keranjang kosong! Tambahkan produk terlebih dahulu.'),
        ),
      );
      return;
    }

    // PERUBAHAN: Navigasi ke Halaman Ringkasan Struk
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptSummaryScreen(
          cartItems: _cartItems,
          totalAmount: _totalCartPrice,
          totalProductCount: _totalProductCount,
          totalUniqueItems: _totalUniqueItems,
        ),
      ),
    );
    // Setelah kembali dari ReceiptScreen, pastikan CartScreen kembali ke HomePage dengan data terbaru
    Navigator.pop(context, _cartItems);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // PERUBAHAN: Menggunakan PopScope untuk mengembalikan data keranjang saat tombol kembali ditekan
      canPop: true,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pop(context, _cartItems);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50], // Basic Component
        appBar: AppBar(
          title: const Text(
            'Keranjang Belanja',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          // PERUBAHAN: Tombol kembali akan memicu pengembalian data keranjang
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, _cartItems),
          ),
        ),

        body: _cartItems.isEmpty
            ? const Center(
                child: Text(
                  'Keranjang Anda Kosong.',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(
                  bottom: 100,
                ), // Padding untuk tombol Payment
                itemCount: _cartItems.length,
                itemBuilder: (context, index) {
                  final item = _cartItems[index];
                  return CartProductCard(
                    item: item,
                    onQuantityChanged: (newQuantity) {
                      _updateQuantity(item.id, newQuantity);
                    },
                    onRemoveItem: () {
                      _removeItem(item.id);
                    },
                  );
                },
              ),

        // Tombol Payment di bagian bawah (2nd Component/Abu-abu Gelap)
        bottomSheet: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _goToPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.teal, // Mengganti dengan aksen Teal yang kuat
              minimumSize: const Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$_totalProductCount Produk',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  formatRupiah(_totalCartPrice),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
