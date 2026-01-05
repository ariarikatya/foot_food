import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../data/models/order_model.dart';
import '../../data/models/order_history_model.dart';
import '../../data/services/mock_api_service.dart';

/// Главный экран продавца
class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  final _apiService = MockApiService();
  final _searchController = TextEditingController();
  List<OrderModel> _activeOrders = [];
  List<OrderHistoryModel> _historyOrders = [];
  List<OrderModel> _filteredActiveOrders = [];
  List<OrderHistoryModel> _filteredHistoryOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterOrders);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterOrders() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredActiveOrders = _activeOrders;
        _filteredHistoryOrders = _historyOrders;
      } else {
        _filteredActiveOrders = _activeOrders.where((order) {
          final sellerInfo = _getSellerInfo(order.idSeller);
          final name = sellerInfo['nameRestaurant']!.toLowerCase();
          final address = sellerInfo['address']!.toLowerCase();
          return name.contains(query) || address.contains(query);
        }).toList();

        _filteredHistoryOrders = _historyOrders.where((order) {
          final sellerInfo = _getSellerInfo(order.idSeller);
          final name = sellerInfo['nameRestaurant']!.toLowerCase();
          final address = sellerInfo['address']!.toLowerCase();
          return name.contains(query) || address.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _loadData() async {
    try {
      final orders = await _apiService.getSellerOrders(1);
      final history = await _apiService.getUserOrderHistory(1);

      setState(() {
        _activeOrders = orders;
        _historyOrders = history;
        _filteredActiveOrders = orders;
        _filteredHistoryOrders = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd.MM.yyyy').format(date);
  }

  Map<String, String> _getSellerInfo(int sellerId) {
    return {
      'nameRestaurant': 'Тестовый ресторан',
      'address': 'Пермь, ул. Революции, 13',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sellerHome.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 150,
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
      child: Column(
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 26, right: 26, bottom: 20),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              // Убираем padding у контейнера, чтобы TextField заполнял все пространство
              child: TextField(
                controller: _searchController,
                // Это свойство центрирует текст по вертикали относительно иконки
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
                  // Явно убираем все виды обводок (рамок)
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,

                  isDense: true,
                  // Отступ текста слева (как было horizontal: 24)
                  contentPadding: const EdgeInsets.only(left: 24),

                  // Вставляем иконку внутрь поля
                  suffixIconConstraints: const BoxConstraints(
                    minHeight: 24,
                    minWidth: 48, // Минимальная ширина для области клика
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(
                      right: 24,
                      left: 10,
                    ), // Отступы иконки
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
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 31),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildSectionTitle('Активные'),
            const SizedBox(height: 20),
            _buildActiveOrders(),
            const SizedBox(height: 23),
            _buildSectionTitle('История'),
            const SizedBox(height: 10),
            _buildHistoryOrders(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(height: 1, color: const Color(0xFF00221D)),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveOrders() {
    if (_filteredActiveOrders.isEmpty) {
      return const Center(
        child: Text(
          'Нет активных заказов',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Montserrat',
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filteredActiveOrders.length,
        itemBuilder: (context, index) {
          final order = _filteredActiveOrders[index];
          final sellerInfo = _getSellerInfo(order.idSeller);
          return _buildOrderCard(
            nameRestaurant: sellerInfo['nameRestaurant']!,
            address: sellerInfo['address']!,
            date: _formatDate(order.cookingTime),
            price: order.price,
          );
        },
      ),
    );
  }

  Widget _buildHistoryOrders() {
    if (_filteredHistoryOrders.isEmpty) {
      return const Center(
        child: Text(
          'История пуста',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Montserrat',
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filteredHistoryOrders.length,
        itemBuilder: (context, index) {
          final order = _filteredHistoryOrders[index];
          final sellerInfo = _getSellerInfo(order.idSeller);
          return _buildOrderCard(
            nameRestaurant: sellerInfo['nameRestaurant']!,
            address: sellerInfo['address']!,
            date: _formatDate(order.bayTime),
            price: order.price,
            historyOrder: order,
          );
        },
      ),
    );
  }

  Widget _buildOrderCard({
    required String nameRestaurant,
    required String address,
    required String date,
    required double price,
    OrderHistoryModel? historyOrder,
  }) {
    return GestureDetector(
      onTap: () {
        if (historyOrder != null) {
          _showExpandedHistoryCard(
            context,
            historyOrder,
            nameRestaurant,
            address,
          );
        }
      },
      child: Container(
        width: 147,
        height: 150,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFCF8F8),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0x59000000),
              offset: const Offset(4, 8),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              nameRestaurant,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                fontFamily: 'Jura',
                color: AppColors.textPrimary,
                height: 0.95,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              address,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${price.toStringAsFixed(0)} ₽',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Montserrat',
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExpandedHistoryCard(
    BuildContext context,
    OrderHistoryModel order,
    String nameRestaurant,
    String address,
  ) {
    final PageController dialogPageController = PageController();
    int currentImageIndex = 0;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 46),
            child: Stack(
              children: [
                _buildHeader(),
                Center(
                  child: Container(
                    height: 480,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCF8F8),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x59051F20),
                          offset: const Offset(4, 8),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Карусель изображений
                        SizedBox(
                          height: 100,
                          child: Stack(
                            children: [
                              PageView.builder(
                                controller: dialogPageController,
                                itemCount: 3,
                                onPageChanged: (index) {
                                  setState(() => currentImageIndex = index);
                                },
                                itemBuilder: (context, index) {
                                  return ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    child: Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.fastfood,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                top: 8,
                                right: 18,
                                child: GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 7,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    3,
                                    (index) => Container(
                                      width: currentImageIndex == index
                                          ? 10
                                          : 5,
                                      height: 5,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD9D9D9),
                                        borderRadius: BorderRadius.circular(
                                          2.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFF10292A),
                                          width: 1.5,
                                        ),
                                        color: Colors.grey[300],
                                      ),
                                      child: const Icon(
                                        Icons.restaurant,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 9),
                                    Expanded(
                                      child: Text(
                                        nameRestaurant,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: 'Montserrat',
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  address,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Montserrat',
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Номер заказа: ${order.numberOrder}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Montserrat',
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Приготовлено',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Montserrat',
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          _formatTime(order.cookingTime),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Montserrat',
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      '|',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Выставлено на продажу',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Montserrat',
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          _formatTime(order.saleTime),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Montserrat',
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      '|',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Забрали в',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Montserrat',
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          _formatTime(order.bayTime),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Montserrat',
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Описание: ${order.description ?? "Нет описания"}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Montserrat',
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Внутри: ${order.compositionOrder ?? "Не указано"}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: 'Montserrat',
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          '${order.price.toStringAsFixed(0)} ₽',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Montserrat',
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              child: const Center(
                                child: Text(
                                  'Выдать',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Jura',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    return DateFormat('HH:mm').format(time);
  }
}
