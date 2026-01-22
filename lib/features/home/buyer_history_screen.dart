import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/search_header_widget.dart';
import '../../data/models/order_history_model.dart';
import '../../data/services/mock_api_service.dart';
import '../home/widgets/order_card.dart';
import '../../data/models/order_model.dart';

/// Экран истории заказов покупателя (Экран 11)
class BuyerHistoryScreen extends StatefulWidget {
  const BuyerHistoryScreen({super.key});

  @override
  State<BuyerHistoryScreen> createState() => _BuyerHistoryScreenState();
}

class _BuyerHistoryScreenState extends State<BuyerHistoryScreen> {
  final _apiService = MockApiService();
  final _searchController = TextEditingController();

  List<OrderHistoryModel> _historyOrders = [];
  List<OrderHistoryModel> _filteredOrders = [];
  bool _isLoading = true;
  bool _isSearching = false;
  bool _isFilterOpen = false;

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
      // Для теста - пустой список
      final history = <OrderHistoryModel>[];
      setState(() {
        _historyOrders = history;
        _filteredOrders = history;
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
        _filteredOrders = _historyOrders;
      } else {
        _filteredOrders = _historyOrders.where((order) {
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

  void _showOrderDetails(OrderHistoryModel historyOrder) {
    final order = OrderModel(
      id: historyOrder.id,
      idSeller: historyOrder.idSeller,
      numberOrder: historyOrder.numberOrder,
      cookingTime: historyOrder.cookingTime,
      saleTime: historyOrder.saleTime,
      endTime: historyOrder.endTime,
      compositionOrder: historyOrder.compositionOrder,
      description: historyOrder.description,
      price: historyOrder.price,
      numberReservation: historyOrder.numberReservation,
    );

    final sellerInfo = _getSellerInfo(historyOrder.idSeller);

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
                child: Container(color: Colors.white.withOpacity(0.3)),
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
                  title: 'История покупок',
                ),
              ),
            ),
            _HistoryOrderDialog(
              order: order,
              nameRestaurant: sellerInfo['nameRestaurant']!,
              address: sellerInfo['address']!,
            ),
          ],
        );
      },
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
                image: AssetImage('assets/images/bucal.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              SearchHeaderWidget(
                searchController: _searchController,
                isSearching: _isSearching,
                onSearchToggle: _toggleSearch,
                onFilterPressed: _toggleFilter,
                showFilter: true,
                isFilterOpen: _isFilterOpen,
                title: 'История покупок',
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildContent(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_filteredOrders.isEmpty) {
      return Stack(
        children: [
          // Размытый светлый фон
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.white.withOpacity(0.3)),
            ),
          ),
          // Текст строго по центру экрана
          Align(
            alignment: Alignment.center,
            child: const Text(
              'На данный момент история\nваших foodbox пуста',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                fontFamily: 'Montserrat',
                color: Colors.black,
              ),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 40),
      itemCount: _filteredOrders.length,
      itemBuilder: (context, index) {
        final historyOrder = _filteredOrders[index];
        final sellerInfo = _getSellerInfo(historyOrder.idSeller);

        final order = OrderModel(
          id: historyOrder.id,
          idSeller: historyOrder.idSeller,
          numberOrder: historyOrder.numberOrder,
          cookingTime: historyOrder.cookingTime,
          saleTime: historyOrder.saleTime,
          endTime: historyOrder.endTime,
          compositionOrder: historyOrder.compositionOrder,
          description: historyOrder.description,
          price: historyOrder.price,
          numberReservation: historyOrder.numberReservation,
        );

        return _HistoryOrderCard(
          order: order,
          nameRestaurant: sellerInfo['nameRestaurant']!,
          address: sellerInfo['address']!,
          logo: sellerInfo['logo']!,
          onTap: () => _showOrderDetails(historyOrder),
        );
      },
    );
  }
}

/// Диалог для заказа из истории
class _HistoryOrderDialog extends StatefulWidget {
  final OrderModel order;
  final String nameRestaurant;
  final String address;

  const _HistoryOrderDialog({
    required this.order,
    required this.nameRestaurant,
    required this.address,
  });

  @override
  State<_HistoryOrderDialog> createState() => _HistoryOrderDialogState();
}

class _HistoryOrderDialogState extends State<_HistoryOrderDialog> {
  late PageController _pageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
            ),
          ],
        ),
        child: Column(
          children: [
            _buildImageCarousel(),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return SizedBox(
      height: 100,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: 3,
            onPageChanged: (index) {
              setState(() => _currentImageIndex = index);
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
                child: const Icon(Icons.close, size: 14, color: Colors.white),
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
                  width: _currentImageIndex == index ? 10 : 5,
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
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRestaurantInfo(),
          const SizedBox(height: 10),
          Text(
            widget.address,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Номер заказа: ${widget.order.numberOrder}',
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
                'Изготовлено: ${_formatTime(widget.order.cookingTime)}',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Jura',
                  color: AppColors.textPrimary,
                ),
              ),
              const Text(
                'Заказ выполнен',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Jura',
                  color: AppColors.success,
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
                    'Описание: ${widget.order.description ?? "Нет описания"}',
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
                    '${widget.order.price.toStringAsFixed(0)} ₽',
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
    );
  }

  Widget _buildRestaurantInfo() {
    return Row(
      children: [
        Container(
          width: 53,
          height: 53,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF10292A), width: 1.5),
            color: Colors.grey[300],
          ),
          child: const Icon(Icons.restaurant, color: Colors.grey),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            widget.nameRestaurant,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Карточка заказа из истории
class _HistoryOrderCard extends StatefulWidget {
  final OrderModel order;
  final String nameRestaurant;
  final String address;
  final String logo;
  final VoidCallback onTap;

  const _HistoryOrderCard({
    required this.order,
    required this.nameRestaurant,
    required this.address,
    required this.logo,
    required this.onTap,
  });

  @override
  State<_HistoryOrderCard> createState() => _HistoryOrderCardState();
}

class _HistoryOrderCardState extends State<_HistoryOrderCard> {
  late PageController _pageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
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
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildImageCarousel(),
                _buildCardContent(),
                _buildDetailsButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return SizedBox(
      height: 100,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: 3,
            onPageChanged: (index) {
              setState(() => _currentImageIndex = index);
            },
            itemBuilder: (context, index) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(Icons.fastfood, size: 50, color: Colors.grey),
              );
            },
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
                  width: _currentImageIndex == index ? 10 : 5,
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
    );
  }

  Widget _buildCardContent() {
    return Padding(
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
                  child: const Icon(Icons.restaurant, color: Colors.grey),
                ),
                const SizedBox(width: 9),
                Text(
                  widget.nameRestaurant,
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
                  widget.address,
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
              const Expanded(
                flex: 4,
                child: Text(
                  'Заказ выполнен',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Montserrat',
                    color: AppColors.success,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                flex: 2,
                child: Text(
                  '${widget.order.price.toStringAsFixed(0)} ₽',
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
    );
  }

  Widget _buildDetailsButton() {
    return Container(
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
          onTap: widget.onTap,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          child: const Center(
            child: Text(
              'Подробнее',
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
    );
  }
}
