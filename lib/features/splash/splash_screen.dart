import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';

/// Экран заставки (Splash Screen)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // ДЛЯ ТЕСТИРОВАНИЯ: всегда показываем онбординг
    // Закомментируйте эти 3 строки когда закончите тестирование
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    }
    return;

    // РАСКОММЕНТИРУЙТЕ КОД НИЖЕ ПОСЛЕ ТЕСТИРОВАНИЯ:
    // Проверяем, первый ли это запуск
    // final prefs = await SharedPreferences.getInstance();
    // final bool isFirstLaunch = prefs.getBool('first_launch') ?? true;

    // if (isFirstLaunch) {
    //   // Это первый запуск - показываем онбординг
    //   await prefs.setBool('first_launch', false);
    //   if (mounted) {
    //     Navigator.of(context).pushReplacementNamed('/onboarding');
    //   }
    // } else {
    //   // Не первый запуск - переходим к авторизации
    //   if (mounted) {
    //     Navigator.of(context).pushReplacementNamed('/auth');
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
