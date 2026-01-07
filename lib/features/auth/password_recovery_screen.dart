import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import 'widgets/user_type_toggle.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _isBuyer = true;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleRecovery() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isBuyer
                  ? 'Инструкции отправлены на ваш номер'
                  : 'Инструкции отправлены на вашу почту',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }

      setState(() => _isLoading = false);
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
            image: AssetImage('assets/images/auth.png'),
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
                        const SizedBox(height: AppSpacing.xl),
                        _buildHeader(),
                        const SizedBox(height: AppSpacing.md),
                        _buildDescription(),
                        const SizedBox(height: AppSpacing.md),
                        UserTypeToggle(
                          isBuyer: _isBuyer,
                          onBuyerTap: () => setState(() => _isBuyer = true),
                          onSellerTap: () => setState(() => _isBuyer = false),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        _buildInputField(),
                        const SizedBox(height: AppSpacing.xl),
                        CustomButton(
                          text: 'Отправить',
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          onPressed: _isLoading ? null : _handleRecovery,
                          isLoading: _isLoading,
                        ),
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
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
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
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'Восстановление пароля',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        fontFamily: 'Montserrat',
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      _isBuyer
          ? 'Введите номер телефона, и мы отправим инструкции по восстановлению пароля'
          : 'Введите email, и мы отправим инструкции по восстановлению пароля',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        fontFamily: 'Montserrat',
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildInputField() {
    if (_isBuyer) {
      return CustomTextField(
        controller: _phoneController,
        hintText: 'Номер телефона',
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Введите номер телефона';
          }
          return null;
        },
      );
    } else {
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
  }
}
