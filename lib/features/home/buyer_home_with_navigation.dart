import 'package:flutter/material.dart';
import 'buyer_home_screen.dart';
import 'buyer_map_screen.dart';
import 'buyer_history_screen.dart';
import 'buyer_settings_screen.dart';
import 'widgets/buyer_bottom_navigation.dart';

/// Обертка для buyer home с нижней навигацией
class BuyerHomeWithNavigation extends StatefulWidget {
  const BuyerHomeWithNavigation({super.key});

  @override
  State<BuyerHomeWithNavigation> createState() =>
      _BuyerHomeWithNavigationState();
}

class _BuyerHomeWithNavigationState extends State<BuyerHomeWithNavigation> {
  int _currentIndex = 0;

  // Данные пользователя (в реальном приложении из AuthProvider)
  final int _userId = 1;

  final List<Widget> _screens = [
    const BuyerHomeScreen(),
    const BuyerMapScreen(),
    const BuyerHistoryScreen(userId: 1),
    const BuyerSettingsScreen(userId: 1),
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
            child: BuyerBottomNavigation(
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