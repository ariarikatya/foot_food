import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';

/// Экран верификации организации (Скрин "Верификация")
class SellerVerificationScreen extends StatefulWidget {
  const SellerVerificationScreen({super.key});

  @override
  State<SellerVerificationScreen> createState() =>
      _SellerVerificationScreenState();
}

class _SellerVerificationScreenState extends State<SellerVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _innController = TextEditingController();
  final _ogrnController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _innController.dispose();
    _ogrnController.dispose();
    super.dispose();
  }

  Future<void> _submitVerification() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      // Имитация отправки
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Заявка на верификацию отправлена'),
            backgroundColor: AppColors.success,
          ),
        );

        Navigator.pop(context);
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
            image: AssetImage('assets/images/selver.png'),
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
                        const SizedBox(height: 40),
                        _buildTitle(),
                        const SizedBox(height: 30),
                        _buildINNField(),
                        const SizedBox(height: 30),
                        _buildOGRNField(),
                        const SizedBox(height: 20),
                        _buildInfoText(),
                        const SizedBox(height: 10),
                        _buildEstimateText(),
                        const SizedBox(height: 10),
                        _buildThankYouText(),
                        const SizedBox(height: 40),
                        _buildSubmitButton(),
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
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
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
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Верификация организации',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        fontFamily: 'Montserrat',
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildINNField() {
    return CustomTextField(
      controller: _innController,
      hintText: 'ИНН',
      keyboardType: TextInputType.number,
      validator: (v) {
        if (v == null || v.isEmpty) return 'Введите ИНН';
        if (v.length != 10 && v.length != 12) {
          return 'ИНН должен содержать 10 или 12 цифр';
        }
        return null;
      },
    );
  }

  Widget _buildOGRNField() {
    return CustomTextField(
      controller: _ogrnController,
      hintText: 'ОГРН/ОГРНИП',
      keyboardType: TextInputType.number,
      validator: (v) {
        if (v == null || v.isEmpty) return 'Введите ОГРН/ОГРНИП';
        if (v.length != 13 && v.length != 15) {
          return 'ОГРН должен содержать 13 или 15 цифр';
        }
        return null;
      },
    );
  }

  Widget _buildInfoText() {
    return const Text(
      'Для обеспечения безопасности сделок и защиты прав покупателей все организации на нашей платформе проходят обязательную проверку.',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        fontFamily: 'Montserrat',
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildEstimateText() {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          fontFamily: 'Montserrat',
          color: AppColors.textPrimary,
        ),
        children: [
          TextSpan(
            text:
                'Это разовая процедура, которая откроет вам доступ к полному функционалу аккаунта.\n\nПроверка займет до ',
          ),
          TextSpan(
            text: '3 рабочих дней',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: '.'),
        ],
      ),
    );
  }

  Widget _buildThankYouText() {
    return const Text(
      'Как только мы закончим, вы получите уведомление. Спасибо за понимание!',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        fontFamily: 'Montserrat',
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return CustomButton(
      text: 'Отправить',
      fontSize: 28,
      fontWeight: FontWeight.w500,
      onPressed: _isLoading ? null : _submitVerification,
      isLoading: _isLoading,
    );
  }
}
