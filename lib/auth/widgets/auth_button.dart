import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final double? height;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? fontSize;
  final FontWeight? fontWeight;

  const AuthButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.height,
    this.gradient,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? double.infinity;
    final effectiveHeight = height ?? 50.h;
    final effectiveGradient = gradient ??
        LinearGradient(
          colors: [AppTheme.textPrimary, AppTheme.accentColor],
        );
    final effectiveTextColor = textColor ?? Colors.white;
    final effectiveBackgroundColor = backgroundColor ?? Colors.transparent;

    return Container(
      width: effectiveWidth,
      height: effectiveHeight,
      decoration: BoxDecoration(
        gradient: isEnabled ? effectiveGradient : null,
        color: isEnabled ? null : effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: effectiveGradient.colors.first.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled && !isLoading ? onPressed : null,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            decoration: BoxDecoration(
              color: isEnabled ? null : effectiveBackgroundColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          effectiveTextColor,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            color: effectiveTextColor,
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                        ],
                        Text(
                          text,
                          style: GoogleFonts.getFont(
                            'Wix Madefor Display',
                            fontSize: fontSize ?? 16.sp,
                            fontWeight: fontWeight ?? FontWeight.w600,
                            color: effectiveTextColor,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// Specialized auth buttons
class AuthPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final IconData? icon;

  const AuthPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AuthButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      width: width,
      icon: icon,
      gradient: const LinearGradient(
        colors: [AppTheme.textPrimary, AppTheme.accentColor],
      ),
    );
  }
}

class AuthSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final IconData? icon;

  const AuthSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AuthButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      width: width,
      icon: icon,
      backgroundColor: AppTheme.glassLight,
      textColor: AppTheme.textPrimary,
    );
  }
}

class AuthSocialButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData icon;
  final bool isLoading;

  const AuthSocialButton({
    super.key,
    required this.text,
    this.onPressed,
    required this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AuthButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      backgroundColor: AppTheme.glassLight,
      textColor: AppTheme.textPrimary,
    );
  }
}
