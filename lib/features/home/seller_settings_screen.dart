import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import 'seller_verification_screen.dart';
import 'about_app_screen.dart';

/// Экран настроек продавца (Экран 8)
class SellerSettingsScreen extends StatefulWidget {
  const SellerSettingsScreen({super.key});

  @override
  State<SellerSettingsScreen> createState() => _SellerSettingsScreenState();
}

class _SellerSettingsScreenState extends State<SellerSettingsScreen> {
  final _imagePicker = ImagePicker();

  final _emailController = TextEditingController(text: 'insdfnsdf@mail.ru');
  final _nameController = TextEditingController(text: 'Никала Пиросмани');
  final _addressController = TextEditingController(
    text: 'Пермь, ул. Монастырская 57',
  );

  String? _logoPath;
  String _verificationStatus = 'pending'; // pending, approved, rejected

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _logoPath = image.path;
        });
      }
    } catch (e) {
      _showError('Ошибка выбора изображения: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void _startVerification() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SellerVerificationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sellset.png'),
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
                      _buildLogoSection(),
                      const SizedBox(height: 30),
                      _buildNameField(),
                      const SizedBox(height: 20),
                      _buildEmailField(),
                      const SizedBox(height: 20),
                      _buildAddressField(),
                      const SizedBox(height: 30),
                      _buildChangeDataButton(),
                      const SizedBox(height: 15),
                      _buildChangePasswordButton(),
                      const SizedBox(height: 30),
                      _buildVerificationSection(),
                      const SizedBox(height: 40),
                      _buildAboutSection(),
                      const SizedBox(height: 20),
                      _buildSupportSection(),
                      const SizedBox(height: 40),
                      _buildLogoutButton(),
                      const SizedBox(height: 20),
                      _buildDeleteAccountButton(),
                      const SizedBox(height: 180),
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

  Widget _buildLogoSection() {
    return Column(
      children: [
        const Text(
          'Пройдите верификацию чтобы добавить фото',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            fontFamily: 'Montserrat',
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 15),
        Center(
          child: GestureDetector(
            onTap: _verificationStatus == 'approved' ? _pickLogo : null,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
                border: Border.all(color: const Color(0xFF10292A), width: 2),
              ),
              child: _logoPath != null
                  ? const Icon(Icons.restaurant, size: 60, color: Colors.grey)
                  : const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      controller: _nameController,
      hintText: 'Название',
      enabled: false,
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      controller: _emailController,
      hintText: 'Email',
      enabled: false,
    );
  }

  Widget _buildAddressField() {
    return CustomTextField(
      controller: _addressController,
      hintText: 'Адрес',
      enabled: false,
    );
  }

  Widget _buildChangeDataButton() {
    return CustomButton(
      text: 'Изменить данные',
      fontSize: 22,
      fontWeight: FontWeight.w400,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Редактирование данных'),
            content: const Text('Функция редактирования будет доступна позже'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChangePasswordButton() {
    return CustomButton(
      text: 'Изменить пароль',
      fontSize: 22,
      fontWeight: FontWeight.w400,
      onPressed: () {
        Navigator.of(context).pushNamed('/password_recovery');
      },
    );
  }

  Widget _buildVerificationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Статус верификации:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 10),
              _buildStatusBadge(),
            ],
          ),
          if (_verificationStatus == 'pending') ...[
            const SizedBox(height: 15),
            const Text(
              'Ваша заявка на рассмотрении',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                fontFamily: 'Montserrat',
                color: AppColors.textSecondary,
              ),
            ),
          ],
          if (_verificationStatus == 'rejected') ...[
            const SizedBox(height: 15),
            CustomButton(
              text: 'Пройти верификацию',
              fontSize: 18,
              fontWeight: FontWeight.w400,
              onPressed: _startVerification,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    String badgeText;

    switch (_verificationStatus) {
      case 'approved':
        badgeColor = AppColors.success;
        badgeText = 'Верифицирован';
        break;
      case 'pending':
        badgeColor = AppColors.warning;
        badgeText = 'На проверке';
        break;
      case 'rejected':
      default:
        badgeColor = AppColors.error;
        badgeText = 'Не верифицирован';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        badgeText,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Montserrat',
          color: Colors.white,
        ),
      ),
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
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/auth',
                                (route) => false,
                              );
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
}
