import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import 'about_app_screen.dart';
import 'add_card_screen.dart';
import '../onboarding/onboarding_screen.dart';

/// Экран настроек покупателя (Экран 12)
class BuyerSettingsScreen extends StatefulWidget {
  const BuyerSettingsScreen({super.key});

  @override
  State<BuyerSettingsScreen> createState() => _BuyerSettingsScreenState();
}

class _BuyerSettingsScreenState extends State<BuyerSettingsScreen> {
  final _phoneController = TextEditingController(text: '+7 (992) 213-09-88');
  final _cityController = TextEditingController(text: 'Пермь');

  @override
  void dispose() {
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/buyerHome.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildTitle(),
                      const SizedBox(height: 30),
                      _buildPhoneField(),
                      const SizedBox(height: 30),
                      _buildCityField(),
                      const SizedBox(height: 30),
                      _buildChangeDataButton(),
                      const SizedBox(height: 15),
                      _buildChangePasswordButton(),
                      const SizedBox(height: 15),
                      _buildTrainingButton(),
                      const SizedBox(height: 40),
                      _buildAboutSection(),
                      const SizedBox(height: 20),
                      _buildSupportSection(),
                      const SizedBox(height: 40),
                      _buildLogoutButton(),
                      const SizedBox(height: 20),
                      _buildDeleteAccountButton(),
                      const SizedBox(height: 180), // Место для навигации
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x59000000),
            offset: const Offset(0, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 17),
        child: Row(
          children: [
            const Spacer(),
            const Text(
              'Настройки',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
                color: Color(0xFF7FA29A),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutAppScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.info_outline,
                color: Color(0xFF7FA29A),
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Foot Food',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        fontFamily: 'Jura',
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildPhoneField() {
    return CustomTextField(
      controller: _phoneController,
      hintText: 'Номер телефона',
      enabled: false,
    );
  }

  Widget _buildCityField() {
    return CustomTextField(
      controller: _cityController,
      hintText: 'Город',
      enabled: false,
    );
  }

  Widget _buildChangeDataButton() {
    return CustomButton(
      text: 'Изменить город',
      fontSize: 22,
      fontWeight: FontWeight.w400,
      onPressed: () {
        _showCitySelectionDialog();
      },
    );
  }

  Widget _buildChangePasswordButton() {
    return CustomButton(
      text: 'Добавить карту',
      fontSize: 22,
      fontWeight: FontWeight.w400,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddCardScreen()),
        );
      },
    );
  }

  Widget _buildTrainingButton() {
    return CustomButton(
      text: 'Пройти обучение еще раз',
      fontSize: 22,
      fontWeight: FontWeight.w400,
      onPressed: () async {
        // Показываем onboarding и возвращаемся обратно
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
        // После завершения onboarding возвращаемся на settings
      },
    );
  }

  Widget _buildAboutSection() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AboutAppScreen()),
        );
      },
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.textPrimary),
          const SizedBox(width: 10),
          const Text(
            'О приложении',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return GestureDetector(
      onTap: () async {
        final Uri emailUri = Uri(
          scheme: 'mailto',
          path: 'support@footfood.ru',
          query: 'subject=Вопрос по приложению Foot Food',
        );

        if (await canLaunchUrl(emailUri)) {
          await launchUrl(emailUri);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Не удалось открыть почтовый клиент'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }
      },
      child: Row(
        children: [
          const Icon(Icons.help_outline, color: AppColors.textPrimary),
          const SizedBox(width: 10),
          const Text(
            'Вопросы и помощь',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          _showLogoutConfirmation();
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text(
          'Выйти',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          _showDeleteConfirmation();
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text(
          'Удалить аккаунт',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.error,
          ),
        ),
      ),
    );
  }

  void _showCitySelectionDialog() {
    final cities = ['Пермь', 'Казань', 'Сочи', 'Уфа'];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: cities.map((city) {
              return ListTile(
                title: Text(
                  city,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Montserrat',
                  ),
                ),
                onTap: () {
                  setState(() {
                    _cityController.text = city;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выход'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed('/auth');
            },
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF163832),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Вы действительно хотите удалить аккаунт?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Удалить аккаунт
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/auth', (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Да',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(
                          color: AppColors.error,
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Нет',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
