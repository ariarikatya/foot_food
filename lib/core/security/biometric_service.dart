import 'package:local_auth/local_auth.dart';

/// Сервис биометрической аутентификации
/// Используется для подтверждения платежей и чувствительных операций
class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// Проверка доступности биометрии
  static Future<bool> isBiometricAvailable() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  /// Проверка поддержки устройством
  static Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  /// Получение доступных типов биометрии
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Аутентификация для платежей
  static Future<bool> authenticateForPayment() async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) return false;

      return await _auth.authenticate(
        localizedReason: 'Подтвердите платёж',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  /// Аутентификация для входа
  static Future<bool> authenticateForLogin() async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) return false;

      return await _auth.authenticate(
        localizedReason: 'Войдите в приложение',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  /// Аутентификация для настроек
  static Future<bool> authenticateForSettings() async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) return false;

      return await _auth.authenticate(
        localizedReason: 'Подтвердите изменение настроек',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
          useErrorDialogs: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  /// Получение названия типа биометрии
  static Future<String> getBiometricTypeName() async {
    final biometrics = await getAvailableBiometrics();

    if (biometrics.isEmpty) {
      return 'Биометрия недоступна';
    }

    if (biometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (biometrics.contains(BiometricType.fingerprint)) {
      return 'Отпечаток пальца';
    } else if (biometrics.contains(BiometricType.iris)) {
      return 'Сканирование радужки';
    } else {
      return 'Биометрия';
    }
  }

  /// Проверка статуса биометрии
  static Future<BiometricStatus> checkBiometricStatus() async {
    final isSupported = await isDeviceSupported();
    if (!isSupported) {
      return BiometricStatus.notSupported;
    }

    final isAvailable = await isBiometricAvailable();
    if (!isAvailable) {
      return BiometricStatus.notEnrolled;
    }

    final biometrics = await getAvailableBiometrics();
    if (biometrics.isEmpty) {
      return BiometricStatus.notEnrolled;
    }

    return BiometricStatus.available;
  }
}

/// Статус биометрии на устройстве
enum BiometricStatus {
  /// Биометрия доступна и настроена
  available,

  /// Устройство не поддерживает биометрию
  notSupported,

  /// Биометрия поддерживается, но не настроена
  notEnrolled,
}