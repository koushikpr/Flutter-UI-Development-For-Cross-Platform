import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/glass_button.dart';
import '../../shared/widgets/glass_text_field.dart';
import '../dashboard/new_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          // Background gradient effects
          Positioned(
            top: -100.h,
            left: -100.w,
            child: Container(
              width: 300.w,
              height: 300.h,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentColor.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          Positioned(
            bottom: -150.h,
            right: -150.w,
            child: Container(
              width: 400.w,
              height: 400.h,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppTheme.accentColor.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 60.h),
                  
                  // Logo
                  _buildLogo(),
                  
                  SizedBox(height: 60.h),
                  
                  // Welcome text
                  _buildWelcomeText(),
                  
                  SizedBox(height: 40.h),
                  
                  // Login form
                  _buildLoginForm(),
                  
                  SizedBox(height: 30.h),
                  
                  // Social login buttons
                  _buildSocialLogins(),
                  
                  SizedBox(height: 30.h),
                  
                  // Toggle sign up/sign in
                  _buildToggleAuth(),
                  
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Text(
          'BAGR_Z',
          style: GoogleFonts.getFont(
            'Montserrat',
            fontSize: 36.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ).animate()
          .fadeIn(duration: 800.ms, delay: 200.ms)
          .slideY(begin: -0.3, end: 0),
        
        SizedBox(height: 8.h),
        
        Container(
          width: 60.w,
          height: 2.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.accentColor,
                Colors.white,
              ],
            ),
            borderRadius: BorderRadius.circular(1.r),
          ),
        ).animate()
          .fadeIn(duration: 600.ms, delay: 400.ms)
          .scaleX(begin: 0, end: 1),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          _isSignUp ? 'Create Account' : 'Welcome Back',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
            letterSpacing: -0.04,
          ),
        ).animate()
          .fadeIn(duration: 600.ms, delay: 600.ms)
          .slideY(begin: 0.2, end: 0),
        
        SizedBox(height: 8.h),
        
        Text(
          _isSignUp 
            ? 'Join the auction community'
            : 'Sign in to continue to BAGR_Z',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.textSecondary,
          ),
        ).animate()
          .fadeIn(duration: 600.ms, delay: 800.ms)
          .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppTheme.glassColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppTheme.glassBorder,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            children: [
              // Email field
              GlassTextField(
                controller: _emailController,
                hintText: 'Email address',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ).animate()
                .fadeIn(duration: 600.ms, delay: 1000.ms)
                .slideX(begin: -0.2, end: 0),
              
              SizedBox(height: 16.h),
              
              // Password field
              GlassTextField(
                controller: _passwordController,
                hintText: 'Password',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppTheme.textSecondary,
                    size: 20.sp,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ).animate()
                .fadeIn(duration: 600.ms, delay: 1200.ms)
                .slideX(begin: -0.2, end: 0),
              
              SizedBox(height: 24.h),
              
              // Login button
              GlassButton(
                text: _isSignUp ? 'Create Account' : 'Sign In',
                onPressed: () {
                  // Dummy sign in - no validation required
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const NewDashboardScreen(),
                    ),
                  );
                },
                width: double.infinity,
                gradient: LinearGradient(
                  colors: [AppTheme.textPrimary, AppTheme.accentColor],
                ),
              ).animate()
                .fadeIn(duration: 600.ms, delay: 1400.ms)
                .slideY(begin: 0.2, end: 0),
              
              if (!_isSignUp) ...[
                SizedBox(height: 16.h),
                
                // Forgot password
                TextButton(
                  onPressed: () {
                    // Handle forgot password
                  },
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 14.sp,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ).animate()
                  .fadeIn(duration: 600.ms, delay: 1600.ms),
              ],
            ],
          ),
        ),
      ),
    ).animate()
      .fadeIn(duration: 800.ms, delay: 1000.ms)
      .slideY(begin: 0.3, end: 0);
  }

  Widget _buildSocialLogins() {
    return Column(
      children: [
        // Divider with "OR"
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1.h,
                color: AppTheme.glassBorder,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'OR',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 12.sp,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1.h,
                color: AppTheme.glassBorder,
              ),
            ),
          ],
        ).animate()
          .fadeIn(duration: 600.ms, delay: 1800.ms),
        
        SizedBox(height: 24.h),
        
        // Apple Sign In
        GlassButton(
          text: 'Continue with Apple',
          onPressed: () {
            // Handle Apple sign in
          },
          icon: const FaIcon(
            FontAwesomeIcons.apple,
            color: AppTheme.textPrimary,
          ),
          backgroundColor: AppTheme.glassLight,
          textColor: AppTheme.textPrimary,
          width: double.infinity,
        ).animate()
          .fadeIn(duration: 600.ms, delay: 2000.ms)
          .slideX(begin: -0.2, end: 0),
        
        SizedBox(height: 12.h),
        
        // Google Sign In
        GlassButton(
          text: 'Continue with Google',
          onPressed: () {
            // Handle Google sign in
          },
          icon: const FaIcon(
            FontAwesomeIcons.google,
            color: AppTheme.textPrimary,
          ),
          backgroundColor: AppTheme.glassLight,
          textColor: AppTheme.textPrimary,
          width: double.infinity,
        ).animate()
          .fadeIn(duration: 600.ms, delay: 2200.ms)
          .slideX(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildToggleAuth() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isSignUp 
            ? 'Already have an account? '
            : "Don't have an account? ",
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            color: AppTheme.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isSignUp = !_isSignUp;
            });
          },
          child: Text(
            _isSignUp ? 'Sign In' : 'Sign Up',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ],
    ).animate()
      .fadeIn(duration: 600.ms, delay: 2400.ms);
  }
}
