import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_button.dart';
import '../widgets/error_dialog.dart';
import 'login_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String username;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.username,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _tokenController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            setState(() {
              _isLoading = true;
            });
          } else {
            setState(() {
              _isLoading = false;
            });
          }

          if (state is AuthError) {
            ErrorDialog.show(
              context,
              title: 'Verification Failed',
              message: state.message,
              details: state.details,
              onRetry: () {
                context.read<AuthBloc>().add(const AuthClearError());
              },
            );
          }

          if (state is AuthEmailVerificationSuccess) {
            ErrorDialog.show(
              context,
              title: 'Email Verified!',
              message: 'Your email has been successfully verified. You can now sign in.',
              onDismiss: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
            );
          }
        },
        child: Stack(
          children: [
            // Background gradient effects
            _buildBackgroundEffects(),
            
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 60.h),
                    
                    // Header
                    _buildHeader(),
                    
                    SizedBox(height: 40.h),
                    
                    // Verification content
                    _buildVerificationContent(),
                    
                    SizedBox(height: 40.h),
                    
                    // Manual verification form
                    _buildManualVerificationForm(),
                    
                    SizedBox(height: 30.h),
                    
                    // Action buttons
                    _buildActionButtons(),
                    
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundEffects() {
    return Stack(
      children: [
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
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Back button
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                FontAwesomeIcons.arrowLeft,
                color: AppTheme.textPrimary,
                size: 20.sp,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 20.h),
        
        // Logo
        Text(
          'BAGR_Z',
          style: GoogleFonts.getFont(
            'Montserrat',
            fontSize: 32.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ).animate()
          .fadeIn(duration: 800.ms, delay: 200.ms)
          .slideY(begin: -0.3, end: 0),
        
        SizedBox(height: 8.h),
        
        Container(
          width: 50.w,
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

  Widget _buildVerificationContent() {
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
              // Email icon
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Icon(
                  FontAwesomeIcons.envelope,
                  color: AppTheme.accentColor,
                  size: 32.sp,
                ),
              ).animate()
                .fadeIn(duration: 800.ms, delay: 600.ms)
                .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),
              
              SizedBox(height: 24.h),
              
              // Title
              Text(
                'Verify Your Email',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ).animate()
                .fadeIn(duration: 600.ms, delay: 800.ms)
                .slideY(begin: 0.2, end: 0),
              
              SizedBox(height: 12.h),
              
              // Description
              Text(
                'We\'ve sent a verification link to',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: AppTheme.textSecondary,
                ),
              ).animate()
                .fadeIn(duration: 600.ms, delay: 1000.ms)
                .slideY(begin: 0.2, end: 0),
              
              SizedBox(height: 8.h),
              
              // Email address
              Text(
                widget.email,
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentColor,
                ),
              ).animate()
                .fadeIn(duration: 600.ms, delay: 1200.ms)
                .slideY(begin: 0.2, end: 0),
              
              SizedBox(height: 20.h),
              
              // Instructions
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppTheme.accentColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.lightbulb,
                          color: AppTheme.accentColor,
                          size: 16.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Instructions:',
                          style: GoogleFonts.getFont(
                            'Wix Madefor Display',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '1. Check your email inbox\n2. Click the verification link\n3. Or enter the verification code below',
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 12.sp,
                        color: AppTheme.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ).animate()
                .fadeIn(duration: 600.ms, delay: 1400.ms)
                .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    ).animate()
      .fadeIn(duration: 800.ms, delay: 1000.ms)
      .slideY(begin: 0.3, end: 0);
  }

  Widget _buildManualVerificationForm() {
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
              Text(
                'Manual Verification',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ).animate()
                .fadeIn(duration: 600.ms, delay: 1600.ms)
                .slideY(begin: 0.2, end: 0),
              
              SizedBox(height: 12.h),
              
              Text(
                'Enter the verification code from your email',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: AppTheme.textSecondary,
                ),
              ).animate()
                .fadeIn(duration: 600.ms, delay: 1800.ms)
                .slideY(begin: 0.2, end: 0),
              
              SizedBox(height: 20.h),
              
              // Token input field
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppTheme.glassColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppTheme.glassBorder,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _tokenController,
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 16.sp,
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Enter verification code',
                    hintStyle: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 14.sp,
                      color: AppTheme.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ).animate()
                .fadeIn(duration: 600.ms, delay: 2000.ms)
                .slideX(begin: -0.2, end: 0),
            ],
          ),
        ),
      ),
    ).animate()
      .fadeIn(duration: 800.ms, delay: 1600.ms)
      .slideY(begin: 0.3, end: 0);
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Verify button
        AuthPrimaryButton(
          text: 'Verify Email',
          onPressed: _handleVerifyEmail,
          isLoading: _isLoading,
          icon: FontAwesomeIcons.check,
        ).animate()
          .fadeIn(duration: 600.ms, delay: 2200.ms)
          .slideY(begin: 0.2, end: 0),
        
        SizedBox(height: 16.h),
        
        // Resend button
        AuthSecondaryButton(
          text: 'Resend Verification Email',
          onPressed: _handleResendEmail,
          isLoading: _isResending,
          icon: FontAwesomeIcons.paperPlane,
        ).animate()
          .fadeIn(duration: 600.ms, delay: 2400.ms)
          .slideY(begin: 0.2, end: 0),
        
        SizedBox(height: 16.h),
        
        // Skip to login button
        TextButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
              (route) => false,
            );
          },
          child: Text(
            'Skip to Login',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              color: AppTheme.textSecondary,
              decoration: TextDecoration.underline,
            ),
          ),
        ).animate()
          .fadeIn(duration: 600.ms, delay: 2600.ms),
      ],
    );
  }

  void _handleVerifyEmail() {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the verification code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(AuthVerifyEmail(token));
  }

  void _handleResendEmail() {
    setState(() {
      _isResending = true;
    });

    // TODO: Implement resend email functionality
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isResending = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent!'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }
}
