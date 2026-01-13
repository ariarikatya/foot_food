import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';

/// Экран добавления карты (Скрин "Если карта не добавлена")
class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();

  bool _rememberCard = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  Future<void> _addCard() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Логика добавления карты
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Карта успешно добавлена!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

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
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildTitle(),
                        const SizedBox(height: 30),
                        _buildCardNumberField(),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: _buildExpiryField()),
                            const SizedBox(width: 15),
                            Expanded(child: _buildCVCField()),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildRememberCardToggle(),
                        const SizedBox(height: 40),
                        _buildAddButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
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
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Добавьте карту',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        fontFamily: 'Montserrat',
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildCardNumberField() {
    return CustomTextField(
      controller: _cardNumberController,
      hintText: 'Номер карты',
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16),
        _CardNumberFormatter(),
      ],
      validator: (v) {
        if (v == null || v.isEmpty) return 'Введите номер карты';
        final digitsOnly = v.replaceAll(' ', '');
        if (digitsOnly.length != 16) return 'Неверный номер карты';
        return null;
      },
    );
  }

  Widget _buildExpiryField() {
    return CustomTextField(
      controller: _expiryController,
      hintText: 'Срок действия',
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
        _ExpiryDateFormatter(),
      ],
      validator: (v) {
        if (v == null || v.isEmpty) return 'Введите срок';
        if (v.length != 5) return 'ММ/ГГ';
        return null;
      },
    );
  }

  Widget _buildCVCField() {
    return CustomTextField(
      controller: _cvcController,
      hintText: 'CVC',
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      validator: (v) {
        if (v == null || v.isEmpty) return 'Введите CVC';
        if (v.length != 3) return 'Неверный CVC';
        return null;
      },
    );
  }

  Widget _buildRememberCardToggle() {
    return Row(
      children: [
        const Text(
          'Запомнить карту',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        Switch(
          value: _rememberCard,
          onChanged: (value) {
            setState(() => _rememberCard = value);
          },
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return CustomButton(
      text: 'Добавить',
      fontSize: 28,
      fontWeight: FontWeight.w500,
      onPressed: _addCard,
    );
  }
}

/// Форматтер для номера карты (#### #### #### ####)
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Форматтер для срока действия (ММ/ГГ)
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.length > 2 && !text.contains('/')) {
      final formatted = '${text.substring(0, 2)}/${text.substring(2)}';
      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    return newValue;
  }
}
