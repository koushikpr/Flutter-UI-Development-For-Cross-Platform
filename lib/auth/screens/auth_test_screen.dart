import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../auth_module.dart';

class AuthTestScreen extends StatelessWidget {
  const AuthTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              
              // Header
              Text(
                'Auth Module Test',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              
              SizedBox(height: 8.h),
              
              Text(
                'Test the authentication system',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 16.sp,
                  color: AppTheme.textSecondary,
                ),
              ),
              
              SizedBox(height: 40.h),
              
              // Auth status
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppTheme.glassColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppTheme.glassBorder,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _getStatusIcon(state),
                          color: _getStatusColor(state),
                          size: 32.sp,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          _getStatusText(state),
                          style: GoogleFonts.getFont(
                            'Wix Madefor Display',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          _getStatusDescription(state),
                          style: GoogleFonts.getFont(
                            'Wix Madefor Display',
                            fontSize: 14.sp,
                            color: AppTheme.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
              
              SizedBox(height: 40.h),
              
              // Action buttons
              Column(
                children: [
                  _buildActionButton(
                    context,
                    'Login',
                    FontAwesomeIcons.rightToBracket,
                    () => AuthModule.navigateToLogin(context),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  _buildActionButton(
                    context,
                    'Register',
                    FontAwesomeIcons.userPlus,
                    () => AuthModule.navigateToRegister(context),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  _buildActionButton(
                    context,
                    'Forgot Password',
                    FontAwesomeIcons.key,
                    () => AuthModule.navigateToForgotPassword(context),
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthAuthenticated) {
                        return _buildActionButton(
                          context,
                          'Logout',
                          FontAwesomeIcons.rightFromBracket,
                          () => AuthModule.logout(context),
                          isDestructive: true,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
              
              const Spacer(),
              
              // Back to dashboard
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Back to Dashboard',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 14.sp,
                    color: AppTheme.textSecondary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    IconData icon,
    VoidCallback onPressed, {
    bool isDestructive = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive 
              ? Colors.red.withOpacity(0.1)
              : AppTheme.accentColor.withOpacity(0.1),
          foregroundColor: isDestructive ? Colors.red : AppTheme.accentColor,
          side: BorderSide(
            color: isDestructive ? Colors.red : AppTheme.accentColor,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18.sp),
            SizedBox(width: 12.w),
            Text(
              text,
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(AuthState state) {
    if (state is AuthAuthenticated) {
      return FontAwesomeIcons.circleCheck;
    } else if (state is AuthLoading) {
      return FontAwesomeIcons.spinner;
    } else if (state is AuthError) {
      return FontAwesomeIcons.triangleExclamation;
    } else {
      return FontAwesomeIcons.userXmark;
    }
  }

  Color _getStatusColor(AuthState state) {
    if (state is AuthAuthenticated) {
      return Colors.green;
    } else if (state is AuthLoading) {
      return AppTheme.accentColor;
    } else if (state is AuthError) {
      return Colors.red;
    } else {
      return AppTheme.textSecondary;
    }
  }

  String _getStatusText(AuthState state) {
    if (state is AuthAuthenticated) {
      return 'Authenticated';
    } else if (state is AuthLoading) {
      return 'Loading...';
    } else if (state is AuthError) {
      return 'Error';
    } else {
      return 'Not Authenticated';
    }
  }

  String _getStatusDescription(AuthState state) {
    if (state is AuthAuthenticated) {
      final user = state.user;
      return 'Welcome back, ${user.displayName}!';
    } else if (state is AuthLoading) {
      return 'Please wait...';
    } else if (state is AuthError) {
      return state.message;
    } else {
      return 'Please sign in to continue';
    }
  }
}
