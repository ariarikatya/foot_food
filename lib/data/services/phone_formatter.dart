import 'package:flutter/services.dart';

/// Форматтер для телефонного номера в формате +7 (XXX) XX-XX-XX
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Если пользователь удаляет всё
    if (text.isEmpty || text == '+' || text == '+7' || text == '+7 ') {
      return const TextEditingValue(
        text: '+7 (',
        selection: TextSelection.collapsed(offset: 4),
      );
    }

    // Если текст не начинается с +7 (, исправляем
    if (!text.startsWith('+7 (')) {
      return const TextEditingValue(
        text: '+7 (',
        selection: TextSelection.collapsed(offset: 4),
      );
    }

    // Извлекаем только цифры после +7 (
    String digitsOnly = '';
    for (int i = 4; i < text.length; i++) {
      if (text[i].contains(RegExp(r'[0-9]'))) {
        digitsOnly += text[i];
      }
    }

    // Ограничиваем до 10 цифр
    if (digitsOnly.length > 10) {
      digitsOnly = digitsOnly.substring(0, 10);
    }

    // Формируем отформатированную строку
    final buffer = StringBuffer('+7 (');

    // Первые 3 цифры
    if (digitsOnly.isNotEmpty) {
      int end = digitsOnly.length > 3 ? 3 : digitsOnly.length;
      buffer.write(digitsOnly.substring(0, end));
      if (end < 3) {
        buffer.write(' ' * (3 - end));
      }
    } else {
      buffer.write('   ');
    }

    buffer.write(') ');

    // Следующие 3 цифры
    if (digitsOnly.length > 3) {
      int end = digitsOnly.length > 6 ? 6 : digitsOnly.length;
      buffer.write(digitsOnly.substring(3, end));
      if (end - 3 < 3) {
        buffer.write(' ' * (3 - (end - 3)));
      }
    } else {
      buffer.write('   ');
    }

    buffer.write('-');

    // Следующие 2 цифры
    if (digitsOnly.length > 6) {
      int end = digitsOnly.length > 8 ? 8 : digitsOnly.length;
      buffer.write(digitsOnly.substring(6, end));
      if (end - 6 < 2) {
        buffer.write(' ' * (2 - (end - 6)));
      }
    } else {
      buffer.write('  ');
    }

    buffer.write('-');

    // Последние 2 цифры
    if (digitsOnly.length > 8) {
      int end = digitsOnly.length > 10 ? 10 : digitsOnly.length;
      buffer.write(digitsOnly.substring(8, end));
      if (end - 8 < 2) {
        buffer.write(' ' * (2 - (end - 8)));
      }
    } else {
      buffer.write('  ');
    }

    final formattedText = buffer.toString();

    // Позиция курсора после последней введенной цифры
    int cursorPosition = 4; // По умолчанию после +7 (

    if (digitsOnly.isNotEmpty) {
      if (digitsOnly.length <= 3) {
        cursorPosition = 4 + digitsOnly.length;
      } else if (digitsOnly.length <= 6) {
        cursorPosition = 9 + (digitsOnly.length - 3);
      } else if (digitsOnly.length <= 8) {
        cursorPosition = 13 + (digitsOnly.length - 6);
      } else {
        cursorPosition = 16 + (digitsOnly.length - 8);
      }
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
