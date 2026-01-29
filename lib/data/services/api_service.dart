import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import '../models/seller_model.dart';
import '../models/order_model.dart';
import '../models/reservation_model.dart';
import '../models/card_model.dart';
import '../models/order_history_model.dart';

/// Сервис для работы с API
class ApiService {
  final http.Client _client;
  String? _authToken;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // Установка токена авторизации
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Получение заголовков с токеном
  Map<String, String> get _headers {
    if (_authToken != null) {
      return ApiConstants.authHeaders(_authToken!);
    }
    return ApiConstants.defaultHeaders;
  }

  // ============= ПОЛЬЗОВАТЕЛИ (Users) =============

  /// Регистрация пользователя
  Future<UserModel> registerUser({
    required String phone,
    required String password,
    String? city,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.userRegisterEndpoint}',
            ),
            headers: ApiConstants.defaultHeaders,
            body: jsonEncode({
              'phone': phone,
              'password': password,
              'city': city,
            }),
          )
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data['user']);
      } else {
        throw Exception('Ошибка регистрации: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }

  /// Авторизация пользователя
  Future<Map<String, dynamic>> loginUser({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.userLoginEndpoint}',
            ),
            headers: ApiConstants.defaultHeaders,
            body: jsonEncode({'phone': phone, 'password': password}),
          )
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'user': UserModel.fromJson(data['user']),
          'token': data['token'],
        };
      } else {
        throw Exception('Ошибка авторизации: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }

  /// Получение профиля пользователя
  Future<UserModel> getUserProfile(int userId) async {
    try {
      final response = await _client
          .get(
            Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.userProfileEndpoint}/$userId',
            ),
            headers: _headers,
          )
          .timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        throw Exception('Ошибка получения профиля: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }

  // ============= ПРОДАВЦЫ (Sellers) =============

  /// Регистрация продавца
  Future<SellerModel> registerSeller({
    required String email,
    required String nameRestaurant,
    required String address,
    required String password,
    required int inn,
    required int ogrn,
    String? logo,
    String? photos,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.sellerRegisterEndpoint}',
            ),
            headers: ApiConstants.defaultHeaders,
            body: jsonEncode({
              'email': email,
              'name_restaurant': nameRestaurant,
              'address': address,
              'password': password,
              'inn': inn,
              'ogrn': ogrn,
              'logo': logo,
              'photos': photos,
            }),
          )
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return SellerModel.fromJson(data['seller']);
      } else {
        throw Exception('Ошибка регистрации: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }

  /// Авторизация продавца
  Future<Map<String, dynamic>> loginSeller({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.sellerLoginEndpoint}',
            ),
            headers: ApiConstants.defaultHeaders,
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'seller': SellerModel.fromJson(data['seller']),
          'token': data['token'],
        };
      } else {
        throw Exception('Ошибка авторизации: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }

  // ============= ЗАКАЗЫ (Orders) =============

  /// Получение списка заказов продавца
  Future<List<OrderModel>> getSellerOrders(int sellerId) async {
    try {
      final response = await _client
          .get(
            Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.ordersBySellerEndpoint}/$sellerId',
            ),
            headers: _headers,
          )
          .timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка получения заказов: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }

  /// Создание нового заказа
  Future<OrderModel> createOrder(OrderModel order) async {
    try {
      final response = await _client
          .post(
            Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.orderCreateEndpoint}',
            ),
            headers: _headers,
            body: jsonEncode(order.toJson()),
          )
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return OrderModel.fromJson(data);
      } else {
        throw Exception('Ошибка создания заказа: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }

  // ============= БРОНИРОВАНИЯ (Reservations) =============

  /// Получение бронирований пользователя
  Future<List<ReservationModel>> getUserReservations(int userId) async {
    try {
      final response = await _client
          .get(
            Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.reservationsByUserEndpoint}/$userId',
            ),
            headers: _headers,
          )
          .timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ReservationModel.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка получения бронирований: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }

  /// Создание бронирования
  Future<ReservationModel> createReservation(
    ReservationModel reservation,
  ) async {
    try {
      final response = await _client
          .post(
            Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.reservationCreateEndpoint}',
            ),
            headers: _headers,
            body: jsonEncode(reservation.toJson()),
          )
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ReservationModel.fromJson(data);
      } else {
        throw Exception('Ошибка создания бронирования: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }

  // ============= КАРТЫ (Cards) =============

  /// Получение карт пользователя
  Future<List<CardModel>> getUserCards(int userId) async {
    try {
      final response = await _client
          .get(
            Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.cardsByUserEndpoint}/$userId',
            ),
            headers: _headers,
          )
          .timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => CardModel.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка получения карт: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }

  // ============= ИСТОРИЯ ЗАКАЗОВ (Order History) =============

  /// Получение истории заказов пользователя
  Future<List<OrderHistoryModel>> getUserOrderHistory(int userId) async {
    try {
      final response = await _client
          .get(
            Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.orderHistoryByUserEndpoint}/$userId',
            ),
            headers: _headers,
          )
          .timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => OrderHistoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Ошибка получения истории: ${response.body}');
      }
    } catch (e) {
      throw Exception('Ошибка подключения: $e');
    }
  }

  // Закрытие клиента
  void dispose() {
    _client.close();
  }
}
