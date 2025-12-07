import 'package:flutter/services.dart';

/// Форматтер для телефонного номера в формате +7 (XXX) XX-XX-XX
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Оставляем только цифры
    final digitsOnly = text.replaceAll(RegExp(r'\D'), '');

    // Если пусто, возвращаем +7 (
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '+7 (',
        selection: TextSelection.collapsed(offset: 4),
      );
    }

    // Формируем строку
    final buffer = StringBuffer('+7 (');

    // Первые 3 цифры
    if (digitsOnly.length >= 1) {
      buffer.write(digitsOnly.substring(0, digitsOnly.length.clamp(0, 3)));
    }

    // Закрываем скобку после первых 3 цифр
    if (digitsOnly.length >= 3) {
      buffer.write(') ');

      // Следующие 2 цифры
      if (digitsOnly.length >= 4) {
        buffer.write(digitsOnly.substring(3, digitsOnly.length.clamp(3, 5)));
      }

      // Первый дефис
      if (digitsOnly.length >= 5) {
        buffer.write('-');

        // Следующие 2 цифры
        if (digitsOnly.length >= 6) {
          buffer.write(digitsOnly.substring(5, digitsOnly.length.clamp(5, 7)));
        }

        // Второй дефис
        if (digitsOnly.length >= 7) {
          buffer.write('-');

          // Последние 2 цифры
          if (digitsOnly.length >= 8) {
            buffer.write(
              digitsOnly.substring(7, digitsOnly.length.clamp(7, 9)),
            );
          }
        }
      }
    }

    final formattedText = buffer.toString();

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
