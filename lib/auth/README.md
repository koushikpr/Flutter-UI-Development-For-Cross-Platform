# 🔐 BAGR Authentication Module

A complete, modular authentication system for the BAGR auction app, designed to integrate seamlessly with the Go backend.

## ✨ Features

- **Complete Authentication Flow**: Register, Login, Email Verification, Password Reset
- **Beautiful UI**: Matches your existing app design with glass morphism effects
- **Modular Architecture**: Self-contained and easily replaceable
- **State Management**: BLoC pattern for clean state handling
- **Error Handling**: Comprehensive error messages and validation
- **JWT Token Management**: Automatic token refresh and storage
- **Role-Based Access**: Support for different user roles (admin, moderator, producer, artist, fan)

## 🏗️ Architecture

```
lib/auth/
├── models/           # Data models matching Go backend
├── services/         # API services and token management
├── screens/          # Authentication UI screens
├── bloc/            # State management (BLoC pattern)
├── widgets/         # Reusable UI components
├── utils/           # Helper functions
└── auth_module.dart # Main entry point
```

## 🚀 Quick Start

### 1. Add Dependencies

The required dependencies are already included in `pubspec.yaml`:
- `http: ^1.1.0` - For API calls
- `shared_preferences: ^2.3.2` - For token storage
- `flutter_bloc: ^8.1.6` - For state management
- `equatable: ^2.0.5` - For value equality

### 2. Initialize the Module

```dart
import 'package:bagrz_app/auth/auth_module.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthWrapper(
      child: MaterialApp(
        // Your app configuration
        routes: {
          ...AuthModule.getRoutes(),
          // Your other routes
        },
      ),
    );
  }
}
```

### 3. Use Authentication

```dart
// Check if user is authenticated
bool isLoggedIn = AuthModule.isAuthenticated(context);

// Get current user
User? user = AuthModule.getCurrentUser(context);

// Logout
AuthModule.logout(context);

// Navigate to auth screens
AuthModule.navigateToLogin(context);
AuthModule.navigateToRegister(context);
```

## 📱 Screens

### Login Screen (`/auth/login`)
- Email/password login
- Form validation
- Social login buttons (Google, Apple)
- Forgot password link

### Register Screen (`/auth/register`)
- User registration with role selection
- Comprehensive form validation
- Password strength requirements
- Social registration options

### Email Verification Screen (`/auth/verify-email`)
- Manual verification code entry
- Resend verification email
- Skip to login option

### Forgot Password Screen (`/auth/forgot-password`)
- Email-based password reset
- Reset link instructions

### Reset Password Screen (`/auth/reset-password`)
- New password creation
- Password confirmation
- Reset code validation

## 🔧 Configuration

### Backend Connection

The auth service connects to your Go backend at:
```
Base URL: http://localhost:8080/api/v1/auth
```

Update the `_baseUrl` in `auth_service.dart` if your backend runs on a different port.

### User Roles

Supported roles:
- `admin` - Full system access
- `moderator` - Content moderation
- `producer` - Beat producers
- `artist` - Music artists
- `fan` - Regular users

## 🎨 UI Components

### AuthTextField
Custom text field with validation and error display:
```dart
AuthTextField(
  controller: emailController,
  hintText: 'Email address',
  prefixIcon: Icons.email_outlined,
  validator: (value) => validateEmail(value),
)
```

### AuthButton
Styled buttons with loading states:
```dart
AuthPrimaryButton(
  text: 'Sign In',
  onPressed: handleLogin,
  isLoading: isLoading,
  icon: FontAwesomeIcons.rightToBracket,
)
```

### Error/Success Dialogs
```dart
ErrorDialog.show(
  context,
  title: 'Login Failed',
  message: 'Invalid credentials',
  onRetry: () => retryLogin(),
);
```

## 🔄 State Management

The auth module uses BLoC pattern for state management:

### Events
- `AuthInitialize` - Initialize auth state
- `AuthLogin` - User login
- `AuthRegister` - User registration
- `AuthVerifyEmail` - Email verification
- `AuthLogout` - User logout

### States
- `AuthInitial` - Initial state
- `AuthLoading` - Loading state
- `AuthAuthenticated` - User is logged in
- `AuthUnauthenticated` - User is not logged in
- `AuthError` - Error state

### Usage
```dart
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthAuthenticated) {
      return DashboardScreen();
    } else {
      return LoginScreen();
    }
  },
)
```

## 🛡️ Security Features

- **JWT Token Management**: Automatic token refresh
- **Password Validation**: Strong password requirements
- **Email Verification**: Required for account activation
- **Secure Storage**: Tokens stored securely using SharedPreferences
- **Input Validation**: Client-side and server-side validation

## 🧪 Testing

### Test Screen
Use `AuthTestScreen` to test all authentication features:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AuthTestScreen(),
  ),
);
```

### Manual Testing
1. Start your Go backend server
2. Run the Flutter app
3. Navigate to the auth test screen
4. Test registration, login, and other flows

## 🔧 Customization

### Styling
All UI components use your existing theme:
- `AppTheme.primaryColor` - Background color
- `AppTheme.glassColor` - Glass morphism effect
- `AppTheme.accentColor` - Accent color
- `AppTheme.textPrimary` - Primary text color

### Validation Rules
Customize validation in the form widgets:
- Password requirements
- Email format validation
- Username rules

### API Endpoints
Update API endpoints in `auth_service.dart`:
```dart
static const String _baseUrl = 'http://your-backend-url/api/v1/auth';
```

## 🚨 Error Handling

The module provides comprehensive error handling:

### Validation Errors
- Real-time form validation
- Field-specific error messages
- Password strength indicators

### API Errors
- Network error handling
- Server error responses
- User-friendly error messages

### Token Errors
- Automatic token refresh
- Graceful logout on token expiry
- Secure token storage

## 📝 API Integration

The auth module integrates with your Go backend endpoints:

- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/login` - User login
- `GET /api/v1/auth/verify` - Email verification
- `POST /api/v1/auth/forgot-password` - Password reset request
- `POST /api/v1/auth/reset-password` - Password reset
- `POST /api/v1/auth/refresh` - Token refresh
- `GET /api/v1/auth/profile` - User profile
- `PUT /api/v1/auth/update-profile` - Update profile
- `POST /api/v1/auth/logout` - User logout

## 🎯 Next Steps

1. **Test the Integration**: Use the test screen to verify all features
2. **Customize UI**: Adjust colors, fonts, and animations to match your brand
3. **Add Social Login**: Implement Google/Apple OAuth (placeholders included)
4. **Add Biometric Auth**: Integrate fingerprint/face ID authentication
5. **Add 2FA**: Implement two-factor authentication

## 🤝 Contributing

This auth module is designed to be:
- **Modular**: Easy to replace or modify
- **Maintainable**: Clean, well-documented code
- **Extensible**: Easy to add new features
- **Testable**: Comprehensive test coverage

Feel free to modify and extend the module to fit your specific needs!


