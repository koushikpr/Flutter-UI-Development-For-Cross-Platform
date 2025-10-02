import 'package:flutter/material.dart';

class GrabBagData {
  final String? thumbnailImagePath;
  final String bagBanner;
  final String musicSet;
  final String primaryVibeTag;
  final double price;

  GrabBagData({
    this.thumbnailImagePath,
    this.bagBanner = '',
    this.musicSet = '',
    this.primaryVibeTag = '',
    this.price = 0.0,
  });

  GrabBagData copyWith({
    String? thumbnailImagePath,
    String? bagBanner,
    String? musicSet,
    String? primaryVibeTag,
    double? price,
  }) {
    return GrabBagData(
      thumbnailImagePath: thumbnailImagePath ?? this.thumbnailImagePath,
      bagBanner: bagBanner ?? this.bagBanner,
      musicSet: musicSet ?? this.musicSet,
      primaryVibeTag: primaryVibeTag ?? this.primaryVibeTag,
      price: price ?? this.price,
    );
  }

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';
}
