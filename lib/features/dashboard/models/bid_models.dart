import 'package:flutter/material.dart';

enum BidStatus {
  active,      // Currently bidding
  won,         // Won the auction
  lost,        // Lost the auction
  outbid,      // Was outbid, can re-bid
  expired,     // Auction ended
}

enum BeatGenre {
  trap,
  hiphop,
  rnb,
  pop,
  drill,
  afrobeats,
  reggaeton,
  ambient,
}

class BidItem {
  final String id;
  final String beatTitle;
  final String producerName;
  final String producerAvatar;
  final BeatGenre genre;
  final int bpm;
  final String key;
  final String coverImageUrl;
  final double myBidAmount;
  final double currentHighestBid;
  final double startingPrice;
  final BidStatus status;
  final DateTime bidDate;
  final DateTime? auctionEndDate;
  final int totalBids;
  final List<String> tags;
  final String audioPreviewUrl;
  final Duration duration;
  final bool isExclusive;
  final double? finalPrice; // If won or sold

  const BidItem({
    required this.id,
    required this.beatTitle,
    required this.producerName,
    required this.producerAvatar,
    required this.genre,
    required this.bpm,
    required this.key,
    required this.coverImageUrl,
    required this.myBidAmount,
    required this.currentHighestBid,
    required this.startingPrice,
    required this.status,
    required this.bidDate,
    this.auctionEndDate,
    required this.totalBids,
    required this.tags,
    required this.audioPreviewUrl,
    required this.duration,
    this.isExclusive = true,
    this.finalPrice,
  });

  String get statusText {
    switch (status) {
      case BidStatus.active:
        return 'Active Bid';
      case BidStatus.won:
        return 'Won';
      case BidStatus.lost:
        return 'Lost';
      case BidStatus.outbid:
        return 'Outbid';
      case BidStatus.expired:
        return 'Expired';
    }
  }

