import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Секция заказов с заголовком для продавца
class OrderSection extends StatelessWidget {
  final String title;
  final bool isEmpty;
  final String emptyMessage;
  final List<Widget> children;

  const OrderSection({
    super.key,
    required this.title,
    required this.isEmpty,
    required this.emptyMessage,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(),
        const SizedBox(height: 20),
        isEmpty ? _buildEmptyState() : _buildOrderList(),
      ],
    );
  }

  Widget _buildSectionTitle() {
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

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        emptyMessage,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Montserrat',
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    return SizedBox(
      height: 180,
      child: ListView(scrollDirection: Axis.horizontal, children: children),
    );
  }
}
