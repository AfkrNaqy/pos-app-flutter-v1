// --- Model Data Produk ---
class ProductModel {
  String? id;
  final String category;
  final String categoryId;
  final String name;
  final double price;
  final String imageUrl;
  final String? qrCode;
  final int? quantity;

  ProductModel({
    this.id,
    required this.category,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.qrCode,
    this.quantity,
  });

  ProductModel copyWith({
    String? id,
    String? category,
    String? categoryId,
    String? name,
    double? price,
    String? imageUrl,
    String? qrCode,
    int? quantity,
  }) {
    return ProductModel(
      id: id ?? this.id,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      qrCode: qrCode ?? this.qrCode,
      quantity: quantity ?? this.quantity,
    );
  }

  factory ProductModel.fromJson(String id, Map<String, dynamic> json) =>
      ProductModel(
        id: id,
        category: json['category'],
        categoryId: json['category_id'],
        name: json['name'],
        price: (json['price'] as num).toDouble(),
        imageUrl: json['imageUrl'],
        qrCode: json['qrCode'],
        quantity: json['quantity'],
      );

  Map<String, dynamic> toJson() => {
    'category': category,
    'category_id': categoryId,
    'name': name,
    'price': price,
    'imageUrl': imageUrl,
    'qrCode': qrCode,
    'quantity': quantity,
  };
}

// --- Data Tiruan (Mock Data) ---
