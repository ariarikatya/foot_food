import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';

/// Единый экран регистрации с переключением типа пользователя
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isBuyer = true;

  // Контроллеры для покупателя
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Контроллеры для продавца
  final _emailController = TextEditingController();
  final _restaurantNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _logoController = TextEditingController();
  final _sellerPasswordController = TextEditingController();
  final _sellerConfirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _restaurantNameController.dispose();
    _addressController.dispose();
    _logoController.dispose();
    _sellerPasswordController.dispose();
    _sellerConfirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Пожалуйста, согласитесь с условиями'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _openMapForAddress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _AddressMapScreen(
          onAddressSelected: (address) {
            setState(() {
              _addressController.text = address;
            });
          },
        ),
      ),
    );
  }

  String get _backgroundImage {
    return _isBuyer ? 'assets/images/regcli.png' : 'assets/images/regsell.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_backgroundImage),
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
                        const SizedBox(height: AppSpacing.lg),
                        _buildHeader(),
                        const SizedBox(height: AppSpacing.xl),
                        _isBuyer ? _buildBuyerForm() : _buildSellerForm(),
                        const SizedBox(height: AppSpacing.xl),
                        _buildRegisterButton(),
                        const SizedBox(height: AppSpacing.md),
                        _buildTermsCheckbox(),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),
              ),
              _buildBottomNavigationBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
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
            width: 60,
            height: 60,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      _isBuyer ? 'Регистрация для покупателя' : 'Регистрация для продовца',
      style: AppTextStyles.h2,
    );
  }

  Widget _buildBuyerForm() {
    return Column(
      children: [
        _buildPhoneField(),
        const SizedBox(height: AppSpacing.md),
        _buildPasswordField(
          controller: _passwordController,
          hintText: 'Пароль',
          obscureText: _obscurePassword,
          onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildConfirmPasswordField(
          controller: _confirmPasswordController,
          passwordController: _passwordController,
          hintText: 'Павтор пароля',
          obscureText: _obscureConfirmPassword,
          onToggle: () => setState(
            () => _obscureConfirmPassword = !_obscureConfirmPassword,
          ),
        ),
      ],
    );
  }

  Widget _buildSellerForm() {
    return Column(
      children: [
        _buildEmailField(),
        const SizedBox(height: AppSpacing.md),
        _buildRestaurantNameField(),
        const SizedBox(height: AppSpacing.md),
        _buildAddressField(),
        const SizedBox(height: AppSpacing.md),
        _buildLogoField(),
        const SizedBox(height: AppSpacing.md),
        _buildPasswordField(
          controller: _sellerPasswordController,
          hintText: 'Пароль',
          obscureText: _obscurePassword,
          onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildConfirmPasswordField(
          controller: _sellerConfirmPasswordController,
          passwordController: _sellerPasswordController,
          hintText: 'Павтор пароля',
          obscureText: _obscureConfirmPassword,
          onToggle: () => setState(
            () => _obscureConfirmPassword = !_obscureConfirmPassword,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return CustomTextField(
      controller: _phoneController,
      hintText: '+7 (   )  -  -',
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Введите номер телефона';
        }
        final digits = value.replaceAll(RegExp(r'\D'), '');
        if (digits.length < 11) {
          return 'Номер должен содержать 11 цифр';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      controller: _emailController,
      hintText: 'Email',
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Введите email';
        }
        if (!value.contains('@')) {
          return 'Неверный формат email';
        }
        return null;
      },
    );
  }

  Widget _buildRestaurantNameField() {
    return CustomTextField(
      controller: _restaurantNameController,
      hintText: 'Asdfg',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Введите название ресторана';
        }
        if (value.length < 6) {
          return 'Минимум 6 символов';
        }
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return CustomTextField(
      controller: _addressController,
      hintText: 'Добавить адрес',
      readOnly: true,
      onTap: _openMapForAddress,
      suffixIcon: GestureDetector(
        onTap: _openMapForAddress,
        child: Container(
          margin: const EdgeInsets.all(AppSpacing.sm),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: const Text(
            'Карта',
            style: TextStyle(
              color: AppColors.textWhite,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Выберите адрес на карте';
        }
        return null;
      },
    );
  }

  Widget _buildLogoField() {
    return CustomTextField(
      controller: _logoController,
      hintText: 'Логотип',
      readOnly: true,
      onTap: () {},
      suffixIcon: IconButton(
        icon: const Icon(Icons.attach_file, color: AppColors.primary),
        onPressed: () {},
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Введите пароль';
        }
        if (value.length < 6) {
          return 'Минимум 6 символов';
        }
        return null;
      },
      suffixIcon: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
        ),
        onPressed: onToggle,
      ),
    );
  }

  Widget _buildConfirmPasswordField({
    required TextEditingController controller,
    required TextEditingController passwordController,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: controller,
          hintText: hintText,
          obscureText: obscureText,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Повторите пароль';
            }
            if (value != passwordController.text) {
              return null;
            }
            return null;
          },
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: AppColors.textSecondary,
            ),
            onPressed: onToggle,
          ),
        ),
        if (controller.text.isNotEmpty &&
            controller.text != passwordController.text)
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.sm,
              left: AppSpacing.md,
            ),
            child: Text(
              'Пароли не совпадают',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return CustomButton(text: 'Зарегистрироваться', onPressed: _handleRegister);
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreedToTerms,
            onChanged: (value) {
              setState(() {
                _agreedToTerms = value ?? false;
              });
            },
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _agreedToTerms = !_agreedToTerms;
              });
            },
            child: Text(
              'Нажимая кнопку "Зарегистрироваться", вы соглашаетесь с политикой конфиденциальности и условиями пользовательского соглашения',
              style: AppTextStyles.bodySmall.copyWith(height: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.bottomNavBar,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            iconPath: 'assets/images/icon people.svg',
            isSelected: _isBuyer,
            onTap: () {
              setState(() {
                _isBuyer = true;
              });
            },
          ),
          _buildNavItem(
            iconPath: 'assets/images/icon coin.svg',
            isSelected: !_isBuyer,
            onTap: () {
              setState(() {
                _isBuyer = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.backgroundWhite : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            width: 35,
            height: 35,
            colorFilter: ColorFilter.mode(
              isSelected ? AppColors.primary : AppColors.textWhite,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

class _AddressMapScreen extends StatefulWidget {
  final Function(String) onAddressSelected;

  const _AddressMapScreen({required this.onAddressSelected});

  @override
  State<_AddressMapScreen> createState() => _AddressMapScreenState();
}

class _AddressMapScreenState extends State<_AddressMapScreen> {
  String _selectedAddress = 'Пермь\nулица Революции, 13';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.grey[300],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 100, color: Colors.grey[400]),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Карта будет здесь',
                    style: AppTextStyles.h3.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Интеграция с Google Maps / Yandex Maps',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Center(
            child: Icon(Icons.location_on, size: 50, color: AppColors.primary),
          ),
          Positioned(
            top: 60,
            left: AppSpacing.lg,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          Positioned(
            top: 60,
            right: AppSpacing.lg,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundWhite,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.my_location, color: AppColors.primary),
                onPressed: () {},
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Адрес вашего ресторна', style: AppTextStyles.h3),
                    const SizedBox(height: AppSpacing.md),
                    Text(_selectedAddress, style: AppTextStyles.bodyLarge),
                    const SizedBox(height: AppSpacing.lg),
                    CustomButton(
                      text: 'Готово',
                      onPressed: () {
                        widget.onAddressSelected(_selectedAddress);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
