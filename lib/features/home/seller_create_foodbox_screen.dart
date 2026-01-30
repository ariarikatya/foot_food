import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../data/models/order_model.dart';
import '../../../data/services/mock_api_service.dart';
import 'dart:math';

class SellerCreateFoodboxScreen extends StatefulWidget {
  final int sellerId;

  const SellerCreateFoodboxScreen({
    super.key,
    required this.sellerId,
  });

  @override
  State<SellerCreateFoodboxScreen> createState() => _SellerCreateFoodboxScreenState();
}

class _SellerCreateFoodboxScreenState extends State<SellerCreateFoodboxScreen> {
  final _formKey = GlobalKey<FormState>();
  final MockApiService _apiService = MockApiService();

  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _compositionController = TextEditingController();

  DateTime? _cookingTime;
  DateTime? _saleTime;
  DateTime? _endTime;

  bool _isLoading = false;

  @override
  void dispose() {
    _priceController.dispose();
    _descriptionController.dispose();
    _compositionController.dispose();
    super.dispose();
  }

  int _generateOrderNumber() {
    final random = Random();
    return 100000 + random.nextInt(900000); // 6-значное число
  }

  Future<void> _selectTime(BuildContext context, String type) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );

      setState(() {
        switch (type) {
          case 'cooking':
            _cookingTime = selectedDateTime;
            break;
          case 'sale':
            _saleTime = selectedDateTime;
            break;
          case 'end':
            _endTime = selectedDateTime;
            break;
        }
      });
    }
  }

  String _formatTime(DateTime? time) {
    if (time == null) return 'Выбрать время';
    return DateFormat('HH:mm').format(time);
  }

  Future<void> _createFoodbox() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_cookingTime == null || _saleTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Пожалуйста, заполните все временные поля'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final newOrder = OrderModel(
        id: 0, // Будет назначен сервером
        idSeller: widget.sellerId,
        numberOrder: _generateOrderNumber(),
        cookingTime: _cookingTime,
        saleTime: _saleTime,
        endTime: _endTime,
        compositionOrder: _compositionController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        numberReservation: 0, // Пока не забронирован
      );

      await _apiService.createOrder(newOrder);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foodbox успешно создан!'),
            backgroundColor: AppColors.primary,
          ),
        );
        Navigator.pop(context, true); // Возвращаем true для обновления списка
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка создания Foodbox: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
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
                const SizedBox(height: 30),
                const Text(
                  'Создать Foodbox',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 30),
                _buildTimeSelector(
                  'Время приготовления',
                  _cookingTime,
                  () => _selectTime(context, 'cooking'),
                ),
                const SizedBox(height: 20),
                _buildTimeSelector(
                  'Время выставления на продажу',
                  _saleTime,
                  () => _selectTime(context, 'sale'),
                ),
                const SizedBox(height: 20),
                _buildTimeSelector(
                  'Время окончания продажи',
                  _endTime,
                  () => _selectTime(context, 'end'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _compositionController,
                  decoration: InputDecoration(
                    labelText: 'Внутри',
                    labelStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'Montserrat',
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Заполните состав';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Описание',
                    labelStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'Montserrat',
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Заполните описание';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Цена (₽)',
                    labelStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'Montserrat',
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: AppColors.primary, width: 1),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Укажите цену';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Введите корректную цену';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Цена должна быть больше 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: _isLoading ? 'Создание...' : 'Создать',
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  onPressed: _isLoading ? null : _createFoodbox,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelector(String label, DateTime? time, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Row(
              children: [
                Text(
                  _formatTime(time),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                    color: time != null ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.access_time,
                  color: AppColors.primary,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}