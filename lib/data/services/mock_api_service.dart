import '../models/user_model.dart';
import '../models/seller_model.dart';
import '../models/order_model.dart';
import '../models/reservation_model.dart';
import '../models/card_model.dart';
import '../models/order_history_model.dart';

/// Mock-сервис для тестирования без сервера
///
/// ТЕСТОВЫЕ ПОЛЬЗОВАТЕЛИ:
///
/// ПОКУПАТЕЛЬ:
/// Телефон: +71234567890
/// Пароль: test123
///
/// ПРОДАВЕЦ:
/// Email: seller@test.com
/// Пароль: seller123
class MockApiService {
  // Тестовые данные
  static final _testBuyer = UserModel(
    id: 1,
    phone: '+71234567890',
    password: 'test123',
    city: 'Пермь',
  );

  static final _testSeller = SellerModel(
    id: 1,
    email: 'seller@test.com',
    nameRestaurant: 'Тестовый ресторан',
    address: 'Пермь, ул. Революции, 13',
    password: 'seller123',
    statusOrder: 'active',
    inn: 123456789,
    ogrn: 987654321,
  );

  // Имитация задержки сети
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  // ============= ПОЛЬЗОВАТЕЛИ (Users) =============

  Future<UserModel> registerUser({
    required String phone,
    required String password,
    String? city,
  }) async {
    await _simulateDelay();

    // Проверка на существующего пользователя
    if (phone == _testBuyer.phone) {
      throw Exception('Пользователь с таким номером уже существует');
    }

    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch,
      phone: phone,
      password: password,
      city: city,
    );
  }

  Future<Map<String, dynamic>> loginUser({
    required String phone,
    required String password,
  }) async {
    await _simulateDelay();

    // Проверка тестового пользователя
    if (phone == _testBuyer.phone && password == _testBuyer.password) {
      return {'user': _testBuyer, 'token': 'mock_token_${_testBuyer.id}'};
    }

    throw Exception('Неверный телефон или пароль');
  }

  Future<UserModel> getUserProfile(int userId) async {
    await _simulateDelay();

    if (userId == _testBuyer.id) {
      return _testBuyer;
    }

    throw Exception('Пользователь не найден');
  }

  // ============= ПРОДАВЦЫ (Sellers) =============

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
    await _simulateDelay();

    // Проверка на существующего продавца
    if (email == _testSeller.email) {
      throw Exception('Продавец с таким email уже существует');
    }

    return SellerModel(
      id: DateTime.now().millisecondsSinceEpoch,
      email: email,
      nameRestaurant: nameRestaurant,
      address: address,
      password: password,
      statusOrder: 'pending',
      inn: inn,
      ogrn: ogrn,
      logo: logo,
      photos: photos,
      verification: null,
    );
  }

  Future<Map<String, dynamic>> loginSeller({
    required String email,
    required String password,
  }) async {
    await _simulateDelay();

    // Проверка тестового продавца
    if (email == _testSeller.email && password == _testSeller.password) {
      return {
        'seller': _testSeller,
        'token': 'mock_seller_token_${_testSeller.id}',
      };
    }

    throw Exception('Неверный email или пароль');
  }

  // ============= ЗАКАЗЫ (Orders) =============

  Future<List<OrderModel>> getSellerOrders(int sellerId) async {
    await _simulateDelay();
    return [
      OrderModel(
        id: 1,
        idSeller: sellerId,
        numberOrder: 1001,
        cookingTime: DateTime.now().subtract(const Duration(hours: 2)),
        saleTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 2)),
        compositionOrder: 'Суп, второе, салат',
        description: 'Обед дня',
        price: 25.50,
        numberReservation: 0,
      ),
      OrderModel(
        id: 2,
        idSeller: sellerId,
        numberOrder: 1002,
        cookingTime: DateTime.now().subtract(const Duration(hours: 1)),
        saleTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 3)),
        compositionOrder: 'Пицца, напиток',
        description: 'Вечерний набор',
        price: 18.00,
        numberReservation: 1,
      ),
    ];
  }

  Future<OrderModel> createOrder(OrderModel order) async {
    await _simulateDelay();
    return order.copyWith(id: DateTime.now().millisecondsSinceEpoch);
  }

  // ============= БРОНИРОВАНИЯ (Reservations) =============

  Future<List<ReservationModel>> getUserReservations(int userId) async {
    await _simulateDelay();
    return [
      ReservationModel(id: 1, number: 1, idUser: userId, idOrder: 1),
      ReservationModel(id: 2, number: 2, idUser: userId, idOrder: 2),
    ];
  }

  Future<ReservationModel> createReservation(
    ReservationModel reservation,
  ) async {
    await _simulateDelay();
    return reservation.copyWith(id: DateTime.now().millisecondsSinceEpoch);
  }

  // ============= КАРТЫ (Cards) =============

  Future<List<CardModel>> getUserCards(int userId) async {
    await _simulateDelay();
    return [
      CardModel(
        id: 1,
        number: 1234567890123456,
        endTime: 1225,
        cvc: 123,
        nameUser: 'Test User',
        idUser: userId,
      ),
    ];
  }

  // ============= ИСТОРИЯ ЗАКАЗОВ (Order History) =============

  Future<List<OrderHistoryModel>> getUserOrderHistory(int userId) async {
    await _simulateDelay();
    return [
      OrderHistoryModel(
        id: 1,
        idUser: userId,
        idSeller: 1,
        numberOrder: 1001,
        numberReservation: 1,
        cookingTime: DateTime.now().subtract(const Duration(days: 1)),
        saleTime: DateTime.now().subtract(const Duration(days: 1)),
        endTime: DateTime.now().subtract(const Duration(hours: 22)),
        bayTime: DateTime.now().subtract(const Duration(hours: 23)),
        compositionOrder: 'Суп, второе, салат',
        description: 'Обед дня',
        price: 25.50,
      ),
      OrderHistoryModel(
        id: 2,
        idUser: userId,
        idSeller: 2,
        numberOrder: 1002,
        numberReservation: 2,
        cookingTime: DateTime.now().subtract(const Duration(days: 2)),
        saleTime: DateTime.now().subtract(const Duration(days: 2)),
        endTime: DateTime.now().subtract(const Duration(hours: 46)),
        bayTime: DateTime.now().subtract(const Duration(hours: 47)),
        compositionOrder: 'Пицца, напиток',
        description: 'Вечерний набор',
        price: 18.00,
      ),
    ];
  }
}
