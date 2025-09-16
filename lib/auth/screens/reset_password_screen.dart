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
import '../models/auth_models.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../widgets/error_dialog.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? token;

  const ResetPasswordScreen({
    super.key,
    this.token,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.token != null) {
      _tokenController.text = widget.token!;
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              title: 'Reset Failed',
              message: state.message,
              details: state.details,
              onRetry: () {
                context.read<AuthBloc>().add(const AuthClearError());
              },
            );
          }

          if (state is AuthPasswordResetSuccess) {
            ErrorDialog.show(
              context,
              title: 'Password Reset!',
              message: 'Your password has been successfully reset. You can now sign in with your new password.',
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
                    
                    // Reset password form
                    _buildResetPasswordForm(),
                    
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

  Widget _buildResetPasswordForm() {
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Icon
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Icon(
                    FontAwesomeIcons.key,
                    color: AppTheme.accentColor,
                    size: 32.sp,
                  ),
                ).animate()
                  .fadeIn(duration: 800.ms, delay: 600.ms)
                  .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),
                
                SizedBox(height: 24.h),
                
                // Title
                Text(
                  'Reset Password',
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
                  'Enter your reset code and create a new password',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 14.sp,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ).animate()
                  .fadeIn(duration: 600.ms, delay: 1000.ms)
                  .slideY(begin: 0.2, end: 0),
                
                SizedBox(height: 32.h),
                
                // Reset code field
                AuthTextField(
                  controller: _tokenController,
                  hintText: 'Enter reset code',
                  prefixIcon: Icons.key,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the reset code';
                    }
                    return null;
                  },
                ).animate()
                  .fadeIn(duration: 600.ms, delay: 1200.ms)
                  .slideX(begin: -0.2, end: 0),
                
                SizedBox(height: 16.h),
                
                // New password field
                AuthTextField(
                  controller: _passwordController,
                  hintText: 'New password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  onSuffixTap: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]').hasMatch(value)) {
                      return 'Password must contain uppercase, lowercase, number, and special character';
                    }
                    return null;
                  },
                ).animate()
                  .fadeIn(duration: 600.ms, delay: 1400.ms)
                  .slideX(begin: -0.2, end: 0),
                
                SizedBox(height: 16.h),
                
                // Confirm password field
                AuthTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm new password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  onSuffixTap: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ).animate()
                  .fadeIn(duration: 600.ms, delay: 1600.ms)
                  .slideX(begin: -0.2, end: 0),
                
                SizedBox(height: 24.h),
                
                // Reset password button
                AuthPrimaryButton(
                  text: 'Reset Password',
                  onPressed: _handleResetPassword,
                  isLoading: _isLoading,
                  icon: FontAwesomeIcons.check,
                ).animate()
                  .fadeIn(duration: 600.ms, delay: 1800.ms)
                  .slideY(begin: 0.2, end: 0),
                
                SizedBox(height: 16.h),
                
                // Back to login
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
                    'Back to Login',
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 14.sp,
                      color: AppTheme.textSecondary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ).animate()
                  .fadeIn(duration: 600.ms, delay: 2000.ms),
              ],
            ),
          ),
        ),
      ),
    ).animate()
      .fadeIn(duration: 800.ms, delay: 1000.ms)
      .slideY(begin: 0.3, end: 0);
  }

  void _handleResetPassword() {
    if (_formKey.currentState!.validate()) {
      final request = ResetPasswordRequest(
        token: _tokenController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );
      
      context.read<AuthBloc>().add(AuthResetPassword(request));
    }
  }
}
