import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';

/// Экран выбора адреса на карте
class AddressMapScreen extends StatefulWidget {
  final Function(String) onAddressSelected;

  const AddressMapScreen({super.key, required this.onAddressSelected});

  @override
  State<AddressMapScreen> createState() => _AddressMapScreenState();
}

class _AddressMapScreenState extends State<AddressMapScreen> {
  final MapController _mapController = MapController();

  // Координаты Перми по умолчанию
  LatLng _selectedPosition = LatLng(58.0105, 56.2502);
  String _selectedAddress = 'Пермь\nулица Революции, 13';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          _buildLocationMarker(),
          _buildTopControls(),
          _buildBottomPanel(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _selectedPosition,
        initialZoom: 15.0,
        minZoom: 10.0,
        maxZoom: 18.0,
        onPositionChanged: (MapPosition position, bool hasGesture) {
          if (hasGesture && position.center != null) {
            setState(() {
              _selectedPosition = position.center!;
              // Здесь можно добавить обратное геокодирование для получения адреса
              _selectedAddress =
                  'Пермь\nКоординаты: ${_selectedPosition.latitude.toStringAsFixed(4)}, ${_selectedPosition.longitude.toStringAsFixed(4)}';
            });
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.foot_food',
        ),
      ],
    );
  }

  Widget _buildLocationMarker() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, size: 50, color: AppColors.primary),
          // Смещение маркера вверх для точности центра
          SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _buildTopControls() {
    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCircleButton(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.of(context).pop(),
            ),
            _buildCircleButton(
              icon: Icons.my_location,
              onPressed: () {
                // Центрировать карту на координатах Перми
                _mapController.move(_selectedPosition, 15.0);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.primary),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Адрес вашего ресторана', style: AppTextStyles.h3),
              const SizedBox(height: AppSpacing.md),
              Text(_selectedAddress, style: AppTextStyles.bodyLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Переместите карту для выбора точного местоположения',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              CustomButton(
                text: 'Готово',
                onPressed: () {
                  widget.onAddressSelected(_selectedAddress);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
