import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchConfirmed;
  final VoidCallback onBarcodeScan;
  final VoidCallback onLogout;
  final ValueChanged<String> onCategorySelected; // Callback baru
  final String selectedCategory; // State kategori yang aktif

  const CustomHeader({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onSearchConfirmed,
    required this.onBarcodeScan,
    required this.onLogout,
    required this.onCategorySelected, // Diperlukan
    required this.selectedCategory, // Diperlukan
  });

  // Placeholder untuk Kategori/Tab Filter
  Widget _buildFilterTabs() {
    final categories = [
      'All',
      'Coffee',
      'Food',
      'Pastry',
      'Beverages',
      'Dessert',
    ];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected =
              category == selectedCategory; // Cek kategori yang aktif
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () =>
                  onCategorySelected(category), // Panggil callback saat ditekan
              borderRadius: BorderRadius.circular(20),
              child: Chip(
                label: Text(category),
                backgroundColor: isSelected
                    ? Colors.teal[100]
                    : Colors.grey[200],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.teal[800] : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide.none,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Pengguna & Keluar (Logout)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.teal,
                    child: Text(
                      'AF',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Afkar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Cashier',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Logout'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.teal,
                  side: const BorderSide(color: Colors.teal, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bilah Pencarian & Tindakan
          Row(
            children: [
              // Bilah Pencarian (Live Search)
              Expanded(
                child: TextField(
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search product by name or category...',
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: onSearchConfirmed,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Tombol Pindai Barcode
              InkWell(
                onTap: onBarcodeScan,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 48, // Menyamai tinggi TextField
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.qr_code_scanner, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tab Filter
          _buildFilterTabs(),
        ],
      ),
    );
  }
}
