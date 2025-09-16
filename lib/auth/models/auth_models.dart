import 'package:equatable/equatable.dart';
import 'user_model.dart';

// Registration Request
class CreateUserRequest extends Equatable {
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String password;
  final String confirmPassword;
  final UserRole role;

  const CreateUserRequest({
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'confirm_password': confirmPassword,
      'role': role.name,
    };
  }

  @override
  List<Object?> get props => [
        email,
        username,
        firstName,
        lastName,
        password,
        confirmPassword,
        role,
      ];
}

// Login Request
class LoginRequest extends Equatable {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  @override
  List<Object?> get props => [email, password];
}

// Forgot Password Request
class ForgotPasswordRequest extends Equatable {
  final String email;

  const ForgotPasswordRequest({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }

  @override
  List<Object?> get props => [email];
}

// Reset Password Request
class ResetPasswordRequest extends Equatable {
  final String token;
  final String password;
  final String confirmPassword;

  const ResetPasswordRequest({
    required this.token,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'password': password,
      'confirm_password': confirmPassword,
    };
  }

  @override
  List<Object?> get props => [token, password, confirmPassword];
}

// Update Profile Request
class UpdateProfileRequest extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? username;

  const UpdateProfileRequest({
    this.firstName,
    this.lastName,
    this.username,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (username != null) data['username'] = username;
    return data;
  }

  @override
  List<Object?> get props => [firstName, lastName, username];
}

// Auth Response
class AuthResponse extends Equatable {
  final User user;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  const AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [user, accessToken, refreshToken, expiresAt];
}

// Refresh Token Request
class RefreshTokenRequest extends Equatable {
  final String refreshToken;

  const RefreshTokenRequest({
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'refresh_token': refreshToken,
    };
  }

  @override
  List<Object?> get props => [refreshToken];
}

