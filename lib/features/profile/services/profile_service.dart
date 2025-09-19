import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_data.dart';
import '../../../auth/models/api_response.dart';

class ProfileService {
  static ProfileService? _instance;
  static ProfileService get instance => _instance ??= ProfileService._();
  ProfileService._();

  static const String _baseUrl = 'http://localhost:8080/api/v1/profile';
  static const String _accessTokenKey = 'access_token';

  // Get current profile data from API
  Future<ApiResponse<ProfileData>> getCurrentProfile() async {
    try {
      final token = await _getAccessToken();
      if (token == null) {
        return ApiResponse.error(message: 'No authentication token found');
      }

      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'] as Map<String, dynamic>;
          final profileData = ProfileData.fromJson(data);
          
          return ApiResponse<ProfileData>(
            success: true,
            message: jsonData['message'] as String,
            data: profileData,
          );
        } else {
          return ApiResponse.error(
            message: jsonData['message'] as String? ?? 'Failed to get profile',
          );
        }
      } else {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return ApiResponse.error(
          message: jsonData['message'] as String? ?? 'Failed to get profile',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Network error: $e',
      );
    }
  }

  // Update profile data via API
  Future<ApiResponse<ProfileData>> updateProfile(ProfileData profileData) async {
    try {
      final token = await _getAccessToken();
      if (token == null) {
        return ApiResponse.error(message: 'No authentication token found');
      }

      final response = await http.put(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(profileData.toJson()),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'] as Map<String, dynamic>;
          final updatedProfile = ProfileData.fromJson(data);
          
          return ApiResponse<ProfileData>(
            success: true,
            message: jsonData['message'] as String,
            data: updatedProfile,
          );
        } else {
          return ApiResponse.error(
            message: jsonData['message'] as String? ?? 'Failed to update profile',
          );
        }
      } else {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return ApiResponse.error(
          message: jsonData['message'] as String? ?? 'Failed to update profile',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Network error: $e',
      );
    }
  }

  // Upload profile image
  Future<ApiResponse<String>> uploadProfileImage(File imageFile) async {
    try {
      final token = await _getAccessToken();
      if (token == null) {
        return ApiResponse.error(message: 'No authentication token found');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/image'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'] as Map<String, dynamic>;
          final imageUrl = data['image_url'] as String;
          
          return ApiResponse<String>(
            success: true,
            message: jsonData['message'] as String,
            data: imageUrl,
          );
        } else {
          return ApiResponse.error(
            message: jsonData['message'] as String? ?? 'Failed to upload image',
          );
        }
      } else {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return ApiResponse.error(
          message: jsonData['message'] as String? ?? 'Failed to upload image',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Network error: $e',
      );
    }
  }

  // Get access token from shared preferences
  Future<String?> _getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_accessTokenKey);
    } catch (e) {
      print('Error getting access token: $e');
      return null;
    }
  }

  // Clear profile data (for logout)
  void clearProfile() {
    // No local storage to clear since we're using API
  }
}
