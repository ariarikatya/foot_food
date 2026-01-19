import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/custom_text_field.dart';

/// Диалог добавления карты
class AddCardDialog extends StatefulWidget {
  final bool hasCard; // Есть ли уже сохраненная карта

  const AddCardDialog({super.key, this.hasCard = false});

  @override
  State<AddCardDialog> createState() => _AddCardDialogState();
}

class _AddCardDialogState extends State<AddCardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _addCard() async {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.hasCard ? 'Карта изменена!' : 'Карта сохранена!',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 46),
      child: Container(
        decoration: BoxDecoration(
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
          mainAxisSize: MainAxisSize.min,
          children: [
            // Верхняя белая часть с формой
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            color: AppColors.textPrimary,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildCardNumberField(),
                    const SizedBox(height: 15),
                    _buildNameField(),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(child: _buildExpiryField()),
                        const SizedBox(width: 15),
                        Expanded(child: _buildCVCField()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Нижняя темно-зеленая кнопка
            Container(
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
                  onTap: _addCard,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      widget.hasCard ? 'Изменить' : 'Сохранить',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Jura',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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

  Widget _buildNameField() {
    return CustomTextField(
      controller: _nameController,
      hintText: 'Имя владельца',
      keyboardType: TextInputType.text,
      validator: (v) {
        if (v == null || v.isEmpty) return 'Введите имя';
        return null;
      },
    );
  }

  Widget _buildExpiryField() {
    return CustomTextField(
      controller: _expiryController,
      hintText: 'ММ/ГГ',
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
        if (v == null || v.isEmpty) return 'CVC';
        if (v.length != 3) return 'CVC';
        return null;
      },
    );
  }
}

/// Форматтер для номера карты
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

/// Форматтер для срока действия
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
