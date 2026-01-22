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
  bool _isScanning = false;

  void _startScanning() {
    setState(() => _isScanning = true);

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildScannerArea()),
            _buildInstructions(),
            const SizedBox(height: 20),
            _buildScanButton(),
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
            icon: const Icon(Icons.close, color: AppColors.primary, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          Text(
            'Заказ #${widget.order.numberOrder}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
              decoration: TextDecoration.none,
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Прозрачная область сканирования
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 3),
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent,
            ),
            child: _isScanning
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.qr_code_scanner,
                    size: 100,
                    color: Colors.grey,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        'Отсканируйте QR-код\nпокупателя',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          fontFamily: 'Montserrat',
          color: AppColors.textPrimary,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  Widget _buildScanButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _isScanning ? null : _startScanning,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Сканировать',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              fontFamily: 'Jura',
              color: Colors.white,
            ),
          ),
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.primary,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Номер заказа: ${order.numberOrder}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Номер брони: 221033803247',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Номер заказа: 221',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 60),
          Text(
            '${order.price.toStringAsFixed(0)} ₽',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onPaymentConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text(
            'Провести оплату',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              fontFamily: 'Jura',
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
