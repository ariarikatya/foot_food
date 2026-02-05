import 'package:flutter/material.dart';
import 'seller_home_screen.dart';
import 'seller_create_foodbox_screen.dart';
import 'seller_settings_screen.dart';
import 'widgets/seller_bottom_navigation.dart';

/// Обертка для seller home с нижней навигацией
class SellerHomeWithNavigation extends StatefulWidget {
  const SellerHomeWithNavigation({super.key});

  @override
  State<SellerHomeWithNavigation> createState() =>
      _SellerHomeWithNavigationState();
}

class _SellerHomeWithNavigationState extends State<SellerHomeWithNavigation> {
  int _currentIndex = 0;

  // Данные продавца (в реальном приложении из AuthProvider)
  final int _sellerId = 1;

  final List<Widget> _screens = [
    const SellerHomeScreen(),
    const SellerCreateFoodboxScreen(sellerId: 1),
    const SellerSettingsScreen(sellerId: 1),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _screens),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SellerBottomNavigation(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
              },
            ),
          ),
        ],
      ),
    );
  }
}