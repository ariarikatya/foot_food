import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/order_model.dart';

class BuyerHistoryScreen extends StatefulWidget {
  const BuyerHistoryScreen({super.key});

  @override
  State<BuyerHistoryScreen> createState() => _BuyerHistoryScreenState();
}

class _BuyerHistoryScreenState extends State<BuyerHistoryScreen> {
  // Моковые данные для проверки
  final List<Map<String, dynamic>> _mockOrders = [
    {
      'id': 1,
      'idSeller': 1,
      'numberOrder': 12345,
      'restaurantName': 'Burger King',
      'description': 'Воппер комбо с картофелем фри',
      'compositionOrder': 'Бургер, картофель, напиток',
      'price': 450.0,
      'numberReservation': 1,
      'cookingTime': DateTime.now().subtract(const Duration(hours: 2)),
      'saleTime': DateTime.now().subtract(const Duration(hours: 1)),
    },
    {
      'id': 2,
      'idSeller': 1,
      'numberOrder': 12346,
      'restaurantName': 'KFC',
      'description': 'Баскет с крыльями',
      'compositionOrder': '8 крыльев, соус',
      'price': 380.0,
      'numberReservation': 2,
      'cookingTime': DateTime.now().subtract(const Duration(days: 1)),
      'saleTime': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': 3,
      'idSeller': 1,
      'numberOrder': 12347,
      'restaurantName': 'Subway',
      'description': 'Сэндвич с курицей',
      'compositionOrder': 'Сэндвич 30см, напиток',
      'price': 320.0,
      'numberReservation': 3,
      'cookingTime': DateTime.now().subtract(const Duration(days: 2)),
      'saleTime': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': 4,
      'idSeller': 1,
      'numberOrder': 12348,
      'restaurantName': 'Додо Пицца',
      'description': 'Пепперони большая',
      'compositionOrder': 'Пицца 35см',
      'price': 599.0,
      'numberReservation': 4,
      'cookingTime': DateTime.now().subtract(const Duration(days: 3)),
      'saleTime': DateTime.now().subtract(const Duration(days: 3)),
    },
  ];

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '';
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      'assets/images/Vector.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    'История заказов',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _mockOrders.isEmpty
                  ? const Center(
                      child: Text(
                        'История заказов пуста',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Montserrat',
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _mockOrders.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 15),
                      itemBuilder: (context, index) {
                        final orderData = _mockOrders[index];
                        return _buildOrderCard(orderData);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> orderData) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderData['restaurantName'] ?? 'Неизвестный ресторан',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${(orderData['price'] as double).toStringAsFixed(0)} ₽',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            orderData['description'] ?? '',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              fontFamily: 'Montserrat',
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Состав: ${orderData['compositionOrder'] ?? ""}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
              fontFamily: 'Montserrat',
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 5),
              Text(
                '${_formatDate(orderData['saleTime'])} в ${_formatTime(orderData['saleTime'])}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Montserrat',
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
