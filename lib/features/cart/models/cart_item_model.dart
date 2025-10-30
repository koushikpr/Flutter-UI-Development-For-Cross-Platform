import 'package:equatable/equatable.dart';

enum CartItemType {
  beatPack,
  soundpack,
  loopKit,
  singleBeat,
}

class CartItemModel extends Equatable {
  final String id;
  final String coverImageUrl;
  final String producerName;
  final String producerAvatarUrl;
  final String title;
  final CartItemType type;
  final String genre;
  final double price;
  final double? originalPrice;
  final bool isDeletable;

  const CartItemModel({
    required this.id,
    required this.coverImageUrl,
    required this.producerName,
    required this.producerAvatarUrl,
    required this.title,
    required this.type,
    required this.genre,
    required this.price,
    this.originalPrice,
    this.isDeletable = false,
  });

  String get typeLabel {
    switch (type) {
      case CartItemType.beatPack:
        return 'Beat Pack';
      case CartItemType.soundpack:
        return 'Soundpack';
      case CartItemType.loopKit:
        return 'Loop Kit';
      case CartItemType.singleBeat:
        return 'Single Beat';
    }
  }

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  double get discountAmount => hasDiscount ? originalPrice! - price : 0;

  double get discountPercentage => 
      hasDiscount ? ((discountAmount / originalPrice!) * 100) : 0;

  CartItemModel copyWith({
    String? id,
    String? coverImageUrl,
    String? producerName,
    String? producerAvatarUrl,
    String? title,
    CartItemType? type,
    String? genre,
    double? price,
    double? originalPrice,
    bool? isDeletable,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      producerName: producerName ?? this.producerName,
      producerAvatarUrl: producerAvatarUrl ?? this.producerAvatarUrl,
      title: title ?? this.title,
      type: type ?? this.type,
      genre: genre ?? this.genre,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      isDeletable: isDeletable ?? this.isDeletable,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coverImageUrl': coverImageUrl,
      'producerName': producerName,
      'producerAvatarUrl': producerAvatarUrl,
      'title': title,
      'type': type.toString(),
      'genre': genre,
      'price': price,
      'originalPrice': originalPrice,
      'isDeletable': isDeletable,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? '',
      coverImageUrl: json['coverImageUrl'] ?? '',
      producerName: json['producerName'] ?? '',
      producerAvatarUrl: json['producerAvatarUrl'] ?? '',
      title: json['title'] ?? '',
      type: _parseType(json['type']),
      genre: json['genre'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: json['originalPrice'] != null 
          ? (json['originalPrice'] as num).toDouble() 
          : null,
      isDeletable: json['isDeletable'] ?? false,
    );
  }

  static CartItemType _parseType(String? typeString) {
    switch (typeString) {
      case 'CartItemType.beatPack':
        return CartItemType.beatPack;
      case 'CartItemType.soundpack':
        return CartItemType.soundpack;
      case 'CartItemType.loopKit':
        return CartItemType.loopKit;
      case 'CartItemType.singleBeat':
        return CartItemType.singleBeat;
      default:
        return CartItemType.beatPack;
    }
  }

  @override
  List<Object?> get props => [
        id,
        coverImageUrl,
        producerName,
        producerAvatarUrl,
        title,
        type,
        genre,
        price,
        originalPrice,
        isDeletable,
      ];
}

class PaymentMethodModel extends Equatable {
  final String id;
  final String type;
  final String lastFourDigits;
  final String email;
  final String billingAddress;
  final String cardBrand;

  const PaymentMethodModel({
    required this.id,
    required this.type,
    required this.lastFourDigits,
    required this.email,
    required this.billingAddress,
    this.cardBrand = 'Mastercard',
  });

  String get displayText => '$cardBrand | •••• $lastFourDigits';

  @override
  List<Object?> get props => [
        id,
        type,
        lastFourDigits,
        email,
        billingAddress,
        cardBrand,
      ];
}

enum TipOption {
  ten,
  fifteen,
  other,
  noTip,
}

class TipSelection extends Equatable {
  final TipOption option;
  final double? customAmount;

  const TipSelection({
    required this.option,
    this.customAmount,
  });

  double calculateTip(double subtotal) {
    switch (option) {
      case TipOption.ten:
        return subtotal * 0.10;
      case TipOption.fifteen:
        return subtotal * 0.15;
      case TipOption.other:
        return customAmount ?? 0;
      case TipOption.noTip:
        return 0;
    }
  }

  String getLabel(double subtotal) {
    switch (option) {
      case TipOption.ten:
        return '10%';
      case TipOption.fifteen:
        return '15%';
      case TipOption.other:
        return 'Other';
      case TipOption.noTip:
        return 'No tip';
    }
  }

  String? getAmount(double subtotal) {
    switch (option) {
      case TipOption.ten:
        return '\$${(subtotal * 0.10).toStringAsFixed(0)}';
      case TipOption.fifteen:
        return '\$${(subtotal * 0.15).toStringAsFixed(0)}';
      case TipOption.other:
      case TipOption.noTip:
        return null;
    }
  }

  @override
  List<Object?> get props => [option, customAmount];
}
