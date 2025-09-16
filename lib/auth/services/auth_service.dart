import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/auth_models.dart';
import '../models/api_response.dart';

class AuthService {
  static const String _baseUrl = 'http://localhost:8080/api/v1/auth';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';

  // Singleton instance
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Current user
  User? _currentUser;
  String? _accessToken;
  String? _refreshToken;

  // Getters
  User? get currentUser => _currentUser;
  String? get accessToken => _accessToken;
  bool get isLoggedIn => _currentUser != null && _accessToken != null;

  // Initialize service
  Future<void> initialize() async {
    await _loadStoredData();
  }

  // Load stored authentication data
  Future<void> _loadStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _accessToken = prefs.getString(_accessTokenKey);
      _refreshToken = prefs.getString(_refreshTokenKey);
      
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        _currentUser = User.fromJson(json.decode(userJson));
      }
    } catch (e) {
      print('Error loading stored auth data: $e');
      await _clearStoredData();
    }
  }

  // Store authentication data
  Future<void> _storeAuthData(AuthResponse authResponse) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, authResponse.accessToken);
      await prefs.setString(_refreshTokenKey, authResponse.refreshToken);
      await prefs.setString(_userKey, json.encode(authResponse.user.toJson()));
      
      _accessToken = authResponse.accessToken;
      _refreshToken = authResponse.refreshToken;
      _currentUser = authResponse.user;
    } catch (e) {
      print('Error storing auth data: $e');
    }
  }

  // Clear stored authentication data
  Future<void> _clearStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_accessTokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.remove(_userKey);
      
      _accessToken = null;
      _refreshToken = null;
      _currentUser = null;
    } catch (e) {
      print('Error clearing stored auth data: $e');
    }
  }

  // Get headers with authentication
  Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth && _accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

    return headers;
  }

  // Handle API response
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJsonT,
  ) {
    try {
      // Debug logging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      final dynamic jsonData = json.decode(response.body);
      print('Parsed JSON type: ${jsonData.runtimeType}');
      print('Parsed JSON data: $jsonData');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Handle both Map and List responses
        if (jsonData is Map<String, dynamic>) {
          // Check if this is our backend's response format
          if (jsonData.containsKey('success') && jsonData.containsKey('data')) {
            // This is our backend's response format
            final data = jsonData['data'];
            if (data != null && fromJsonT != null) {
              // Check if data is a Map or List
              if (data is Map<String, dynamic>) {
                final parsedData = fromJsonT(data);
                return ApiResponse<T>(
                  success: jsonData['success'] as bool,
                  message: jsonData['message'] as String,
                  data: parsedData,
                );
              } else if (data is List) {
                // If data is a List, we need to handle it specially
                // For now, return success but with null data
                // The specific parsing will be handled in the individual methods
                return ApiResponse<T>(
                  success: jsonData['success'] as bool,
                  message: jsonData['message'] as String,
                  data: null,
                );
              } else {
                // Unknown data type
                return ApiResponse<T>(
                  success: jsonData['success'] as bool,
                  message: jsonData['message'] as String,
                  data: null,
                );
              }
            } else {
              return ApiResponse<T>(
                success: jsonData['success'] as bool,
                message: jsonData['message'] as String,
                data: null,
              );
            }
          } else {
            // This is a direct response format
            return ApiResponse.fromJson(jsonData, fromJsonT);
          }
        } else if (jsonData is List) {
          // If it's a list, wrap it in a success response
          return ApiResponse<T>(
            success: true,
            message: 'Success',
            data: null, // Lists don't have a direct data mapping
          );
        } else {
          return ApiResponse.error(
            message: 'Unexpected response format',
            errorDetails: 'Expected Map or List, got ${jsonData.runtimeType}',
          );
        }
      } else {
        // Handle error responses
        if (jsonData is Map<String, dynamic>) {
          // Check if this is our backend's error format
          if (jsonData.containsKey('success') && jsonData.containsKey('error')) {
            final errorData = jsonData['error'] as Map<String, dynamic>;
            final error = ApiError.fromJson(errorData);
            return ApiResponse.error(
              message: error.message,
              error: error,
            );
          } else {
            // This is a direct error format
            final error = ApiError.fromJson(jsonData);
            return ApiResponse.error(
              message: error.message,
              error: error,
            );
          }
        } else {
          return ApiResponse.error(
            message: 'Request failed with status ${response.statusCode}',
            errorDetails: response.body,
          );
        }
      }
    } catch (e) {
      print('Error parsing response: $e');
      return ApiResponse.error(
        message: 'Failed to parse response: $e',
        errorDetails: e.toString(),
      );
    }
  }

  // Handle API response with list data
  ApiResponse<T> _handleListResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJsonT,
  ) {
    try {
      // Debug logging
      print('List Response status: ${response.statusCode}');
      print('List Response body: ${response.body}');
      
      final dynamic jsonData = json.decode(response.body);
      print('List Parsed JSON type: ${jsonData.runtimeType}');
      print('List Parsed JSON data: $jsonData');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (jsonData is Map<String, dynamic>) {
          // Check if this is our backend's response format
          if (jsonData.containsKey('success') && jsonData.containsKey('data')) {
            final data = jsonData['data'];
            if (data != null && fromJsonT != null) {
              final parsedData = fromJsonT(data);
              return ApiResponse<T>(
                success: jsonData['success'] as bool,
                message: jsonData['message'] as String,
                data: parsedData,
              );
            } else {
              return ApiResponse<T>(
                success: jsonData['success'] as bool,
                message: jsonData['message'] as String,
                data: null,
              );
            }
          } else {
            // This is a direct response format
            return ApiResponse<T>(
              success: true,
              message: 'Success',
              data: fromJsonT != null ? fromJsonT(jsonData) : null,
            );
          }
        } else {
          return ApiResponse.error(
            message: 'Unexpected response format',
            errorDetails: 'Expected Map, got ${jsonData.runtimeType}',
          );
        }
      } else {
        // Handle error responses
        if (jsonData is Map<String, dynamic>) {
          if (jsonData.containsKey('success') && jsonData.containsKey('error')) {
            final errorData = jsonData['error'] as Map<String, dynamic>;
            final error = ApiError.fromJson(errorData);
            return ApiResponse.error(
              message: error.message,
              error: error,
            );
          } else {
            final error = ApiError.fromJson(jsonData);
            return ApiResponse.error(
              message: error.message,
              error: error,
            );
          }
        } else {
          return ApiResponse.error(
            message: 'Request failed with status ${response.statusCode}',
            errorDetails: response.body,
          );
        }
      }
    } catch (e) {
      print('Error parsing list response: $e');
      return ApiResponse.error(
        message: 'Failed to parse response: $e',
        errorDetails: e.toString(),
      );
    }
  }

  // Register user
  Future<ApiResponse<AuthResponse>> register(CreateUserRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: _getHeaders(includeAuth: false),
        body: json.encode(request.toJson()),
      );

      // Handle the response manually to parse the backend's format correctly
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'] as Map<String, dynamic>;
          final authResponse = AuthResponse.fromJson(data);
          
          // Store auth data
          await _storeAuthData(authResponse);
          
          return ApiResponse<AuthResponse>(
            success: true,
            message: jsonData['message'] as String,
            data: authResponse,
          );
        } else {
          return ApiResponse.error(
            message: jsonData['message'] as String? ?? 'Registration failed',
          );
        }
      } else {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return ApiResponse.error(
          message: jsonData['message'] as String? ?? 'Registration failed',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Network error: $e',
      );
    }
  }

  // Login user
  Future<ApiResponse<AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: _getHeaders(includeAuth: false),
        body: json.encode(request.toJson()),
      );

      // Handle the response manually to parse the backend's format correctly
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final data = jsonData['data'] as Map<String, dynamic>;
          final authResponse = AuthResponse.fromJson(data);
          
          // Store auth data
          await _storeAuthData(authResponse);
          
          return ApiResponse<AuthResponse>(
            success: true,
            message: jsonData['message'] as String,
            data: authResponse,
          );
        } else {
          return ApiResponse.error(
            message: jsonData['message'] as String? ?? 'Login failed',
          );
        }
      } else {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return ApiResponse.error(
          message: jsonData['message'] as String? ?? 'Login failed',
        );
      }
    } catch (e) {
      return ApiResponse.error(
        message: 'Network error: $e',
      );
    }
  }

  // Verify email
  Future<ApiResponse<User>> verifyEmail(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/verify?token=$token'),
        headers: _getHeaders(includeAuth: false),
      );

      final apiResponse = _handleResponse<User>(
        response,
        (json) => User.fromJson(json),
      );

      // Update current user if verification successful
      if (apiResponse.success && apiResponse.data != null) {
        _currentUser = apiResponse.data;
        await _updateStoredUser();
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse.error(
        message: 'Network error: $e',
      );
    }
  }

  // Forgot password
  Future<ApiResponse<void>> forgotPassword(ForgotPasswordRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/forgot-password'),
        headers: _getHeaders(includeAuth: false),
        body: json.encode(request.toJson()),
      );

      return _handleResponse<void>(response, null);
    } catch (e) {
      return ApiResponse.error(
        message: 'Network error: $e',
      );
    }
  }

  // Reset password
  Future<ApiResponse<void>> resetPassword(ResetPasswordRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/reset-password'),
        headers: _getHeaders(includeAuth: false),
        body: json.encode(request.toJson()),
      );

      return _handleResponse<void>(response, null);
    } catch (e) {
      return ApiResponse.error(
        message: 'Network error: $e',
      );
    }
  }

  // Refresh token
  Future<ApiResponse<AuthResponse>> refreshToken() async {
    if (_refreshToken == null) {
      return ApiResponse.error(
        message: 'No refresh token available',
      );
    }

    try {
      final request = RefreshTokenRequest(refreshToken: _refreshToken!);
      final response = await http.post(
        Uri.parse('$_baseUrl/refresh'),
        headers: _getHeaders(includeAuth: false),
        body: json.encode(request.toJson()),
      );

      final apiResponse = _handleResponse<AuthResponse>(
        response,
        (json) => AuthResponse.fromJson(json),
      );

      // Store new auth data if successful
      if (apiResponse.success && apiResponse.data != null) {
        await _storeAuthData(apiResponse.data!);
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse.error(
        message: 'Network error: $e',
      );
    }
  }

  // Get user profile
  Future<ApiResponse<User>> getProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/profile'),
        headers: _getHeaders(),
      );

      final apiResponse = _handleResponse<User>(
        response,
        (json) => User.fromJson(json),
      );

      // Update current user if successful
      if (apiResponse.success && apiResponse.data != null) {
        _currentUser = apiResponse.data;
        await _updateStoredUser();
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse.error(
        message: 'Network error: $e',
      );
    }
  }

  // Update user profile
  Future<ApiResponse<User>> updateProfile(UpdateProfileRequest request) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/update-profile'),
        headers: _getHeaders(),
        body: json.encode(request.toJson()),
      );

      final apiResponse = _handleResponse<User>(
        response,
        (json) => User.fromJson(json),
      );

      // Update current user if successful
      if (apiResponse.success && apiResponse.data != null) {
        _currentUser = apiResponse.data;
        await _updateStoredUser();
      }

      return apiResponse;
    } catch (e) {
      return ApiResponse.error(
        message: 'Network error: $e',
      );
    }
  }

  // Get available roles
  Future<ApiResponse<List<String>>> getRoles() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/roles'),
        headers: _getHeaders(includeAuth: false),
      );

      return _handleListResponse<List<String>>(
        response,
        (data) {
          // The backend returns roles in the data field as an array of objects
          // We need to extract the 'value' field from each object
          final List<dynamic> rolesList = data as List<dynamic>;
          return rolesList.map((role) => role['value'] as String).toList();
        },
      );
    } catch (e) {
      return ApiResponse.error(
        message: 'Network error: $e',
      );
    }
  }

  // Logout
  Future<ApiResponse<void>> logout() async {
    try {
      // Call logout endpoint if token is available
      if (_accessToken != null) {
        await http.post(
          Uri.parse('$_baseUrl/logout'),
          headers: _getHeaders(),
        );
      }

      // Clear stored data
      await _clearStoredData();

      return ApiResponse.success(
        message: 'Logged out successfully',
      );
    } catch (e) {
      // Even if logout fails, clear local data
      await _clearStoredData();
      return ApiResponse.error(
        message: 'Logout failed: $e',
      );
    }
  }

  // Update stored user data
  Future<void> _updateStoredUser() async {
    if (_currentUser != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, json.encode(_currentUser!.toJson()));
      } catch (e) {
        print('Error updating stored user: $e');
      }
    }
  }

  // Check if token is expired
  bool get isTokenExpired {
    if (_accessToken == null) return true;
    
    try {
      // Simple JWT decode to check expiration
      final parts = _accessToken!.split('.');
      if (parts.length != 3) return true;
      
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final resp = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(resp);
      
      final exp = payloadMap['exp'] as int?;
      if (exp == null) return true;
      
      final expirationTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expirationTime);
    } catch (e) {
      return true;
    }
  }

  // Auto-refresh token if needed
  Future<bool> ensureValidToken() async {
    if (_accessToken == null) return false;
    
    if (isTokenExpired) {
      final refreshResponse = await refreshToken();
      return refreshResponse.success;
    }
    
    return true;
  }
}
