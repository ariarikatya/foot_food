import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

/// AppBar с логотипом и кнопкой назад
class AppBarWithLogo extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final bool showSmallLogo;

  const AppBarWithLogo({
    super.key,
    this.onBackPressed,
    this.showSmallLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: showSmallLogo ? 0 : AppSpacing.md,
      ),
      child: showSmallLogo
          ? Row(
              children: [
                if (onBackPressed != null)
                  GestureDetector(
                    onTap: onBackPressed,
                    child: SvgPicture.asset(
                      'assets/images/Vector.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                const Spacer(),
                Image.asset(
                  'assets/images/logodark.png',
                  width: 71,
                  height: 41,
                  fit: BoxFit.contain,
                ),
              ],
            )
          : Column(
              children: [
                Row(
                  children: [
                    if (onBackPressed != null)
                      GestureDetector(
                        onTap: onBackPressed,
                        child: SvgPicture.asset(
                          'assets/images/Vector.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            AppColors.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'assets/images/logodark.png',
                    width: 223,
                    height: 128,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
    );
  }
}
