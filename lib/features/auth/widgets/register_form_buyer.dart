import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/phone_formatter.dart';

/// Форма регистрации покупателя
class RegisterFormBuyer extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode phoneFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPasswordFocusNode;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;

  const RegisterFormBuyer({
    super.key,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.phoneFocusNode,
    required this.passwordFocusNode,
    required this.confirmPasswordFocusNode,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: phoneController,
          focusNode: phoneFocusNode,
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
