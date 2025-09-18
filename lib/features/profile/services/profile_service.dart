import '../models/profile_data.dart';

class ProfileService {
  static ProfileService? _instance;
  static ProfileService get instance => _instance ??= ProfileService._();
  ProfileService._();

  // Temporary in-memory storage (will be replaced with actual backend)
  ProfileData? _currentProfile;

  // Get current profile data
  ProfileData getCurrentProfile(String userRole) {
    if (_currentProfile != null) {
      return _currentProfile!;
    }
    
    // Return default data based on user role
    return userRole == 'artist' 
        ? ProfileData.getDefaultArtistData()
        : ProfileData.getDefaultProducerData();
  }

  // Update profile data (temporary local storage)
  Future<bool> updateProfile(ProfileData profileData) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Store locally (temporary)
      _currentProfile = profileData;
      
      print('✅ Profile updated successfully:');
      print('   Name: ${profileData.artistName}');
      print('   Location: ${profileData.location}');
      print('   Description: ${profileData.description}');
      
      return true;
    } catch (e) {
      print('❌ Failed to update profile: $e');
      return false;
    }
  }

  // Clear profile data (for logout)
  void clearProfile() {
    _currentProfile = null;
  }

  // Get social media links
  Map<String, String> getSocialLinks() {
    final profile = _currentProfile;
    if (profile == null) return {};
    
    Map<String, String> links = {};
    
    if (profile.youtubeUrl.isNotEmpty) {
      links['YouTube'] = 'https://youtube.com/${profile.youtubeUrl}';
    }
    if (profile.tiktokHandle.isNotEmpty) {
      links['TikTok'] = 'https://tiktok.com/${profile.tiktokHandle.replaceFirst('@', '')}';
    }
    if (profile.instagramHandle.isNotEmpty) {
      links['Instagram'] = 'https://instagram.com/${profile.instagramHandle.replaceFirst('@', '')}';
    }
    if (profile.twitterHandle.isNotEmpty) {
      links['Twitter'] = 'https://twitter.com/${profile.twitterHandle.replaceFirst('@', '')}';
    }
    if (profile.websiteUrl.isNotEmpty) {
      String url = profile.websiteUrl;
      if (!url.startsWith('http')) {
        url = 'https://$url';
      }
      links['Website'] = url;
    }
    
    return links;
  }
}