  Color get statusColor {
    switch (status) {
      case BidStatus.active:
        return const Color(0xFF4CAF50); // Green
      case BidStatus.won:
        return const Color(0xFFFFD700); // Gold
      case BidStatus.lost:
        return const Color(0xFFFF5252); // Red
      case BidStatus.outbid:
        return const Color(0xFFFF9800); // Orange
      case BidStatus.expired:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  String get genreText {
    switch (genre) {
      case BeatGenre.trap:
        return 'Trap';
      case BeatGenre.hiphop:
        return 'Hip Hop';
      case BeatGenre.rnb:
        return 'R&B';
      case BeatGenre.pop:
        return 'Pop';
      case BeatGenre.drill:
        return 'Drill';
      case BeatGenre.afrobeats:
        return 'Afrobeats';
      case BeatGenre.reggaeton:
        return 'Reggaeton';
      case BeatGenre.ambient:
        return 'Ambient';
    }
  }

  bool get canReBid => status == BidStatus.outbid || (status == BidStatus.active && currentHighestBid > myBidAmount);
  
  bool get canSell => status == BidStatus.won;
  
  bool get isWinning => status == BidStatus.active && myBidAmount >= currentHighestBid;
}

class MockBidData {
  static List<BidItem> getSampleBids() {
    return [
      BidItem(
        id: 'bid_1',
        beatTitle: 'Midnight Vibes',
        producerName: 'Metro Boomin',
        producerAvatar: '',
        genre: BeatGenre.trap,
        bpm: 140,
        key: 'C# Minor',
        coverImageUrl: '',
        myBidAmount: 850.0,
        currentHighestBid: 900.0,
        startingPrice: 500.0,
        status: BidStatus.outbid,
        bidDate: DateTime.now().subtract(const Duration(hours: 2)),
        auctionEndDate: DateTime.now().add(const Duration(hours: 6)),
        totalBids: 12,
        tags: ['Dark', 'Melodic', 'Hard'],
        audioPreviewUrl: '',
        duration: const Duration(minutes: 3, seconds: 45),
      ),
      
      BidItem(
        id: 'bid_2',
        beatTitle: 'Golden Hour',
        producerName: 'Southside',
        producerAvatar: '',
        genre: BeatGenre.rnb,
        bpm: 75,
        key: 'F Major',
        coverImageUrl: '',
        myBidAmount: 1200.0,
        currentHighestBid: 1200.0,
        startingPrice: 800.0,
        status: BidStatus.won,
        bidDate: DateTime.now().subtract(const Duration(days: 2)),
        auctionEndDate: DateTime.now().subtract(const Duration(days: 1)),
        totalBids: 8,
        tags: ['Smooth', 'Soulful', 'Warm'],
        audioPreviewUrl: '',
        duration: const Duration(minutes: 4, seconds: 12),
        finalPrice: 1200.0,
      ),
      
      BidItem(
        id: 'bid_3',
        beatTitle: 'Street Dreams',
        producerName: 'Wheezy',
        producerAvatar: '',
        genre: BeatGenre.drill,
        bpm: 150,
        key: 'G Minor',
        coverImageUrl: '',
        myBidAmount: 650.0,
        currentHighestBid: 650.0,
        startingPrice: 400.0,
        status: BidStatus.active,
        bidDate: DateTime.now().subtract(const Duration(minutes: 30)),
        auctionEndDate: DateTime.now().add(const Duration(hours: 12)),
        totalBids: 5,
        tags: ['Aggressive', 'Raw', 'NYC'],
        audioPreviewUrl: '',
        duration: const Duration(minutes: 2, seconds: 58),
      ),
      
      BidItem(
        id: 'bid_4',
        beatTitle: 'Ocean Waves',
        producerName: 'TM88',
        producerAvatar: '',
        genre: BeatGenre.ambient,
        bpm: 85,
        key: 'D Major',
        coverImageUrl: '',
        myBidAmount: 750.0,
        currentHighestBid: 950.0,
        startingPrice: 600.0,
        status: BidStatus.lost,
        bidDate: DateTime.now().subtract(const Duration(days: 5)),
        auctionEndDate: DateTime.now().subtract(const Duration(days: 3)),
        totalBids: 15,
        tags: ['Chill', 'Atmospheric', 'Dreamy'],
        audioPreviewUrl: '',
        duration: const Duration(minutes: 5, seconds: 22),
        finalPrice: 950.0,
      ),
      
      BidItem(
        id: 'bid_5',
        beatTitle: 'Neon Nights',
        producerName: 'Pierre Bourne',
        producerAvatar: '',
        genre: BeatGenre.pop,
        bpm: 128,
        key: 'A Minor',
        coverImageUrl: '',
        myBidAmount: 1100.0,
        currentHighestBid: 1350.0,
        startingPrice: 700.0,
        status: BidStatus.outbid,
        bidDate: DateTime.now().subtract(const Duration(hours: 8)),
        auctionEndDate: DateTime.now().add(const Duration(hours: 4)),
        totalBids: 18,
        tags: ['Energetic', 'Catchy', '80s'],
        audioPreviewUrl: '',
        duration: const Duration(minutes: 3, seconds: 33),
      ),
      
      BidItem(
        id: 'bid_6',
        beatTitle: 'Lagos Vibes',
        producerName: 'Kel-P',
        producerAvatar: '',
        genre: BeatGenre.afrobeats,
        bpm: 110,
        key: 'E Minor',
        coverImageUrl: '',
        myBidAmount: 800.0,
        currentHighestBid: 800.0,
        startingPrice: 500.0,
        status: BidStatus.won,
        bidDate: DateTime.now().subtract(const Duration(days: 1)),
        auctionEndDate: DateTime.now().subtract(const Duration(hours: 6)),
        totalBids: 9,
        tags: ['Afrobeats', 'Danceable', 'African'],
        audioPreviewUrl: '',
        duration: const Duration(minutes: 3, seconds: 48),
        finalPrice: 800.0,
      ),
    ];
  }
}
