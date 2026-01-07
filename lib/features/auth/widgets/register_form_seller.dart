import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/custom_text_field.dart';

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

/// Форма регистрации продавца
class RegisterFormSeller extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController restaurantNameController;
  final TextEditingController addressController;
  final TextEditingController logoController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPasswordFocusNode;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onAddressFieldTap;
  final VoidCallback onLogoFieldTap;

  const RegisterFormSeller({
    super.key,
    required this.emailController,
    required this.restaurantNameController,
    required this.addressController,
    required this.logoController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.passwordFocusNode,
    required this.confirmPasswordFocusNode,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onAddressFieldTap,
    required this.onLogoFieldTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: emailController,
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
          validator: (v) =>
              v != null && v.contains('@') ? null : 'Неверный email',
        ),
        const SizedBox(height: 30),
        CustomTextField(
          controller: restaurantNameController,
          hintText: 'Название ресторана',
          validator: (v) =>
              v != null && v.length >= 6 ? null : 'Минимум 6 символов',
        ),
        const SizedBox(height: 30),
        _AddressField(controller: addressController, onTap: onAddressFieldTap),
        const SizedBox(height: 30),
        _LogoField(controller: logoController, onTap: onLogoFieldTap),
        const SizedBox(height: 30),
        _PasswordField(
          controller: passwordController,
          focusNode: passwordFocusNode,
          obscureText: obscurePassword,
          onToggle: onTogglePassword,
        ),
        const SizedBox(height: 30),
        _ConfirmPasswordField(
          controller: confirmPasswordController,
          focusNode: confirmPasswordFocusNode,
          originalPasswordController: passwordController,
          obscureText: obscureConfirmPassword,
          onToggle: onToggleConfirmPassword,
        ),
      ],
    );
  }
}

class _AddressField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;

  const _AddressField({required this.controller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: 'Добавить адрес',
      readOnly: true,
      onTap: onTap,
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
    );
  }
}

class _LogoField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;

  const _LogoField({required this.controller, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _OuterShadowPainter(radius: AppSpacing.radiusLg),
            ),
          ),
          Container(
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
                    controller.text.isEmpty ? 'Логотип' : controller.text,
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
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.controller,
    required this.focusNode,
    required this.obscureText,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      focusNode: focusNode,
      hintText: 'Пароль',
      obscureText: obscureText,
      validator: (v) {
        if (v == null || v.isEmpty) return 'Введите пароль';
        if (v.length < 6) return 'Минимум 6 символов';
        return null;
      },
      suffixIcon: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: onToggle,
      ),
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextEditingController originalPasswordController;
  final bool obscureText;
  final VoidCallback onToggle;

  const _ConfirmPasswordField({
    required this.controller,
    required this.focusNode,
    required this.originalPasswordController,
    required this.obscureText,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      focusNode: focusNode,
      hintText: 'Повтор пароля',
      obscureText: obscureText,
      validator: (v) {
        if (v == null || v.isEmpty) return 'Повторите пароль';
        if (v != originalPasswordController.text) return 'Пароли не совпадают';
        return null;
      },
      suffixIcon: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: onToggle,
      ),
    );
  }
}
