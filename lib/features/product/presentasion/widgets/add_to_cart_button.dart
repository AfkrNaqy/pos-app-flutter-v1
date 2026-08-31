import 'package:flutter/material.dart';

class AddToCartButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String productName;
  final String selectedSize;
  final String selectedRoast;

  const AddToCartButton({
    super.key,
    required this.onPressed,
    required this.productName,
    required this.selectedSize,
    required this.selectedRoast,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
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
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.add_shopping_cart, size: 24, color: Colors.white),
          label: const Text(
            'Tambah ke Keranjang',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}