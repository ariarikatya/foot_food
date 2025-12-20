import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';

/// Главный экран покупателя (экран 9 из дизайна)
class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  int _selectedIndex = 0;

  // Тестовые данные для заказов
  final List<Map<String, dynamic>> _activeOrders = [
    {
      'name': 'Никала\nПиросмани',
      'location': 'Пермь,\nМонастырская...',
      'date': '21.08.2025',
      'price': '500 ₽',
      'image': 'assets/images/placeholder_food.png',
    },
  ];

  final List<Map<String, dynamic>> _historyOrders = [
    {
      'name': 'Casa Mia',
      'location': 'Пермь,\nул. Революции...',
      'date': '21.08.2025',
      'price': '410 ₽',
      'image': 'assets/images/placeholder_food.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: _selectedIndex == 0
                  ? _buildActiveOrders()
                  : _buildHistoryOrders(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Поиск
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: AppColors.border, width: 2),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Поиск',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1A1C1B),
                        fontFamily: 'Montserrat',
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      suffixIcon: Icon(Icons.search, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Меню
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.backgroundWhite,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: AppColors.border, width: 2),
                ),
                child: const Icon(Icons.menu, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTabs(),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        Expanded(
          child: _buildTab('Активные', _selectedIndex == 0, () {
            setState(() => _selectedIndex = 0);
          }),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildTab('История', _selectedIndex == 1, () {
            setState(() => _selectedIndex = 1);
          }),
        ),
      ],
    );
  }

  Widget _buildTab(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.border, width: 2),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveOrders() {
    if (_activeOrders.isEmpty) {
      return Center(
        child: Text(
          'Нет активных заказов',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: _activeOrders.length,
      itemBuilder: (context, index) {
        final order = _activeOrders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildHistoryOrders() {
    if (_historyOrders.isEmpty) {
      return Center(
        child: Text(
          'История пуста',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: _historyOrders.length,
      itemBuilder: (context, index) {
        final order = _historyOrders[index];
        return _buildOrderCard(order, isHistory: true);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, {bool isHistory = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: Row(
        children: [
          // Логотип ресторана
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 80,
              height: 80,
              color: Colors.grey[300],
              child: Image.asset(
                order['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.restaurant, size: 40);
                },
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Информация о заказе
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1C1B),
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order['location'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7A9999),
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order['date'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1A1C1B),
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
          // Цена
          Text(
            order['price'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: AppColors.bottomNavBar,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, true),
          _buildNavItem(Icons.public, false),
          _buildNavItem(Icons.calendar_today, false),
          _buildNavItem(Icons.settings, false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isSelected) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.backgroundWhite : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textWhite,
        size: 28,
      ),
    );
  }
}
