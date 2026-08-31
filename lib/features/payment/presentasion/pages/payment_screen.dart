import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_cashier_app_v2/core/utils/currency_formatter.dart';

import 'payment_keypad.dart';

// Halaman tiruan Struk (Receipt)
class ReceiptScreen extends StatelessWidget {
  final double totalAmount;
  final double paidAmount;

  const ReceiptScreen({
    super.key,
    required this.totalAmount,
    required this.paidAmount,
  });

  @override
  Widget build(BuildContext context) {
    final double change = paidAmount - totalAmount;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Struk Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.teal,
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Pembayaran Berhasil!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Detail Struk
                _buildReceiptRow('Total Dibayar:', totalAmount),
                _buildReceiptRow('Jumlah Dibayarkan:', paidAmount),
                const Divider(height: 30, thickness: 2),
                _buildReceiptRow('Kembalian:', change, isChange: true),

                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Kembali ke home atau memulai transaksi baru
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Selesai',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(
    String label,
    double amount, {
    bool isChange = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: isChange ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            formatRupiah(amount),
            style: TextStyle(
              fontSize: 18,
              fontWeight: isChange ? FontWeight.w900 : FontWeight.w600,
              color: isChange ? Colors.teal : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  // Menerima total yang harus dibayar dari layar sebelumnya
  final double totalAmount;

  const PaymentScreen({super.key, required this.totalAmount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Menggunakan TextEditingController untuk menampilkan input yang diformat
  final TextEditingController _paidAmountController = TextEditingController();

  // State untuk melacak jumlah yang dimasukkan (dalam bentuk numerik murni)
  double _paidAmount = 0.0;

  // State untuk melacak error
  String? _inputError;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller, biasanya kosong, tetapi bisa diatur ke nilai default.
    _paidAmountController.text = formatRupiah(_paidAmount);
  }

  @override
  void dispose() {
    _paidAmountController.dispose();
    super.dispose();
  }

  // Logika validasi dan navigasi
  void _processPayment() {
    setState(() {
      _inputError = null;
      if (_paidAmount >= widget.totalAmount) {
        // Navigasi ke halaman struk (ReceiptScreen)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReceiptScreen(
              totalAmount: widget.totalAmount,
              paidAmount: _paidAmount,
            ),
          ),
        );
      } else {
        // Menampilkan alert pada text field
        _inputError = 'Jumlah dibayarkan tidak mencukupi.';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_inputError!)));
      }
    });
  }

  // Handler untuk input dari keypad kustom
  void _handleKeypadInput(String key) {
    String currentText = _paidAmountController.text;
    String cleanText = currentText.replaceAll(RegExp(r'[Rp.,\s]'), '');

    if (key == 'backspace') {
      if (cleanText.isNotEmpty) {
        cleanText = cleanText.substring(0, cleanText.length - 1);
      }
    } else {
      // Batasi panjang input numerik (misalnya, maks 9 digit)
      if (cleanText.length < 9) {
        cleanText += key;
      }
    }

    // Konversi string bersih kembali ke double
    final newAmount = double.tryParse(cleanText) ?? 0.0;

    setState(() {
      _paidAmount = newAmount;
      // Update controller dengan teks yang diformat
      _paidAmountController.text = formatRupiah(_paidAmount);
      // Pindahkan kursor ke akhir
      _paidAmountController.selection = TextSelection.fromPosition(
        TextPosition(offset: _paidAmountController.text.length),
      );

      // Hapus error jika jumlahnya sudah mencukupi saat mengetik
      if (_paidAmount >= widget.totalAmount) {
        _inputError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double change = _paidAmount - widget.totalAmount;
    final bool isPaymentSufficient = _paidAmount >= widget.totalAmount;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Harga Barang
            const Text(
              'Total Harga Barang',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ), // Basic Component
            ),
            const SizedBox(height: 4),
            Text(
              formatRupiah(widget.totalAmount),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.teal,
              ), // 2nd Component
            ),
            const Divider(height: 30),

            // Jumlah yang Dibayarkan
            const Text(
              'Jumlah yang Dibayarkan',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _paidAmountController,
              readOnly: true, // Nonaktifkan keyboard standar
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: formatRupiah(0.0),
                fillColor: Colors.grey[200], // Basic Component
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                // Alert pada Text Field
                errorText: _inputError,
              ),
            ),
            const SizedBox(height: 16),

            // Kembalian
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Kembalian:',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                Text(
                  formatRupiah(change),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: isPaymentSufficient
                        ? Colors.green[700]
                        : Colors.red, // Warna dinamis
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Keypad Kustom (Mengganti keyboard standar)
            PaymentKeypad(onKeyPress: _handleKeypadInput),
          ],
        ),
      ),

      // Tombol Bayar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: isPaymentSufficient
              ? _processPayment
              : null, // Tombol hanya aktif jika pembayaran mencukupi
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal, // 2nd Component
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            // Warna dinamis saat tombol dinonaktifkan
            disabledBackgroundColor: Colors.grey[300],
            disabledForegroundColor: Colors.grey[600],
          ),
          child: const Text(
            'Bayar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// File main.dart sederhana untuk menjalankan halaman pembayaran
void main() {
  runApp(const PaymentApp());
}

class PaymentApp extends StatelessWidget {
  const PaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Screen',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      // Contoh Total Pembayaran Rp 85.000
      home: const PaymentScreen(totalAmount: 85000.0),
    );
  }
}
