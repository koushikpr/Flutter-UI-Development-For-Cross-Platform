class ProfileData {
  final String artistName;
  final String description;
  final String location;
  final String youtubeUrl;
  final String tiktokHandle;
  final String instagramHandle;
  final String twitterHandle;
  final String websiteUrl;
  final String profileImageUrl;

  const ProfileData({
    required this.artistName,
    required this.description,
    required this.location,
    required this.youtubeUrl,
    required this.tiktokHandle,
    required this.instagramHandle,
    required this.twitterHandle,
    required this.websiteUrl,
    required this.profileImageUrl,
  });

  ProfileData copyWith({
    String? artistName,
    String? description,
    String? location,
    String? youtubeUrl,
    String? tiktokHandle,
    String? instagramHandle,
    String? twitterHandle,
    String? websiteUrl,
    String? profileImageUrl,
  }) {
    return ProfileData(
      artistName: artistName ?? this.artistName,
      description: description ?? this.description,
      location: location ?? this.location,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      tiktokHandle: tiktokHandle ?? this.tiktokHandle,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      twitterHandle: twitterHandle ?? this.twitterHandle,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }

  // Default data for different user roles
  static ProfileData getDefaultArtistData() {
    return const ProfileData(
      artistName: 'Travis Scott',
      description: 'Houston rapper and songwriter known for atmospheric production and melodic rap style.',
      location: 'Houston, TX',
      youtubeUrl: 'travisscott',
      tiktokHandle: '@travisscott',
      instagramHandle: '@travisscott',
      twitterHandle: '@trvisXX',
      websiteUrl: 'travisscott.com',
      profileImageUrl: '',
    );
  }

  static ProfileData getDefaultProducerData() {
    return const ProfileData(
      artistName: 'Metro Boomin',
      description: 'Multi-platinum producer and songwriter. Creating the sound of the future.',
      location: 'St. Louis, MO',
      youtubeUrl: 'metroboomin',
      tiktokHandle: '@metroboomin',
      instagramHandle: '@metroboomin',
      twitterHandle: '@MetroBoomin',
      websiteUrl: 'metroboomin.com',
      profileImageUrl: '',
    );
  }
}
