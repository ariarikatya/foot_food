import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/order_model.dart';
import '../../data/services/mock_api_service.dart';
import 'widgets/buyer_home_header.dart';
import 'widgets/order_card.dart';
import 'widgets/filter_dialog.dart';
import 'widgets/expanded_order_dialog.dart';

/// Чистый главный экран покупателя
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
  FilterState _filterState = FilterState();

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
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => FilterDialog(
        initialState: _filterState,
        onApply: (newState) {
          setState(() => _filterState = newState);
          // TODO: Применить фильтры к списку заказов
        },
      ),
    );
  }

  void _showExpandedOrder(OrderModel order) {
    final sellerInfo = _getSellerInfo(order.idSeller);
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => ExpandedOrderDialog(
        order: order,
        nameRestaurant: sellerInfo['nameRestaurant']!,
        address: sellerInfo['address']!,
        onReserve: () => _handleReserve(order),
      ),
    );
  }

  void _handleReserve(OrderModel order) {
    // TODO: Реализовать логику бронирования
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Заказ #${order.numberOrder} забронирован'),
        backgroundColor: AppColors.success,
      ),
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
            BuyerHomeHeader(
              searchController: _searchController,
              isSearching: _isSearching,
              onSearchToggle: _toggleSearch,
              onFilterPressed: _showFilterDialog,
            ),
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
