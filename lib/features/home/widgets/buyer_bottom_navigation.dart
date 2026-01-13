import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Нижняя навигация для покупателя (4 кнопки, 70x70)
class BuyerBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BuyerBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const double barHeight = 113.0;

    return SizedBox(
      height: 180,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Фон
          Positioned(
            bottom: 0,
            child: CustomPaint(
              size: Size(width, barHeight),
              painter: _BuyerNavigationPainter(selectedIndex: currentIndex),
            ),
          ),

          // Иконки
          _buildIcon(width * 0.2, 0, 'assets/images/icon people.svg'),
          _buildIcon(width * 0.4, 1, 'assets/images/icon coin.svg'),
          _buildIcon(width * 0.6, 2, 'assets/images/icon people.svg'),
          _buildIcon(width * 0.8, 3, 'assets/images/icon coin.svg'),
        ],
      ),
    );
  }

  Widget _buildIcon(double x, int index, String asset) {
    final isSelected = currentIndex == index;
    return Positioned(
      left: x - 35, // 70/2 = 35
      bottom: 70,
      child: GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isSelected
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF235347), Color(0xFF163832)],
                  )
                : null,
          ),
          child: Center(
            child: SvgPicture.asset(
              asset,
              width: 28,
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

class _BuyerNavigationPainter extends CustomPainter {
  final int selectedIndex;
  _BuyerNavigationPainter({required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(0, size.height),
        [const Color(0xFF163832), const Color(0xFF0B2B26)],
      )
      ..style = PaintingStyle.fill;

    final path = Path();

    // Позиции кнопок (20%, 40%, 60%, 80% от ширины)
    final positions = [
      size.width * 0.2,
      size.width * 0.4,
      size.width * 0.6,
      size.width * 0.8,
    ];

    path.moveTo(0, 0);

    for (int i = 0; i < positions.length; i++) {
      final isSelected = selectedIndex == i;
      _drawShape(path, positions[i], isSelected ? 1 : -1);
    }

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path.shift(const Offset(0, -1)), Colors.black, 10, false);
    canvas.drawPath(path, paint);
  }

  void _drawShape(Path path, double center, double dir) {
    const double radius = 36.5; // 70/2 + 1.5 зазор
    const double shoulder = 10.0;

    final double startX = center - radius - shoulder;
    path.lineTo(startX, 0);

    path.arcToPoint(
      Offset(center - radius, dir * shoulder),
      radius: const Radius.circular(shoulder),
      clockwise: dir == 1,
    );

    path.arcToPoint(
      Offset(center + radius, dir * shoulder),
      radius: const Radius.circular(radius),
      clockwise: dir == -1,
    );

    path.arcToPoint(
      Offset(center + radius + shoulder, 0),
      radius: const Radius.circular(shoulder),
      clockwise: dir == 1,
    );
  }

  @override
  bool shouldRepaint(covariant _BuyerNavigationPainter old) =>
      old.selectedIndex != selectedIndex;
}
