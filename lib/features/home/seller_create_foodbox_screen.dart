import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  List<String> _selectedPhotos = [];

  @override
  void dispose() {
    _cookingTimeController.dispose();
    _saleEndTimeController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        imageQuality: 85,
      );

      if (images.isNotEmpty) {
        setState(() {
          _selectedPhotos = images.map((img) => img.path).toList();
        });
      }
    } catch (e) {
      _showError('Ошибка выбора изображений: $e');
    }
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
      // Здесь будет логика создания foodbox
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foodbox создан успешно!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Вернуться на главный экран
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
          child: Column(
            children: [
              _buildHeader(),
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
                        _buildCookingTimeField(),
                        const SizedBox(height: 30),
                        _buildSaleEndTimeField(),
                        const SizedBox(height: 30),
                        _buildCompositionToggle(),
                        const SizedBox(height: 30),
                        _buildDescriptionField(),
                        const SizedBox(height: 30),
                        _buildPriceField(),
                        const SizedBox(height: 30),
                        _buildPhotoSection(),
                        const SizedBox(height: 40),
                        _buildCreateButton(),
                        const SizedBox(height: 180), // Место для навигации
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

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x59000000),
            offset: const Offset(0, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 17),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset(
                'assets/images/Vector.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF7FA29A),
                  BlendMode.srcIn,
                ),
              ),
            ),
            const Spacer(),
            const Text(
              'Создать foodbox',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
                color: Color(0xFF7FA29A),
              ),
            ),
            const Spacer(),
            const SizedBox(width: 24), // Баланс с кнопкой назад
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Создать foodbox',
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
          suffixIcon: const Icon(Icons.access_time, color: AppColors.primary),
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
          suffixIcon: const Icon(Icons.access_time, color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildCompositionToggle() {
    return Row(
      children: [
        const Text(
          'Состав',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
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
    );
  }

  Widget _buildDescriptionField() {
    return CustomTextField(
      controller: _descriptionController,
      hintText: 'Описание',
      maxLines: 4,
      validator: (v) => v == null || v.isEmpty ? 'Добавьте описание' : null,
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
      suffixIcon: const Padding(
        padding: EdgeInsets.only(right: 16, top: 16),
        child: Text(
          '₽',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Фото:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        if (_selectedPhotos.isEmpty)
          _buildAddPhotoButton()
        else
          _buildPhotoGrid(),
      ],
    );
  }

  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: _pickImages,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border, width: 2),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, size: 48, color: AppColors.primary),
            SizedBox(height: 10),
            Text(
              'Добавить фото',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _selectedPhotos.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border, width: 2),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(Icons.image, size: 40, color: Colors.grey[600]),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPhotos.removeAt(index);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 15),
        TextButton.icon(
          onPressed: _pickImages,
          icon: const Icon(Icons.add),
          label: const Text('Добавить еще фото'),
        ),
      ],
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
