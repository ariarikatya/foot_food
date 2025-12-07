import '../models/user_model.dart';
import '../models/seller_model.dart';
import '../models/order_model.dart';
import '../models/reservation_model.dart';
import '../models/card_model.dart';
import '../models/order_history_model.dart';

/// Mock-сервис для тестирования без сервера
class MockApiService {
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
    return UserModel(id: 1, phone: phone, password: password, city: city);
  }

  Future<Map<String, dynamic>> loginUser({
    required String phone,
    required String password,
  }) async {
    await _simulateDelay();
    return {
      'user': UserModel(
        id: 1,
        phone: phone,
        password: password,
        city: 'Warsaw',
      ),
      'token': 'mock_token_12345',
    };
  }

  Future<UserModel> getUserProfile(int userId) async {
    await _simulateDelay();
    return UserModel(
      id: userId,
      phone: '+48123456789',
      password: 'hashed_password',
      city: 'Warsaw',
    );
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
    return SellerModel(
      id: 1,
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
    return {
      'seller': SellerModel(
        id: 1,
        email: email,
        nameRestaurant: 'Test Restaurant',
        address: 'Warsaw, Test Street 1',
        password: password,
        statusOrder: 'active',
        inn: 123456789,
        ogrn: 987654321,
      ),
      'token': 'mock_seller_token_12345',
    };
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
