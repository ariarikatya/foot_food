/// API константы и эндпоинты
class ApiConstants {
  ApiConstants._();

  // Базовый URL (замените на ваш реальный URL когда сервер будет готов)
  static const String baseUrl = 'http://localhost:3000/api';

  // Таймауты
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Эндпоинты для пользователей (users - покупатели)
  static const String usersEndpoint = '/users';
  static const String userLoginEndpoint = '/users/login';
  static const String userRegisterEndpoint = '/users/register';
  static const String userProfileEndpoint = '/users/profile';
  static const String userUpdateEndpoint = '/users/update';

  // Эндпоинты для продавцов (sellers)
  static const String sellersEndpoint = '/sellers';
  static const String sellerLoginEndpoint = '/sellers/login';
  static const String sellerRegisterEndpoint = '/sellers/register';
  static const String sellerProfileEndpoint = '/sellers/profile';
  static const String sellerUpdateEndpoint = '/sellers/update';

  // Эндпоинты для заказов (order_foodbox)
  static const String ordersEndpoint = '/orders';
  static const String orderCreateEndpoint = '/orders/create';
  static const String orderDetailsEndpoint = '/orders/details';
  static const String orderUpdateEndpoint = '/orders/update';
  static const String ordersBySellerEndpoint = '/orders/seller';
  static const String ordersByUserEndpoint = '/orders/user';

  // Эндпоинты для истории заказов (order_history)
  static const String orderHistoryEndpoint = '/order-history';
  static const String orderHistoryByUserEndpoint = '/order-history/user';
  static const String orderHistoryBySellerEndpoint = '/order-history/seller';

  // Эндпоинты для бронирования (reservation_foodbox)
  static const String reservationsEndpoint = '/reservations';
  static const String reservationCreateEndpoint = '/reservations/create';
  static const String reservationUpdateEndpoint = '/reservations/update';
  static const String reservationsByUserEndpoint = '/reservations/user';
  static const String reservationsByOrderEndpoint = '/reservations/order';

  // Эндпоинты для карт (card)
  static const String cardsEndpoint = '/cards';
  static const String cardAddEndpoint = '/cards/add';
  static const String cardUpdateEndpoint = '/cards/update';
  static const String cardDeleteEndpoint = '/cards/delete';
  static const String cardsByUserEndpoint = '/cards/user';

  // Заголовки
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}
