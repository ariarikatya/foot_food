import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../data/services/mock_api_service.dart';

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
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              _isBuyer
                                  ? 'Регистрация для покупателя'
                                  : 'Регистрация для продавца',
                              style: AppTextStyles.h2,
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            _isBuyer ? _buildBuyerForm() : _buildSellerForm(),
                            const SizedBox(height: AppSpacing.xl),
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
            width: _isBuyer ? 223 : 71,
            height: _isBuyer ? 128 : 41,
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
          hintText: '+7 (   )  -  -',
          keyboardType: TextInputType.phone,
          validator: (v) =>
              v == null || v.isEmpty ? 'Введите номер телефона' : null,
        ),
        const SizedBox(height: AppSpacing.md),
        _passwordField(_passwordController),
        const SizedBox(height: AppSpacing.md),
        _confirmPasswordField(_confirmPasswordController, _passwordController),
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
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          controller: _restaurantNameController,
          hintText: 'Название ресторана',
          validator: (v) =>
              v != null && v.length >= 6 ? null : 'Минимум 6 символов',
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          controller: _addressController,
          hintText: 'Добавить адрес',
          readOnly: true,
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          controller: _logoController,
          hintText: 'Логотип',
          readOnly: true,
        ),
        const SizedBox(height: AppSpacing.md),
        _passwordField(_sellerPasswordController),
        const SizedBox(height: AppSpacing.md),
        _confirmPasswordField(
          _sellerConfirmPasswordController,
          _sellerPasswordController,
        ),
      ],
    );
  }

  Widget _passwordField(TextEditingController controller) {
    return CustomTextField(
      controller: controller,
      hintText: 'Пароль',
      obscureText: _obscurePassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
        ),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      ),
    );
  }

  Widget _confirmPasswordField(
    TextEditingController controller,
    TextEditingController original,
  ) {
    return CustomTextField(
      controller: controller,
      hintText: 'Повтор пароля',
      obscureText: _obscureConfirmPassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
        ),
        onPressed: () =>
            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
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
    const double circleSize = 85;
    const double circleOverlap = 36;

    return SizedBox(
      height: barHeight + bottomInset + 50, // место под текст
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
            left: width * 0.25 - circleSize / 2,
            bottom: barHeight - circleOverlap,
            child: _buildFloatingNavItem(
              iconPath: 'assets/images/icon people.svg',
              isSelected: _isBuyer,
              onTap: () => setState(() => _isBuyer = true),
            ),
          ),

          // ПРАВЫЙ КРУГ
          Positioned(
            left: width * 0.75 - circleSize / 2,
            bottom: barHeight - circleOverlap,
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

  Widget _navItem(String icon, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.bottomNavBar,
          shape: BoxShape.circle,
          border: null,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: SvgPicture.asset(
            icon,
            width: 34,
            height: 34,
            colorFilter: const ColorFilter.mode(
              AppColors.textWhite,
              BlendMode.srcIn,
            ),
          ),
        ),
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

    final double horizontalOffset = -6.0; // сдвиг выемки влево

    final double centerX =
        size.width * (isLeft ? 0.25 : 0.75) + horizontalOffset;

    final double radius = circleSize / 2.2;

    // Верх выемки (она ВЫШЕ начала прямоугольника)
    final double notchTop = 18.0;

    // Насколько глубоко выемка заходит в круг
    final double notchDepth = 23.0;

    path.moveTo(0, 0);

    // До начала выемки
    path.lineTo(centerX - radius - 16, 0);

    // Левая часть выемки (вверх)
    path.cubicTo(
      centerX - radius + 2,
      0,
      centerX - radius,
      notchTop + notchDepth,
      centerX,
      notchTop + notchDepth,
    );

    // Правая часть выемки
    path.cubicTo(
      centerX + radius,
      notchTop + notchDepth,
      centerX + radius - 2,
      0,
      centerX + radius + 16,
      0,
    );

    // Остальная часть прямоугольника
    path.lineTo(size.width, 0);
    path.lineTo(size.width, barHeight);
    path.lineTo(0, barHeight);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BottomNavClipper oldClipper) => oldClipper.isLeft != isLeft;
}

class BottomNavPainter extends CustomPainter {
  final bool leftActive;
  final Color backgroundColor;

  BottomNavPainter({required this.leftActive, required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final path = Path();

    final double centerX = size.width * (leftActive ? 0.25 : 0.75);

    const double r = 35;
    const double depth = 22;

    path.moveTo(0, 0);
    path.lineTo(centerX - r, 0);

    path.quadraticBezierTo(centerX, depth * 2, centerX + r, 0);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BottomNavPainter oldDelegate) {
    return oldDelegate.leftActive != leftActive;
  }
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
                    Text('Адрес вашего ресторна', style: AppTextStyles.h3),
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
