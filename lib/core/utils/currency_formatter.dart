// Digunakan untuk memformat mata uang Rupiah
String formatRupiah(double amount) {
  // Pastikan jumlah adalah non-negatif
  if (amount < 0) {
    amount = 0;
  }
  
  // Konversi ke string tanpa desimal (misalnya 1234500)
  final String amountString = amount.toStringAsFixed(0);
  
  // Memisahkan ribuan dengan titik
  final String formatted = amountString.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
  return 'Rp $formatted';
}

// Mengkonversi input string Rupiah ke double
double parseRupiah(String formattedAmount) {
  // Hapus "Rp", spasi, dan titik
  final cleanString = formattedAmount.replaceAll(RegExp(r'[Rp.,\s]'), '');
  return double.tryParse(cleanString) ?? 0.0;
}