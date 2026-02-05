import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:foot_food/core/constants/app_colors.dart';
import 'package:foot_food/data/services/yookassa_service.dart';
import 'package:foot_food/core/security/biometric_service.dart';

class YookassaPaymentScreen extends StatefulWidget {
  final double amount;
  final String description;
  final int orderId;
  final String? paymentMethodId; // Если есть сохраненная карта

  const YookassaPaymentScreen({
    super.key,
    required this.amount,
    required this.description,
    required this.orderId,
    this.paymentMethodId,
  });

  @override
  State<YookassaPaymentScreen> createState() => _YookassaPaymentScreenState();
}

class _YookassaPaymentScreenState extends State<YookassaPaymentScreen> {
  late WebViewController _webViewController;
  bool _isLoading = true;
  String? _confirmationUrl;
  String? _paymentId;

  @override
  void initState() {
    super.initState();
    _initPayment();
  }

  Future<void> _initPayment() async {
    try {
      // Если есть сохраненная карта - запрашиваем биометрию
      if (widget.paymentMethodId != null) {
        final authenticated = await BiometricService.authenticateForPayment();
        if (!authenticated) {
          if (mounted) {
            Navigator.pop(context, {'success': false, 'error': 'Биометрия отклонена'});
          }
          return;
        }

        // Оплата сохраненной картой
        await _payWithSavedCard();
      } else {
        // Создание нового платежа
        await _createNewPayment();
      }
    } catch (e) {
      if (mounted) {
        _showError('Ошибка инициализации платежа: $e');
      }
    }
  }

  Future<void> _payWithSavedCard() async {
    try {
      final paymentData = await YookassaService.createPaymentWithToken(
        paymentMethodId: widget.paymentMethodId!,
        amount: widget.amount,
        description: widget.description,
        metadata: {
          'order_id': widget.orderId.toString(),
        },
      );

      _paymentId = paymentData['id'];
      final status = paymentData['status'];

      if (status == 'succeeded') {
        // Оплата прошла успешно
        if (mounted) {
          Navigator.pop(context, {
            'success': true,
            'payment_id': _paymentId,
          });
        }
      } else if (status == 'pending') {
        // Требуется 3D-Secure
        final confirmationUrl = paymentData['confirmation']?['confirmation_url'];
        if (confirmationUrl != null) {
          setState(() {
            _confirmationUrl = confirmationUrl;
            _isLoading = false;
          });
          _initWebView();
        }
      } else {
        throw Exception('Неизвестный статус платежа: $status');
      }
    } catch (e) {
      _showError('Ошибка оплаты: $e');
    }
  }

  Future<void> _createNewPayment() async {
    try {
      final paymentData = await YookassaService.createPayment(
        amount: widget.amount,
        description: widget.description,
        returnUrl: 'footfood://payment/success',
        metadata: {
          'order_id': widget.orderId.toString(),
        },
      );

      _paymentId = paymentData['id'];
      _confirmationUrl = paymentData['confirmation']['confirmation_url'];

      setState(() {
        _isLoading = false;
      });

      _initWebView();
    } catch (e) {
      _showError('Ошибка создания платежа: $e');
    }
  }

  void _initWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _checkPaymentStatus(url);
          },
        ),
      )
      ..loadRequest(Uri.parse(_confirmationUrl!));
  }

  Future<void> _checkPaymentStatus(String url) async {
    // Проверяем, вернулись ли мы из ЮКассы
    if (url.contains('footfood://payment/success') || 
        url.contains('payment/success')) {
      try {
        // Проверяем статус платежа
        final paymentData = await YookassaService.getPaymentStatus(_paymentId!);
        final status = paymentData['status'];

        if (status == 'succeeded') {
          // Сохраняем токен платежного метода
          await YookassaService.savePaymentMethod(paymentData);

          if (mounted) {
            Navigator.pop(context, {
              'success': true,
              'payment_id': _paymentId,
            });
          }
        } else if (status == 'canceled') {
          _showError('Платеж отменен');
        } else if (status == 'pending') {
          // Еще обрабатывается
          await Future.delayed(const Duration(seconds: 2));
          _checkPaymentStatus(url);
        }
      } catch (e) {
        _showError('Ошибка проверки платежа: $e');
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
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
              const Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 60,
              ),
              const SizedBox(height: 15),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context, {'success': false, 'error': message});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Закрыть',
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
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, {'success': false, 'error': 'Отменено пользователем'});
          },
        ),
        title: const Text(
          'Оплата',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: 'Montserrat',
            color: Colors.white,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.all(15),
            color: AppColors.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'К оплате:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Montserrat',
                    color: Colors.white70,
                  ),
                ),
                Text(
                  YookassaService.formatAmount(widget.amount),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Подготовка платежа...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat',
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : WebViewWidget(controller: _webViewController),
    );
  }
}