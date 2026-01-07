import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    const double barHeight = 113;

    return SizedBox(
      height: barHeight + 60,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Основная панель (Rectangle 11)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(width, barHeight),
              painter: _FigmaPainter(isLeft: isBuyer),
            ),
          ),

          // Иконки всегда на одном уровне (по центру эллипсов фигуры)
          _buildStaticIcon(
            width * 0.25,
            'assets/images/icon people.svg',
            onBuyerTap,
          ),
          _buildStaticIcon(
            width * 0.75,
            'assets/images/icon coin.svg',
            onSellerTap,
          ),

          Positioned(
            bottom: 20,
            left: 45,
            right: 45,
            child: Text(
              'Нажимая кнопку “Зарегистрироваться”, вы соглашаетесь с политикой конфиденциальности м условиями пользовательского соглашения',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Jura',
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF7FA29A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaticIcon(double x, String asset, VoidCallback tap) {
    return Positioned(
      left: x - 42.5,
      // Центрируем иконку там, где находится Ellipse 3 в фигуре
      top: 5,
      child: GestureDetector(
        onTap: tap,
        child: Container(
          width: 85,
          height: 85,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF235347), Color(0xFF163832)],
            ),
          ),
          child: Center(
            child: SvgPicture.asset(
              asset,
              width: 32,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FigmaPainter extends CustomPainter {
  final bool isLeft;
  _FigmaPainter({required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final double lX = size.width * 0.25;
    final double rX = size.width * 0.75;

    final Paint paint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(0, size.height),
        [const Color(0xFF163832), const Color(0xFF0B2B26)],
      );

    Path mainPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // ТА САМАЯ ФИГУРА (Rectangle 14 + Ellipse 3)
    // Она не переворачивается, она статична относительно верха панели
    Path getFigmaObject(double x) {
      final Path shape = Path();
      // Rectangle 14 (верх совпадает с y=0, уходит вглубь на 54px)
      shape.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - 61.5, 0, 123, 54),
          const Radius.circular(5),
        ),
      );
      // Ellipse 3 (торчит вверх над панелью)
      shape.addOval(
        Rect.fromCenter(center: Offset(x, 0), width: 85, height: 85),
      );
      return shape;
    }

    final Path leftObj = getFigmaObject(lX);
    final Path rightObj = getFigmaObject(rX);

    // Логика вычитания/сложения
    if (isLeft) {
      // Для выбранной — вычитаем (Subtract)
      mainPath = Path.combine(PathOperation.difference, mainPath, leftObj);
      // Для невыбранной — добавляем (Union)
      mainPath = Path.combine(PathOperation.union, mainPath, rightObj);
    } else {
      mainPath = Path.combine(PathOperation.union, mainPath, leftObj);
      mainPath = Path.combine(PathOperation.difference, mainPath, rightObj);
    }

    canvas.drawShadow(
      mainPath.shift(const Offset(0, -1)),
      Colors.black.withOpacity(0.5),
      10,
      false,
    );
    canvas.drawPath(mainPath, paint);
  }

  @override
  bool shouldRepaint(_FigmaPainter old) => old.isLeft != isLeft;
}
