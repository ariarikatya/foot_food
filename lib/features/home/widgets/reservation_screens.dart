import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/order_model.dart';

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildQRCode(),
                  const SizedBox(height: 10),
                  _buildReservationNumber(),
                  const SizedBox(height: 5),
                  _buildInstructions(),
                  const SizedBox(height: 10),
                  _buildRestaurantCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCode() {
    return Column(
      children: [
        const Text(
          'QR-код вашего foodbox',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 291,
          height: 291,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0x1A000000),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.qr_code,
                size: 150,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReservationNumber() {
    return const Text(
      'Номер брони: 221033803247',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        fontFamily: 'Montserrat',
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildInstructions() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Покажите QR-код на кассе\nи вам выдадут ваш заказ',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          fontFamily: 'Montserrat',
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: AppColors.primary,
                  size: 40,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nameRestaurant,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat',
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      address,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Montserrat',
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${order.price.toStringAsFixed(0)} ₽',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 35),
          _buildTimer(),
          const SizedBox(height: 20),
          _buildCancelButton(context),
        ],
      ),
    );
  }

  Widget _buildTimer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Column(
        children: [
          Text(
            'До окончания продажи осталось',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              fontFamily: 'Montserrat',
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Text(
            '01:55:26',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.all(20),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Отменить бронь?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Нет',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.error,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Да',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        child: const Text(
          'Отменить бронь',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            fontFamily: 'Montserrat',
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}