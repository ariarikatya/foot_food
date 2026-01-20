import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/order_model.dart';
import '../add_card_screen.dart';

/// Экран "Если карта не добавлена"
class NoCardScreen extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onCardAdded;

  const NoCardScreen({
    super.key,
    required this.order,
    required this.onCardAdded,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          SafeArea(
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 46),
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x59051F20),
                      offset: const Offset(4, 8),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.credit_card_off,
                      size: 80,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Карта не добавлена',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Для бронирования заказа необходимо добавить банковскую карту',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Montserrat',
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierColor: Colors.transparent,
                            useSafeArea: false,
                            builder: (ctx) => Stack(
                              fit: StackFit.expand,
                              children: [
                                BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 5,
                                    sigmaY: 5,
                                  ),
                                  child: GestureDetector(
                                    onTap: () => Navigator.pop(ctx),
                                    child: Container(
                                      color: Colors.black.withOpacity(0.3),
                                    ),
                                  ),
                                ),
                                const AddCardDialog(hasCard: false),
                              ],
                            ),
                          ).then((_) {
                            // После добавления карты
                            Navigator.pop(context);
                            onCardAdded();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Добавить карту',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Jura',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Отмена',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Montserrat',
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Экран "Забрать заказ" с QR-кодом
class PickupOrderScreen extends StatelessWidget {
  final OrderModel order;
  final String nameRestaurant;
  final String address;

  const PickupOrderScreen({
    super.key,
    required this.order,
    required this.nameRestaurant,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/buyerHome.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          const Text(
            'Забрать заказ',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildRestaurantInfo(),
          const SizedBox(height: 30),
          _buildQRCode(),
          const SizedBox(height: 30),
          _buildOrderInfo(),
          const SizedBox(height: 20),
          _buildInstructions(),
        ],
      ),
    );
  }

  Widget _buildRestaurantInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF10292A), width: 1.5),
              color: Colors.grey[300],
            ),
            child: const Icon(Icons.restaurant, color: Colors.grey, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nameRestaurant,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  address,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Montserrat',
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCode() {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary, width: 3),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.qr_code,
                size: 120,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Номер заказа:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${order.numberOrder}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Стоимость:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '${order.price.toStringAsFixed(0)} ₽',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Заказ забронирован и оплачен',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Как забрать заказ:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 15),
          Text(
            '1. Покажите этот QR-код сотруднику заведения\n\n'
            '2. После сканирования заказ будет выдан\n\n'
            '3. Приятного аппетита!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
