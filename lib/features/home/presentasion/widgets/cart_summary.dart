import 'package:flutter/material.dart';
import 'package:mini_cashier_app_v2/core/utils/currency_formatter.dart';

class CartSummary extends StatelessWidget {
  final double totalAmount;
  final int totalProducts;
  final VoidCallback onTap;

  const CartSummary({
    super.key,
    required this.totalAmount,
    required this.totalProducts,
    required this.onTap,
  });

  // Digunakan untuk memformat mata uang Rupiah (Diulang dari file lain agar widget ini independen)
  

  @override
  Widget build(BuildContext context) {
    // Tombol Ringkasan Keranjang (Overlay)
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
        child: InkWell(
          onTap: onTap, // Aksi navigasi dari HomePage
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.teal[700],
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$totalProducts Product',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Total : ${formatRupiah(totalAmount)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
