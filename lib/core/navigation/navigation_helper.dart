import 'package:flutter/material.dart';

/// Navigation helper class for common app navigation patterns
class NavigationHelper {
  /// Navigate to producer public profile
  static void navigateToProducerProfile(
    BuildContext context, {
    required String producerId,
  }) {
    Navigator.of(context).pushNamed(
      '/producer-profile',
      arguments: {
        'producerId': producerId,
      },
    );
  }

  /// Navigate to producer public profile with custom transition
  static void navigateToProducerProfileWithTransition(
    BuildContext context, {
    required String producerId,
    Widget? heroWidget,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            Navigator.of(context).pushNamed(
          '/producer-profile',
          arguments: {
            'producerId': producerId,
          },
        ) as Widget,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  /// Navigate back
  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Navigate to dashboard
  static void navigateToDashboard(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/dashboard',
      (route) => false,
    );
  }
}

