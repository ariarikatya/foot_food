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
    const double barHeight = 113.0;

    final double lX = width * 0.25;
    final double rX = width * 0.75;

    // Расчеты центров кнопок (Y=0 - верхняя линия панели)
    // Невыбранная: Прямоугольник внутри (0 до 54). Круг на 5px выше низа (54-5=49). Центр 49-42.5 = 6.5
    const double unselectedIconBottom = barHeight - 6.5 - 42.5;

    // Выбранная: Прямоугольник сверху (-50 до 0). Круг на 14px ниже верха (-50+14=-36). Центр -36+46 = 10
    const double selectedIconBottom = barHeight - 10 - 42.5;

    return SizedBox(
      height: 180,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            child: CustomPaint(
              size: Size(width, barHeight),
              painter: _FigmaFinalPainter(isLeft: isBuyer),
            ),
          ),
          _buildIcon(
            lX,
            isBuyer,
            'assets/images/icon people.svg',
            isBuyer ? selectedIconBottom : unselectedIconBottom,
            onBuyerTap,
          ),
          _buildIcon(
            rX,
            !isBuyer,
            'assets/images/icon coin.svg',
            !isBuyer ? selectedIconBottom : unselectedIconBottom,
            onSellerTap,
          ),

          Positioned(
            bottom: 20,
            left: 45,
            right: 45,
            child: const Text(
              'Нажимая кнопку “Зарегистрироваться”, вы соглашаетесь с политикой конфиденциальности...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Jura',
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7FA29A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(
    double x,
    bool isSelected,
    String asset,
    double bottom,
    VoidCallback tap,
  ) {
    return Positioned(
      left: x - 42.5,
      bottom: bottom,
      child: GestureDetector(
        onTap: tap,
        child: Container(
          width: 85,
          height: 85,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? const Color(0xFF163832) : Colors.transparent,
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

class _FigmaFinalPainter extends CustomPainter {
  final bool isLeft;
  _FigmaFinalPainter({required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(0, size.height),
        [const Color(0xFF163832), const Color(0xFF0B2B26)],
      )
      ..style = PaintingStyle.fill;

    final double lX = size.width * 0.25;
    final double rX = size.width * 0.75;

    Path mainPanel = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // 1. Невыбранная (Hill) - Прямоугольник ВНУТРИ панели (от 0 до 54)
    Path hill = _createFigmaShape(
      radius: 5.0,
      w: 123,
      h: 54,
      d: 85,
      offset: 5.0,
      isHill: true,
    );

    // 2. Выбранная (Hole) - Прямоугольник НАД панелью (от -50 до 0)
    Path hole = _createFigmaShape(
      radius: 10.0,
      w: 140,
      h: 50,
      d: 92,
      offset: 14.0,
      isHill: false,
    );

    Path finalPath = mainPanel;
    if (isLeft) {
      finalPath = Path.combine(
        PathOperation.difference,
        finalPath,
        hole.shift(Offset(lX, 0)),
      );
      finalPath = Path.combine(
        PathOperation.union,
        finalPath,
        hill.shift(Offset(rX, 0)),
      );
    } else {
      finalPath = Path.combine(
        PathOperation.union,
        finalPath,
        hill.shift(Offset(lX, 0)),
      );
      finalPath = Path.combine(
        PathOperation.difference,
        finalPath,
        hole.shift(Offset(rX, 0)),
      );
    }

    canvas.drawShadow(
      finalPath.shift(const Offset(0, -1)),
      Colors.black,
      10,
      false,
    );
    canvas.drawPath(finalPath, paint);
  }

  Path _createFigmaShape({
    required double radius,
    required double w,
    required double h,
    required double d,
    required double offset,
    required bool isHill,
  }) {
    final path = Path();
    final double r = d / 2;

    if (isHill) {
      // Union.png: Прямоугольник опущен вниз (в тело панели)
      path.addRRect(
        RRect.fromLTRBAndCorners(
          -w / 2,
          0,
          w / 2,
          h,
          bottomLeft: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
        ),
      );
      // Круг: Низ на 5px выше низа прямоугольника (Y=h-5)
      path.addOval(
        Rect.fromCircle(center: Offset(0, h - offset - r), radius: r),
      );
    } else {
      // Union1.png: Прямоугольник торчит вверх над панелью
      path.addRRect(
        RRect.fromLTRBAndCorners(
          -w / 2,
          -h,
          w / 2,
          0,
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      );
      // Круг: На 14px ниже верха прямоугольника (-h+14)
      path.addOval(
        Rect.fromCircle(center: Offset(0, -h + offset + r), radius: r),
      );
    }

    // Flutter автоматически объединит перекрывающиеся Path.
    // Поскольку у прямоугольников уже есть скругления (radius), стыки будут мягче.
    return path;
  }

  @override
  bool shouldRepaint(covariant _FigmaFinalPainter old) => old.isLeft != isLeft;
}
