import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
import '../data/models/seller_model.dart';
import '../data/services/mock_api_service.dart';

/// Типы пользователей
enum UserType { buyer, seller, none }

/// Provider для управления авторизацией
class AuthProvider extends ChangeNotifier {
  final MockApiService _apiService = MockApiService();

  UserModel? _currentUser;
  SellerModel? _currentSeller;
  String? _authToken;
  UserType _userType = UserType.none;
  bool _isLoading = false;
  String? _errorMessage;

  // Геттеры
  UserModel? get currentUser => _currentUser;
  SellerModel? get currentSeller => _currentSeller;
  String? get authToken => _authToken;
  UserType get userType => _userType;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _authToken != null;

  // Установка состояния загрузки
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Установка ошибки
  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Очистка ошибки
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ============= РЕГИСТРАЦИЯ =============

  /// Регистрация покупателя
  Future<bool> registerBuyer({
    required String phone,
    required String password,
    String? city,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final user = await _apiService.registerUser(
        phone: phone,
        password: password,
        city: city,
      );

      _currentUser = user;
      _userType = UserType.buyer;
      _authToken = 'mock_token_${user.id}';

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Ошибка регистрации: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Регистрация продавца
  Future<bool> registerSeller({
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
      _setLoading(true);
      _setError(null);

      final seller = await _apiService.registerSeller(
        email: email,
        nameRestaurant: nameRestaurant,
        address: address,
        password: password,
        inn: inn,
        ogrn: ogrn,
        logo: logo,
        photos: photos,
      );

      _currentSeller = seller;
      _userType = UserType.seller;
      _authToken = 'mock_seller_token_${seller.id}';

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Ошибка регистрации: $e');
      _setLoading(false);
      return false;
    }
  }

  // ============= АВТОРИЗАЦИЯ =============

  /// Авторизация покупателя
  Future<bool> loginBuyer({
    required String phone,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final result = await _apiService.loginUser(
        phone: phone,
        password: password,
      );

      _currentUser = result['user'] as UserModel;
      _authToken = result['token'] as String;
      _userType = UserType.buyer;

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Ошибка авторизации: $e');
      _setLoading(false);
      return false;
    }
  }

  /// Авторизация продавца
  Future<bool> loginSeller({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      final result = await _apiService.loginSeller(
        email: email,
        password: password,
      );

      _currentSeller = result['seller'] as SellerModel;
      _authToken = result['token'] as String;
      _userType = UserType.seller;

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Ошибка авторизации: $e');
      _setLoading(false);
      return false;
    }
  }

  // ============= ВЫХОД =============

  /// Выход из аккаунта
  Future<void> logout() async {
    _currentUser = null;
    _currentSeller = null;
    _authToken = null;
    _userType = UserType.none;
    _errorMessage = null;
    notifyListeners();
  }

  // ============= ПРОВЕРКА ТОКЕНА =============

  /// Проверка действительности токена (можно расширить)
  Future<bool> checkAuthStatus() async {
    // Здесь можно добавить проверку токена на сервере
    // Пока просто возвращаем наличие токена
    return _authToken != null;
  }
}
