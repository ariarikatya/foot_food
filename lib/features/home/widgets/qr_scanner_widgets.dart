import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../data/models/order_model.dart';

/// Экран сканирования QR-кода
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

    // Имитация сканирования
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.onScanSuccess();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
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
              ),
              const SizedBox(height: 40),
              const Text(
                'Отсканируйте QR-код',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary, width: 3),
                  ),
                  child: Center(
                    child: _isScanning
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Сканирование...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Montserrat',
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          )
                        : Icon(
                            Icons.qr_code_scanner,
                            size: 100,
                            color: Colors.grey[600],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Сканировать',
                fontSize: 28,
                fontWeight: FontWeight.w500,
                onPressed: _isScanning ? null : _startScanning,
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Назад',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Montserrat',
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Экран подтверждения оплаты
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

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 40),
              Text(
                'Номер заказа: ${order.numberOrder}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Информация о заказе:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 15),
              _buildInfoRow('Приготовлено:', _formatTime(order.cookingTime)),
              const SizedBox(height: 10),
              _buildInfoRow(
                'Выставлено на продажу:',
                _formatTime(order.saleTime),
              ),
              const SizedBox(height: 10),
              _buildInfoRow('Описание:', order.description ?? 'Нет описания'),
              const SizedBox(height: 10),
              _buildInfoRow('Внутри:', order.compositionOrder ?? 'Не указано'),
              const Spacer(),
              Center(
                child: Text(
                  '${order.price.toStringAsFixed(0)} ₽',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Провести оплату',
                fontSize: 28,
                fontWeight: FontWeight.w500,
                onPressed: onPaymentConfirm,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
