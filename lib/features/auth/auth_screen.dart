import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/custom_button.dart';

/// Экран выбора типа регистрации
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/reg:auth.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Логотип
                Image.asset(
                  'assets/images/logodark.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Кнопки регистрации
                CustomButton(
                  text: 'Регистрация',
                  onPressed: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                ),

                const SizedBox(height: AppSpacing.md),

                CustomButton(
                  text: 'Авторизация',
                  isOutlined: true,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                ),

                const Spacer(),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
