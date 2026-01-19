import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';

/// Экран "О приложении"
class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Логотип
                      Image.asset(
                        'assets/images/logo.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(width: 200, height: 200);
                        },
                      ),
                      const SizedBox(height: 10),

                      // Версия
                      const Text(
                        'Версия 1.1',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Montserrat',
                          color: Color(0xFF7FA29A),
                        ),
                      ),
                      const Spacer(),

                      // Ссылки внизу
                      _buildBottomLinks(),
                      const SizedBox(height: 40),
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

  Widget _buildAppBar(BuildContext context) {
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
                Color(0xFF7FA29A),
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomLinks() {
    return const Column(
      children: [
        Text(
          'Политика конфиденциальности',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: Colors.white,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
          ),
        ),
        SizedBox(height: 15),
        Text(
          'Условия пользовательского соглашения',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: Colors.white,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
