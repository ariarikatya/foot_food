import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';

/// Кастомная нижняя навигация для экрана регистрации
class RegisterBottomNavigation extends StatelessWidget {
  final bool isBuyer;
  final VoidCallback onBuyerTap;
  final VoidCallback onSellerTap;

  const RegisterBottomNavigation({
    super.key,
    required this.isBuyer,
    required this.onBuyerTap,
    required this.onSellerTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    const double barHeight = 113;

    return SizedBox(
      height: barHeight + bottomInset + 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Тень
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomPaint(
              size: Size(width, barHeight),
              painter: _NavShadowPainter(isLeft: isBuyer, color: Colors.black),
            ),
          ),
          // Основной контейнер
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: _BottomNavClipper(isLeft: isBuyer),
              child: Container(
                height: barHeight,
                color: AppColors.bottomNavBar,
                padding: EdgeInsets.only(bottom: bottomInset + 12),
                alignment: Alignment.bottomCenter,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Нажимая кнопку "Зарегистрироваться", вы соглашаетесь с политикой конфиденциальности и условиями пользовательского соглашения',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7FA29A),
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Плавающие кнопки
          Positioned(
            left: width * 0.25 - 35,
            bottom: barHeight - 35,
            child: _FloatingNavItem(
              iconPath: 'assets/images/icon people.svg',
              isSelected: isBuyer,
              onTap: onBuyerTap,
            ),
          ),
          Positioned(
            left: width * 0.75 - 35,
            bottom: barHeight - 35,
            child: _FloatingNavItem(
              iconPath: 'assets/images/icon coin.svg',
              isSelected: !isBuyer,
              onTap: onSellerTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingNavItem extends StatelessWidget {
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _FloatingNavItem({
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.bottomNavBar,
          shape: BoxShape.circle,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            width: 35,
            height: 35,
            colorFilter: const ColorFilter.mode(
              AppColors.textWhite,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

class _NavShadowPainter extends CustomPainter {
  final bool isLeft;
  final Color color;

  _NavShadowPainter({required this.isLeft, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = _BottomNavClipper(isLeft: isLeft).getClip(size);
    final paint = Paint()
      ..color = color.withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawPath(path.shift(const Offset(0, -2)), paint);
  }

  @override
  bool shouldRepaint(_NavShadowPainter old) => old.isLeft != isLeft;
}

class _BottomNavClipper extends CustomClipper<Path> {
  final bool isLeft;

  _BottomNavClipper({required this.isLeft});

  @override
  Path getClip(Size size) {
    final path = Path();
    final double centerX = size.width * (isLeft ? 0.25 : 0.75);
    const double radius = 36.5;
    const double depth = 40.0;
    const double smooth = 15.0;

    path.moveTo(0, 0);
    path.lineTo(centerX - radius - smooth, 0);
    path.cubicTo(centerX - radius, 0, centerX - radius, depth, centerX, depth);
    path.cubicTo(
      centerX + radius,
      depth,
      centerX + radius,
      0,
      centerX + radius + smooth,
      0,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(_BottomNavClipper old) => old.isLeft != isLeft;
}
