import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/constants/app_colors.dart';

/// Экран карты для покупателя (Экран 10)
class BuyerMapScreen extends StatefulWidget {
  const BuyerMapScreen({super.key});

  @override
  State<BuyerMapScreen> createState() => _BuyerMapScreenState();
}

class _BuyerMapScreenState extends State<BuyerMapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  // Доступные города
  final List<Map<String, dynamic>> _cities = [
    {'name': 'Пермь', 'position': LatLng(58.0105, 56.2502)},
    {'name': 'Казань', 'position': LatLng(55.7958, 49.1068)},
    {'name': 'Сочи', 'position': LatLng(43.6028, 39.7342)},
    {'name': 'Уфа', 'position': LatLng(54.7388, 55.9721)},
  ];

  String? _selectedCity;
  LatLng _currentCenter = LatLng(58.0105, 56.2502);

  // Примеры ресторанов
  final List<Map<String, dynamic>> _restaurants = [
    {
      'name': 'Тестовый ресторан 1',
      'address': 'Пермь, ул. Революции, 13',
      'position': LatLng(58.0105, 56.2502),
      'available': 3,
    },
    {
      'name': 'Тестовый ресторан 2',
      'address': 'Пермь, ул. Ленина, 50',
      'position': LatLng(58.0095, 56.2602),
      'available': 5,
    },
    {
      'name': 'Тестовый ресторан 3',
      'address': 'Пермь, ул. Сибирская, 24',
      'position': LatLng(58.0125, 56.2402),
      'available': 2,
    },
  ];

  String _selectedFilter = 'Все'; // Все, search, filter
  bool _showCitySelector = true;
  bool _showCitySearch = false;

  @override
  void initState() {
    super.initState();
    // Показываем селектор города при первом запуске
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedCity == null) {
        setState(() => _showCitySelector = true);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectCity(String cityName) {
    final city = _cities.firstWhere((c) => c['name'] == cityName);
    setState(() {
      _selectedCity = cityName;
      _currentCenter = city['position'];
      _showCitySelector = false;
      _showCitySearch = false;
    });
    _mapController.move(_currentCenter, 13.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Карта без верхнего отступа
          _buildMap(),

          // Нижняя панель фильтров
          if (_selectedCity != null) _buildBottomFilterPanel(),

          // Поисковая строка (если search выбран)
          if (_selectedFilter == 'search' && _selectedCity != null)
            _buildSearchPanel(),

          // Панель фильтров (если filter выбран)
          if (_selectedFilter == 'filter' && _selectedCity != null)
            _buildFilterPanel(),

          // Селектор города
          if (_showCitySelector) _buildCitySelector(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentCenter,
        initialZoom: 13.0,
        minZoom: 10.0,
        maxZoom: 18.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.foot_food',
        ),
        if (_selectedCity != null)
          MarkerLayer(
            markers: _restaurants.map((restaurant) {
              return Marker(
                point: restaurant['position'],
                width: 60,
                height: 60,
                child: GestureDetector(
                  onTap: () => _showRestaurantInfo(restaurant),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/geo point.svg',
                        width: 60,
                        height: 60,
                      ),
                      Positioned(
                        top: 8,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: const Icon(
                            Icons.restaurant,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildBottomFilterPanel() {
    return Positioned(
      bottom: 190,
      left: 15,
      right: 15,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: const Color(0x59000000),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 24),
            _buildFilterButton('Все', _selectedFilter == 'Все', () {
              setState(() => _selectedFilter = 'Все');
            }),
            const Spacer(),
            Text(
              'С foodbox',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                fontFamily: 'Montserrat',
                color: const Color(0xFF90AAAB),
              ),
            ),
            const Spacer(),
            _buildIconButton(
              _selectedFilter == 'filter'
                  ? 'assets/images/filter.svg'
                  : 'assets/images/filtergreen.svg',
              _selectedFilter == 'filter',
              () {
                setState(() {
                  _selectedFilter = _selectedFilter == 'filter'
                      ? 'Все'
                      : 'filter';
                });
              },
            ),
            const SizedBox(width: 20),
            _buildIconButton(
              _selectedFilter == 'search'
                  ? 'assets/images/search.svg'
                  : 'assets/images/searchgreen.svg',
              _selectedFilter == 'search',
              () {
                setState(() {
                  _selectedFilter = _selectedFilter == 'search'
                      ? 'Все'
                      : 'search';
                });
              },
            ),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 35,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            fontFamily: 'Montserrat',
            color: isSelected ? Colors.black : const Color(0xFF90AAAB),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(
    String assetPath,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 35,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(assetPath, width: 15, height: 15),
      ),
    );
  }

  Widget _buildSearchPanel() {
    return Positioned(
      bottom: 235, // Прикреплено к нижней панели
      left: 15,
      right: 15,
      child: Container(
        height: 45,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '',
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return Positioned(
      bottom: 235, // Прикреплено к нижней панели
      left: 15,
      right: 15,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Фильтр',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Рядом',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                  ),
                ),
                Switch(
                  value: false,
                  onChanged: (value) {},
                  activeColor: AppColors.primary,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildRadioOption('По возрастающей', false),
                    const SizedBox(height: 5),
                    _buildRadioOption('По убывающей', false),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategoryOption('Все заведения', true),
                      _buildCategoryOption('Рестораны', false),
                      _buildCategoryOption('Кондитерские', false),
                      _buildCategoryOption('Пекарни', false),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategoryOption('Бары', false),
                      _buildCategoryOption('Магазины', false),
                      _buildCategoryOption('Фастфуд', false),
                      _buildCategoryOption('Кафе', false),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Применить',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD6D6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Сбросить',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption(String title, bool selected) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? AppColors.primary : Colors.transparent,
            border: Border.all(color: Colors.grey),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryOption(String title, bool selected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? AppColors.primary : Colors.transparent,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Montserrat',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCitySelector() {
    return Stack(
      children: [
        // Размытый фон
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
        ),
        // Кнопка или список городов
        Center(
          child: _showCitySearch ? _buildCityList() : _buildSelectCityButton(),
        ),
      ],
    );
  }

  Widget _buildSelectCityButton() {
    return GestureDetector(
      onTap: () {
        setState(() => _showCitySearch = true);
      },
      child: Container(
        width: 300,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: const Color(0x59000000),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Text(
          'Выберете город',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCityList() {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0x59000000),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Поисковая строка
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.white, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '',
                      hintStyle: TextStyle(color: Colors.white70),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Список городов
          ...(_cities.map(
            (city) => ListTile(
              title: Text(
                city['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                ),
              ),
              onTap: () => _selectCity(city['name']),
            ),
          )),
        ],
      ),
    );
  }

  void _showRestaurantInfo(Map<String, dynamic> restaurant) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFFFCF8F8),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 53,
                  height: 53,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF10292A),
                      width: 1.5,
                    ),
                    color: Colors.grey[300],
                  ),
                  child: const Icon(Icons.restaurant, color: Colors.grey),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        restaurant['address'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'Montserrat',
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              'Доступно ${restaurant['available']} foodbox',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Смотреть заказы',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Jura',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
