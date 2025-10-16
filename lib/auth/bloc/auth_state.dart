import 'package:equatable/equatable.dart';
import '../models/user_model.dart';

// Base auth state
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();
}

// Loading state
class AuthLoading extends AuthState {
  const AuthLoading();
}

// Authenticated state
class AuthAuthenticated extends AuthState {
  final User user;
  final String accessToken;

  const AuthAuthenticated({
    required this.user,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [user, accessToken];
}

// Unauthenticated state
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

// Registration success state
class AuthRegistrationSuccess extends AuthState {
  final String message;
  final User user;

  const AuthRegistrationSuccess({
    required this.message,
    required this.user,
  });

  @override
  List<Object?> get props => [message, user];
}

// Email verification success state
class AuthEmailVerificationSuccess extends AuthState {
  final String message;
  final User user;

  const AuthEmailVerificationSuccess({
    required this.message,
    required this.user,
  });

  @override
  List<Object?> get props => [message, user];
}

// Password reset success state
class AuthPasswordResetSuccess extends AuthState {
  final String message;

  const AuthPasswordResetSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Profile update success state
class AuthProfileUpdateSuccess extends AuthState {
  final String message;
  final User user;

  const AuthProfileUpdateSuccess({
    required this.message,
    required this.user,
  });

  @override
  List<Object?> get props => [message, user];
}

// Roles loaded state
class AuthRolesLoaded extends AuthState {
  final List<String> roles;

  const AuthRolesLoaded(this.roles);

  @override
  List<Object?> get props => [roles];
}

// Error state
class AuthError extends AuthState {
  final String message;
  final String? code;
  final String? details;

  const AuthError({
    required this.message,
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];
}

// Validation error state
class AuthValidationError extends AuthState {
  final Map<String, String> fieldErrors;

  const AuthValidationError(this.fieldErrors);

  @override
  List<Object?> get props => [fieldErrors];
}

// Success message state
class AuthSuccess extends AuthState {
  final String message;

  const AuthSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
