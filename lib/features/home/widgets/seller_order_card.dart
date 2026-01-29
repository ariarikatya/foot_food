import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Компактная карточка заказа для продавца
class SellerOrderCard extends StatelessWidget {
  final String nameRestaurant;
  final String address;
  final String date;
  final double price;
  final VoidCallback onTap;

  const SellerOrderCard({
    super.key,
    required this.nameRestaurant,
    required this.address,
    required this.date,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 147,
        height: 180, // Одинаковая высота для Активных и Истории
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFCF8F8),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0x59000000),
              offset: const Offset(4, 8),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              nameRestaurant,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                fontFamily: 'Jura',
                color: AppColors.textPrimary,
                height: 0.95,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              address,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${price.toStringAsFixed(0)} ₽',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Montserrat',
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
