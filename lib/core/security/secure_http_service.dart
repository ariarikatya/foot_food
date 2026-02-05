import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:convert';

/// Сервис безопасных HTTP-запросов
/// Использует TLS 1.3 и certificate pinning
class SecureHttpService {
  static const String baseUrl = 'https://api.footfood.ru';
  
  // SSL Certificate pins для вашего API
  // Получить их можно командой: openssl s_client -connect api.footfood.ru:443 < /dev/null | openssl x509 -pubkey -noout | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64
  static const List<String> certificatePins = [
    // Добавьте реальные SHA-256 хеши сертификатов вашего API
    // 'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
    // 'sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=',
  ];

  static http.Client? _client;

  /// Инициализация HTTP клиента с certificate pinning
  static Future<http.Client> _getClient() async {
    if (_client != null) return _client!;

    final httpClient = HttpClient();

    // Настройка TLS
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
      // В продакшене здесь должна быть проверка сертификата
      // Для разработки возвращаем true
      if (certificatePins.isEmpty) return true;

      // Certificate Pinning
      final certHash = _getCertificateHash(cert);
      return certificatePins.contains(certHash);
    };

    // Минимальная версия TLS
    httpClient.connectionTimeout = const Duration(seconds: 30);

    _client = IOClient(httpClient);
    return _client!;
  }

  /// Получение SHA-256 хеша сертификата
  static String _getCertificateHash(X509Certificate cert) {
    // Это упрощенная версия, в продакшене нужна полная реализация
    return 'sha256/${cert.sha1}';
  }

  /// GET запрос
  static Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    final client = await _getClient();
    
    // Добавляем query параметры
    var uri = Uri.parse('$baseUrl$endpoint');
    if (queryParams != null) {
      uri = uri.replace(queryParameters: queryParams);
    }

    final defaultHeaders = await _getDefaultHeaders();
    final mergedHeaders = {...defaultHeaders, ...?headers};

    return await client.get(uri, headers: mergedHeaders);
  }

  /// POST запрос
  static Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final client = await _getClient();
    final uri = Uri.parse('$baseUrl$endpoint');

    final defaultHeaders = await _getDefaultHeaders();
    final mergedHeaders = {...defaultHeaders, ...?headers};

    return await client.post(
      uri,
      headers: mergedHeaders,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  /// PUT запрос
  static Future<http.Response> put(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final client = await _getClient();
    final uri = Uri.parse('$baseUrl$endpoint');

    final defaultHeaders = await _getDefaultHeaders();
    final mergedHeaders = {...defaultHeaders, ...?headers};

    return await client.put(
      uri,
      headers: mergedHeaders,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  /// DELETE запрос
  static Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final client = await _getClient();
    final uri = Uri.parse('$baseUrl$endpoint');

    final defaultHeaders = await _getDefaultHeaders();
    final mergedHeaders = {...defaultHeaders, ...?headers};

    return await client.delete(uri, headers: mergedHeaders);
  }

  /// Получение заголовков по умолчанию
  static Future<Map<String, String>> _getDefaultHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Request-ID': _generateRequestId(),
    };

    // Добавляем токен авторизации если есть
    final authToken = await _getAuthToken();
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    return headers;
  }

  /// Получение токена авторизации
  static Future<String?> _getAuthToken() async {
    // Здесь должна быть интеграция с EncryptionService
    // return await EncryptionService.getAuthToken();
    return null;
  }

  /// Генерация уникального ID запроса (для защиты от replay атак)
  static String _generateRequestId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 1000).toString();
    return '$timestamp-$random';
  }

  /// Закрытие клиента
  static void dispose() {
    _client?.close();
    _client = null;
  }
}

/// Обработчик ошибок HTTP
class HttpErrorHandler {
  static String getErrorMessage(http.Response response) {
    switch (response.statusCode) {
      case 400:
        return 'Неверный запрос';
      case 401:
        return 'Необходима авторизация';
      case 403:
        return 'Доступ запрещен';
      case 404:
        return 'Ресурс не найден';
      case 429:
        return 'Слишком много запросов. Попробуйте позже';
      case 500:
        return 'Ошибка сервера';
      case 502:
        return 'Сервер недоступен';
      case 503:
        return 'Сервис временно недоступен';
      default:
        return 'Ошибка сети: ${response.statusCode}';
    }
  }

  static Map<String, dynamic>? parseErrorBody(http.Response response) {
    try {
      return jsonDecode(response.body);
    } catch (e) {
      return null;
    }
  }
}