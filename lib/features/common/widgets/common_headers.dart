import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

/// AppBar с логотипом и кнопкой назад
class AppBarWithLogo extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBackPressed;
  final bool showSmallLogo;

  const AppBarWithLogo({
    super.key,
    this.onBackPressed,
    this.showSmallLogo = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 40);

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

/// Header с поиском для главного экрана покупателя
class BuyerHomeHeader extends StatefulWidget {
  final TextEditingController searchController;
  final bool isSearching;
  final VoidCallback onSearchToggle;
  final VoidCallback onFilterPressed;

  const BuyerHomeHeader({
    super.key,
    required this.searchController,
    required this.isSearching,
    required this.onSearchToggle,
    required this.onFilterPressed,
  });

  @override
  State<BuyerHomeHeader> createState() => _BuyerHomeHeaderState();
}

class _BuyerHomeHeaderState extends State<BuyerHomeHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x59000000),
            offset: const Offset(0, 6),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5),
            if (widget.isSearching) _buildSearchMode() else _buildNormalMode(),
            const SizedBox(height: 17),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchMode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        children: [
          const Text(
            'Введите любое слово',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              fontFamily: 'Montserrat',
              color: Color(0xFF7FA29A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: widget.searchController,
                          autofocus: true,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Поиск',
                            hintStyle: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Montserrat',
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: widget.onSearchToggle,
                        child: const Icon(Icons.close, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: widget.onFilterPressed,
                child: SvgPicture.asset(
                  'assets/images/filtergreen.svg',
                  width: 28,
                  height: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNormalMode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 31),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onSearchToggle,
            child: SvgPicture.asset(
              'assets/images/searchgreen.svg',
              width: 25,
              height: 25,
            ),
          ),
          const Spacer(),
          const Text(
            'Лента footbox',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              fontFamily: 'Montserrat',
              color: Color(0xFF7FA29A),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: widget.onFilterPressed,
            child: SvgPicture.asset(
              'assets/images/filtergreen.svg',
              width: 28,
              height: 20,
            ),
          ),
        ],
      ),
    );
  }
}

/// Header с поиском для главного экрана продавца
class SellerHomeHeader extends StatelessWidget {
  final TextEditingController searchController;

  const SellerHomeHeader({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x59000000),
            offset: const Offset(0, 6),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 26,
            right: 26,
            top: 10,
            bottom: 20,
          ),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: TextField(
              controller: searchController,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Поиск',
                hintStyle: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.only(left: 24, right: 24),
                suffixIconConstraints: const BoxConstraints(
                  minHeight: 24,
                  minWidth: 48,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 24, left: 10),
                  child: SvgPicture.asset(
                    'assets/images/search.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
