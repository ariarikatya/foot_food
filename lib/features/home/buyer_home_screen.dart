import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/order_model.dart';
import '../../data/services/mock_api_service.dart';

/// Главный экран покупателя
class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  final _apiService = MockApiService();
  final _searchController = TextEditingController();
  List<OrderModel> _orders = [];
  List<OrderModel> _filteredOrders = [];
  bool _isLoading = true;
  bool _isSearching = false;
  bool _isFilterOpen = false;
  final Map<int, PageController> _pageControllers = {};
  final Map<int, int> _currentImageIndices = {};
  final Map<int, Timer?> _autoScrollTimers = {};

  // Фильтры
  bool _filterNearby = false;
  bool _filterIncreasing = false;
  bool _filterDecreasing = false;
  Set<String> _selectedCategories = {};

  final List<String> _categories = [
    'Все заведения',
    'Бары',
    'Рестораны',
    'Магазины',
    'Кондитерские',
    'Фастфуд',
    'Пекарни',
    'Кафе',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterOrders);
  }

  @override
  void dispose() {
    _searchController.dispose();
    for (var controller in _pageControllers.values) {
      controller.dispose();
    }
    for (var timer in _autoScrollTimers.values) {
      timer?.cancel();
    }
    super.dispose();
  }

  void _filterOrders() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredOrders = _orders;
      } else {
        _filteredOrders = _orders.where((order) {
          final sellerInfo = _getSellerInfo(order.idSeller);
          final name = sellerInfo['nameRestaurant']!.toLowerCase();
          final address = sellerInfo['address']!.toLowerCase();
          return name.contains(query) || address.contains(query);
        }).toList();
      }
    });
  }

  void _startAutoScroll(int orderId) {
    _autoScrollTimers[orderId]?.cancel();
    _autoScrollTimers[orderId] = Timer.periodic(const Duration(seconds: 3), (
      timer,
    ) {
      final controller = _pageControllers[orderId];
      if (controller != null && controller.hasClients) {
        final currentIndex = _currentImageIndices[orderId] ?? 0;
        final nextPage = (currentIndex + 1) % 3;
        controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _loadData() async {
    try {
      final orders = await _apiService.getSellerOrders(1);
      setState(() {
        _orders = orders;
        _filteredOrders = orders;
        _isLoading = false;
        for (var order in orders) {
          _pageControllers[order.id] = PageController();
          _currentImageIndices[order.id] = 0;
          _startAutoScroll(order.id);
        }
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    return DateFormat('HH:mm').format(time);
  }

  Map<String, String> _getSellerInfo(int sellerId) {
    return {
      'nameRestaurant': 'Тестовый ресторан',
      'address': 'Пермь, ул. Революции, 13',
      'logo': 'assets/images/placeholder_restaurant.png',
    };
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.transparent,
          alignment: Alignment.topCenter,
          insetPadding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 60,
            left: 26,
            right: 26,
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 500),
            decoration: BoxDecoration(
              color: const Color(0xFFFCF8F8),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x59051F20),
                  offset: const Offset(4, 8),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Заголовок
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: const Text(
                    'Фильтр',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat',
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFF00221D)),

                // Содержимое фильтра
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Рядом
                        _buildFilterCheckbox(
                          'Рядом',
                          _filterNearby,
                          (value) =>
                              setState(() => _filterNearby = value ?? false),
                        ),
                        const SizedBox(height: 10),

                        // По возрастающей
                        _buildFilterCheckbox(
                          'По возрастающей',
                          _filterIncreasing,
                          (value) => setState(
                            () => _filterIncreasing = value ?? false,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // По убывающей
                        _buildFilterCheckbox(
                          'По убывающей',
                          _filterDecreasing,
                          (value) => setState(
                            () => _filterDecreasing = value ?? false,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Разделитель
                        const Divider(height: 1, color: Color(0xFF00221D)),
                        const SizedBox(height: 20),

                        // Категории
                        ..._categories.map(
                          (category) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _buildCategoryCheckbox(category),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Кнопки
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Применить фильтры
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Применить',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _filterNearby = false;
                              _filterIncreasing = false;
                              _filterDecreasing = false;
                              _selectedCategories.clear();
                            });
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(
                              color: AppColors.border,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Сбросить',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                            ),
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
      ),
    );
  }

  Widget _buildFilterCheckbox(
    String title,
    bool value,
    Function(bool?) onChanged,
  ) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCheckbox(String category) {
    final isSelected = _selectedCategories.contains(category);
    return Row(
      children: [
        Checkbox(
          value: isSelected,
          onChanged: (value) {
            setState(() {
              if (value == true) {
                _selectedCategories.add(category);
              } else {
                _selectedCategories.remove(category);
              }
            });
          },
          activeColor: AppColors.primary,
        ),
        Text(
          category,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w300,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/buyerHome.png'),
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
            if (_isSearching) ...[
              Padding(
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
                                    controller: _searchController,
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
                                  onTap: () {
                                    setState(() {
                                      _isSearching = false;
                                      _searchController.clear();
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _showFilterDialog,
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
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 31),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() => _isSearching = true);
                      },
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
                      onTap: _showFilterDialog,
                      child: SvgPicture.asset(
                        'assets/images/filtergreen.svg',
                        width: 28,
                        height: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 17),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_filteredOrders.isEmpty) {
      return const Center(
        child: Text(
          'Нет доступных заказов',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Montserrat',
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 40),
      itemCount: _filteredOrders.length,
      itemBuilder: (context, index) {
        final order = _filteredOrders[index];
        final sellerInfo = _getSellerInfo(order.idSeller);
        return _buildOrderCard(
          order: order,
          nameRestaurant: sellerInfo['nameRestaurant']!,
          address: sellerInfo['address']!,
          logo: sellerInfo['logo']!,
        );
      },
    );
  }

  Widget _buildOrderCard({
    required OrderModel order,
    required String nameRestaurant,
    required String address,
    required String logo,
  }) {
    final images = [
      'assets/images/placeholder_food.png',
      'assets/images/placeholder_food.png',
      'assets/images/placeholder_food.png',
    ];

    if (!_pageControllers.containsKey(order.id)) {
      _pageControllers[order.id] = PageController();
      _currentImageIndices[order.id] = 0;
      _startAutoScroll(order.id);
    }

    final pageController = _pageControllers[order.id]!;
    final currentImageIndex = _currentImageIndices[order.id] ?? 0;

    return GestureDetector(
      onTap: () =>
          _showExpandedCard(context, order, nameRestaurant, address, logo),
      child: Center(
        child: Container(
          width: 331,
          margin: const EdgeInsets.only(bottom: 30),
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 100,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: pageController,
                        itemCount: images.length,
                        onPageChanged: (index) {
                          setState(
                            () => _currentImageIndices[order.id] = index,
                          );
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.fastfood,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 8,
                        right: 18,
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
                      Positioned(
                        bottom: 7,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            images.length,
                            (index) => Container(
                              width: currentImageIndex == index ? 10 : 5,
                              height: 5,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD9D9D9),
                                borderRadius: BorderRadius.circular(2.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.translate(
                        offset: const Offset(0, -23),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                            Text(
                              nameRestaurant,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Montserrat',
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
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
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 4,
                            child: Text(
                              'В продаже с ${_formatTime(order.saleTime)} до ${_formatTime(order.endTime)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Montserrat',
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${order.price.toStringAsFixed(0)} ₽',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Montserrat',
                                color: AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
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
                      onTap: () {},
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      child: const Center(
                        child: Text(
                          'Забронировать',
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
      ),
    );
  }

  void _showExpandedCard(
    BuildContext context,
    OrderModel order,
    String nameRestaurant,
    String address,
    String logo,
  ) {
    final PageController dialogPageController = PageController();
    int currentImageIndex = 0;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Stack(
          children: [
            // Размытый фон
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.transparent),
              ),
            ),
            // Хедер БЕЗ размытия
            Positioned(top: 0, left: 0, right: 0, child: _buildHeader()),
            // Диалог
            Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(horizontal: 46),
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
                    SizedBox(
                      height: 100,
                      child: Stack(
                        children: [
                          PageView.builder(
                            controller: dialogPageController,
                            itemCount: 3,
                            onPageChanged: (index) {
                              setDialogState(() => currentImageIndex = index);
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
                                  width: currentImageIndex == index ? 10 : 5,
                                  height: 5,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD9D9D9),
                                    borderRadius: BorderRadius.circular(2.5),
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
                            const SizedBox(height: 5),
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
                                      fontSize: 16,
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
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Montserrat',
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Изготовлено: ${_formatTime(order.cookingTime)}',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Jura',
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'В продаже до: ${_formatTime(order.endTime)}',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Jura',
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Описание: ${order.description ?? "Нет описания"}',
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
                                        fontSize: 28,
                                        fontWeight: FontWeight.w500,
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
                              'Забронировать',
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
    );
  }
}
