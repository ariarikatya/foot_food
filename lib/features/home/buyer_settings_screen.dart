import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/custom_button.dart';
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
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/buset.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Контент
          Positioned.fill(
            child: Column(
              children: [
                // Верхняя часть с прокруткой
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 20,
                      left: AppSpacing.lg,
                      right: AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildTitle(),
                        const SizedBox(height: 60),
                        _buildChangeDataButton(),
                        const SizedBox(height: 15),
                        _buildChangePasswordButton(),
                        const SizedBox(height: 15),
                        _buildTrainingButton(),
                        const SizedBox(height: 40),
                        _buildAboutSection(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                // Нижние кнопки с отступом 49 от меню
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.lg,
                    right: AppSpacing.lg,
                    bottom: 49 + 180, // 49 от меню + высота меню
                  ),
                  child: _buildLogoutAndDeleteRow(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logodark.png',
          width: 71,
          height: 41,
          fit: BoxFit.contain,
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _phoneController.text,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Город: ${_cityController.text}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                fontFamily: 'Montserrat',
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
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
        _showAddCardDialog();
      },
    );
  }

  Widget _buildTrainingButton() {
    return CustomButton(
      text: 'Пройти обучение еще раз',
      fontSize: 22,
      fontWeight: FontWeight.w400,
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
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

  Widget _buildLogoutAndDeleteRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _showLogoutConfirmation,
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
        ),
        Expanded(
          child: GestureDetector(
            onTap: _showDeleteConfirmation,
            child: const Text(
              'Удалить аккаунт',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
                color: AppColors.error,
              ),
            ),
          ),
        ),
      ],
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

  void _showAddCardDialog() {
    // Здесь можно проверить, есть ли сохраненная карта
    final bool hasCard = false; // Замените на реальную проверку

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (context) {
        return Stack(
          fit: StackFit.expand,
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
            ),
            AddCardDialog(hasCard: hasCard),
          ],
        );
      },
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
        insetPadding: const EdgeInsets.symmetric(horizontal: 50),
        child: Container(
          height: 118,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color(0x59000000),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Верхняя часть - темно-зеленый фон
              Container(
                height: 68,
                decoration: const BoxDecoration(
                  color: Color(0xFF163832),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: const Text(
                  'Вы действительно хотите удалить аккаунт?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
              ),
              // Нижняя часть - белый фон с кнопками
              Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 60),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(
                            context,
                          ).pushNamedAndRemoveUntil('/auth', (route) => false);
                        },
                        child: const Center(
                          child: Text(
                            'Да',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Jura',
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Center(
                          child: Text(
                            'Нет',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Jura',
                              color: Color(0xFFBA1A1A),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
