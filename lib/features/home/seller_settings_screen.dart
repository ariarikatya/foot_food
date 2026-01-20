import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/custom_button.dart';
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

  String _logoPath = '';
  String _nameRestaurant = 'Никала Пиросмани';
  String _email = 'insdfnsdf@mail.ru';
  String _address = 'Пермь, ул. Монастырская 57';

  String _verificationStatus = 'pending'; // pending, approved, rejected

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
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              top: 20,
              bottom: 180 + 49, // Высота навигации + отступ
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLogoSection(),
                const SizedBox(height: 30),
                _buildInfoText('Название:', _nameRestaurant),
                const SizedBox(height: 15),
                _buildInfoText('Email:', _email),
                const SizedBox(height: 15),
                _buildInfoText('Адрес:', _address),
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
                _buildLogoutAndDeleteRow(),
              ],
            ),
          ),
        ),
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
              child: _logoPath.isNotEmpty
                  ? const Icon(Icons.restaurant, size: 60, color: Colors.grey)
                  : const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
          ),
        ),
      ],
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

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 50),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 293),
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
                  'Вы действительно хотите выйти?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                  ),
                ),
              ),
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
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacementNamed('/auth');
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
                    const SizedBox(width: 91),
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
                  ],
                ),
              ),
            ],
          ),
        ),
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
          constraints: const BoxConstraints(maxWidth: 293),
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
                    const SizedBox(width: 91),
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
