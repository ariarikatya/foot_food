import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';

/// Экран редактирования данных продавца
class SellerEditDataScreen extends StatefulWidget {
  final String nameRestaurant;
  final String email;
  final String address;

  const SellerEditDataScreen({
    super.key,
    required this.nameRestaurant,
    required this.email,
    required this.address,
  });

  @override
  State<SellerEditDataScreen> createState() => _SellerEditDataScreenState();
}

class _SellerEditDataScreenState extends State<SellerEditDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _restaurantNameController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
    _restaurantNameController.text = widget.nameRestaurant;
    _addressController.text = widget.address;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _restaurantNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // Имитация обновления данных
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Данные успешно обновлены'),
            backgroundColor: AppColors.success,
          ),
        );

        Navigator.pop(context);
      }
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
            image: AssetImage('assets/images/regsell.png'),
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
                        const SizedBox(height: 40),
                        _buildTitle(),
                        const SizedBox(height: 30),
                        _buildEmailField(),
                        const SizedBox(height: 30),
                        _buildRestaurantNameField(),
                        const SizedBox(height: 30),
                        _buildAddressField(),
                        const SizedBox(height: 40),
                        _buildUpdateButton(),
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
          const Spacer(),
          Image.asset(
            'assets/images/logodark.png',
            width: 71,
            height: 41,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Редактирование данных',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        fontFamily: 'Montserrat',
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      controller: _emailController,
      hintText: 'Email',
      keyboardType: TextInputType.emailAddress,
      validator: (v) => v != null && v.contains('@') ? null : 'Неверный email',
    );
  }

  Widget _buildRestaurantNameField() {
    return CustomTextField(
      controller: _restaurantNameController,
      hintText: 'Название ресторана',
      validator: (v) =>
          v != null && v.length >= 6 ? null : 'Минимум 6 символов',
    );
  }

  Widget _buildAddressField() {
    return CustomTextField(
      controller: _addressController,
      hintText: 'Адрес',
      validator: (v) => v != null && v.isNotEmpty ? null : 'Введите адрес',
    );
  }

  Widget _buildUpdateButton() {
    return CustomButton(
      text: 'Изменить',
      fontSize: 28,
      fontWeight: FontWeight.w500,
      onPressed: _isLoading ? null : _handleUpdate,
      isLoading: _isLoading,
    );
  }
}
