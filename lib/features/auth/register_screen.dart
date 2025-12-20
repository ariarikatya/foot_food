import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../data/services/mock_api_service.dart';

/// Форматтер для телефонного номера в формате +7 (XXX) XXX-XX-XX
class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Если пользователь удаляет всё
    if (text.isEmpty || text == '+' || text == '+7' || text == '+7 ') {
      return const TextEditingValue(
        text: '+7 (',
        selection: TextSelection.collapsed(offset: 4),
      );
    }

    // Если текст не начинается с +7 (, исправляем
    if (!text.startsWith('+7 (')) {
      return const TextEditingValue(
        text: '+7 (',
        selection: TextSelection.collapsed(offset: 4),
      );
    }

    // Извлекаем только цифры после +7 (, игнорируем всё кроме цифр 0-9
    String digitsOnly = '';
    for (int i = 4; i < text.length; i++) {
      final char = text[i];
      // Берём только цифры от 0 до 9
      if (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57) {
        digitsOnly += char;
      }
    }

    // Ограничиваем до 10 цифр
    if (digitsOnly.length > 10) {
      digitsOnly = digitsOnly.substring(0, 10);
    }

    // Формируем отформатированную строку
    final buffer = StringBuffer('+7 (');

    // Первые 3 цифры
    if (digitsOnly.isNotEmpty) {
      int end = digitsOnly.length > 3 ? 3 : digitsOnly.length;
      buffer.write(digitsOnly.substring(0, end));
    }

    buffer.write(') ');

    // Следующие 3 цифры
    if (digitsOnly.length > 3) {
      int end = digitsOnly.length > 6 ? 6 : digitsOnly.length;
      buffer.write(digitsOnly.substring(3, end));
    }

    buffer.write('-');

    // Следующие 2 цифры
    if (digitsOnly.length > 6) {
      int end = digitsOnly.length > 8 ? 8 : digitsOnly.length;
      buffer.write(digitsOnly.substring(6, end));
    }

    buffer.write('-');

    // Последние 2 цифры
    if (digitsOnly.length > 8) {
      buffer.write(digitsOnly.substring(8));
    }

    final formattedText = buffer.toString();

    // Позиция курсора после последней введенной цифры
    int cursorPosition = 4; // По умолчанию после +7 (

    if (digitsOnly.isNotEmpty) {
      if (digitsOnly.length <= 3) {
        cursorPosition = 4 + digitsOnly.length;
      } else if (digitsOnly.length <= 6) {
        cursorPosition = 9 + (digitsOnly.length - 3);
      } else if (digitsOnly.length <= 8) {
        cursorPosition = 13 + (digitsOnly.length - 6);
      } else {
        cursorPosition = 16 + (digitsOnly.length - 8);
      }
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = MockApiService();

  bool _isBuyer = true;
  bool _isLoading = false;
  bool _agreedToTerms = false;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Фокусы для текстовых полей
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _sellerPasswordFocusNode = FocusNode();
  final _sellerConfirmPasswordFocusNode = FocusNode();

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _emailController = TextEditingController();
  final _restaurantNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _logoController = TextEditingController();
  final _sellerPasswordController = TextEditingController();
  final _sellerConfirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Слушатели фокуса для телефона
    _phoneFocusNode.addListener(() {
      if (_phoneFocusNode.hasFocus && _phoneController.text.isEmpty) {
        setState(() {
          _phoneController.text = '+7 (';
          _phoneController.selection = TextSelection.collapsed(offset: 4);
        });
      }
    });
  }

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _sellerPasswordFocusNode.dispose();
    _sellerConfirmPasswordFocusNode.dispose();

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

  String get _backgroundImage =>
      _isBuyer ? 'assets/images/regcli.png' : 'assets/images/regsell.png';

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
          bottom: false,
          child: Stack(
            children: [
              Column(
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
                            Text(
                              _isBuyer
                                  ? 'Регистрация для покупателя'
                                  : 'Регистрация для продавца',
                              style: AppTextStyles.h2,
                            ),
                            SizedBox(height: _isBuyer ? 25 : 20),
                            _isBuyer ? _buildBuyerForm() : _buildSellerForm(),
                            SizedBox(height: _isBuyer ? 40 : 20),
                            CustomButton(
                              text: 'Зарегистрироваться',
                              onPressed: _isLoading ? null : _handleRegister,
                              isLoading: _isLoading,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _buildTermsCheckbox(),
                            const SizedBox(height: 160),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomNavigationBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: _isBuyer
          ? Column(
              children: [
                // Стрелка назад слева
                Row(
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
                  ],
                ),
                const SizedBox(height: 20),
                // Логотип по центру
                Center(
                  child: Image.asset(
                    'assets/images/logodark.png',
                    width: 223,
                    height: 128,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            )
          : Row(
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
                  width: 71,
                  height: 41,
                  fit: BoxFit.contain,
                ),
              ],
            ),
    );
  }

  Widget _buildBuyerForm() {
    return Column(
      children: [
        CustomTextField(
          controller: _phoneController,
          focusNode: _phoneFocusNode,
          hintText: 'Номер телефона',
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d\+\(\)\s\-]')),
            PhoneInputFormatter(),
          ],
          validator: (v) {
            if (v == null || v.isEmpty || v == '+7 (') {
              return 'Введите номер телефона';
            }
            if (v.length < 18) {
              return 'Введите полный номер телефона';
            }
            return null;
          },
        ),
        const SizedBox(height: 30),
        _passwordField(
          _passwordController,
          _passwordFocusNode,
          _obscurePassword,
          () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        const SizedBox(height: 30),
        _confirmPasswordField(
          _confirmPasswordController,
          _confirmPasswordFocusNode,
          _passwordController,
          _obscureConfirmPassword,
          () => setState(
            () => _obscureConfirmPassword = !_obscureConfirmPassword,
          ),
        ),
      ],
    );
  }

  Widget _buildSellerForm() {
    return Column(
      children: [
        CustomTextField(
          controller: _emailController,
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
          validator: (v) =>
              v != null && v.contains('@') ? null : 'Неверный email',
        ),
        const SizedBox(height: 30),
        CustomTextField(
          controller: _restaurantNameController,
          hintText: 'Название ресторана',
          validator: (v) =>
              v != null && v.length >= 6 ? null : 'Минимум 6 символов',
        ),
        const SizedBox(height: 30),
        CustomTextField(
          controller: _addressController,
          hintText: 'Добавить адрес',
          readOnly: true,
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddressMapScreen(
                  onAddressSelected: (address) {
                    setState(() {
                      _addressController.text = address;
                    });
                  },
                ),
              ),
            );
          },
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Карта',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        CustomTextField(
          controller: _logoController,
          hintText: 'Логотип',
          readOnly: true,
          suffixIcon: const Icon(Icons.attach_file, color: AppColors.primary),
        ),
        const SizedBox(height: 30),
        _passwordField(
          _sellerPasswordController,
          _sellerPasswordFocusNode,
          _obscurePassword,
          () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        const SizedBox(height: 30),
        _confirmPasswordField(
          _sellerConfirmPasswordController,
          _sellerConfirmPasswordFocusNode,
          _sellerPasswordController,
          _obscureConfirmPassword,
          () => setState(
            () => _obscureConfirmPassword = !_obscureConfirmPassword,
          ),
        ),
      ],
    );
  }

  Widget _passwordField(
    TextEditingController controller,
    FocusNode focusNode,
    bool obscure,
    VoidCallback onToggle,
  ) {
    return CustomTextField(
      controller: controller,
      focusNode: focusNode,
      hintText: 'Пароль',
      obscureText: obscure,
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
        ),
        onPressed: onToggle,
      ),
    );
  }

  Widget _confirmPasswordField(
    TextEditingController controller,
    FocusNode focusNode,
    TextEditingController original,
    bool obscure,
    VoidCallback onToggle,
  ) {
    return CustomTextField(
      controller: controller,
      focusNode: focusNode,
      hintText: 'Повтор пароля',
      obscureText: obscure,
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
        ),
        onPressed: onToggle,
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _agreedToTerms,
          onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
          activeColor: AppColors.primary,
        ),
        Expanded(
          child: Text('Согласен с условиями', style: AppTextStyles.bodySmall),
        ),
      ],
    );
  }

  Widget _buildFloatingNavItem({
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
          color: AppColors.bottomNavBar,
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            width: 35,
            height: 35,
            colorFilter: const ColorFilter.mode(
              AppColors.textWhite,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final bottomInset = media.padding.bottom;

    const double barHeight = 113;

    return SizedBox(
      height: barHeight + bottomInset + 50,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ФОН С ВЫЕМКОЙ
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: BottomNavClipper(isLeft: _isBuyer),
              child: Container(
                height: barHeight,
                color: AppColors.bottomNavBar,
                padding: EdgeInsets.only(bottom: bottomInset + 12),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Нажимая кнопку "Зарегистрироваться", вы соглашаетесь с политикой конфиденциальности и условиями пользовательского соглашения',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF7FA29A),
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ЛЕВЫЙ КРУГ
          Positioned(
            left: width * 0.25 - 35,
            bottom: barHeight - 36,
            child: _buildFloatingNavItem(
              iconPath: 'assets/images/icon people.svg',
              isSelected: _isBuyer,
              onTap: () => setState(() => _isBuyer = true),
            ),
          ),

          // ПРАВЫЙ КРУГ
          Positioned(
            left: width * 0.75 - 35,
            bottom: barHeight - 36,
            child: _buildFloatingNavItem(
              iconPath: 'assets/images/icon coin.svg',
              isSelected: !_isBuyer,
              onTap: () => setState(() => _isBuyer = false),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRegister() async {}
}

class BottomNavClipper extends CustomClipper<Path> {
  final bool isLeft;

  BottomNavClipper({required this.isLeft});

  static const double barHeight = 113;
  static const double circleSize = 85;
  static const double circleOverlap = 36;

  @override
  Path getClip(Size size) {
    final path = Path();

    final double centerX = size.width * (isLeft ? 0.25 : 0.75);
    final double radius = circleSize / 2.2;
    final double notchTop = 18.0;
    final double notchDepth = 23.0;

    // Начинаем путь
    path.moveTo(0, 0);

    // Левая часть до выемки - одинаковая ширина для обеих сторон
    path.lineTo(centerX - radius - 16, 0);

    // Левая часть выемки с радиусом скругления
    path.arcToPoint(
      Offset(centerX - radius + 4, 5),
      radius: const Radius.circular(5),
    );

    // Левая часть выемки (вверх)
    path.cubicTo(
      centerX - radius + 4,
      5,
      centerX - radius,
      notchTop + notchDepth,
      centerX,
      notchTop + notchDepth,
    );

    // Правая часть выемки
    path.cubicTo(
      centerX + radius,
      notchTop + notchDepth,
      centerX + radius - 4,
      5,
      centerX + radius - 4,
      5,
    );

    // Правая часть выемки с радиусом скругления
    path.arcToPoint(
      Offset(centerX + radius + 16, 0),
      radius: const Radius.circular(5),
    );

    // Правая часть до конца
    path.lineTo(size.width, 0);
    path.lineTo(size.width, barHeight);
    path.lineTo(0, barHeight);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BottomNavClipper oldClipper) => oldClipper.isLeft != isLeft;
}

// Экран выбора адреса на карте
class AddressMapScreen extends StatefulWidget {
  final Function(String) onAddressSelected;

  const AddressMapScreen({super.key, required this.onAddressSelected});

  @override
  State<AddressMapScreen> createState() => _AddressMapScreenState();
}

class _AddressMapScreenState extends State<AddressMapScreen> {
  String selectedAddress = 'Пермь\nулица Революции, 13';

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
                    Text('Адрес вашего ресторана', style: AppTextStyles.h3),
                    const SizedBox(height: AppSpacing.md),
                    Text(selectedAddress, style: AppTextStyles.bodyLarge),
                    const SizedBox(height: AppSpacing.lg),
                    CustomButton(
                      text: 'Готово',
                      onPressed: () {
                        widget.onAddressSelected(selectedAddress);
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
