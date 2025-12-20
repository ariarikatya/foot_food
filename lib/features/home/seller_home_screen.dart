import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/custom_button.dart';

/// Главный экран продавца (экран 6 из дизайна)
class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  // Тестовые данные для футбоксов
  final List<Map<String, dynamic>> _foodboxes = [
    {
      'title': 'Футбокс 1',
      'description': 'Суп, второе, салат',
      'price': '500 ₽',
      'cookingTime': '8:08',
      'endTime': '14:00',
      'reservations': 3,
      'maxReservations': 10,
      'image': 'assets/images/placeholder_food.png',
    },
    {
      'title': 'Футбокс 2',
      'description': 'Пицца, напиток',
      'price': '410 ₽',
      'cookingTime': '10:00',
      'endTime': '16:00',
      'reservations': 7,
      'maxReservations': 10,
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
            _buildHeader(),
            Expanded(child: _buildFoodboxList()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          // Логотип ресторана
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: const Icon(Icons.restaurant, size: 30),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Название ресторана
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Лента footbox',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1C1B),
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Пермь, ул. Революции, 13',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
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
    );
  }

  Widget _buildFoodboxList() {
    if (_foodboxes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fastfood_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Нет активных футбоксов',
              style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Создайте первый футбокс',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: _foodboxes.length,
      itemBuilder: (context, index) {
        final foodbox = _foodboxes[index];
        return _buildFoodboxCard(foodbox);
      },
    );
  }

  Widget _buildFoodboxCard(Map<String, dynamic> foodbox) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Изображение футбокса
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            child: Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[300],
              child: Image.asset(
                foodbox['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.fastfood, size: 80);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Название и цена
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      foodbox['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1C1B),
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    Text(
                      foodbox['price'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                // Описание
                Text(
                  foodbox['description'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7A9999),
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // Время приготовления и окончания
                Row(
                  children: [
                    _buildInfoChip(
                      'В продаже с ${foodbox['cookingTime']} до ${foodbox['endTime']}',
                      Icons.access_time,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                // Бронирования
                Row(
                  children: [
                    _buildInfoChip(
                      'Бронирований: ${foodbox['reservations']}/${foodbox['maxReservations']}',
                      Icons.people,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // Кнопки действий
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Редактировать',
                        height: 44,
                        onPressed: () {
                          // Редактирование
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: CustomButton(
                        text: 'Удалить',
                        height: 44,
                        isOutlined: true,
                        onPressed: () {
                          // Удаление
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 70,
      height: 70,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDark,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.add, size: 35, color: AppColors.textWhite),
        onPressed: () {
          // Добавить футбокс
          _showAddFoodboxDialog();
        },
      ),
    );
  }

  void _showAddFoodboxDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать футбокс'),
        content: const Text('Здесь будет форма создания нового футбокса'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Добавить новый футбокс
            },
            child: const Text('Создать'),
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
          _buildNavItem(Icons.receipt_long, false),
          const SizedBox(width: 70), // Пространство для FAB
          _buildNavItem(Icons.analytics, false),
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
