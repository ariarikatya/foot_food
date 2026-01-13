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

  // Координаты Перми
  final LatLng _permCenter = LatLng(58.0105, 56.2502);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Реальная карта OpenStreetMap
          _buildMap(),

          // Заголовок поверх карты
          _buildHeader(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _permCenter,
        initialZoom: 13.0,
        minZoom: 10.0,
        maxZoom: 18.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.foot_food',
        ),
        MarkerLayer(
          markers: _restaurants.map((restaurant) {
            return Marker(
              point: restaurant['position'],
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => _showRestaurantInfo(restaurant),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 17),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // Показать поиск
                  },
                  child: SvgPicture.asset(
                    'assets/images/searchgreen.svg',
                    width: 25,
                    height: 25,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Карта',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Montserrat',
                    color: Color(0xFF7FA29A),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    // Центрировать на текущей позиции
                    _mapController.move(_permCenter, 13.0);
                  },
                  child: const Icon(
                    Icons.my_location,
                    color: Color(0xFF7FA29A),
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
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
                  // Перейти к списку заказов этого ресторана
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
