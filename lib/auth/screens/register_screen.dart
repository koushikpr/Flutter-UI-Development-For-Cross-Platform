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
import '../models/user_model.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';
import '../widgets/error_dialog.dart';
import 'email_verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  UserRole _selectedRole = UserRole.fan;

  @override
  void initState() {
    super.initState();
    // Load available roles
    context.read<AuthBloc>().add(const AuthGetRoles());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
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

          if (state is AuthError && mounted) {
            ErrorDialog.show(
              context,
              title: 'Registration Failed',
              message: state.message,
              details: state.details,
              onRetry: () {
                if (mounted) {
                  context.read<AuthBloc>().add(const AuthClearError());
                }
              },
            );
          }

          if (state is AuthRegistrationSuccess && mounted) {
            ErrorDialog.show(
              context,
              title: 'Registration Successful!',
              message: 'Please check your email for verification instructions.',
              onDismiss: () {
                if (mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => EmailVerificationScreen(
                        email: _emailController.text.trim(),
                        username: _usernameController.text.trim(),
                      ),
                    ),
                  );
                }
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
                    SizedBox(height: 40.h),
                    
                    // Header
                    _buildHeader(),
                    
                    SizedBox(height: 40.h),
                    
                    // Registration form
                    _buildRegistrationForm(),
                    
                    SizedBox(height: 30.h),
                    
                    // Social registration buttons
                    _buildSocialRegistrations(),
                    
                    SizedBox(height: 30.h),
                    
                    // Toggle to login
                    _buildToggleToLogin(),
                    
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
        
        SizedBox(height: 20.h),
        
        // Title
        Text(
          'Create Account',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
            letterSpacing: -0.04,
          ),
        ).animate()
          .fadeIn(duration: 600.ms, delay: 600.ms)
          .slideY(begin: 0.2, end: 0),
        
        SizedBox(height: 8.h),
        
        Text(
          'Join the auction community',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.textSecondary,
          ),
        ).animate()
          .fadeIn(duration: 600.ms, delay: 800.ms)
          .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildRegistrationForm() {
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
                
                // Username field
                AuthTextField(
                  controller: _usernameController,
                  hintText: 'Username',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    if (value.length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                      return 'Username can only contain letters, numbers, and underscores';
                    }
                    return null;
                  },
                ).animate()
                  .fadeIn(duration: 600.ms, delay: 1200.ms)
                  .slideX(begin: -0.2, end: 0),
                
                SizedBox(height: 16.h),
                
                // Name fields
                Row(
                  children: [
                    Expanded(
                      child: AuthTextField(
                        controller: _firstNameController,
                        hintText: 'First name',
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AuthTextField(
                        controller: _lastNameController,
                        hintText: 'Last name',
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ).animate()
                  .fadeIn(duration: 600.ms, delay: 1400.ms)
                  .slideX(begin: -0.2, end: 0),
                
                SizedBox(height: 16.h),
                
                // Role selection
                _buildRoleSelection().animate()
                  .fadeIn(duration: 600.ms, delay: 1600.ms)
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
                      return 'Please enter a password';
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
                  .fadeIn(duration: 600.ms, delay: 1800.ms)
                  .slideX(begin: -0.2, end: 0),
                
                SizedBox(height: 16.h),
                
                // Confirm password field
                AuthTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm password',
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
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ).animate()
                  .fadeIn(duration: 600.ms, delay: 2000.ms)
                  .slideX(begin: -0.2, end: 0),
                
                SizedBox(height: 24.h),
                
                // Register button
                AuthPrimaryButton(
                  text: 'Create Account',
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                  icon: FontAwesomeIcons.userPlus,
                ).animate()
                  .fadeIn(duration: 600.ms, delay: 2200.ms)
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

  Widget _buildRoleSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Role',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<UserRole>(
              value: _selectedRole,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.textSecondary,
                size: 20.sp,
              ),
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 16.sp,
                color: AppTheme.textPrimary,
              ),
              items: UserRole.values.map((role) {
                return DropdownMenuItem<UserRole>(
                  value: role,
                  child: Text(
                    role.name.toUpperCase(),
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 14.sp,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (UserRole? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialRegistrations() {
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
          .fadeIn(duration: 600.ms, delay: 2400.ms),
        
        SizedBox(height: 24.h),
        
        // Google Sign Up
        AuthSocialButton(
          text: 'Continue with Google',
          onPressed: _handleGoogleSignUp,
          icon: FontAwesomeIcons.google,
        ).animate()
          .fadeIn(duration: 600.ms, delay: 2600.ms)
          .slideX(begin: 0.2, end: 0),
        
        SizedBox(height: 12.h),
        
        // Apple Sign Up
        AuthSocialButton(
          text: 'Continue with Apple',
          onPressed: _handleAppleSignUp,
          icon: FontAwesomeIcons.apple,
        ).animate()
          .fadeIn(duration: 600.ms, delay: 2800.ms)
          .slideX(begin: -0.2, end: 0),
      ],
    );
  }

  Widget _buildToggleToLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            color: AppTheme.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Sign In',
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
      .fadeIn(duration: 600.ms, delay: 3000.ms);
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      final request = CreateUserRequest(
        email: _emailController.text.trim(),
        username: _usernameController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        role: _selectedRole,
      );
      
      context.read<AuthBloc>().add(AuthRegister(request));
    }
  }

  void _handleGoogleSignUp() {
    // TODO: Implement Google Sign Up
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Google Sign Up coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _handleAppleSignUp() {
    // TODO: Implement Apple Sign Up
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Apple Sign Up coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
