import 'package:flutter/services.dart';

// TextInputFormatter to capitalize the first letter of the input
class FirstLetterCapitalFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    String capitalized =
        newValue.text[0].toUpperCase() + newValue.text.substring(1);

    return newValue.copyWith(
      text: capitalized,
      selection: TextSelection.collapsed(offset: capitalized.length),
    );
  }
}

final FirstLetterCapitalFormatter firstLetterCapitalFormatter =
    FirstLetterCapitalFormatter();
