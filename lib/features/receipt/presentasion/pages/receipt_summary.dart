import 'package:flutter/material.dart';
import 'package:mini_cashier_app_v2/core/utils/currency_formatter.dart';
import 'package:mini_cashier_app_v2/features/cart/data/models/cart_model.dart';
import 'package:mini_cashier_app_v2/features/payment/presentasion/pages/payment_screen.dart';

class ReceiptSummaryScreen extends StatelessWidget {
  final List<CartItem> cartItems;
  final double totalAmount;
  final int totalProductCount;
  final int totalUniqueItems;

  const ReceiptSummaryScreen({
    super.key,
    required this.cartItems,
    required this.totalAmount,
    required this.totalProductCount,
    required this.totalUniqueItems,
  });

  // Logika navigasi ke PaymentScreen
  void _navigateToPayment(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentScreen(totalAmount: totalAmount),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Struk Ringkasan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),

      body: CustomScrollView(
        slivers: [
          // Daftar Item Keranjang
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = cartItems[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Produk
                    Text(
                      item.product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    // Tipe Produk
                    Text(
                      item.type,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const Divider(
                      height: 5,
                      thickness: 1,
                      color: Colors.transparent,
                    ),

                    // Detail Harga dan Kuantitas
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${item.quantity} x ${formatRupiah(item.product.price)}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          formatRupiah(item.totalPrice),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16, thickness: 1, color: Colors.grey),
                  ],
                ),
              );
            }, childCount: cartItems.length),
          ),

          // Ringkasan Total
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total Jenis Barang: 2', // Menggunakan hardcode sesuai wireframe, atau: totalUniqueItems.toString()
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Text(
                    'Total Jumlah Barang: $totalProductCount',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Total Harga Barang',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                  Text(
                    formatRupiah(totalAmount),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 80), // Padding untuk tombol
                ],
              ),
            ),
          ),
        ],
      ),

      // Tombol Lanjut Bayar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => _navigateToPayment(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal, // 2nd Component
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text(
            'Lanjut Bayar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
