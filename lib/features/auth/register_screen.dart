import 'package:flutter/material.dart';
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

  // Тип пользователя: true - покупатель, false - продавец
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
      // Здесь логика регистрации
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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

                      // Динамическое содержимое в зависимости от типа
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
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Spacer(),
          Text(
            'Foot\nFood',
            style: AppTextStyles.h3.copyWith(height: 1.2),
            textAlign: TextAlign.right,
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

  // ========== ФОРМА ПОКУПАТЕЛЯ ==========

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

  // ========== ФОРМА ПРОДАВЦА ==========

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

  // ========== ПОЛЯ ВВОДА ==========

  Widget _buildPhoneField() {
    return CustomTextField(
      controller: _phoneController,
      hintText: '+7 (   )  -  -',
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Введите номер телефона';
        }
        // Убираем все нецифровые символы
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
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
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
      onTap: () {
        // TODO: Загрузить логотип
      },
      suffixIcon: IconButton(
        icon: const Icon(Icons.attach_file, color: AppColors.primary),
        onPressed: () {
          // TODO: Загрузить логотип
        },
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
              return null; // Не показываем ошибку здесь
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
      height: 70,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSpacing.radiusLg),
          topRight: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon: Icons.person,
            isSelected: _isBuyer,
            onTap: () {
              setState(() {
                _isBuyer = true;
              });
            },
          ),
          _buildNavItem(
            icon: Icons.restaurant,
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
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.backgroundWhite : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.textWhite,
          size: 30,
        ),
      ),
    );
  }
}

// ========== ЭКРАН КАРТЫ ДЛЯ ВЫБОРА АДРЕСА ==========

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
          // Карта (заглушка)
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

          // Маркер в центре
          const Center(
            child: Icon(Icons.location_on, size: 50, color: AppColors.primary),
          ),

          // Кнопка назад
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

          // Кнопка центрирования
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
                onPressed: () {
                  // TODO: Центрировать на текущей геолокации
                },
              ),
            ),
          ),

          // Нижняя панель с адресом
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                color: AppColors.backgroundWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.radiusLg),
                  topRight: Radius.circular(AppSpacing.radiusLg),
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
