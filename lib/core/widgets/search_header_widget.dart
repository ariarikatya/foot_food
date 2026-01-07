import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';

/// Общий виджет header с поиском для buyer и seller
class SearchHeaderWidget extends StatelessWidget {
  final TextEditingController searchController;
  final bool isSearching;
  final VoidCallback? onSearchToggle;
  final VoidCallback? onFilterPressed;
  final bool showFilter;
  final bool isFilterOpen;
  final String? title;

  const SearchHeaderWidget({
    super.key,
    required this.searchController,
    this.isSearching = false,
    this.onSearchToggle,
    this.onFilterPressed,
    this.showFilter = false,
    this.isFilterOpen = false,
    this.title,
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
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 17),
          child: showFilter
              ? (isSearching
                    ? _buildBuyerSearchMode()
                    : _buildBuyerNormalMode())
              : _buildSellerSearchField(),
        ),
      ),
    );
  }

  Widget _buildBuyerNormalMode() {
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
          Text(
            title ?? 'Лента footbox',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              fontFamily: 'Montserrat',
              color: Color(0xFF7FA29A),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onFilterPressed,
            child: AnimatedRotation(
              turns: isFilterOpen ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: SvgPicture.asset(
                'assets/images/filtergreen.svg',
                width: 28,
                height: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyerSearchMode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Введите любое слово',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              fontFamily: 'Montserrat',
              color: Color(0xFF7FA29A),
            ),
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
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
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
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onFilterPressed,
                child: AnimatedRotation(
                  turns: isFilterOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: SvgPicture.asset(
                    'assets/images/filtergreen.svg',
                    width: 28,
                    height: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSellerSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
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
                controller: searchController,
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
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(width: 10),
            SvgPicture.asset('assets/images/search.svg', width: 24, height: 24),
          ],
        ),
      ),
    );
  }
}
