import 'package:flutter/material.dart';

/// Экраны онбординга при первом входе
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/images/firstenter1.png',
      'subtitle': 'Foodbox',
      'title':
          'Foodbox - это набор-сюрприз из готовых блюд и продуктов от кафе и ресторанов по цене почти равной своей себестоимости',
    },
    {
      'image': 'assets/images/firstenter2.png',
      'subtitle': 'Бронирование',
      'title':
          'Хотите забронировать? Жмите на соответствующую кнопку и приходите за foodbox в указанное время',
    },
    {
      'image': 'assets/images/firstenter3.png',
      'subtitle': 'Те, кто не забирает foodbox - блокируются',
      'title':
          'Бронируйте набор, только если уверены в том, что заберете его. Это помогает заведениям избежать убытков от непроданных товаров.',
    },
    {
      'image': 'assets/images/firstenter4.png',
      'subtitle': 'Выкуп заказа',
      'title':
          'После оформления брони на экране появится QR-код. Покажите его сотруднику, чтобы подтвердить получение. После проверки код исчезнет заказ оплатиться и его можно будет забирать.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToAuth();
    }
  }

  void _navigateToAuth() {
    Navigator.of(context).pushReplacementNamed('/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7FA29A),
      body: Stack(
        children: [
          // PageView с контентом
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),

          // Нижняя панель навигации
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNavigation(),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(Map<String, String> pageData) {
    // Получаем высоту экрана для расчета пропорций
    final double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // --- ИЗМЕНЕНИЯ ЗДЕСЬ ---
        // Вместо Positioned.fill используем Positioned с привязкой к низу
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          // Задаем высоту картинки.
          // 0.45 означает 45% от высоты экрана.
          // Если нужно еще ниже/уже - поставьте 0.40. Если выше - 0.50.
          height: screenHeight * 0.45,
          child: Image.asset(
            'assets/images/firstenterRoands.png',
            // BoxFit.fill растянет картинку ровно по размеру контейнера (на 45% снизу)
            fit: BoxFit.fill,
            alignment: Alignment.bottomCenter,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox.shrink();
            },
          ),
        ),
        // -----------------------

        // Контент поверх фона
        SafeArea(
          child: Column(
            children: [
              // Изображение - занимает верхнюю часть
              Expanded(
                flex: 5,
                child: Center(
                  child: Image.asset(
                    pageData['image']!,
                    // Немного уменьшил ширину (с 0.7 до 0.65), чтобы еда смотрелась аккуратнее,
                    // но это можно вернуть обратно, если не понравится.
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.4,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Текстовый блок - занимает нижнюю часть
              Expanded(
                flex: 3, // Это примерно соответствует высоте фона (3/8 экрана)
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Subtitle
                      Text(
                        pageData['subtitle']!,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      // Title
                      Text(
                        pageData['title']!,
                        style: const TextStyle(
                          fontSize:
                              16, // Немного уменьшил шрифт, чтобы текст влезал лучше (было 28, что очень много для длинного текста)
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Отступ снизу для навигационной панели
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Кнопка "Пропустить"
            GestureDetector(
              onTap: _navigateToAuth,
              child: const Text(
                'Пропустить',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                ),
              ),
            ),

            // Индикаторы страниц
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                _pages.length,
                (index) => Container(
                  width: _currentPage == index ? 10 : 5,
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
            ),

            // Кнопка "Дальше"
            GestureDetector(
              onTap: _nextPage,
              child: Text(
                _currentPage == _pages.length - 1 ? 'Начать' : 'Дальше',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
