import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // BAGR_Z Logo
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                'BAGR_Z',
                style: GoogleFonts.getFont(
                  'Montserrat',
                  fontSize: 48.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accentColor,
                  letterSpacing: 2.0,
                ),
              ),
            ).animate()
              .fadeIn(duration: 800.ms, delay: 200.ms)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                duration: 800.ms,
                delay: 200.ms,
                curve: Curves.elasticOut,
              )
              .shimmer(
                duration: 1500.ms,
                delay: 1000.ms,
                color: AppTheme.textPrimary.withOpacity(0.3),
              ),
            
            SizedBox(height: 40.h),
            
            // Loading indicator
            SizedBox(
              width: 30.w,
              height: 30.h,
              child: CircularProgressIndicator(
                strokeWidth: 2.w,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.textSecondary,
                ),
              ),
            ).animate(onPlay: (controller) => controller.repeat())
              .fadeIn(duration: 600.ms, delay: 800.ms)
              .rotate(duration: 1000.ms),
          ],
        ),
      ),
    );
  }
}
