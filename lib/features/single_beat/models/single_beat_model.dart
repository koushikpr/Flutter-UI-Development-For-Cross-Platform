class SingleBeatModel {
  final String id;
  final String producerName;
  final String beatTitle;
  final String artistName;
  final String? beatImage;
  final double price;
  final String description;
  final DateTime expiryDate;
  final bool hasLicenseSplit;
  final String duration;
  final String vibeTag;
  final int bpm;
  final String key;

  SingleBeatModel({
    required this.id,
    required this.producerName,
    required this.beatTitle,
    required this.artistName,
    this.beatImage,
    required this.price,
    required this.description,
    required this.expiryDate,
    required this.hasLicenseSplit,
    required this.duration,
    required this.vibeTag,
    required this.bpm,
    required this.key,
  });

  String get fullTitle => '$beatTitle - $artistName';
  
  String getTimeRemaining() {
    final now = DateTime.now();
    final difference = expiryDate.difference(now);

    if (difference.isNegative) {
      return 'Expired';
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;

    if (days > 0) {
      return '${days}d ${hours}h';
    } else {
      return '${hours}h';
    }
  }
}

