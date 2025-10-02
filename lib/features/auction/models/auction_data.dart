class AuctionData {
  // Step 1: Set Up Your Live Auction
  String? streamCoverImagePath;
  String auctionBanner;
  String? audioFilePath;
  
  // Step 2: Auction Details
  String? beatSleeveImagePath;
  String beatTitle;
  String vibeTag;
  String bpm;
  String key;
  
  // Step 3: Auction Settings
  double startingBid;
  int durationMinutes;
  bool buyNowEnabled;
  double? buyNowPrice;
  
  AuctionData({
    this.streamCoverImagePath,
    this.auctionBanner = '',
    this.audioFilePath,
    this.beatSleeveImagePath,
    this.beatTitle = '',
    this.vibeTag = '',
    this.bpm = '',
    this.key = '',
    this.startingBid = 25.0,
    this.durationMinutes = 25,
    this.buyNowEnabled = false,
    this.buyNowPrice,
  });
  
  // Copy with method for updating specific fields
  AuctionData copyWith({
    String? streamCoverImagePath,
    String? auctionBanner,
    String? audioFilePath,
    String? beatSleeveImagePath,
    String? beatTitle,
    String? vibeTag,
    String? bpm,
    String? key,
    double? startingBid,
    int? durationMinutes,
    bool? buyNowEnabled,
    double? buyNowPrice,
  }) {
    return AuctionData(
      streamCoverImagePath: streamCoverImagePath ?? this.streamCoverImagePath,
      auctionBanner: auctionBanner ?? this.auctionBanner,
      audioFilePath: audioFilePath ?? this.audioFilePath,
      beatSleeveImagePath: beatSleeveImagePath ?? this.beatSleeveImagePath,
      beatTitle: beatTitle ?? this.beatTitle,
      vibeTag: vibeTag ?? this.vibeTag,
      bpm: bpm ?? this.bpm,
      key: key ?? this.key,
      startingBid: startingBid ?? this.startingBid,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      buyNowEnabled: buyNowEnabled ?? this.buyNowEnabled,
      buyNowPrice: buyNowPrice ?? this.buyNowPrice,
    );
  }
  
  // Check if all required fields are filled
  bool get isComplete {
    return auctionBanner.isNotEmpty &&
           audioFilePath != null &&
           beatTitle.isNotEmpty &&
           vibeTag.isNotEmpty &&
           bpm.isNotEmpty &&
           key.isNotEmpty;
  }
  
  // Get formatted starting bid
  String get formattedStartingBid => '\$${startingBid.toInt()}';
  
  // Get formatted duration
  String get formattedDuration => '${durationMinutes} min';
  
  // Get formatted buy now price
  String get formattedBuyNowPrice => buyNowEnabled && buyNowPrice != null 
      ? '\$${buyNowPrice!.toInt()}' 
      : 'Not set';
}
