import 'package:flutter/material.dart';
import 'package:mini_cashier_app_v2/core/utils/currency_formatter.dart';
import 'package:mini_cashier_app_v2/features/product/data/models/product_model.dart';
import 'package:mini_cashier_app_v2/features/product/presentasion/widgets/add_to_cart_button.dart';
import 'package:mini_cashier_app_v2/features/product/presentasion/widgets/option_selector.dart';

class ProductDetail extends StatefulWidget {
  final Product productData;
  const ProductDetail({super.key, required this.productData});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  // Gunakan data tiruan

  String _selectedSize = 'Medium';
  String _selectedRoast = 'Dark';
  bool _isFavorite = false;

  void _addToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.productData.name} (${_selectedSize}, ${_selectedRoast}) ditambahkan ke keranjang!',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tinggi Area Gambar (Area Biru)
    const double imageHeight = 350.0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              CustomScrollView(
                slivers: <Widget>[
                  // 1. Product Image Section (Area Biru) & Interactive Elements (Area Merah)
                  SliverAppBar(
                    expandedHeight: imageHeight,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Gambar Produk
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0),
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                onError: (exception, stackTrace) =>
                                    const Center(
                                      child: Text(
                                        'Gagal memuat gambar',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    ),
                                image: NetworkImage(
                                  widget.productData.imageUrl,
                                ),
                              ),
                            ),
                            child: Text(''),
                          ),
                          // Overlay gradient ringan untuk teks agar terlihat jelas
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(30.0),
                                bottomRight: Radius.circular(30.0),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.5],
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 4,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: Colors.black26,
                                    size: 15,
                                  ),
                                  Icon(
                                    Icons.circle,
                                    color: Colors.black26,
                                    size: 15,
                                  ),
                                  Icon(
                                    Icons.circle,
                                    color: Colors.black26,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Contoh: Tombol kembali
                      },
                    ),
                    actions: [
                      // Icon Favorit/Wishlist (Area Merah - Interaktif)
                      IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.redAccent, // Warna Icon Merah
                        ),
                        onPressed: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _isFavorite
                                    ? 'Ditambahkan ke Favorit'
                                    : 'Dihapus dari Favorit',
                              ),
                            ),
                          );
                        },
                      ),
                      // Icon Share (Area Merah - Interaktif)
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Share produk')),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  // 3. Product Information (Detail Produk)
                  SliverList(
                    delegate: SliverChildListDelegate([
                      // Container Detail Utama dengan Bentuk Melengkung di Atas
                      Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            // topLeft: Radius.circular(30.0),
                            // topRight: Radius.circular(30.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nama Produk & Harga
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.productData.name,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Text(
                                  formatRupiah(widget.productData.price),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Rating
                            // Row(
                            //   children: [
                            //     const Icon(
                            //       Icons.star_rounded,
                            //       color: Colors.amber,
                            //       size: 20,
                            //     ),
                            //     const SizedBox(width: 4),
                            //     Text(
                            //       '${widget.productData.rating} (124 reviews)',
                            //       style: const TextStyle(
                            //         fontSize: 14,
                            //         color: Colors.black54,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(height: 16),
                            // Deskripsi Produk
                            const Text(
                              'Deskripsi:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Text(
                            //   widget.productData.description,
                            //   style: const TextStyle(
                            //     fontSize: 14,
                            //     height: 1.5,
                            //     color: Colors.black87,
                            //   ),
                            //   textAlign: TextAlign.justify,
                            // ),
                            const Divider(height: 30),

                            // Opsi Ukuran (Menggunakan Widget Terpisah)
                            // OptionSelector(
                            //   title: 'Ukuran',
                            //   options: widget.productData.sizes,
                            //   selectedOption: _selectedSize,
                            //   onSelected: (newSize) {
                            //     setState(() {
                            //       _selectedSize = newSize;
                            //     });
                            //   },
                            // ),
                            // const SizedBox(height: 20),

                            // // Opsi Jenis Roasting (Menggunakan Widget Terpisah)
                            // OptionSelector(
                            //   title: 'Jenis Roasting',
                            //   options: widget.productData.roastLevels,
                            //   selectedOption: _selectedRoast,
                            //   onSelected: (newRoast) {
                            //     setState(() {
                            //       _selectedRoast = newRoast;
                            //     });
                            //   },
                            // ),
                            // const SizedBox(
                            //   height: 80,
                            // ), // Padding untuk tombol di bagian bawah
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Container(
              //     height: MediaQuery.of(context).size.height * 0.65,
              //     padding: const EdgeInsets.only(
              //       bottom: 24.0,
              //       left: 24,
              //       right: 24,
              //       top: 10,
              //     ),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: const BorderRadius.only(
              //         topLeft: Radius.circular(30.0),
              //         topRight: Radius.circular(30.0),
              //       ),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black.withOpacity(0.1),
              //           blurRadius: 10,
              //           offset: const Offset(0, -5),
              //         ),
              //       ],
              //     ),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             SizedBox(
              //               width: 100,
              //               child: Divider(
              //                 thickness: 5,
              //                 radius: BorderRadius.circular(3),
              //               ),
              //             ),
              //           ],
              //         ),
              //         SizedBox(height: 10),
              //         // Nama Produk & Harga
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Expanded(
              //               child: Text(
              //                 widget.productData.name,
              //                 style: const TextStyle(
              //                   fontSize: 28,
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.black87,
              //                 ),
              //               ),
              //             ),
              //             Text(
              //               widget.productData.price,
              //               style: const TextStyle(
              //                 fontSize: 24,
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.teal,
              //               ),
              //             ),
              //           ],
              //         ),
              //         const SizedBox(height: 8),
              //         // Rating
              //         Row(
              //           children: [
              //             const Icon(
              //               Icons.star_rounded,
              //               color: Colors.amber,
              //               size: 20,
              //             ),
              //             const SizedBox(width: 4),
              //             Text(
              //               '${widget.productData.rating} (124 reviews)',
              //               style: const TextStyle(
              //                 fontSize: 14,
              //                 color: Colors.black54,
              //               ),
              //             ),
              //           ],
              //         ),
              //         const SizedBox(height: 16),
              //         // Deskripsi Produk
              //         const Text(
              //           'Deskripsi:',
              //           style: TextStyle(
              //             fontSize: 16,
              //             fontWeight: FontWeight.bold,
              //             color: Colors.black87,
              //           ),
              //         ),
              //         const SizedBox(height: 4),
              //         Text(
              //           widget.productData.description,
              //           style: const TextStyle(
              //             fontSize: 14,
              //             height: 1.5,
              //             color: Colors.black87,
              //           ),
              //           textAlign: TextAlign.justify,
              //         ),
              //         const Divider(height: 30),

              //         // Opsi Ukuran (Menggunakan Widget Terpisah)
              //         OptionSelector(
              //           title: 'Ukuran',
              //           options: widget.productData.sizes,
              //           selectedOption: _selectedSize,
              //           onSelected: (newSize) {
              //             setState(() {
              //               _selectedSize = newSize;
              //             });
              //           },
              //         ),
              //         const SizedBox(height: 20),

              //         // Opsi Jenis Roasting (Menggunakan Widget Terpisah)
              //         OptionSelector(
              //           title: 'Jenis Roasting',
              //           options: widget.productData.roastLevels,
              //           selectedOption: _selectedRoast,
              //           onSelected: (newRoast) {
              //             setState(() {
              //               _selectedRoast = newRoast;
              //             });
              //           },
              //         ),
              //         const SizedBox(
              //           height: 80,
              //         ), // Padding untuk tombol di bagian bawah
              //       ],
              //     ),
              //   ),
              // ),

              // Tombol Tambah ke Keranjang Mengambang (Menggunakan Widget Terpisah)
              AddToCartButton(
                onPressed: _addToCart,
                productName: widget.productData.name,
                selectedSize: _selectedSize,
                selectedRoast: _selectedRoast,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
