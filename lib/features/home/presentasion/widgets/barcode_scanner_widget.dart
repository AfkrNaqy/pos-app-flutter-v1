import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class BarcodeScannerWidget extends StatefulWidget {
  final ValueChanged<String> onBarcodeScanned;

  const BarcodeScannerWidget({super.key, required this.onBarcodeScanned});

  @override
  State<BarcodeScannerWidget> createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
  // Controller untuk mengontrol status pemindai (misalnya, menghentikan pemrosesan)
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _permissionGranted = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  // Fungsi untuk memeriksa izin kamera
  void _checkPermissions() async {
    var status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        _permissionGranted = true;
      });
    } else {
      // Tampilkan pesan jika izin ditolak
      setState(() {
        _permissionGranted = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Izin kamera ditolak. Tidak dapat memindai barcode.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_permissionGranted) {
      return Center(
        child: ElevatedButton(
          onPressed: _checkPermissions,
          child: const Text('Aktifkan Kamera'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pindai Barcode Produk',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          // Tombol Flash
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, state, child) {
                switch (state.torchState) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                  default:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => controller.toggleTorch(),
          ),
          // Tombol Ganti Kamera
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, state, child) {
                switch (state.cameraDirection) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                  default:
                    return const Icon(Icons.error);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => controller.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: controller,
        // Area pemindai yang dapat disesuaikan (optional)
        overlayBuilder: (context, constraints) => Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white54, width: 2),
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.all(50),
        ),

        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty && !_isProcessing) {
            // Mengambil data pertama yang terdeteksi
            final String code = barcodes.first.rawValue ?? "Unknown Code";

            // Menghentikan pemrosesan berulang
            setState(() {
              _isProcessing = true;
            });

            // Beri tahu widget induk dan keluar dari layar pemindai
            widget.onBarcodeScanned(code);
            Navigator.pop(context);

            // Opsional: Atur ulang _isProcessing setelah beberapa saat
            // Future.delayed(const Duration(seconds: 1), () => _isProcessing = false);
          }
        },
      ),
    );
  }
}
