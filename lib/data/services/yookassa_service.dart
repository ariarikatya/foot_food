import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:foot_food/core/security/encryption_service.dart';

/// Сервис для работы с ЮКасса
/// Документация: https://yookassa.ru/developers/api
class YookassaService {
  // TODO: Получите эти данные в личном кабинете ЮКассы
  static const String _shopId = 'YOUR_SHOP_ID'; // Замените на реальный
  static const String _secretKey = 'YOUR_SECRET_KEY'; // Замените на реальный
  static const String _baseUrl = 'https://api.yookassa.ru/v3';

  /// Создание платежа
  static Future<Map<String, dynamic>> createPayment({
    required double amount,
    required String description,
    String? returnUrl,
    bool capture = true,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/payments');
      
      // Генерируем уникальный ключ идемпотентности
      final idempotenceKey = _generateIdempotenceKey();
      
      final body = {
        'amount': {
          'value': amount.toStringAsFixed(2),
          'currency': 'RUB',
        },
        'capture': capture,
        'confirmation': {
          'type': 'redirect',
          'return_url': returnUrl ?? 'footfood://payment/success',
        },
        'description': description,
        if (metadata != null) 'metadata': metadata,
      };

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Basic ${_getAuthorizationHeader()}',
          'Idempotence-Key': idempotenceKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Ошибка создания платежа: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка создания платежа: $e');
    }
  }

  /// Создание платежа с сохраненным токеном
  static Future<Map<String, dynamic>> createPaymentWithToken({
    required String paymentMethodId,
    required double amount,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/payments');
      final idempotenceKey = _generateIdempotenceKey();
      
      final body = {
        'amount': {
          'value': amount.toStringAsFixed(2),
          'currency': 'RUB',
        },
        'capture': true,
        'payment_method_id': paymentMethodId,
        'description': description,
        if (metadata != null) 'metadata': metadata,
      };

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Basic ${_getAuthorizationHeader()}',
          'Idempotence-Key': idempotenceKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Ошибка оплаты: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка оплаты: $e');
    }
  }

  /// Проверка статуса платежа
  static Future<Map<String, dynamic>> getPaymentStatus(String paymentId) async {
    try {
      final url = Uri.parse('$_baseUrl/payments/$paymentId');
      
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Basic ${_getAuthorizationHeader()}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Ошибка получения статуса: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка получения статуса: $e');
    }
  }

  /// Сохранение токена платежного метода после успешной оплаты
  static Future<void> savePaymentMethod(Map<String, dynamic> paymentData) async {
    try {
      final paymentMethod = paymentData['payment_method'];
      if (paymentMethod == null) return;

      final card = paymentMethod['card'];
      if (card == null) return;

      await EncryptionService.savePaymentMethodToken(
        paymentMethodId: paymentMethod['id'],
        last4: card['last4'] ?? '',
        cardType: card['card_type'] ?? 'Unknown',
        expiryMonth: card['expiry_month'] ?? '',
        expiryYear: card['expiry_year'] ?? '',
      );
    } catch (e) {
      // Игнорируем ошибки сохранения токена
      print('Ошибка сохранения токена: $e');
    }
  }

  /// Получение списка сохраненных платежных методов
  static Future<List<Map<String, dynamic>>> getSavedPaymentMethods() async {
    return await EncryptionService.getPaymentMethods();
  }

  /// Удаление сохраненного платежного метода
  static Future<void> deletePaymentMethod(String paymentMethodId) async {
    await EncryptionService.deletePaymentMethod(paymentMethodId);
  }

  /// Генерация заголовка авторизации
  static String _getAuthorizationHeader() {
    const credentials = '$_shopId:$_secretKey';
    final bytes = utf8.encode(credentials);
    return base64.encode(bytes);
  }

  /// Генерация ключа идемпотентности
  static String _generateIdempotenceKey() {
    return '${DateTime.now().millisecondsSinceEpoch}-${_generateRandomString(8)}';
  }

  static String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(length, (index) => chars[(DateTime.now().millisecondsSinceEpoch + index) % chars.length]).join();
  }

  /// Форматирование суммы для отображения
  static String formatAmount(double amount) {
    return '${amount.toStringAsFixed(2)} ₽';
  }

  /// Получение иконки карты по типу
  static String getCardIcon(String cardType) {
    switch (cardType.toLowerCase()) {
      case 'visa':
        return '💳 Visa';
      case 'mastercard':
        return '💳 MasterCard';
      case 'mir':
        return '💳 МИР';
      default:
        return '💳 Карта';
    }
  }
}