import 'package:equatable/equatable.dart';
import '../models/cart_item_model.dart';

class CartState extends Equatable {
  final List<CartItemModel> items;
  final bool isGiftEnabled;
  final String giftEmail;
  final TipOption tipOption;
  final double customTipAmount;
  final PaymentMethodModel paymentMethod;

  const CartState({
    required this.items,
    required this.isGiftEnabled,
    required this.giftEmail,
    required this.tipOption,
    required this.customTipAmount,
    required this.paymentMethod,
  });

  double get subtotal => items.fold(0.0, (sum, i) => sum + i.price);

  double get tip => switch (tipOption) {
        TipOption.ten => subtotal * 0.10,
        TipOption.fifteen => subtotal * 0.15,
        TipOption.other => customTipAmount,
        TipOption.noTip => 0,
      };

  double get total => subtotal + tip;

  CartState copyWith({
    List<CartItemModel>? items,
    bool? isGiftEnabled,
    String? giftEmail,
    TipOption? tipOption,
    double? customTipAmount,
    PaymentMethodModel? paymentMethod,
  }) {
    return CartState(
      items: items ?? this.items,
      isGiftEnabled: isGiftEnabled ?? this.isGiftEnabled,
      giftEmail: giftEmail ?? this.giftEmail,
      tipOption: tipOption ?? this.tipOption,
      customTipAmount: customTipAmount ?? this.customTipAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'isGiftEnabled': isGiftEnabled,
      'giftEmail': giftEmail,
      'tipOption': tipOption.name,
      'customTipAmount': customTipAmount,
      'paymentMethod': {
        'id': paymentMethod.id,
        'type': paymentMethod.type,
        'lastFourDigits': paymentMethod.lastFourDigits,
        'email': paymentMethod.email,
        'billingAddress': paymentMethod.billingAddress,
        'cardBrand': paymentMethod.cardBrand,
      },
    };
  }

  factory CartState.fromJson(Map<String, dynamic> json) {
    return CartState(
      items: ((json['items'] as List?) ?? [])
          .map((e) => CartItemModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      isGiftEnabled: json['isGiftEnabled'] ?? false,
      giftEmail: json['giftEmail'] ?? '',
      tipOption: _parseTip(json['tipOption']) ?? TipOption.noTip,
      customTipAmount: (json['customTipAmount'] ?? 0).toDouble(),
      paymentMethod: PaymentMethodModel(
        id: json['paymentMethod']?['id'] ?? '1',
        type: json['paymentMethod']?['type'] ?? 'card',
        lastFourDigits: json['paymentMethod']?['lastFourDigits'] ?? '0000',
        email: json['paymentMethod']?['email'] ?? '',
        billingAddress: json['paymentMethod']?['billingAddress'] ?? '',
        cardBrand: json['paymentMethod']?['cardBrand'] ?? 'Mastercard',
      ),
    );
  }

  static TipOption? _parseTip(String? name) {
    if (name == null) return null;
    for (final v in TipOption.values) {
      if (v.name == name) return v;
    }
    return null;
  }

  @override
  List<Object?> get props => [
        items,
        isGiftEnabled,
        giftEmail,
        tipOption,
        customTipAmount,
        paymentMethod,
      ];
}

