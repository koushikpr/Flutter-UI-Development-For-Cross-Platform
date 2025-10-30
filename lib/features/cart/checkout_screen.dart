import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'models/cart_item_model.dart';
import 'state/cart_state.dart';
import 'state/cart_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItemModel>? initialItems;
  final PaymentMethodModel? paymentMethod;

  const CheckoutScreen({
    super.key,
    this.initialItems,
    this.paymentMethod,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late List<CartItemModel> _cartItems;
  bool _isGiftEnabled = true;
  String _giftEmail = 'friend@email.com';
  bool _isEmailValid = true;
  TipOption _selectedTipOption = TipOption.other;
  final TextEditingController _tipController = TextEditingController(text: '\$20');
  final TextEditingController _emailController = TextEditingController();
  late PaymentMethodModel _paymentMethod;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<CartCubit>();
    _cartItems = widget.initialItems ?? (cubit.state.items.isNotEmpty
        ? cubit.state.items
        : _getDummyCartItems());
    _isGiftEnabled = cubit.state.isGiftEnabled;
    _giftEmail = cubit.state.giftEmail.isNotEmpty ? cubit.state.giftEmail : _giftEmail;
    _emailController.text = _giftEmail;
    _paymentMethod = widget.paymentMethod ?? cubit.state.paymentMethod;
    _selectedTipOption = cubit.state.tipOption;
    if (_selectedTipOption == TipOption.other) {
      _tipController.text = '\$${cubit.state.customTipAmount.toStringAsFixed(0)}';
    }
  }

  @override
  void dispose() {
    _tipController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  List<CartItemModel> _getDummyCartItems() {
    return [
      const CartItemModel(
        id: '1',
        coverImageUrl: 'https://api.builder.io/api/v1/image/assets/TEMP/196688b42235e2da5bc2bb8987afa6c83847a3ab',
        producerName: '@DreBeatz',
        producerAvatarUrl: 'https://via.placeholder.com/16',
        title: 'Lo-Fi Chill Vol. 1',
        type: CartItemType.beatPack,
        genre: 'Trap',
        price: 120,
        isDeletable: false,
      ),
      const CartItemModel(
        id: '2',
        coverImageUrl: 'https://api.builder.io/api/v1/image/assets/TEMP/196688b42235e2da5bc2bb8987afa6c83847a3ab',
        producerName: '@DreBeatz',
        producerAvatarUrl: 'https://via.placeholder.com/16',
        title: 'Lo-Fi Chill\nVol. 1',
        type: CartItemType.soundpack,
        genre: 'Trap',
        price: 40,
        originalPrice: 50,
        isDeletable: true,
      ),
      const CartItemModel(
        id: '3',
        coverImageUrl: 'https://api.builder.io/api/v1/image/assets/TEMP/196688b42235e2da5bc2bb8987afa6c83847a3ab',
        producerName: '@DreBeatz',
        producerAvatarUrl: 'https://via.placeholder.com/16',
        title: 'Lo-Fi Chill Vol. 1',
        type: CartItemType.loopKit,
        genre: 'Trap',
        price: 40,
        originalPrice: 50,
        isDeletable: true,
      ),
    ];
  }

  PaymentMethodModel _getDummyPaymentMethod() {
    return const PaymentMethodModel(
      id: '1',
      type: 'card',
      lastFourDigits: '4568',
      email: 'example@email.com',
      billingAddress: '1226 University Dr, Menlo Park, CA 94025-4221',
      cardBrand: 'Mastercard',
    );
  }

  double get _subtotal {
    return _cartItems.fold(0, (sum, item) => sum + item.price);
  }

  double get _tipAmount {
    final tipText = _tipController.text.replaceAll('\$', '');
    return double.tryParse(tipText) ?? 0;
  }

  double get _total {
    return _subtotal + _tipAmount;
  }

  void _removeItem(String itemId) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == itemId);
    });
    context.read<CartCubit>().removeItem(itemId);
  }

  void _toggleGift(bool value) {
    setState(() {
      _isGiftEnabled = value;
    });
    context.read<CartCubit>().setGift(_isGiftEnabled, _giftEmail);
  }

  void _selectTipOption(TipOption option) {
    setState(() {
      _selectedTipOption = option;
      if (option == TipOption.ten) {
        _tipController.text = '\$${(_subtotal * 0.10).toStringAsFixed(0)}';
      } else if (option == TipOption.fifteen) {
        _tipController.text = '\$${(_subtotal * 0.15).toStringAsFixed(0)}';
      } else if (option == TipOption.noTip) {
        _tipController.text = '\$0';
      }
    });
    final custom = option == TipOption.other
        ? double.tryParse(_tipController.text.replaceAll('\$', '')) ?? 0
        : null;
    context.read<CartCubit>().setTip(option, customAmount: custom);
  }

  void _applyTip() {
    setState(() {});
    final custom = double.tryParse(_tipController.text.replaceAll('\$', '')) ?? 0;
    context.read<CartCubit>().setTip(TipOption.other, customAmount: custom);
  }

  void _completePurchase() {
    context.read<CartCubit>().clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Purchase completed successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    _buildItemsSection(),
                    SizedBox(height: 24.h),
                    _buildGiftSection(),
                    SizedBox(height: 24.h),
                    _buildTipSection(),
                    SizedBox(height: 24.h),
                    _buildPaymentMethodSection(),
                    SizedBox(height: 120.h),
                  ],
                ),
              ),
            ),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 46.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 24.w,
              height: 24.h,
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 18.sp,
              ),
            ),
          ),
          Text(
            'Checkout',
            style: TextStyle(
              fontFamily: 'Wix Madefor Display',
              fontSize: 21.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.15,
              letterSpacing: -0.84,
            ),
          ),
          SizedBox(width: 24.w),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items',
            style: TextStyle(
              fontFamily: 'Wix Madefor Display',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          SizedBox(height: 16.h),
          ..._cartItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Column(
              children: [
                _buildCartItem(item),
                if (index < _cartItems.length - 1) ...[
                  SizedBox(height: 16.h),
                  _buildDivider(),
                  SizedBox(height: 16.h),
                ],
              ],
            );
          }),
          SizedBox(height: 12.h),
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItemModel item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 72.w,
          height: 72.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: const Color(0xFFA4A4A4),
              width: 0.602,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              item.coverImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[800],
                  child: Icon(
                    Icons.music_note,
                    color: Colors.white.withOpacity(0.3),
                    size: 32.sp,
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 16.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Colors.grey[700],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: Image.network(
                          item.producerAvatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[700],
                              child: Icon(
                                Icons.person,
                                size: 10.sp,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      item.producerName,
                      style: TextStyle(
                        fontFamily: 'Wix Madefor Display',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFD4D4D4),
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  item.title,
                  style: TextStyle(
                    fontFamily: 'Wix Madefor Display',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      item.typeLabel,
                      style: TextStyle(
                        fontFamily: 'Wix Madefor Display',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.6),
                        height: 1.33,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '·',
                      style: TextStyle(
                        fontFamily: 'Wix Madefor Display',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.6),
                        height: 1.33,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      item.genre,
                      style: TextStyle(
                        fontFamily: 'Wix Madefor Display',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.6),
                        height: 1.33,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (item.isDeletable) ...[
              GestureDetector(
                onTap: () => _removeItem(item.id),
                child: Icon(
                  Icons.delete_outline,
                  color: const Color(0xFFA3A3A3),
                  size: 20.sp,
                ),
              ),
              SizedBox(height: 8.h),
            ],
            if (!item.isDeletable) SizedBox(height: 20.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '\$${item.price.toInt()}',
                  style: TextStyle(
                    fontFamily: 'Wix Madefor Display',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFAFAFA),
                    height: 1.33,
                  ),
                ),
                if (item.hasDiscount) ...[
                  SizedBox(width: 4.w),
                  Text(
                    '\$${item.originalPrice!.toInt()}',
                    style: TextStyle(
                      fontFamily: 'Wix Madefor Display',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFA3A3A3),
                      height: 1.33,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: const Color(0xFFA3A3A3),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGiftSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFF171717),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gift to Friend',
                  style: TextStyle(
                    fontFamily: 'Wix Madefor Display',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFFAFAFA),
                    height: 1.43,
                    letterSpacing: -0.28,
                  ),
                ),
                _buildSwitch(_isGiftEnabled, _toggleGift),
              ],
            ),
          ),
          if (_isGiftEnabled) ...[
            SizedBox(height: 24.h),
            Text(
              'Want it sent to someone else? Add their email:',
              style: TextStyle(
                fontFamily: 'Wix Madefor Display',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                height: 1.43,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              height: 56.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF171717),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      style: TextStyle(
                        fontFamily: 'Wix Madefor Display',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFFAFAFA),
                        height: 1.43,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'friend@email.com',
                        hintStyle: TextStyle(
                          fontFamily: 'Wix Madefor Display',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFFAFAFA).withOpacity(0.4),
                          height: 1.43,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _giftEmail = value;
                          _isEmailValid = value.contains('@');
                        });
                        context.read<CartCubit>().setGift(_isGiftEnabled, _giftEmail);
                      },
                    ),
                  ),
                  if (_isEmailValid)
                    Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Gift for Delivery To: $_giftEmail.',
              style: TextStyle(
                fontFamily: 'Wix Madefor Display',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.25,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Heads up — this order will only be sent to this email, not yours.',
              style: TextStyle(
                fontFamily: 'Wix Madefor Display',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.6),
                height: 1.43,
              ),
            ),
          ],
          SizedBox(height: 24.h),
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildTipSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Tip?',
            style: TextStyle(
              fontFamily: 'Wix Madefor Display',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildTipOption(
                  TipOption.ten,
                  '10%',
                  '\$${(_subtotal * 0.10).toStringAsFixed(0)}',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildTipOption(
                  TipOption.fifteen,
                  '15%',
                  '\$${(_subtotal * 0.15).toStringAsFixed(0)}',
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: _buildTipOption(
                  TipOption.other,
                  'Other',
                  null,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildTipOption(
                  TipOption.noTip,
                  'No tip',
                  null,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'Tip amount',
            style: TextStyle(
              fontFamily: 'Wix Madefor Display',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFFAFAFA),
              height: 1.43,
              letterSpacing: -0.56,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 56.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF171717),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: TextField(
                    controller: _tipController,
                    style: TextStyle(
                      fontFamily: 'Wix Madefor Display',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFFAFAFA),
                      height: 1.43,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: _applyTip,
                child: Container(
                  height: 56.h,
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Apply',
                    style: TextStyle(
                      fontFamily: 'Wix Madefor Display',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildTipOption(TipOption option, String label, String? amount) {
    final isSelected = _selectedTipOption == option;
    return GestureDetector(
      onTap: () => _selectTipOption(option),
      child: Container(
        height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.white.withOpacity(0.24) 
              : Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16.r),
          border: isSelected 
              ? Border.all(color: Colors.white, width: 1)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Wix Madefor Display',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1.43,
              ),
            ),
            if (amount != null) ...[
              SizedBox(height: 4.h),
              Text(
                amount,
                style: TextStyle(
                  fontFamily: 'Wix Madefor Display',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.6),
                  height: 1.33,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment method',
            style: TextStyle(
              fontFamily: 'Wix Madefor Display',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildMastercardIcon(),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                _paymentMethod.displayText,
                                style: TextStyle(
                                  fontFamily: 'Wix Madefor Display',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFFAFAFA),
                                  height: 1.43,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '${_paymentMethod.email}, ${_paymentMethod.billingAddress}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Wix Madefor Display',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFFAFAFA),
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
            color: Color(0x33FFFFFF),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Wix Madefor Display',
                    height: 1.43,
                  ),
                  children: [
                    TextSpan(
                      text: 'Total\n',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: '(${_cartItems.length} items)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFA3A3A3),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${_total.toInt()}',
                style: TextStyle(
                  fontFamily: 'Fjalla One',
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  height: 1.25,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: _completePurchase,
            child: Container(
              width: double.infinity,
              height: 56.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              alignment: Alignment.center,
              child: Text(
                'Complete Purchase',
                style: TextStyle(
                  fontFamily: 'Wix Madefor Display',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.5,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            width: 139.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildSwitch(bool value, Function(bool) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 51.w,
        height: 31.h,
        decoration: BoxDecoration(
          color: value ? const Color(0xFF32D74B) : Colors.grey[700],
          borderRadius: BorderRadius.circular(31.r),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 27.w,
            height: 27.h,
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(27.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMastercardIcon() {
    return SizedBox(
      width: 28.33.w,
      height: 20.h,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            child: Container(
              width: 19.w,
              height: 11.h,
              decoration: const BoxDecoration(
                color: Color(0xFFED0006),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 9.33.w,
            child: Container(
              width: 19.w,
              height: 11.h,
              decoration: const BoxDecoration(
                color: Color(0xFFF9A000),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: double.infinity,
      height: 1.h,
      color: Colors.white.withOpacity(0.1),
    );
  }
}

