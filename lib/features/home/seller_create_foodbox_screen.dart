import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';

/// Экран создания foodbox для продавца (Экран 7)
class SellerCreateFoodboxScreen extends StatefulWidget {
  const SellerCreateFoodboxScreen({super.key});

  @override
  State<SellerCreateFoodboxScreen> createState() =>
      _SellerCreateFoodboxScreenState();
}

class _SellerCreateFoodboxScreenState extends State<SellerCreateFoodboxScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  final _cookingTimeController = TextEditingController();
  final _saleEndTimeController = TextEditingController();
  bool _compositionEnabled = false;
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _cookingTimeController.dispose();
    _saleEndTimeController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  Future<void> _createFoodbox() async {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foodbox создан успешно!'),
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
            image: AssetImage('assets/images/selladd.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  _buildTitle(),
                  const SizedBox(height: 30),
                  _buildCookingTimeField(),
                  const SizedBox(height: 30),
                  _buildSaleEndTimeField(),
                  const SizedBox(height: 30),
                  _buildCompositionToggle(),
                  const SizedBox(height: 30),
                  _buildDescriptionField(),
                  const SizedBox(height: 30),
                  _buildPriceField(),
                  const SizedBox(height: 10),
                  _buildTotalPrice(),
                  const SizedBox(height: 40),
                  _buildCreateButton(),
                  const SizedBox(height: 180),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Создать foodbox',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        fontFamily: 'Montserrat',
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildCookingTimeField() {
    return GestureDetector(
      onTap: () => _selectTime(context, _cookingTimeController),
      child: AbsorbPointer(
        child: CustomTextField(
          controller: _cookingTimeController,
          hintText: 'Время приготовления',
          validator: (v) =>
              v == null || v.isEmpty ? 'Укажите время приготовления' : null,
        ),
      ),
    );
  }

  Widget _buildSaleEndTimeField() {
    return GestureDetector(
      onTap: () => _selectTime(context, _saleEndTimeController),
      child: AbsorbPointer(
        child: CustomTextField(
          controller: _saleEndTimeController,
          hintText: 'В продаже до',
          validator: (v) => v == null || v.isEmpty ? 'Укажите время' : null,
        ),
      ),
    );
  }

  Widget _buildCompositionToggle() {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: _OuterShadowPainter(radius: AppSpacing.radiusLg),
          ),
        ),
        Container(
          constraints: const BoxConstraints(minHeight: 60),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border, width: 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              const Text(
                'Состав',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                  color: Color(0xFF1A1C1B),
                ),
              ),
              const Spacer(),
              Switch(
                value: _compositionEnabled,
                onChanged: (value) {
                  setState(() => _compositionEnabled = value);
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      child: TextField(
        controller: _descriptionController,
        maxLines: null,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          color: Color(0xFF1A1C1B),
          fontFamily: 'Montserrat',
        ),
        decoration: InputDecoration(
          hintText: 'Описание',
          hintStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1A1C1B),
            fontFamily: 'Montserrat',
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.3),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: AppColors.border, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: AppColors.border, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: AppColors.border, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceField() {
    return CustomTextField(
      controller: _priceController,
      hintText: 'Стоимость',
      keyboardType: TextInputType.number,
      validator: (v) {
        if (v == null || v.isEmpty) return 'Укажите стоимость';
        if (double.tryParse(v) == null) return 'Неверный формат';
        return null;
      },
    );
  }

  Widget _buildTotalPrice() {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        'Итоговая стоимость: ${_priceController.text.isEmpty ? "0" : _priceController.text} ₽',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          fontFamily: 'Montserrat',
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return CustomButton(
      text: 'Создать',
      fontSize: 28,
      fontWeight: FontWeight.w500,
      onPressed: _createFoodbox,
    );
  }
}

class _OuterShadowPainter extends CustomPainter {
  final double radius;

  _OuterShadowPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    canvas.saveLayer(
      Rect.fromLTWH(-50, -50, size.width + 100, size.height + 100),
      Paint(),
    );

    final shadowPaint = Paint()
      ..color = const Color(0x4D051F20)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12 / 2);

    canvas.translate(4, 8);
    canvas.drawRRect(rrect, shadowPaint);
    canvas.translate(-4, -8);

    final cutPaint = Paint()
      ..blendMode = BlendMode.dstOut
      ..color = Colors.black;

    canvas.drawRRect(rrect, cutPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
