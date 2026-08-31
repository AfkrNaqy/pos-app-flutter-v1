import 'package:flutter/material.dart';
import 'package:mini_cashier_app_v2/core/utils/currency_formatter.dart';
import 'package:mini_cashier_app_v2/features/cart/data/models/cart_model.dart';

// Digunakan untuk memformat mata uang Rupiah


class CartProductCard extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback
  onRemoveItem; // Opsional: untuk menghapus item jika kuantitas = 0

  const CartProductCard({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Area Gambar Produk (Area Biru/Image Guide)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(item.product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                    // color: Colors.blueAccent.withOpacity(
                    //   0.7,
                    // ), // Meniru warna biru
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SizedBox(),
                  // child: const Icon(
                  //   Icons.shopping_bag_outlined,
                  //   color: Colors.white,
                  //   size: 30,
                  // ),
                ),
                const SizedBox(width: 12),

                // Detail Produk
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        item.type,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatRupiah(item.product.price),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal[700],
                        ),
                      ),
                    ],
                  ),
                ),

                // Tombol Plus/Minus (Area Merah/Icon Guide)
                Row(
                  children: [
                    // Tombol Minus
                    IconButton(
                      icon: Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent[700],
                      ), // Merah untuk Icon
                      onPressed: () {
                        if (item.quantity > 1) {
                          onQuantityChanged(item.quantity - 1);
                        } else {
                          // Jika kuantitas 0, panggil fungsi hapus
                          onRemoveItem();
                        }
                      },
                    ),

                    // Jumlah
                    SizedBox(
                      width: 24,
                      child: Text(
                        item.quantity.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    // Tombol Plus
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: Colors.redAccent[700],
                      ), // Merah untuk Icon
                      onPressed: () {
                        onQuantityChanged(item.quantity + 1);
                      },
                    ),
                  ],
                ),
              ],
            ),

            const Divider(height: 20, thickness: 1),

            // Total Harga Per Item
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Item:',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                Text(
                  formatRupiah(item.totalPrice),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
