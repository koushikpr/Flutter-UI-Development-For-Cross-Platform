import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class GlassButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final Gradient? gradient;
  final bool isLoading;

  const GlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.gradient,
    this.isLoading = false,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: isEnabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1.0 - (_controller.value * 0.02);
          
          return Transform.scale(
            scale: scale,
            child: Container(
              width: widget.width,
              height: widget.height ?? 56.h,
              decoration: BoxDecoration(
                gradient: widget.gradient,
                color: widget.gradient == null 
                  ? (widget.backgroundColor ?? AppTheme.glassColor)
                  : null,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppTheme.glassBorder,
                  width: 1,
                ),
                boxShadow: isEnabled && _isPressed
                  ? [
                      BoxShadow(
                        color: AppTheme.textPrimary.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.gradient != null 
                        ? null 
                        : (widget.backgroundColor ?? AppTheme.glassColor),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Center(
                      child: widget.isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.textColor ?? AppTheme.textPrimary,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.icon != null) ...[
                                widget.icon!,
                                SizedBox(width: 12.w),
                              ],
                              Text(
                                widget.text,
                                style: GoogleFonts.getFont(
                                  'Wix Madefor Display',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: widget.textColor ?? 
                                    (widget.gradient != null 
                                      ? AppTheme.backgroundColor 
                                      : AppTheme.textPrimary),
                                ),
                              ),
                            ],
                          ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ).animate(target: _isPressed ? 1 : 0)
      .shimmer(
        duration: const Duration(milliseconds: 1000),
        color: AppTheme.textPrimary.withOpacity(0.1),
      );
  }
}
