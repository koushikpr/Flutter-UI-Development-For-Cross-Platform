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
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

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
              title: 'Login Failed',
              message: state.message,
              details: state.details,
              onRetry: () {
                context.read<AuthBloc>().add(const AuthClearError());
              },
            );
          }

          if (state is AuthAuthenticated) {
            // Navigate to dashboard or main app
            Navigator.of(context).pushReplacementNamed('/dashboard');
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
                    
                    // Toggle to register
                    _buildToggleToRegister(),
                    
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
          'Welcome Back',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: -0.04,
          ),
        ).animate()
          .fadeIn(duration: 600.ms, delay: 600.ms)
          .slideY(begin: 0.2, end: 0),
        
        SizedBox(height: 8.h),
        
        Text(
          'Sign in to continue to BAGR_Z',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Email field
                AuthTextField(
                  controller: _emailController,
                  hintText: 'Email address',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ).animate()
                  .fadeIn(duration: 600.ms, delay: 1000.ms)
                  .slideX(begin: -0.2, end: 0),
                
                SizedBox(height: 16.h),
                
                // Password field
                AuthTextField(
                  controller: _passwordController,
                  hintText: 'Password',
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
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ).animate()
                  .fadeIn(duration: 600.ms, delay: 1200.ms)
                  .slideX(begin: -0.2, end: 0),
                
                SizedBox(height: 16.h),
                
                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 14.sp,
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ).animate()
                  .fadeIn(duration: 600.ms, delay: 1400.ms),
                
                SizedBox(height: 24.h),
                
                // Login button
                AuthPrimaryButton(
                  text: 'Sign In',
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                  icon: FontAwesomeIcons.rightToBracket,
                ).animate()
                  .fadeIn(duration: 600.ms, delay: 1600.ms)
                  .slideY(begin: 0.2, end: 0),
              ],
            ),
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
                  color: Colors.white,
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
        
        // Google Sign In
        AuthSocialButton(
          text: 'Continue with Google',
          onPressed: _handleGoogleSignIn,
          icon: FontAwesomeIcons.google,
        ).animate()
          .fadeIn(duration: 600.ms, delay: 2000.ms)
          .slideX(begin: 0.2, end: 0),
        
        SizedBox(height: 12.h),
        
        // Apple Sign In
        AuthSocialButton(
          text: 'Continue with Apple',
          onPressed: _handleAppleSignIn,
          icon: FontAwesomeIcons.apple,
        ).animate()
          .fadeIn(duration: 600.ms, delay: 2200.ms)
          .slideX(begin: -0.2, end: 0),
      ],
    );
  }

  Widget _buildToggleToRegister() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ),
            );
          },
          child: Text(
            'Sign Up',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ).animate()
      .fadeIn(duration: 600.ms, delay: 2400.ms);
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final request = LoginRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      context.read<AuthBloc>().add(AuthLogin(request));
    }
  }

  void _handleGoogleSignIn() {
    // TODO: Implement Google Sign In
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Google Sign In coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _handleAppleSignIn() {
    // TODO: Implement Apple Sign In
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Apple Sign In coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

