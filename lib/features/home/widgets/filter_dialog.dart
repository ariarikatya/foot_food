import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Модель состояния фильтров
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

  FilterState copyWith({
    bool? filterNearby,
    bool? filterIncreasing,
    bool? filterDecreasing,
    Set<String>? selectedCategories,
  }) {
    return FilterState(
      filterNearby: filterNearby ?? this.filterNearby,
      filterIncreasing: filterIncreasing ?? this.filterIncreasing,
      filterDecreasing: filterDecreasing ?? this.filterDecreasing,
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }

  void reset() {
    filterNearby = false;
    filterIncreasing = false;
    filterDecreasing = false;
    selectedCategories.clear();
  }
}

/// Диалог фильтров для главного экрана покупателя
class FilterDialog extends StatefulWidget {
  final FilterState initialState;
  final Function(FilterState) onApply;

  const FilterDialog({
    super.key,
    required this.initialState,
    required this.onApply,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late FilterState _state;

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
    _state = widget.initialState.copyWith(
      selectedCategories: Set.from(widget.initialState.selectedCategories),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
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
              _buildHeader(),
              const Divider(height: 1, color: Color(0xFF00221D)),
              _buildContent(),
              _buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
    );
  }

  Widget _buildContent() {
    return Flexible(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FilterCheckbox(
              title: 'Рядом',
              value: _state.filterNearby,
              onChanged: (value) {
                setState(() => _state.filterNearby = value ?? false);
              },
            ),
            const SizedBox(height: 10),
            _FilterCheckbox(
              title: 'По возрастающей',
              value: _state.filterIncreasing,
              onChanged: (value) {
                setState(() => _state.filterIncreasing = value ?? false);
              },
            ),
            const SizedBox(height: 10),
            _FilterCheckbox(
              title: 'По убывающей',
              value: _state.filterDecreasing,
              onChanged: (value) {
                setState(() => _state.filterDecreasing = value ?? false);
              },
            ),
            const SizedBox(height: 20),
            const Divider(height: 1, color: Color(0xFF00221D)),
            const SizedBox(height: 20),
            ..._categories.map(
              (category) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _FilterCheckbox(
                  title: category,
                  value: _state.selectedCategories.contains(category),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        _state.selectedCategories.add(category);
                      } else {
                        _state.selectedCategories.remove(category);
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(_state);
                Navigator.pop(context);
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
                setState(() => _state.reset());
                widget.onApply(_state);
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.border, width: 2),
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
    );
  }
}

class _FilterCheckbox extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool?) onChanged;

  const _FilterCheckbox({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
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
}
