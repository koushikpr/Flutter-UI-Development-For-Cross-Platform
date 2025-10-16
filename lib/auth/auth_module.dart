import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/auth_service.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_state.dart';
import 'bloc/auth_event.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/email_verification_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/reset_password_screen.dart';

/// Main authentication module entry point
/// This provides a complete, self-contained authentication system
class AuthModule {
  static const String routeLogin = '/auth/login';
  static const String routeRegister = '/auth/register';
  static const String routeEmailVerification = '/auth/verify-email';
  static const String routeForgotPassword = '/auth/forgot-password';
  static const String routeResetPassword = '/auth/reset-password';

  /// Initialize the authentication module
  static Future<void> initialize() async {
    final authService = AuthService();
    await authService.initialize();
  }

  /// Get the authentication BLoC provider
  static Widget getBlocProvider({
    required Widget child,
    AuthService? authService,
  }) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(authService: authService),
      child: child,
    );
  }

  /// Get authentication routes
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      routeLogin: (context) => const LoginScreen(),
      routeRegister: (context) => const RegisterScreen(),
      routeEmailVerification: (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
        return EmailVerificationScreen(
          email: args?['email'] ?? '',
          username: args?['username'] ?? '',
        );
      },
      routeForgotPassword: (context) => const ForgotPasswordScreen(),
      routeResetPassword: (context) {
        final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
        return ResetPasswordScreen(
          token: args?['token'],
        );
      },
    };
  }

  /// Check if user is authenticated
  static bool isAuthenticated(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    return authBloc.state is AuthAuthenticated;
  }

  /// Get current user
  static dynamic getCurrentUser(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    if (authBloc.state is AuthAuthenticated) {
      return (authBloc.state as AuthAuthenticated).user;
    }
    return null;
  }

  /// Logout user
  static void logout(BuildContext context) {
    context.read<AuthBloc>().add(const AuthLogout());
  }

  /// Navigate to login screen
  static void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushNamed(routeLogin);
  }

  /// Navigate to register screen
  static void navigateToRegister(BuildContext context) {
    Navigator.of(context).pushNamed(routeRegister);
  }

  /// Navigate to email verification screen
  static void navigateToEmailVerification(
    BuildContext context, {
    required String email,
    required String username,
  }) {
    Navigator.of(context).pushNamed(
      routeEmailVerification,
      arguments: {
        'email': email,
        'username': username,
      },
    );
  }

  /// Navigate to forgot password screen
  static void navigateToForgotPassword(BuildContext context) {
    Navigator.of(context).pushNamed(routeForgotPassword);
  }

  /// Navigate to reset password screen
  static void navigateToResetPassword(
    BuildContext context, {
    String? token,
  }) {
    Navigator.of(context).pushNamed(
      routeResetPassword,
      arguments: {
        'token': token,
      },
    );
  }

  /// Authentication guard widget
  /// Redirects to login if user is not authenticated
  static Widget authGuard({
    required Widget child,
    Widget? loginScreen,
  }) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return child;
        } else {
          return loginScreen ?? const LoginScreen();
        }
      },
    );
  }

  /// Authentication listener widget
  /// Listens to authentication state changes
  static Widget authListener({
    required Widget child,
    required Function(AuthState) onAuthStateChanged,
  }) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        onAuthStateChanged(state);
      },
      child: child,
    );
  }
}

/// Authentication wrapper widget
/// Provides authentication context to the entire app
class AuthWrapper extends StatefulWidget {
  final Widget child;
  final AuthService? authService;

  const AuthWrapper({
    super.key,
    required this.child,
    this.authService,
  });

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Initialize auth when wrapper is created
    AuthModule.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return AuthModule.getBlocProvider(
      authService: widget.authService,
      child: widget.child,
    );
  }
}
