import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          Positioned.fill(
            child: Column(
              children: [
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
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.lg,
                    right: AppSpacing.lg,
                    bottom: 49 + 180,
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
    final searchController = TextEditingController();
    final scrollController = ScrollController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 184,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  // Поле поиска
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/search.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) => setState(() {}),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Поиск',
                              hintStyle: TextStyle(color: Colors.white70),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              filled: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Список городов со скроллбаром
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return NotificationListener<ScrollNotification>(
                          onNotification: (notification) {
                            setState(() {});
                            return true;
                          },
                          child: Stack(
                            children: [
                              ListView(
                                controller: scrollController,
                                padding: EdgeInsets.zero,
                                children: cities
                                    .where(
                                      (city) => city.toLowerCase().contains(
                                        searchController.text.toLowerCase(),
                                      ),
                                    )
                                    .map((city) {
                                      return ListTile(
                                        dense: true,
                                        title: Text(
                                          city,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Montserrat',
                                            color: Colors.black,
                                          ),
                                        ),
                                        onTap: () {
                                          this.setState(() {
                                            _cityController.text = city;
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    })
                                    .toList(),
                              ),
                              // Динамический скроллбар - исправлен
                              if (scrollController.hasClients &&
                                  scrollController.position.maxScrollExtent > 0)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    height: constraints.maxHeight,
                                    child: CustomPaint(
                                      size: Size(4, constraints.maxHeight),
                                      painter: _ScrollbarPainter(
                                        scrollController: scrollController,
                                        containerHeight: constraints.maxHeight,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddCardDialog() {
    final bool hasCard = false;

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

class _ScrollbarPainter extends CustomPainter {
  final ScrollController scrollController;
  final double containerHeight;

  _ScrollbarPainter({
    required this.scrollController,
    required this.containerHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!scrollController.hasClients) return;

    final thumbHeight = 104.0;
    final maxOffset = containerHeight - thumbHeight;
    final scrollProgress =
        scrollController.offset / scrollController.position.maxScrollExtent;
    final thumbOffset = (scrollProgress * maxOffset).clamp(0.0, maxOffset);

    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, thumbOffset, 4, thumbHeight),
      const Radius.circular(2),
    );

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(_ScrollbarPainter oldDelegate) => true;
}
