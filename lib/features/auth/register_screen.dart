import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../data/services/mock_api_service.dart';

// --- ИСПРАВЛЕННЫЕ КЛАССЫ (ФОРМА "U" - КОВШ) ---

// --- ФИНАЛЬНЫЙ ВАРИАНТ (ПЛОТНЫЙ И МЯГКИЙ) ---

class NavShadowPainter extends CustomPainter {
  final bool isLeft;
  final Color color;
  NavShadowPainter({required this.isLeft, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = BottomNavClipper(isLeft: isLeft).getClip(size);
    final paint = Paint()
      ..color = color.withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawPath(path.shift(const Offset(0, -2)), paint);
  }

  @override
  bool shouldRepaint(NavShadowPainter old) => old.isLeft != isLeft;
}

class BottomNavClipper extends CustomClipper<Path> {
  final bool isLeft;

  BottomNavClipper({required this.isLeft});

  @override
  Path getClip(Size size) {
    final path = Path();

    final double centerX = size.width * (isLeft ? 0.25 : 0.75);

    // Параметры выреза

    const double radius = 36.5; // Ширина выреза

    const double depth = 40.0; // Глубина чаши

    const double smooth = 15.0; // Плечо скругления верхних углов (было 15.0)

    path.moveTo(0, 0);

    // 1. Подходим к вырезу

    path.lineTo(centerX - radius - smooth, 0);

    // 2. Левая сторона: один плавный переход от горизонтали к дну

    path.cubicTo(
      centerX - radius,

      0, // CP1

      centerX - radius,

      depth, // CP2

      centerX,

      depth, // Конец: центр дна
    );

    // 3. Правая сторона (зеркально)

    path.cubicTo(
      centerX + radius,

      depth,

      centerX + radius,

      0,

      centerX + radius + smooth,

      0,
    );

    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height);

    path.lineTo(0, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(BottomNavClipper old) => old.isLeft != isLeft;
}

// --- ОСНОВНОЙ КЛАСС ЭКРАНА ---

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

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _phoneFocusNode.addListener(() {
      if (_phoneFocusNode.hasFocus && _phoneController.text.isEmpty) {
        setState(() {
          _phoneController.text = '+7 (';
          _phoneController.selection = const TextSelection.collapsed(offset: 4);
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

  Future<void> _handleRegister() async {
    // Твоя логика регистрации
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _logoController.text = image.path.split('/').last;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка выбора изображения: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
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
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                color: AppColors.textPrimary,
                                fontFamily: 'Montserrat',
                              ),
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

  // --- ТВОИ МЕТОДЫ ИНТЕРФЕЙСА (ВОССТАНОВЛЕНО) ---

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: _isBuyer ? AppSpacing.md : 0,
      ),
      child: _isBuyer
          ? Column(
              children: [
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
          validator: (v) =>
              (v == null || v.length < 18) ? 'Введите полный номер' : null,
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
                  onAddressSelected: (address) =>
                      setState(() => _addressController.text = address),
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
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: AppColors.border, width: 2),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.attach_file,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _logoController.text.isEmpty
                        ? 'Логотип'
                        : _logoController.text,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1A1C1B),
                      fontFamily: 'Montserrat',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
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
  ) => CustomTextField(
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
  Widget _confirmPasswordField(
    TextEditingController controller,
    FocusNode focusNode,
    TextEditingController original,
    bool obscure,
    VoidCallback onToggle,
  ) => CustomTextField(
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
  Widget _buildTermsCheckbox() => Row(
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
    final width = MediaQuery.of(context).size.width;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    const double barHeight = 113;

    return SizedBox(
      height: barHeight + bottomInset + 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ТЕНЬ
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomPaint(
              size: Size(width, barHeight),
              painter: NavShadowPainter(isLeft: _isBuyer, color: Colors.black),
            ),
          ),
          // МЕНЮ
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
                alignment: Alignment.bottomCenter,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Нажимая кнопку "Зарегистрироваться", вы соглашаетесь с политикой конфиденциальности и условиями пользовательского соглашения',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
          // КРУГИ
          Positioned(
            left: width * 0.25 - 35,
            bottom: barHeight - 35,
            child: _buildFloatingNavItem(
              iconPath: 'assets/images/icon people.svg',
              isSelected: _isBuyer,
              onTap: () => setState(() => _isBuyer = true),
            ),
          ),
          Positioned(
            left: width * 0.75 - 35,
            bottom: barHeight - 35,
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
}

// --- ВОССТАНОВЛЕННЫЙ ЭКРАН КАРТЫ ---

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

class PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty || text == '+' || text == '+7' || text == '+7 ') {
      return const TextEditingValue(
        text: '+7 (',
        selection: TextSelection.collapsed(offset: 4),
      );
    }
    if (!text.startsWith('+7 (')) {
      return const TextEditingValue(
        text: '+7 (',
        selection: TextSelection.collapsed(offset: 4),
      );
    }
    String digitsOnly = '';
    for (int i = 4; i < text.length; i++) {
      final char = text[i];
      if (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57)
        digitsOnly += char;
    }
    if (digitsOnly.length > 10) digitsOnly = digitsOnly.substring(0, 10);
    final buffer = StringBuffer('+7 (');
    if (digitsOnly.isNotEmpty) {
      int end = digitsOnly.length > 3 ? 3 : digitsOnly.length;
      buffer.write(digitsOnly.substring(0, end));
    }
    buffer.write(') ');
    if (digitsOnly.length > 3) {
      int end = digitsOnly.length > 6 ? 6 : digitsOnly.length;
      buffer.write(digitsOnly.substring(3, end));
    }
    buffer.write('-');
    if (digitsOnly.length > 6) {
      int end = digitsOnly.length > 8 ? 8 : digitsOnly.length;
      buffer.write(digitsOnly.substring(6, end));
    }
    buffer.write('-');
    if (digitsOnly.length > 8) buffer.write(digitsOnly.substring(8));
    final formattedText = buffer.toString();
    int cursorPosition = 4;
    if (digitsOnly.isNotEmpty) {
      if (digitsOnly.length <= 3)
        cursorPosition = 4 + digitsOnly.length;
      else if (digitsOnly.length <= 6)
        cursorPosition = 9 + (digitsOnly.length - 3);
      else if (digitsOnly.length <= 8)
        cursorPosition = 13 + (digitsOnly.length - 6);
      else
        cursorPosition = 16 + (digitsOnly.length - 8);
    }
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
