import 'package:flutter/material.dart';
import 'package:mini_cashier_app_v2/core/data_dummy/list_product.dart';
import 'package:mini_cashier_app_v2/features/cart/data/models/cart_model.dart';
import 'package:mini_cashier_app_v2/features/cart/presentasion/pages/cart_screen.dart';
import 'package:mini_cashier_app_v2/features/home/presentasion/widgets/barcode_scanner_widget.dart';
import 'package:mini_cashier_app_v2/features/home/presentasion/widgets/cart_summary.dart';
import 'package:mini_cashier_app_v2/features/home/presentasion/widgets/custom_header.dart';
import 'package:mini_cashier_app_v2/features/home/presentasion/widgets/product_card.dart';
import 'package:mini_cashier_app_v2/features/product/data/models/product_model.dart';
import 'package:mini_cashier_app_v2/features/product/presentasion/pages/product_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';
  String _selectedCategory = 'All'; // State baru untuk kategori yang dipilih

  // --- Logic Placeholder Cart ---
  // Placeholder data keranjang untuk ditampilkan di CartSummary
  List<CartItem> _cartItems = [];

  // PERUBAHAN: Getter Total Keranjang (Live)
  double get _liveCartTotal {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // PERUBAHAN: Getter Jumlah Produk (Live)
  int get _liveProductCount {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  // PERUBAHAN: Fungsi untuk menambahkan/memperbarui item ke keranjang
  void _addItemToCart(Product product) {
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.id == product.id,
    );

    setState(() {
      if (existingItemIndex != -1) {
        // Jika produk sudah ada, tingkatkan kuantitas
        _cartItems[existingItemIndex].quantity++;
      } else {
        // Jika produk belum ada, tambahkan item baru
        _cartItems.add(
          CartItem(
            id: product.id!,
            product: product,
            type: product
                .category, // Menggunakan kategori sebagai tipe/varian sederhana
            quantity: 1,
          ),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${product.name} ditambahkan! Total Produk: $_liveProductCount',
          ),
        ),
      );
    });
  }

  // final double _mockCartTotal = 43000.0;
  // final int _mockProductCount = 2;
  // --- End Logic Placeholder Cart ---

  // Fungsi untuk mensimulasikan pemfilteran 'live search' dan kategori
  List<Product> get filteredProducts {
    // 1. Filter berdasarkan kategori
    List<Product> categoryFiltered = mockProducts;
    if (_selectedCategory != 'All') {
      categoryFiltered = mockProducts.where((product) {
        return product.category == _selectedCategory;
      }).toList();
    }

    // 2. Filter berdasarkan query pencarian
    if (_searchQuery.isEmpty) {
      return categoryFiltered;
    }

    final query = _searchQuery.toLowerCase();
    return categoryFiltered.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
    }).toList();
  }

  // Aksi Logout
  void _handleLogout() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Logout Pressed!')));
  }

  // BARIS BERUBAH: Handler hasil scan untuk menambah produk
  void _handleScanResult(String code) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Barcode Terdeteksi: $code. Mencari produk...')),
    );
    // Logika sederhana: Cari produk berdasarkan ID yang sama dengan code
    final product = mockProducts.firstWhere(
      (p) => p.id == code,
      orElse: () {
        // Jika tidak ditemukan, tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Produk dengan ID $code tidak ditemukan.')),
        );
        print('Barcode barang $code');
        return mockProducts.first; // Return default/dummy product
      },
    );

    // Tambahkan produk yang ditemukan ke keranjang (hanya jika ID ditemukan)
    if (product.id == code) {
      _addItemToCart(product);
    }
  }

  // BARIS BERUBAH: Aksi Pindai Barcode: Navigasi ke Scanner
  void _handleBarcodeScan() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarcodeScannerWidget(
          onBarcodeScanned: _handleScanResult,
        ), // Meneruskan handler
      ),
    );
  }

  // Aksi Pindai Barcode
  // void _handleBarcodeScan() {
  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(const SnackBar(content: Text('Barcode Scan Initiated!')));
  // }

  // Aksi Konfirmasi Pencarian (Non-live)
  void _handleSearchConfirmed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Confirmed Search for: $_searchQuery')),
    );
  }

  // Aksi Pemilihan Produk
  void _handleProductTap(Product product) {
    // Navigasi ke halaman detail produk
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetail(productData: product),
      ),
    );
  }

  // Aksi pemilihan kategori baru
  void _handleCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  // Navigasi ke Cart Screen
  void _navigateToCart() async {
    // PERUBAHAN: Menunggu hasil dari CartScreen
    final updatedCart = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CartScreen(initialCartItems: _cartItems), // Mengirim data keranjang
      ),
    );

    // PERUBAHAN: Memperbarui state keranjang setelah kembali dari CartScreen
    if (updatedCart != null && updatedCart is List<CartItem>) {
      setState(() {
        _cartItems = updatedCart;
      });
    }
  }

  // Cart Summary bar (Kini menjadi tombol)
  Widget _buildCartSummary(BuildContext context) {
    // PERUBAHAN: Meneruskan data keranjang yang live
    return CartSummary(
      totalAmount: _liveCartTotal,
      totalProducts: _liveProductCount,
      onTap: _navigateToCart, // Meneruskan fungsi navigasi
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Custom Header/App Bar
                CustomHeader(
                  searchQuery: _searchQuery,
                  onSearchChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  onSearchConfirmed: _handleSearchConfirmed,
                  onBarcodeScan: _handleBarcodeScan,
                  onLogout: _handleLogout,
                  // Meneruskan state dan callback kategori
                  selectedCategory: _selectedCategory,
                  onCategorySelected: _handleCategorySelected,
                ),

                // Product Grid Display Area
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: 80,
                    ), // Padding bawah untuk Ringkasan Keranjang
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () => _handleProductTap(product),
                        onAddToCart: () => _addItemToCart(product),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Cart Summary Button Overlay
            // Cart Summary Button Overlay
            if (_liveProductCount >
                0) // PERUBAHAN: Hanya tampilkan jika ada produk di keranjang
              _buildCartSummary(context),
          ],
        ),
      ),
    );
  }
}
