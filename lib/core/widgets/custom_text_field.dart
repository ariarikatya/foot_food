import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

// 1. Добавьте этот класс Painter (можно в этот же файл или отдельно)
// Он рисует тень и "вырезает" из неё внутреннюю часть
class _OuterShadowPainter extends CustomPainter {
  final double radius;

  _OuterShadowPainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    // Создаем слой для наложения эффектов
    canvas.saveLayer(
      Rect.fromLTWH(-50, -50, size.width + 100, size.height + 100),
      Paint(),
    );

    // Рисуем тень (с вашими параметрами: цвет, оффсет, блюр)
    final shadowPaint = Paint()
      ..color = const Color(0x4D051F20)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        12 / 2,
      ); // Blur sigma ~ radius / 2

    // Сдвигаем холст для Offset(4, 8)
    canvas.translate(4, 8);
    canvas.drawRRect(rrect, shadowPaint);
    canvas.translate(-4, -8); // Возвращаем обратно

    // Главный трюк: вырезаем внутреннюю часть (BlendMode.dstOut)
    // Это делает область под полем полностью прозрачной, убирая тень
    final cutPaint = Paint()
      ..blendMode = BlendMode.dstOut
      ..color = Colors.black; // Цвет не важен, важна непрозрачность

    canvas.drawRRect(rrect, cutPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Кастомное текстовое поле
class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 2. Исправленная тень (используем CustomPaint вместо Container с shadow)
        Positioned.fill(
          child: CustomPaint(
            painter: _OuterShadowPainter(radius: AppSpacing.radiusLg),
          ),
        ),
        // Поле ввода (стекло)
        // Поле ввода
        Container(
          height: 60,
          alignment: Alignment.center, // Центрируем содержимое контейнера
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border, width: 2),
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            obscuringCharacter: '*',
            textAlignVertical:
                TextAlignVertical.center, // Центрируем текст по вертикали
            keyboardType: keyboardType,
            validator: validator,
            onChanged: onChanged,
            onTap: onTap,
            readOnly: readOnly,
            maxLines: maxLines,
            enabled: enabled,
            inputFormatters: inputFormatters,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1A1C1B),
              fontFamily: 'Montserrat',
            ),
            decoration: InputDecoration(
              hintText: hintText,
              labelText: labelText,
              hintStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1A1C1B),
                fontFamily: 'Montserrat',
              ),
              // Убираем плавающую метку, если используем hintText для центровки
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              filled: false,
              // Важно: убираем vertical padding или делаем его симметричным
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
