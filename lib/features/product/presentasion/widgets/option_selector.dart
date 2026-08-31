import 'package:flutter/material.dart';

// Widget untuk menampilkan opsi yang dapat dipilih (misalnya Ukuran, Jenis Roasting)
class OptionSelector extends StatelessWidget {
  final String title;
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String> onSelected;

  const OptionSelector({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: options.map((option) {
            final isSelected = option == selectedOption;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onSelected(option);
                }
              },
              selectedColor: Colors.teal[100],
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.teal[900] : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSelected ? Colors.teal : Colors.grey[300]!,
                  width: 1.5,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            );
          }).toList(),
        ),
      ],
    );
  }
}
