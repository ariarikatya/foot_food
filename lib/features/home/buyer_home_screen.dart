import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/search_header_widget.dart';
import '../../data/models/order_model.dart';
import '../../data/services/mock_api_service.dart';
import 'widgets/order_card.dart';
import 'widgets/expanded_order_dialog.dart';
import 'widgets/reservation_screens.dart';

class FilterState {
  bool filterNearby;
  bool filterIncreasing;
  bool filterDecreasing;
  Set<String> selectedCategories;

  FilterState({
    this.filterNearby = false,
    this.filterIncreasing = false,
    this.filterDecreasing = false,
    Set<String>? selectedCategories,
  }) : selectedCategories = selectedCategories ?? {};

  void reset() {
    filterNearby = false;
    filterIncreasing = false;
    filterDecreasing = false;
    selectedCategories.clear();
  }
}

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
  FilterState _filterState = FilterState();
  bool _hasCard = false; // Симуляция наличия карты

  final List<String> _categories = [
    'Все заведения',
    'Рестораны',
    'Кондитерские',
    'Пекарни',
    'Бары',
    'Магазины',
    'Фастфуд',
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
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final orders = await _apiService.getSellerOrders(1);
      setState(() {
        _orders = orders;
        _filteredOrders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
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

  Map<String, String> _getSellerInfo(int sellerId) {
    return {
      'nameRestaurant': 'Тестовый ресторан',
      'address': 'Пермь, ул. Революции, 13',
      'logo': 'assets/images/placeholder_restaurant.png',
    };
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
      if (_isFilterOpen) {
        _isFilterOpen = false;
      }
    });
  }

  void _toggleFilter() {
    setState(() {
      _isFilterOpen = !_isFilterOpen;
    });
  }

  void _applyFilters() {
    setState(() {
      _isFilterOpen = false;
    });
  }

  void _resetFilters() {
    setState(() {
      _filterState.reset();
      _isFilterOpen = false;
    });
  }

  void _toggleCategory(String category) {
    setState(() {
      if (category == 'Все заведения') {
        if (_filterState.selectedCategories.contains(category)) {
          _filterState.selectedCategories.remove(category);
        } else {
          _filterState.selectedCategories.clear();
          _filterState.selectedCategories.add(category);
        }
      } else {
        _filterState.selectedCategories.remove('Все заведения');
        if (_filterState.selectedCategories.contains(category)) {
          _filterState.selectedCategories.remove(category);
        } else {
          _filterState.selectedCategories.add(category);
        }
      }
    });
  }

  void _showExpandedOrder(OrderModel order) {
    final sellerInfo = _getSellerInfo(order.idSeller);

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (dialogContext) {
        return Stack(
          fit: StackFit.expand,
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: GestureDetector(
                onTap: () => Navigator.pop(dialogContext),
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                type: MaterialType.transparency,
                child: SearchHeaderWidget(
                  searchController: _searchController,
                  isSearching: _isSearching,
                  onSearchToggle: () {
                    Navigator.pop(dialogContext);
                    _toggleSearch();
                  },
                  onFilterPressed: () {
                    Navigator.pop(dialogContext);
                    _toggleFilter();
                  },
                  showFilter: true,
                  isFilterOpen: false,
                  title: 'Лента footbox',
                ),
              ),
            ),
            ExpandedOrderDialog(
              order: order,
              nameRestaurant: sellerInfo['nameRestaurant']!,
              address: sellerInfo['address']!,
              onReserve: () {
                Navigator.pop(dialogContext);
                _handleReserve(order);
              },
            ),
          ],
        );
      },
    );
  }

  void _handleReserve(OrderModel order) {
    final sellerInfo = _getSellerInfo(order.idSeller);

    if (!_hasCard) {
      // Показываем экран "Карта не добавлена"
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NoCardScreen(
            order: order,
            onCardAdded: () {
              // После добавления карты
              setState(() => _hasCard = true);
              _showPickupScreen(order, sellerInfo);
            },
          ),
        ),
      );
    } else {
      // Сразу показываем экран забрать заказ
      _showPickupScreen(order, sellerInfo);
    }
  }

  void _showPickupScreen(OrderModel order, Map<String, String> sellerInfo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PickupOrderScreen(
          order: order,
          nameRestaurant: sellerInfo['nameRestaurant']!,
          address: sellerInfo['address']!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/buyerHome.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: _isFilterOpen
                      ? BorderRadius.zero
                      : const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                ),
                child: SearchHeaderWidget(
                  searchController: _searchController,
                  isSearching: _isSearching,
                  onSearchToggle: _toggleSearch,
                  onFilterPressed: _toggleFilter,
                  showFilter: true,
                  isFilterOpen: _isFilterOpen,
                  title: 'Лента footbox',
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildContent(),
                    if (_isFilterOpen) _buildFilterOverlay(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOverlay() {
    final categoriesLeft = [
      'Все заведения',
      'Рестораны',
      'Кондитерские',
      'Пекарни',
    ];
    final categoriesRight = ['Бары', 'Магазины', 'Фастфуд', 'Кафе'];

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Рядом',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Montserrat',
                            color: Color(0xFF7FA29A),
                          ),
                        ),
                        Switch(
                          value: _filterState.filterNearby,
                          onChanged: (value) {
                            setState(() => _filterState.filterNearby = value);
                          },
                          activeColor: const Color(0xFF7FA29A),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildRadioOption(
                          'По возрастающей',
                          _filterState.filterIncreasing,
                          () {
                            setState(() {
                              _filterState.filterIncreasing = true;
                              _filterState.filterDecreasing = false;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildRadioOption(
                          'По убывающей',
                          _filterState.filterDecreasing,
                          () {
                            setState(() {
                              _filterState.filterDecreasing = true;
                              _filterState.filterIncreasing = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: categoriesLeft
                            .map(
                              (category) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _buildCategoryOption(category),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: categoriesRight
                            .map(
                              (category) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: _buildCategoryOption(category),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _applyFilters,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
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
                      child: ElevatedButton(
                        onPressed: _resetFilters,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFD32F2F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOption(String title, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? const Color(0xFF7FA29A) : Colors.transparent,
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
                color: Color(0xFF7FA29A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryOption(String category) {
    final isSelected = _filterState.selectedCategories.contains(category);
    return GestureDetector(
      onTap: () => _toggleCategory(category),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF7FA29A) : Colors.transparent,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            category,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'Montserrat',
              color: Color(0xFF7FA29A),
            ),
          ),
        ],
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

        return OrderCard(
          order: order,
          nameRestaurant: sellerInfo['nameRestaurant']!,
          address: sellerInfo['address']!,
          logo: sellerInfo['logo']!,
          onTap: () => _showExpandedOrder(order),
          onReserve: () => _handleReserve(order),
        );
      },
    );
  }
}
