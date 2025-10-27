class BeatPackModel {
  final String id;
  final String producerName;
  final String packTitle;
  final String? packImage;
  final double price;
  final int beatCount;
  final String description;
  final DateTime expiryDate;
  final bool hasLicenseSplit;
  final List<BeatModel> beats;

  BeatPackModel({
    required this.id,
    required this.producerName,
    required this.packTitle,
    this.packImage,
    required this.price,
    required this.beatCount,
    required this.description,
    required this.expiryDate,
    required this.hasLicenseSplit,
    required this.beats,
  });

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

class BeatModel {
  final String id;
  final String title;
  final String artistName;
  final String duration;
  final String genre;
  final int bpm;
  final String key;
  final String? audioUrl;
  final String? coverImage;

  BeatModel({
    required this.id,
    required this.title,
    required this.artistName,
    required this.duration,
    required this.genre,
    required this.bpm,
    required this.key,
    this.audioUrl,
    this.coverImage,
  });

  String get fullTitle => '$title - $artistName';
  
  String get metadata => '$duration · $genre · $bpm BPM · $key';
}

