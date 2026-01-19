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

    const double unselectedIconBottom = barHeight - 6.5 - 42.5;
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

    // Параметры
    const double smoothR = 20.0; // Радиус скругления стыков

    // Создаем фигуры сразу со скругленными стыками в одном контуре
    Path hill = _createSmoothShape(
      w: 123,
      h: 54,
      d: 85,
      offset: 5.0,
      isHill: true,
      sR: smoothR,
      rectRadius: 5,
    );
    Path hole = _createSmoothShape(
      w: 140,
      h: 50,
      d: 94,
      offset: 14.0,
      isHill: false,
      sR: smoothR,
      rectRadius: 10,
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

  Path _createSmoothShape({
    required double w,
    required double h,
    required double d,
    required double offset,
    required bool isHill,
    required double sR,
    required double rectRadius,
  }) {
    final path = Path();
    final double r = d / 2;

    if (isHill) {
      // Горка (Hill) с плавным входом
      path.moveTo(-w / 2 - sR, 0);
      path.arcToPoint(
        Offset(-w / 2, -0.1),
        radius: Radius.circular(sR),
        clockwise: true,
      ); // Левый стык
      path.lineTo(-w / 2, 0);
      // Рисуем прямоугольник горки (вниз)
      path.addRRect(
        RRect.fromLTRBAndCorners(
          -w / 2,
          0,
          w / 2,
          h,
          bottomLeft: Radius.circular(rectRadius),
          bottomRight: Radius.circular(rectRadius),
        ),
      );
      // Добавляем круг
      path.addOval(
        Rect.fromCircle(center: Offset(0, h - offset - r), radius: r),
      );
      // Правый стык (добавим дугу отдельно для корректного Union)
      Path rightSmooth = Path()
        ..moveTo(w / 2, 0)
        ..arcToPoint(
          Offset(w / 2 + sR, 0),
          radius: Radius.circular(sR),
          clockwise: true,
        );
      path.addPath(rightSmooth, Offset.zero);
    } else {
      // Вырез (Hole) с плавными краями сверху
      // Рисуем верхнюю часть выреза с "ушками" скругления
      path.moveTo(-w / 2 - sR, 0);
      path.lineTo(-w / 2, 0);
      path.lineTo(-w / 2, sR);
      path.arcToPoint(
        Offset(-w / 2 - sR, 0),
        radius: Radius.circular(sR),
        clockwise: false,
      ); // Левое скругление

      path.moveTo(w / 2 + sR, 0);
      path.lineTo(w / 2, 0);
      path.lineTo(w / 2, sR);
      path.arcToPoint(
        Offset(w / 2 + sR, 0),
        radius: Radius.circular(sR),
        clockwise: true,
      ); // Правое скругление

      // Основной прямоугольник выреза
      path.addRRect(
        RRect.fromLTRBAndCorners(
          -w / 2,
          -h,
          w / 2,
          0,
          topLeft: Radius.circular(rectRadius),
          topRight: Radius.circular(rectRadius),
        ),
      );
      // Круг выреза
      path.addOval(
        Rect.fromCircle(center: Offset(0, -h + offset + r), radius: r),
      );
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant _FigmaFinalPainter old) => old.isLeft != isLeft;
}
