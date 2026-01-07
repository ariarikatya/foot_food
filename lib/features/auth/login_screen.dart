import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/services/mock_api_service.dart';
import 'widgets/login_form.dart';
import 'widgets/user_type_toggle.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = MockApiService();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isBuyer = true;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        if (_isBuyer) {
          await _apiService.loginUser(
            phone: _loginController.text,
            password: _passwordController.text,
          );
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/buyer_home');
          }
        } else {
          await _apiService.loginSeller(
            email: _loginController.text,
            password: _passwordController.text,
          );
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/seller_home');
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка авторизации: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
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
                        UserTypeToggle(
                          isBuyer: _isBuyer,
                          onBuyerTap: () => setState(() => _isBuyer = true),
                          onSellerTap: () => setState(() => _isBuyer = false),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        LoginForm(
                          loginController: _loginController,
                          passwordController: _passwordController,
                          isBuyer: _isBuyer,
                          obscurePassword: _obscurePassword,
                          onTogglePassword: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _buildForgotPassword(),
                        const SizedBox(height: AppSpacing.xl),
                        CustomButton(
                          text: 'Войти',
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          onPressed: _isLoading ? null : _handleLogin,
                          isLoading: _isLoading,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _buildRegisterLink(),
                        const SizedBox(height: AppSpacing.lg),
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
    return Text(
      _isBuyer ? 'Авторизация покупателя' : 'Авторизация продавца',
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w300,
        fontFamily: 'Montserrat',
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/password_recovery');
        },
        child: const Text(
          'Забыли пароль?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            fontFamily: 'Montserrat',
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('Еще нет аккаунта? Тогда ', style: AppTextStyles.bodyMedium),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/register');
            },
            child: Text(
              'ЗАРЕГИСТРИРУЙТЕСЬ',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
