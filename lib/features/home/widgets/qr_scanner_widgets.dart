import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';

/// Экран сканирования QR-кода
class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const QRResultScreen(
              orderNumber: '12345',
              cookingTime: '12:30',
              saleTime: '14:00',
              description: 'Вкусный обед с салатом',
              composition: 'Салат, паста, десерт',
              price: 500,
            ),
          ),
        );
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
              // Иконка назад
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
              // Текст над сканером
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
              // Область сканирования
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
              // Кнопка Сканировать
              CustomButton(
                text: 'Сканировать',
                fontSize: 28,
                fontWeight: FontWeight.w500,
                onPressed: _isScanning ? null : _startScanning,
              ),
              const SizedBox(height: 15),
              // Кнопка Назад
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

/// Экран результата сканирования QR-кода
class QRResultScreen extends StatelessWidget {
  final String orderNumber;
  final String cookingTime;
  final String saleTime;
  final String description;
  final String composition;
  final double price;

  const QRResultScreen({
    super.key,
    required this.orderNumber,
    required this.cookingTime,
    required this.saleTime,
    required this.description,
    required this.composition,
    required this.price,
  });

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
              // Иконка назад
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
              // Номер заказа
              Text(
                'Номер заказа: $orderNumber',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 30),
              // Информация о заказе
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
              _buildInfoRow('Приготовлено:', cookingTime),
              const SizedBox(height: 10),
              _buildInfoRow('Выставлено на продажу:', saleTime),
              const SizedBox(height: 10),
              _buildInfoRow('Описание:', description),
              const SizedBox(height: 10),
              _buildInfoRow('Внутри:', composition),
              const Spacer(),
              // Цена
              Center(
                child: Text(
                  '${price.toStringAsFixed(0)} ₽',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Кнопка оплаты
              CustomButton(
                text: 'Провести оплату',
                fontSize: 28,
                fontWeight: FontWeight.w500,
                onPressed: () {
                  // Переход на seller_home_screen
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/seller_home', (route) => false);
                },
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
