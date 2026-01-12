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
    // Высота панели
    const double barHeight = 113.0;

    return SizedBox(
      height: 180,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // 1. ФОН (Rpainter)
          Positioned(
            bottom: 0,
            child: CustomPaint(
              size: Size(width, barHeight),
              painter: _FigmaStrictMirrorPainter(isLeft: isBuyer),
            ),
          ),

          // 2. ИКОНКИ
          _buildStaticIcon(
            width * 0.25,
            isBuyer,
            'assets/images/icon people.svg',
            onBuyerTap,
          ),
          _buildStaticIcon(
            width * 0.75,
            !isBuyer,
            'assets/images/icon coin.svg',
            onSellerTap,
          ),

          // 3. ТЕКСТ
          Positioned(
            bottom: 20,
            left: 45,
            right: 45,
            child: Text(
              'Нажимая кнопку “Зарегистрироваться”, вы соглашаетесь с политикой конфиденциальности...',
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

  Widget _buildStaticIcon(
    double x,
    bool isSelected,
    String asset,
    VoidCallback tap,
  ) {
    // Кнопка 85x85. Радиус 42.5.
    // Центр кнопки должен совпадать с геометрией выреза.
    return Positioned(
      left: x - 42.5,
      bottom: 70,
      child: GestureDetector(
        onTap: tap,
        child: Container(
          width: 85,
          height: 85,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // Если выбрано - рисуем зеленый круг.
            // Если нет - круг прозрачный, иконка висит над "горкой".
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

class _FigmaStrictMirrorPainter extends CustomPainter {
  final bool isLeft;
  _FigmaStrictMirrorPainter({required this.isLeft});

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
    final double lX = size.width * 0.25;
    final double rX = size.width * 0.75;

    // Начинаем рисовать
    path.moveTo(0, 0);

    // Левая часть
    // isLeft = true -> Выбрана (Hole/Выемка), direction = 1
    // isLeft = false -> Не выбрана (Hill/Горка), direction = -1
    _drawMirrorShape(path, lX, isLeft ? 1 : -1);

    // Правая часть
    // Наоборот
    _drawMirrorShape(path, rX, !isLeft ? 1 : -1);

    // Замыкаем контур панели
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Тень и отрисовка
    canvas.drawShadow(path.shift(const Offset(0, -1)), Colors.black, 10, false);
    canvas.drawPath(path, paint);
  }

  /// ЕДИНАЯ ФУНКЦИЯ ДЛЯ ГОРКИ И ЯМЫ
  /// [center] - координата X центра кнопки
  /// [dir] - 1.0 для Ямы (вниз), -1.0 для Горки (вверх)
  void _drawMirrorShape(Path path, double center, double dir) {
    // --- НАСТРОЙКИ ГЕОМЕТРИИ ---
    // Радиус кнопки 42.5.
    // Вы просили "уже на 1". Значит зазор = 1.0.
    // Итоговый радиус дуги = 43.5.
    const double radius = 43.5;

    // Радиус скругления "плечей" (вход в яму/на горку)
    const double shoulder = 10.0;

    // Вычисляем точки начала и конца всей конструкции
    // Общая ширина элемента = (radius + shoulder) * 2 = 107px
    final double startX = center - radius - shoulder;

    // 1. Подходим к началу фигуры
    path.lineTo(startX, 0);

    // 2. Первое плечо (скругление)
    // Если яма (dir=1): загибаем вниз (clockwise)
    // Если горка (dir=-1): загибаем вверх (counter-clockwise)
    path.arcToPoint(
      Offset(center - radius, dir * shoulder),
      radius: const Radius.circular(shoulder),
      clockwise: dir == 1,
    );

    // 3. Основная дуга (Чаша или Купол)
    // Высота/Глубина равна 'radius' относительно плечей.
    // Если яма (dir=1): дуга идет против часовой (вогнутая)
    // Если горка (dir=-1): дуга идет по часовой (выпуклая)
    path.arcToPoint(
      Offset(center + radius, dir * shoulder),
      radius: const Radius.circular(radius),
      clockwise: dir == -1,
    );

    // 4. Второе плечо (выход)
    // Если яма (dir=1): загибаем вверх (clockwise)
    // Если горка (dir=-1): загибаем вниз (counter-clockwise)
    path.arcToPoint(
      Offset(center + radius + shoulder, 0),
      radius: const Radius.circular(shoulder),
      clockwise: dir == 1,
    );
  }

  @override
  bool shouldRepaint(covariant _FigmaStrictMirrorPainter old) =>
      old.isLeft != isLeft;
}
