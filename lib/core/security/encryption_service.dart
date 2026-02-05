import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

/// Сервис шифрования для Foot Food
/// Использует нативные средства iOS Keychain и Android Keystore
class EncryptionService {
  static final _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // ============= ТОКЕНЫ И СЕССИИ =============

  /// Сохранение токена авторизации (30 дней)
  static Future<void> saveAuthToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
    await _saveTokenExpiry('auth_token_expiry', 30);
  }

  /// Получение токена авторизации
  static Future<String?> getAuthToken() async {
    if (await _isTokenExpired('auth_token_expiry')) {
      await deleteAuthToken();
      return null;
    }
    return await _storage.read(key: 'auth_token');
  }

  /// Удаление токена
  static Future<void> deleteAuthToken() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'auth_token_expiry');
  }

  /// Сохранение refresh токена (90 дней)
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
    await _saveTokenExpiry('refresh_token_expiry', 90);
  }

  /// Получение refresh токена
  static Future<String?> getRefreshToken() async {
    if (await _isTokenExpired('refresh_token_expiry')) {
      await deleteRefreshToken();
      return null;
    }
    return await _storage.read(key: 'refresh_token');
  }

  /// Удаление refresh токена
  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'refresh_token_expiry');
  }

  /// Сохранение session ID (30 дней)
  static Future<void> saveSessionId(String sessionId) async {
    await _storage.write(key: 'session_id', value: sessionId);
    await _saveTokenExpiry('session_expiry', 30);
  }

  /// Получение session ID
  static Future<String?> getSessionId() async {
    if (await _isTokenExpired('session_expiry')) {
      await deleteSessionId();
      return null;
    }
    return await _storage.read(key: 'session_id');
  }

  /// Удаление session ID
  static Future<void> deleteSessionId() async {
    await _storage.delete(key: 'session_id');
    await _storage.delete(key: 'session_expiry');
  }

  // ============= ПЛАТЕЖНЫЕ ТОКЕНЫ =============

  /// Сохранение токена платежного метода ЮКассы
  static Future<void> savePaymentMethodToken({
    required String paymentMethodId,
    required String last4,
    required String cardType,
    required String expiryMonth,
    required String expiryYear,
  }) async {
    final data = jsonEncode({
      'payment_method_id': paymentMethodId,
      'last4': last4,
      'card_type': cardType,
      'expiry_month': expiryMonth,
      'expiry_year': expiryYear,
      'saved_at': DateTime.now().toIso8601String(),
    });

    await _storage.write(key: 'payment_method_$paymentMethodId', value: data);
  }

  /// Получение всех платежных методов
  static Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    final allKeys = await _storage.readAll();
    final paymentMethods = <Map<String, dynamic>>[];

    for (var entry in allKeys.entries) {
      if (entry.key.startsWith('payment_method_')) {
        try {
          final data = jsonDecode(entry.value);
          
          // Проверяем срок действия карты
          final expiryMonth = int.parse(data['expiry_month']);
          final expiryYear = int.parse(data['expiry_year']);
          final now = DateTime.now();
          final expiryDate = DateTime(2000 + expiryYear, expiryMonth + 1, 0);

          if (expiryDate.isAfter(now)) {
            paymentMethods.add(data);
          } else {
            // Удаляем истекшие карты
            await _storage.delete(key: entry.key);
          }
        } catch (e) {
          // Игнорируем поврежденные данные
        }
      }
    }

    return paymentMethods;
  }

  /// Удаление платежного метода
  static Future<void> deletePaymentMethod(String paymentMethodId) async {
    await _storage.delete(key: 'payment_method_$paymentMethodId');
  }

  // ============= ПАРОЛИ =============

  /// Хеширование пароля (SHA-256 + salt)
  static String hashPassword(String password, {String? salt}) {
    salt ??= _generateSalt();
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return '$salt:${digest.toString()}';
  }

  /// Проверка пароля
  static bool verifyPassword(String password, String hashedPassword) {
    final parts = hashedPassword.split(':');
    if (parts.length != 2) return false;

    final salt = parts[0];
    final hash = parts[1];
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);

    return digest.toString() == hash;
  }

  /// Генерация соли
  static String _generateSalt() {
    final random = Random.secure();
    final values = List<int>.generate(16, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  // ============= DEVICE ID =============

  /// Получение/создание ID устройства
  static Future<String> getOrCreateDeviceId() async {
    String? deviceId = await _storage.read(key: 'device_id');
    if (deviceId == null) {
      deviceId = _generateSecureToken();
      await _storage.write(key: 'device_id', value: deviceId);
    }
    return deviceId;
  }

  // ============= ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ =============

  /// Сохранение времени истечения
  static Future<void> _saveTokenExpiry(String key, int days) async {
    final expiry = DateTime.now().add(Duration(days: days));
    await _storage.write(key: key, value: expiry.toIso8601String());
  }

  /// Проверка истечения токена
  static Future<bool> _isTokenExpired(String key) async {
    final expiryString = await _storage.read(key: key);
    if (expiryString == null) return true;

    try {
      final expiry = DateTime.parse(expiryString);
      return DateTime.now().isAfter(expiry);
    } catch (e) {
      return true;
    }
  }

  /// Генерация безопасного токена
  static String _generateSecureToken() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  /// Очистка всех данных
  static Future<void> clearAllSecureData() async {
    await _storage.deleteAll();
  }

  /// Очистка истекших токенов
  static Future<void> cleanupExpiredTokens() async {
    await getAuthToken();
    await getRefreshToken();
    await getSessionId();
    await getPaymentMethods();
  }
}