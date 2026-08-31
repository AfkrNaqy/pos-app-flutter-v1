import 'package:flutter/material.dart';
import 'package:mini_cashier_app_v2/core/utils/currency_formatter.dart';
import 'package:mini_cashier_app_v2/features/product/data/models/product_model.dart';
// Asumsikan ini mengarah ke model Product yang memiliki imageUrl

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // Menggunakan warna Teal sebagai aksen, dan White/Grey sebagai Basic/2nd Component
    return Stack(
      fit: StackFit.expand,
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(product.imageUrl),
                  colorFilter: ColorFilter.mode(
                    Colors.black,
                    BlendMode.colorDodge,
                  ),
                  opacity: 0.65,
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Product Category (Basic Component/Abu-abu Muda)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      product.category,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.teal[400],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Product Name (2nd Component/Abu-abu Gelap - sebagai fokus utama teks)
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Product Price (2nd Component/Abu-abu Gelap)
                  Text(
                    formatRupiah(product.price),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: onAddToCart,
            style: ButtonStyle(
              iconColor: WidgetStatePropertyAll(Colors.tealAccent),
              overlayColor: WidgetStatePropertyAll(Colors.white24),
            ),
            icon: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
