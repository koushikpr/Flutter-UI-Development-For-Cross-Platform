import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/dashboard/new_dashboard_screen.dart';
import 'auth/auth_module.dart';

void main() {
  runApp(const BagrzApp());
}

class BagrzApp extends StatelessWidget {
  const BagrzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852), // iPhone 14 Pro dimensions
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AuthWrapper(
          child: MaterialApp(
            title: 'Bagrz',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark, // Set to dark theme by default
            home: const SplashScreen(),
            routes: {
              // Add auth routes
              ...AuthModule.getRoutes(),
              // Add dashboard route
              '/dashboard': (context) => const NewDashboardScreen(),
            },
          ),
        );
      },
    );
  }
}