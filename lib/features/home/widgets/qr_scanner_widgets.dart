import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/order_model.dart';

/// Экран сканирования QR-кода (Выдать заказ 1)
class QRScannerScreen extends StatefulWidget {
  final OrderModel order;
  final VoidCallback onScanSuccess;

  const QRScannerScreen({
    super.key,
    required this.order,
    required this.onScanSuccess,
  });

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    // Симуляция успешного сканирования через 2 секунды
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isScanning = false);
        widget.onScanSuccess();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildScannerArea()),
            _buildInstructions(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          Text(
            'Заказ #${widget.order.numberOrder}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: 'Montserrat',
              color: Colors.white,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 46),
        ],
      ),
    );
  }

  Widget _buildScannerArea() {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: _isScanning
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.check_circle, size: 100, color: Colors.green),
      ),
    );
  }

  Widget _buildInstructions() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        'Наведите камеру на QR-код покупателя',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          fontFamily: 'Montserrat',
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Экран подтверждения оплаты (Выдать заказ 2)
class PaymentConfirmationScreen extends StatelessWidget {
  final OrderModel order;
  final String nameRestaurant;
  final VoidCallback onPaymentConfirm;

  const PaymentConfirmationScreen({
    super.key,
    required this.order,
    required this.nameRestaurant,
    required this.onPaymentConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 46),
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: const Color(0xFFFCF8F8),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: const Color(0x59051F20),
              offset: const Offset(4, 8),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildContent()),
            _buildPaymentButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Stack(
        children: [
          const Center(
            child: Text(
              'Подтверждение заказа',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 18,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRestaurantInfo(),
          const SizedBox(height: 20),
          _buildOrderInfo(),
          const Spacer(),
          _buildPriceInfo(),
        ],
      ),
    );
  }

  Widget _buildRestaurantInfo() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF10292A), width: 1.5),
            color: Colors.grey[300],
          ),
          child: const Icon(Icons.restaurant, color: Colors.grey, size: 24),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            nameRestaurant,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Номер заказа: ${order.numberOrder}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Описание: ${order.description ?? "Нет описания"}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildPriceInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'К оплате:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          '${order.price.toStringAsFixed(0)} ₽',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentButton(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            onPaymentConfirm();
          },
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          child: const Center(
            child: Text(
              'Провести оплату',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                fontFamily: 'Jura',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
