import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Кастомное текстовое поле
class CustomTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool enabled;
  final bool readOnly;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            obscuringCharacter: '*',
            keyboardType: keyboardType,
            validator: validator,
            onChanged: onChanged,
            onTap: onTap,
            readOnly: readOnly,
            maxLines: maxLines,
            enabled: enabled,
            inputFormatters: inputFormatters,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1A1C1B),
              fontFamily: 'Montserrat',
            ),
            decoration: InputDecoration(
              hintText: hintText,
              labelText: labelText,
              hintStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1A1C1B),
                fontFamily: 'Montserrat',
              ),
              labelStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1A1C1B),
                fontFamily: 'Montserrat',
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              filled: true,
              fillColor: Colors.white.withOpacity(0.3),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                borderSide: const BorderSide(color: AppColors.border, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                borderSide: const BorderSide(color: AppColors.border, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                borderSide: const BorderSide(color: AppColors.error, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                borderSide: const BorderSide(color: AppColors.error, width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                borderSide: BorderSide(
                  color: AppColors.border.withOpacity(0.5),
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
