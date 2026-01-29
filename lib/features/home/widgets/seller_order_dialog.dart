import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/order_history_model.dart';

/// Диалог для активного заказа продавца
class ActiveOrderDialog extends StatefulWidget {
  final OrderModel order;
  final String nameRestaurant;
  final String address;
  final VoidCallback onComplete;

  const ActiveOrderDialog({
    super.key,
    required this.order,
    required this.nameRestaurant,
    required this.address,
    required this.onComplete,
  });

  @override
  State<ActiveOrderDialog> createState() => _ActiveOrderDialogState();
}

class _ActiveOrderDialogState extends State<ActiveOrderDialog> {
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
    return DateFormat('HH:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Dialog(
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
              _buildActionButton(),
            ],
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
              child: const Icon(Icons.close, size: 14, color: Colors.white),
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
              Text(
                'В продаже до: ${_formatTime(widget.order.endTime)}',
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

  Widget _buildActionButton() {
    return Container(
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
          onTap: widget.onComplete,
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
    );
  }
}

/// Диалог для истории заказа продавца (ОДИНАКОВАЯ ВЫСОТА 480)
class HistoryOrderDialog extends StatefulWidget {
  final OrderHistoryModel order;
  final String nameRestaurant;
  final String address;
  final VoidCallback onClose;

  const HistoryOrderDialog({
    super.key,
    required this.order,
    required this.nameRestaurant,
    required this.address,
    required this.onClose,
  });

  @override
  State<HistoryOrderDialog> createState() => _HistoryOrderDialogState();
}

class _HistoryOrderDialogState extends State<HistoryOrderDialog> {
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
    return DateFormat('HH:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 46),
        child: Container(
          height: 480, // Та же высота, что и ActiveOrderDialog
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
              onTap: widget.onClose,
              child: const Icon(Icons.close, size: 14, color: Colors.white),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
          _buildTimelineInfo(),
          const SizedBox(height: 5),
          Text(
            'Описание: ${widget.order.description ?? "Нет описания"}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              fontFamily: 'Montserrat',
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Внутри: ${widget.order.compositionOrder ?? "Не указано"}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Montserrat',
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '${widget.order.price.toStringAsFixed(0)} ₽',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                  color: AppColors.textPrimary,
                ),
              ),
            ],
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

  Widget _buildTimelineInfo() {
    return Wrap(
      spacing: 10,
      runSpacing: 5,
      children: [
        _buildTimelineItem(
          'Приготовлено',
          _formatTime(widget.order.cookingTime),
        ),
        const Text('|', style: TextStyle(fontSize: 16)),
        _buildTimelineItem(
          'Выставлено на продажу',
          _formatTime(widget.order.saleTime),
        ),
        const Text('|', style: TextStyle(fontSize: 16)),
        _buildTimelineItem('Забрали в', _formatTime(widget.order.bayTime)),
      ],
    );
  }

  Widget _buildTimelineItem(String label, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            fontFamily: 'Jura',
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          time,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            fontFamily: 'Jura',
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
