import 'package:mini_cashier_app_v2/features/product/data/models/product_model.dart';

class CartModel {
  final String id;
  final ProductModel product;
  final String type; // Contoh: Ukuran atau Varian
  int quantity;

  CartModel({
    required this.id,
    required this.product,
    required this.type,
    this.quantity = 1,
  });

  // Getter untuk menghitung total harga per item
  double get totalPrice => product.price * quantity;
}

// Data tiruan untuk Cart Screen
// final List<CartItem> mockCartItems = [
//   CartItem(
//     id: 'p001',
//     product: Product(
//       id: 'p001',
//       name: 'Espresso Blend',
//       categoryId: '1',
//       price: 25000.00,
//       category: 'Coffee',
//       imageUrl: 'https://picsum.photos/id/1084/600/400',
//     ),
//     type: 'Medium Roast, Large',
//     quantity: 2,
//   ),
//   CartItem(
//     id: 'p002',
//     product: Product(
//       id: 'p001',
//       categoryId: '1',
//       name: 'Espresso Blend',
//       price: 25000.00,
//       category: 'Coffee',
//       imageUrl: 'https://picsum.photos/id/1084/600/400',
//     ),
//     type: 'Regular',
//     quantity: 1,
//   ),
//   CartItem(
//     id: 'p003',
//     product: Product(
//       id: 'p001',
//       name: 'Espresso Blend',
//       categoryId: '1',
//       price: 25000.00,
//       category: 'Coffee',
//       imageUrl: 'https://picsum.photos/id/1084/600/400',
//     ),
//     type: 'Standard',
//     quantity: 3,
//   ),
// ];
