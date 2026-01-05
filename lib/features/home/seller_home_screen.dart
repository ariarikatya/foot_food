import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/order_model.dart';
import '../../data/models/order_history_model.dart';
import '../../data/services/mock_api_service.dart';
import 'widgets/seller_home_header.dart';
import 'widgets/seller_order_card.dart';
import 'widgets/seller_order_dialog.dart';
import 'widgets/order_section.dart';

/// Чистый главный экран продавца
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

  Map<String, String> _getSellerInfo(int sellerId) {
    return {
      'nameRestaurant': 'Тестовый ресторан',
      'address': 'Пермь, ул. Революции, 13',
    };
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd.MM.yyyy').format(date);
  }

  void _showActiveOrderDialog(OrderModel order) {
    final sellerInfo = _getSellerInfo(order.idSeller);
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => ActiveOrderDialog(
        order: order,
        nameRestaurant: sellerInfo['nameRestaurant']!,
        address: sellerInfo['address']!,
        onComplete: () => _handleCompleteOrder(order),
      ),
    );
  }

  void _showHistoryOrderDialog(OrderHistoryModel order) {
    final sellerInfo = _getSellerInfo(order.idSeller);
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => HistoryOrderDialog(
        order: order,
        nameRestaurant: sellerInfo['nameRestaurant']!,
        address: sellerInfo['address']!,
      ),
    );
  }

  void _handleCompleteOrder(OrderModel order) {
    // TODO: Реализовать логику выдачи заказа
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Заказ #${order.numberOrder} выдан'),
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
            image: AssetImage('assets/images/sellerHome.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SellerHomeHeader(searchController: _searchController),
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 31),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            OrderSection(
              title: 'Активные',
              isEmpty: _filteredActiveOrders.isEmpty,
              emptyMessage: 'Нет активных заказов',
              children: _filteredActiveOrders.map((order) {
                final sellerInfo = _getSellerInfo(order.idSeller);
                return SellerOrderCard(
                  nameRestaurant: sellerInfo['nameRestaurant']!,
                  address: sellerInfo['address']!,
                  date: _formatDate(order.cookingTime),
                  price: order.price,
                  onTap: () => _showActiveOrderDialog(order),
                );
              }).toList(),
            ),
            const SizedBox(height: 23),
            OrderSection(
              title: 'История',
              isEmpty: _filteredHistoryOrders.isEmpty,
              emptyMessage: 'История пуста',
              children: _filteredHistoryOrders.map((order) {
                final sellerInfo = _getSellerInfo(order.idSeller);
                return SellerOrderCard(
                  nameRestaurant: sellerInfo['nameRestaurant']!,
                  address: sellerInfo['address']!,
                  date: _formatDate(order.bayTime),
                  price: order.price,
                  onTap: () => _showHistoryOrderDialog(order),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
