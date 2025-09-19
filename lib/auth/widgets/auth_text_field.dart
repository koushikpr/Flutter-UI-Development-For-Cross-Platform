import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final int maxLines;
  final String? errorText;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.errorText,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.glassColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: widget.errorText != null
                  ? Colors.red.withOpacity(0.5)
                  : _isFocused
                      ? AppTheme.accentColor.withOpacity(0.5)
                      : AppTheme.glassBorder,
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: TextFormField(
                controller: widget.controller,
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                validator: widget.validator,
                onChanged: widget.onChanged,
                enabled: widget.enabled,
                maxLines: widget.maxLines,
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 16.sp,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 16.sp,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: widget.prefixIcon != null
                      ? Icon(
                          widget.prefixIcon,
                          color: _isFocused
                              ? AppTheme.accentColor
                              : AppTheme.textSecondary,
                          size: 20.sp,
                        )
                      : null,
                  suffixIcon: widget.suffixIcon != null
                      ? IconButton(
                          icon: Icon(
                            widget.suffixIcon,
                            color: _isFocused
                                ? AppTheme.accentColor
                                : AppTheme.textSecondary,
                            size: 20.sp,
                          ),
                          onPressed: widget.onSuffixTap,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _isFocused = true;
                  });
                },
                onFieldSubmitted: (value) {
                  setState(() {
                    _isFocused = false;
                  });
                },
                onTapOutside: (event) {
                  setState(() {
                    _isFocused = false;
                  });
                },
              ),
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          SizedBox(height: 8.h),
          Text(
            widget.errorText!,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 12.sp,
              color: Colors.red,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}


