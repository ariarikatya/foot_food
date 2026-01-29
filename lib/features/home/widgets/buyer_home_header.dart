import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_colors.dart';

/// Header для главного экрана покупателя с поиском и фильтром
class BuyerHomeHeader extends StatelessWidget {
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
            isSearching ? _buildSearchMode() : _buildNormalMode(),
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
              Expanded(child: _buildSearchField()),
              const SizedBox(width: 10),
              _buildFilterButton(),
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
            onTap: onSearchToggle,
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
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
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
              controller: searchController,
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
            onTap: onSearchToggle,
            child: const Icon(Icons.close, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: onFilterPressed,
      child: SvgPicture.asset(
        'assets/images/filtergreen.svg',
        width: 28,
        height: 20,
      ),
    );
  }
}
