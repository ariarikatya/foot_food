import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Сервис локального хранилища (аналог cookies)
/// Управляет настройками, кэшем и несекретными данными
class LocalStorageService {
  static SharedPreferences? _prefs;

  /// Инициализация сервиса (вызывать при старте приложения)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _cleanExpiredData();
  }

  // ============= ФУНКЦИОНАЛЬНЫЕ ДАННЫЕ (можно отключить) =============

  /// Последний выбранный город
  /// Срок хранения: 1 год
  static Future<void> saveLastCity(String city) async {
    await _prefs?.setString('last_city', city);
    await _setExpiry('last_city_expiry', 365);
  }

  static String? getLastCity() {
    if (_isExpired('last_city_expiry')) {
      deleteLastCity();
      return null;
    }
    return _prefs?.getString('last_city');
  }

  static Future<void> deleteLastCity() async {
    await _prefs?.remove('last_city');
    await _prefs?.remove('last_city_expiry');
  }

  /// Настройки фильтров
  /// Срок хранения: 1 год
  static Future<void> saveFilterPreferences(Map<String, dynamic> filters) async {
    await _prefs?.setString('filter_prefs', jsonEncode(filters));
    await _setExpiry('filter_prefs_expiry', 365);
  }

  static Map<String, dynamic>? getFilterPreferences() {
    if (_isExpired('filter_prefs_expiry')) {
      deleteFilterPreferences();
      return null;
    }

    final filtersStr = _prefs?.getString('filter_prefs');
    if (filtersStr == null) return null;

    try {
      return jsonDecode(filtersStr) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  static Future<void> deleteFilterPreferences() async {
    await _prefs?.remove('filter_prefs');
    await _prefs?.remove('filter_prefs_expiry');
  }

  /// Тема приложения (светлая/темная)
  /// Срок хранения: постоянно
  static Future<void> saveThemeMode(String mode) async {
    await _prefs?.setString('theme_mode', mode);
  }

  static String getThemeMode() {
    return _prefs?.getString('theme_mode') ?? 'system';
  }

  /// Язык приложения
  /// Срок хранения: постоянно
  static Future<void> saveLanguage(String languageCode) async {
    await _prefs?.setString('language', languageCode);
  }

  static String getLanguage() {
    return _prefs?.getString('language') ?? 'ru';
  }

  // ============= КЭШИРОВАНИЕ =============

  /// Кэш списка городов
  /// Срок хранения: 7 дней
  static Future<void> cacheCities(List<String> cities) async {
    await _prefs?.setStringList('cached_cities', cities);
    await _setExpiry('cached_cities_expiry', 7);
  }

  static List<String>? getCachedCities() {
    if (_isExpired('cached_cities_expiry')) {
      deleteCachedCities();
      return null;
    }
    return _prefs?.getStringList('cached_cities');
  }

  static Future<void> deleteCachedCities() async {
    await _prefs?.remove('cached_cities');
    await _prefs?.remove('cached_cities_expiry');
  }

  /// Кэш категорий блюд
  /// Срок хранения: 7 дней
  static Future<void> cacheCategories(List<String> categories) async {
    await _prefs?.setStringList('cached_categories', categories);
    await _setExpiry('cached_categories_expiry', 7);
  }

  static List<String>? getCachedCategories() {
    if (_isExpired('cached_categories_expiry')) {
      deleteCachedCategories();
      return null;
    }
    return _prefs?.getStringList('cached_categories');
  }

  static Future<void> deleteCachedCategories() async {
    await _prefs?.remove('cached_categories');
    await _prefs?.remove('cached_categories_expiry');
  }

  // ============= АНАЛИТИЧЕСКИЕ ДАННЫЕ =============

  /// Включена ли аналитика
  static Future<void> setAnalyticsEnabled(bool enabled) async {
    await _prefs?.setBool('analytics_enabled', enabled);
  }

  static bool isAnalyticsEnabled() {
    return _prefs?.getBool('analytics_enabled') ?? true;
  }

  /// ID для аналитики
  /// Срок хранения: 1 год
  static Future<void> saveAnalyticsId(String id) async {
    await _prefs?.setString('analytics_id', id);
    await _setExpiry('analytics_id_expiry', 365);
  }

  static String? getAnalyticsId() {
    if (_isExpired('analytics_id_expiry')) {
      deleteAnalyticsId();
      return null;
    }
    return _prefs?.getString('analytics_id');
  }

  static Future<void> deleteAnalyticsId() async {
    await _prefs?.remove('analytics_id');
    await _prefs?.remove('analytics_id_expiry');
  }

  /// Версия приложения
  static Future<void> saveAppVersion(String version) async {
    await _prefs?.setString('app_version', version);
  }

  static String? getAppVersion() {
    return _prefs?.getString('app_version');
  }

  // ============= МАРКЕТИНГОВЫЕ ДАННЫЕ =============

  /// Включены ли push-уведомления
  static Future<void> setPushEnabled(bool enabled) async {
    await _prefs?.setBool('push_enabled', enabled);
  }

  static bool isPushEnabled() {
    return _prefs?.getBool('push_enabled') ?? true;
  }

  /// FCM токен
  /// Срок хранения: до отзыва
  static Future<void> saveFCMToken(String token) async {
    await _prefs?.setString('fcm_token', token);
  }

  static String? getFCMToken() {
    return _prefs?.getString('fcm_token');
  }

  static Future<void> deleteFCMToken() async {
    await _prefs?.remove('fcm_token');
  }

  /// Источник установки (UTM метки)
  /// Срок хранения: 90 дней
  static Future<void> saveCampaignSource(Map<String, String> utmParams) async {
    await _prefs?.setString('campaign_source', jsonEncode(utmParams));
    await _setExpiry('campaign_source_expiry', 90);
  }

  static Map<String, String>? getCampaignSource() {
    if (_isExpired('campaign_source_expiry')) {
      deleteCampaignSource();
      return null;
    }

    final sourceStr = _prefs?.getString('campaign_source');
    if (sourceStr == null) return null;

    try {
      final decoded = jsonDecode(sourceStr) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      return null;
    }
  }

  static Future<void> deleteCampaignSource() async {
    await _prefs?.remove('campaign_source');
    await _prefs?.remove('campaign_source_expiry');
  }

  // ============= БЕЗОПАСНОСТЬ =============

  /// Дата последней смены пароля
  /// Срок хранения: постоянно
  static Future<void> saveLastPasswordChange(DateTime date) async {
    await _prefs?.setInt('last_password_change', date.millisecondsSinceEpoch);
  }

  static DateTime? getLastPasswordChange() {
    final timestamp = _prefs?.getInt('last_password_change');
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Время последней активности (для auto-logout)
  static Future<void> updateLastActivity() async {
    await _prefs?.setInt('last_activity', DateTime.now().millisecondsSinceEpoch);
  }

  static DateTime? getLastActivity() {
    final timestamp = _prefs?.getInt('last_activity');
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Проверка необходимости auto-logout (15 минут)
  static bool shouldAutoLogout() {
    final lastActivity = getLastActivity();
    if (lastActivity == null) return false;

    final minutesPassed = DateTime.now().difference(lastActivity).inMinutes;
    return minutesPassed >= 15;
  }

  /// Счетчик неудачных попыток входа
  /// Срок хранения: 1 час
  static Future<void> incrementFailedLogins(String identifier) async {
    final key = 'failed_logins_$identifier';
    final attempts = _prefs?.getInt(key) ?? 0;
    await _prefs?.setInt(key, attempts + 1);
    await _prefs?.setInt(
      '${key}_timestamp',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  static int getFailedLogins(String identifier) {
    final key = 'failed_logins_$identifier';
    final timestamp = _prefs?.getInt('${key}_timestamp');

    if (timestamp != null) {
      final hoursPassed = (DateTime.now().millisecondsSinceEpoch - timestamp) / (1000 * 60 * 60);
      if (hoursPassed >= 1) {
        resetFailedLogins(identifier);
        return 0;
      }
    }

    return _prefs?.getInt(key) ?? 0;
  }

  static Future<void> resetFailedLogins(String identifier) async {
    final key = 'failed_logins_$identifier';
    await _prefs?.remove(key);
    await _prefs?.remove('${key}_timestamp');
  }

  static bool isLoginBlocked(String identifier) {
    return getFailedLogins(identifier) >= 5;
  }

  // ============= ОНБОРДИНГ =============

  /// Был ли показан онбординг
  static Future<void> setOnboardingShown(bool shown) async {
    await _prefs?.setBool('onboarding_shown', shown);
  }

  static bool isOnboardingShown() {
    return _prefs?.getBool('onboarding_shown') ?? false;
  }

  /// Версия онбординга
  static Future<void> saveOnboardingVersion(String version) async {
    await _prefs?.setString('onboarding_version', version);
  }

  static String? getOnboardingVersion() {
    return _prefs?.getString('onboarding_version');
  }

  // ============= ПОЛИТИКА КОНФИДЕНЦИАЛЬНОСТИ =============

  /// Принятие политики конфиденциальности
  static Future<void> setPrivacyPolicyAccepted(bool accepted) async {
    await _prefs?.setBool('privacy_accepted', accepted);
    if (accepted) {
      await _prefs?.setInt(
        'privacy_accepted_timestamp',
        DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  static bool isPrivacyPolicyAccepted() {
    return _prefs?.getBool('privacy_accepted') ?? false;
  }

  static DateTime? getPrivacyAcceptedDate() {
    final timestamp = _prefs?.getInt('privacy_accepted_timestamp');
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Версия принятой политики
  static Future<void> savePrivacyVersion(String version) async {
    await _prefs?.setString('privacy_version', version);
  }

  static String? getPrivacyVersion() {
    return _prefs?.getString('privacy_version');
  }

  // ============= ОЧИСТКА ДАННЫХ =============

  /// Полная очистка всех данных
  static Future<void> clearAll() async {
    await _prefs?.clear();
  }

  /// Очистка только необязательных данных
  static Future<void> clearOptionalData() async {
    // Удаляем аналитику
    await deleteAnalyticsId();
    await deleteFCMToken();
    await deleteCampaignSource();
    
    // Удаляем кэш
    await deleteCachedCities();
    await deleteCachedCategories();
    
    // Оставляем настройки приложения (тема, язык и т.д.)
  }

  // ============= ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ =============

  /// Установка срока истечения данных
  static Future<void> _setExpiry(String key, int days) async {
    final expiry = DateTime.now().add(Duration(days: days));
    await _prefs?.setInt(key, expiry.millisecondsSinceEpoch);
  }

  /// Проверка истечения срока
  static bool _isExpired(String key) {
    final expiry = _prefs?.getInt(key);
    if (expiry == null) return false;

    return DateTime.now().millisecondsSinceEpoch > expiry;
  }

  /// Автоматическая очистка истекших данных
  static Future<void> _cleanExpiredData() async {
    getLastCity();
    getFilterPreferences();
    getCachedCities();
    getCachedCategories();
    getAnalyticsId();
    getCampaignSource();
  }

  /// Экспорт всех данных (для GDPR)
  static Map<String, dynamic> exportAllData() {
    final keys = _prefs?.getKeys() ?? {};
    final data = <String, dynamic>{};

    for (final key in keys) {
      data[key] = _prefs?.get(key);
    }

    return data;
  }

  /// Получение всех ключей
  static Set<String> getAllKeys() {
    return _prefs?.getKeys() ?? {};
  }
}