import 'package:mini_cashier_app_v2/features/product/data/models/product_model.dart';

final List<Product> mockProducts = [
  Product(
    id: 'p001',
    name: 'Espresso Blend',
    price: 25000.00,
    category: 'Coffee',
    imageUrl: 'https://picsum.photos/id/1084/600/400',
    isSpecial: true,
    description:
        'Biji kopi premium yang dipanggang sempurna untuk hasil espresso yang kaya dan beraroma kuat.',
    rating: 4.7,
    sizes: ['Small', 'Medium', 'Large'],
    roastLevels: ['Light', 'Medium', 'Dark'],
  ),
  Product(
    id: 'p002',
    name: 'Chicken Sandwich',
    price: 32000.00,
    category: 'Food',
    isSpecial: false,
    description:
        'Sandwich klasik dengan potongan ayam panggang, selada segar, tomat, dan saus spesial.',
    rating: 4.5,
    imageUrl: 'https://picsum.photos/id/104/600/400',
    sizes: ['Regular', 'Jumbo'],
    roastLevels: [], // Tidak ada tingkat pemanggangan untuk makanan
  ),
  Product(
    id: 'p003',
    name: 'Croissant Almond',
    price: 18000,
    category: 'Pastry',
    isSpecial: true,
    description:
        'Kue kering mentega berlapis renyah, diisi dengan krim almond manis dan taburan almond.',
    rating: 4.8,
    imageUrl: 'https://picsum.photos/id/191/600/400',
    sizes: ['Standard'],
    roastLevels: [],
  ),
  Product(
    id: 'p004',
    name: 'Mineral Water',
    price: 5000,
    category: 'Drinks',
    isSpecial: false,
    description: 'Air mineral murni yang menyegarkan.',
    rating: 4.9,
    imageUrl: 'https://picsum.photos/id/21/600/400',
    sizes: ['330ml', '600ml'],
    roastLevels: [],
  ),
  Product(
    id: 'p005',
    name: 'Cheese Cake Slice',
    price: 45000,
    category: 'Dessert',
    isSpecial: true,
    description:
        'Potongan kue keju klasik yang lembut dan creamy di atas lapisan remah biskuit.',
    rating: 4.6,
    imageUrl: 'https://picsum.photos/id/225/600/400',
    sizes: ['Slice'],
    roastLevels: [],
  ),
];
