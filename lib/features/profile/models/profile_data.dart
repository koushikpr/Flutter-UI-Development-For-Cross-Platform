class ProfileData {
  final int id;
  final int userId;
  final String displayName;
  final String bio;
  final String location;
  final String profileImageUrl;
  final String websiteUrl;
  final String youtubeHandle;
  final String tiktokHandle;
  final String instagramHandle;
  final String twitterHandle;
  final String createdAt;
  final String updatedAt;

  const ProfileData({
    required this.id,
    required this.userId,
    required this.displayName,
    required this.bio,
    required this.location,
    required this.profileImageUrl,
    required this.websiteUrl,
    required this.youtubeHandle,
    required this.tiktokHandle,
    required this.instagramHandle,
    required this.twitterHandle,
    required this.createdAt,
    required this.updatedAt,
  });

  // Legacy getters for backward compatibility
  String get artistName => displayName;
  String get description => bio;
  String get youtubeUrl => youtubeHandle;

  ProfileData copyWith({
    int? id,
    int? userId,
    String? displayName,
    String? bio,
    String? location,
    String? profileImageUrl,
    String? websiteUrl,
    String? youtubeHandle,
    String? tiktokHandle,
    String? instagramHandle,
    String? twitterHandle,
    String? createdAt,
    String? updatedAt,
  }) {
    return ProfileData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      youtubeHandle: youtubeHandle ?? this.youtubeHandle,
      tiktokHandle: tiktokHandle ?? this.tiktokHandle,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      twitterHandle: twitterHandle ?? this.twitterHandle,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // JSON serialization
  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      displayName: json['display_name'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      location: json['location'] as String? ?? '',
      profileImageUrl: json['profile_image_url'] as String? ?? '',
      websiteUrl: json['website_url'] as String? ?? '',
      youtubeHandle: json['youtube_handle'] as String? ?? '',
      tiktokHandle: json['tiktok_handle'] as String? ?? '',
      instagramHandle: json['instagram_handle'] as String? ?? '',
      twitterHandle: json['twitter_handle'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'display_name': displayName,
      'bio': bio,
      'location': location,
      'website_url': websiteUrl,
      'youtube_handle': youtubeHandle,
      'tiktok_handle': tiktokHandle,
      'instagram_handle': instagramHandle,
      'twitter_handle': twitterHandle,
    };
  }

}
