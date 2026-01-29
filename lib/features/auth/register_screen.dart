import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/services/mock_api_service.dart';
import 'widgets/register_form_buyer.dart';
import 'widgets/register_form_seller.dart';
import 'widgets/register_bottom_navigation.dart';
import 'widgets/address_map_screen.dart';
import 'widgets/common_app_bar.dart';

/// Чистый экран регистрации
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = MockApiService();
  final _imagePicker = ImagePicker();

  // Состояние
  bool _isBuyer = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Контроллеры для покупателя
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Контроллеры для продавца
  final _emailController = TextEditingController();
  final _restaurantNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _logoController = TextEditingController();
  final _sellerPasswordController = TextEditingController();
  final _sellerConfirmPasswordController = TextEditingController();

  // FocusNode
  final _phoneFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _sellerPasswordFocusNode = FocusNode();
  final _sellerConfirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _phoneFocusNode.addListener(_initializePhoneField);
  }

  @override
  void dispose() {
    _disposeControllers();
    _disposeFocusNodes();
    super.dispose();
  }

  void _disposeControllers() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _restaurantNameController.dispose();
    _addressController.dispose();
    _logoController.dispose();
    _sellerPasswordController.dispose();
    _sellerConfirmPasswordController.dispose();
  }

  void _disposeFocusNodes() {
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _sellerPasswordFocusNode.dispose();
    _sellerConfirmPasswordFocusNode.dispose();
  }

  void _initializePhoneField() {
    if (_phoneFocusNode.hasFocus && _phoneController.text.isEmpty) {
      setState(() {
        _phoneController.text = '+7 (';
        _phoneController.selection = const TextSelection.collapsed(offset: 4);
      });
    }
  }

  String get _backgroundImage =>
      _isBuyer ? 'assets/images/regcli.png' : 'assets/images/regsell.png';

  Future<void> _handleRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      try {
        if (_isBuyer) {
          await _registerBuyer();
        } else {
          await _registerSeller();
        }
      } catch (e) {
        _showError(e.toString());
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _registerBuyer() async {
    final result = await _apiService.registerUser(
      phone: _phoneController.text,
      password: _passwordController.text,
    );

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/buyer_home');
    }
  }

  Future<void> _registerSeller() async {
    final result = await _apiService.registerSeller(
      email: _emailController.text,
      nameRestaurant: _restaurantNameController.text,
      address: _addressController.text,
      password: _sellerPasswordController.text,
      inn: 123456789,
      ogrn: 987654321,
      logo: _logoController.text.isNotEmpty ? _logoController.text : null,
    );

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/seller_home');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: $message'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _logoController.text = image.path.split('/').last;
        });
      }
    } catch (e) {
      _showError('Ошибка выбора изображения: $e');
    }
  }

  Future<void> _openAddressMap() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddressMapScreen(
          onAddressSelected: (address) {
            setState(() => _addressController.text = address);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Column(
                children: [
                  AppBarWithLogo(
                    onBackPressed: () => Navigator.of(context).pop(),
                    showSmallLogo: !_isBuyer,
                  ),
                  Expanded(child: _buildForm()),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: RegisterBottomNavigation(
                  isBuyer: _isBuyer,
                  onBuyerTap: () => setState(() => _isBuyer = true),
                  onSellerTap: () => setState(() => _isBuyer = false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isBuyer
                  ? 'Регистрация для покупателя'
                  : 'Регистрация для продавца',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: AppColors.textPrimary,
                fontFamily: 'Montserrat',
              ),
            ),
            SizedBox(height: _isBuyer ? 25 : 20),
            _isBuyer ? _buildBuyerForm() : _buildSellerForm(),
            SizedBox(height: _isBuyer ? 40 : 20),
            CustomButton(
              text: 'Зарегистрироваться',
              onPressed: _isLoading ? null : _handleRegister,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 160),
          ],
        ),
      ),
    );
  }

  Widget _buildBuyerForm() {
    return RegisterFormBuyer(
      phoneController: _phoneController,
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
      phoneFocusNode: _phoneFocusNode,
      passwordFocusNode: _passwordFocusNode,
      confirmPasswordFocusNode: _confirmPasswordFocusNode,
      obscurePassword: _obscurePassword,
      obscureConfirmPassword: _obscureConfirmPassword,
      onTogglePassword: () =>
          setState(() => _obscurePassword = !_obscurePassword),
      onToggleConfirmPassword: () =>
          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
    );
  }

  Widget _buildSellerForm() {
    return RegisterFormSeller(
      emailController: _emailController,
      restaurantNameController: _restaurantNameController,
      addressController: _addressController,
      logoController: _logoController,
      passwordController: _sellerPasswordController,
      confirmPasswordController: _sellerConfirmPasswordController,
      passwordFocusNode: _sellerPasswordFocusNode,
      confirmPasswordFocusNode: _sellerConfirmPasswordFocusNode,
      obscurePassword: _obscurePassword,
      obscureConfirmPassword: _obscureConfirmPassword,
      onTogglePassword: () =>
          setState(() => _obscurePassword = !_obscurePassword),
      onToggleConfirmPassword: () =>
          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
      onAddressFieldTap: _openAddressMap,
      onLogoFieldTap: _pickImage,
    );
  }
}
