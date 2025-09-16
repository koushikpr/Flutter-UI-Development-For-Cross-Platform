import 'package:equatable/equatable.dart';
import '../models/auth_models.dart';

// Base auth event
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Initialize auth state
class AuthInitialize extends AuthEvent {
  const AuthInitialize();
}

// Register user
class AuthRegister extends AuthEvent {
  final CreateUserRequest request;

  const AuthRegister(this.request);

  @override
  List<Object?> get props => [request];
}

// Login user
class AuthLogin extends AuthEvent {
  final LoginRequest request;

  const AuthLogin(this.request);

  @override
  List<Object?> get props => [request];
}

// Verify email
class AuthVerifyEmail extends AuthEvent {
  final String token;

  const AuthVerifyEmail(this.token);

  @override
  List<Object?> get props => [token];
}

// Forgot password
class AuthForgotPassword extends AuthEvent {
  final ForgotPasswordRequest request;

  const AuthForgotPassword(this.request);

  @override
  List<Object?> get props => [request];
}

// Reset password
class AuthResetPassword extends AuthEvent {
  final ResetPasswordRequest request;

  const AuthResetPassword(this.request);

  @override
  List<Object?> get props => [request];
}

// Refresh token
class AuthRefreshToken extends AuthEvent {
  const AuthRefreshToken();
}

// Get user profile
class AuthGetProfile extends AuthEvent {
  const AuthGetProfile();
}

// Update user profile
class AuthUpdateProfile extends AuthEvent {
  final UpdateProfileRequest request;

  const AuthUpdateProfile(this.request);

  @override
  List<Object?> get props => [request];
}

// Get available roles
class AuthGetRoles extends AuthEvent {
  const AuthGetRoles();
}

// Logout
class AuthLogout extends AuthEvent {
  const AuthLogout();
}

// Clear error
class AuthClearError extends AuthEvent {
  const AuthClearError();
}

// Clear success message
class AuthClearSuccess extends AuthEvent {
  const AuthClearSuccess();
}

