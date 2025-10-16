import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({AuthService? authService})
      : _authService = authService ?? AuthService(),
        super(const AuthInitial()) {
    
    // Register event handlers
    on<AuthInitialize>(_onInitialize);
    on<AuthRegister>(_onRegister);
    on<AuthLogin>(_onLogin);
    on<AuthVerifyEmail>(_onVerifyEmail);
    on<AuthForgotPassword>(_onForgotPassword);
    on<AuthResetPassword>(_onResetPassword);
    on<AuthRefreshToken>(_onRefreshToken);
    on<AuthGetProfile>(_onGetProfile);
    on<AuthUpdateProfile>(_onUpdateProfile);
    on<AuthGetRoles>(_onGetRoles);
    on<AuthLogout>(_onLogout);
    on<AuthClearError>(_onClearError);
    on<AuthClearSuccess>(_onClearSuccess);
  }

  // Initialize auth state
  Future<void> _onInitialize(
    AuthInitialize event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authService.initialize();
      
      if (_authService.isLoggedIn) {
        emit(AuthAuthenticated(
          user: _authService.currentUser!,
          accessToken: _authService.accessToken!,
        ));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to initialize: $e'));
    }
  }

  // Register user
  Future<void> _onRegister(
    AuthRegister event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final response = await _authService.register(event.request);

      if (response.success && response.data != null) {
        emit(AuthRegistrationSuccess(
          message: response.message,
          user: response.data!.user,
        ));
      } else {
        emit(AuthError(
          message: response.message,
          code: response.error?.code,
          details: response.error?.details,
        ));
      }
    } catch (e) {
      emit(AuthError(message: 'Registration failed: $e'));
    }
  }

  // Login user
  Future<void> _onLogin(
    AuthLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final response = await _authService.login(event.request);

      if (response.success && response.data != null) {
        emit(AuthAuthenticated(
          user: response.data!.user,
          accessToken: response.data!.accessToken,
        ));
      } else {
        emit(AuthError(
          message: response.message,
          code: response.error?.code,
          details: response.error?.details,
        ));
      }
    } catch (e) {
      emit(AuthError(message: 'Login failed: $e'));
    }
  }

  // Verify email
  Future<void> _onVerifyEmail(
    AuthVerifyEmail event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final response = await _authService.verifyEmail(event.token);

      if (response.success && response.data != null) {
        emit(AuthEmailVerificationSuccess(
          message: response.message,
          user: response.data!,
        ));
      } else {
        emit(AuthError(
          message: response.message,
          code: response.error?.code,
          details: response.error?.details,
        ));
      }
    } catch (e) {
      emit(AuthError(message: 'Email verification failed: $e'));
    }
  }

  // Forgot password
  Future<void> _onForgotPassword(
    AuthForgotPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final response = await _authService.forgotPassword(event.request);

      if (response.success) {
        emit(AuthSuccess(response.message));
      } else {
        emit(AuthError(
          message: response.message,
          code: response.error?.code,
          details: response.error?.details,
        ));
      }
    } catch (e) {
      emit(AuthError(message: 'Forgot password failed: $e'));
    }
  }

  // Reset password
  Future<void> _onResetPassword(
    AuthResetPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final response = await _authService.resetPassword(event.request);

      if (response.success) {
        emit(AuthPasswordResetSuccess(response.message));
      } else {
        emit(AuthError(
          message: response.message,
          code: response.error?.code,
          details: response.error?.details,
        ));
      }
    } catch (e) {
      emit(AuthError(message: 'Password reset failed: $e'));
    }
  }

  // Refresh token
  Future<void> _onRefreshToken(
    AuthRefreshToken event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final response = await _authService.refreshToken();

      if (response.success && response.data != null) {
        emit(AuthAuthenticated(
          user: response.data!.user,
          accessToken: response.data!.accessToken,
        ));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  // Get user profile
  Future<void> _onGetProfile(
    AuthGetProfile event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final response = await _authService.getProfile();

      if (response.success && response.data != null) {
        emit(AuthAuthenticated(
          user: response.data!,
          accessToken: _authService.accessToken!,
        ));
      } else {
        emit(AuthError(
          message: response.message,
          code: response.error?.code,
          details: response.error?.details,
        ));
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to get profile: $e'));
    }
  }

  // Update user profile
  Future<void> _onUpdateProfile(
    AuthUpdateProfile event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final response = await _authService.updateProfile(event.request);

      if (response.success && response.data != null) {
        emit(AuthProfileUpdateSuccess(
          message: response.message,
          user: response.data!,
        ));
      } else {
        emit(AuthError(
          message: response.message,
          code: response.error?.code,
          details: response.error?.details,
        ));
      }
    } catch (e) {
      emit(AuthError(message: 'Profile update failed: $e'));
    }
  }

  // Get available roles
  Future<void> _onGetRoles(
    AuthGetRoles event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final response = await _authService.getRoles();

      if (response.success && response.data != null) {
        emit(AuthRolesLoaded(response.data!));
      } else {
        emit(AuthError(
          message: response.message,
          code: response.error?.code,
          details: response.error?.details,
        ));
      }
    } catch (e) {
      emit(AuthError(message: 'Failed to get roles: $e'));
    }
  }

  // Logout
  Future<void> _onLogout(
    AuthLogout event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _authService.logout();
      emit(const AuthUnauthenticated());
    } catch (e) {
      // Even if logout fails, clear local state
      emit(const AuthUnauthenticated());
    }
  }

  // Clear error
  void _onClearError(
    AuthClearError event,
    Emitter<AuthState> emit,
  ) {
    if (state is AuthError) {
      emit(const AuthUnauthenticated());
    }
  }

  // Clear success message
  void _onClearSuccess(
    AuthClearSuccess event,
    Emitter<AuthState> emit,
  ) {
    if (state is AuthSuccess) {
      emit(const AuthUnauthenticated());
    }
  }
}
