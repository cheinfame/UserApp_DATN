import 'package:flutter/services.dart';

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final numericalOnly = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    final spaced = numericalOnly.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ');

    // Remove leading zeros
    final trimmed = spaced.replaceAll(RegExp(r'^0+'), '');

    return newValue.copyWith(
      text: trimmed,
      selection: TextSelection.collapsed(offset: trimmed.length),
    );
  }
}
