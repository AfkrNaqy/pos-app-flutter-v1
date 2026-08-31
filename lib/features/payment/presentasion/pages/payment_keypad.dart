import 'package:flutter/material.dart';

class PaymentKeypad extends StatelessWidget {
  final ValueChanged<String> onKeyPress;

  const PaymentKeypad({
    super.key,
    required this.onKeyPress,
  });

  Widget _buildKey(String text, {IconData? icon, Color color = Colors.black87}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: InkWell(
          onTap: () => onKeyPress(text),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[200], // Basic Component
              borderRadius: BorderRadius.circular(12),
            ),
            height: 60,
            child: icon != null
                ? Icon(icon, size: 28, color: color)
                : Text(
                    text,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: color),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _buildKey('1'),
            _buildKey('2'),
            _buildKey('3'),
          ],
        ),
        Row(
          children: [
            _buildKey('4'),
            _buildKey('5'),
            _buildKey('6'),
          ],
        ),
        Row(
          children: [
            _buildKey('7'),
            _buildKey('8'),
            _buildKey('9'),
          ],
        ),
        Row(
          children: [
            _buildKey('00', color: Colors.black54), // Shortcut 00
            _buildKey('0'),
            _buildKey('backspace', icon: Icons.backspace_outlined), // Hapus
          ],
        ),
      ],
    );
  }
}