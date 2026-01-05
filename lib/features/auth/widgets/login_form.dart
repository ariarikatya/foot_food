import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/custom_text_field.dart';

/// Форма авторизации
class LoginForm extends StatelessWidget {
  final TextEditingController loginController;
  final TextEditingController passwordController;
  final bool isBuyer;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;

  const LoginForm({
    super.key,
    required this.loginController,
    required this.passwordController,
    required this.isBuyer,
    required this.obscurePassword,
    required this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: loginController,
          hintText: isBuyer ? 'Номер телефона' : 'Email',
          keyboardType: isBuyer
              ? TextInputType.phone
              : TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return isBuyer ? 'Введите номер телефона' : 'Введите email';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          controller: passwordController,
          hintText: 'Пароль',
          obscureText: obscurePassword,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Введите пароль';
            }
            return null;
          },
          suffixIcon: IconButton(
            icon: Icon(
              obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: AppColors.textSecondary,
            ),
            onPressed: onTogglePassword,
          ),
        ),
      ],
    );
  }
}
