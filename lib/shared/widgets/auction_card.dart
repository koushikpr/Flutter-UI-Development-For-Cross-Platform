import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';

class AuctionCard extends StatelessWidget {
  final String title;
  final String username;
  final String? avatarUrl;
  final VoidCallback? onContinue;
  final VoidCallback? onShare;
  final VoidCallback? onLike;
  final bool isLiked;

  const AuctionCard({
    super.key,
    required this.title,
    required this.username,
    this.avatarUrl,
    this.onContinue,
    this.onShare,
    this.onLike,
    this.isLiked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 184.h,
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // Background with blur effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.glassColor,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: AppTheme.glassBorder,
                    width: 1,
                  ),
                ),
              ),
            ),
            
            // Gradient overlay (purple glow)
            Positioned(
              left: -128.75.w,
              top: -62.h,
              child: Container(
                width: 226.w,
                height: 226.h,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(113.r),
                ),
              ).animate()
                .shimmer(
                  duration: 3000.ms,
                  color: AppTheme.accentColor.withOpacity(0.1),
                ),
            ),
            
            // Rotated background element
            Positioned(
              left: -49.94.w,
              top: -88.68.h,
              child: Transform.rotate(
                angle: 0.324, // 18.54 degrees in radians
                child: Container(
                  width: 384.26.w,
                  height: 309.69.h,
                  decoration: BoxDecoration(
                    color: AppTheme.glassColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ),
            
            // Content
            Positioned(
              left: 94.w,
              top: 0,
              bottom: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Wix Madefor Display',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.04,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Continue Button
                  Container(
                    width: 62.w,
                    height: 36.h,
                    child: ElevatedButton(
                      onPressed: onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.textPrimary,
                        foregroundColor: AppTheme.backgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontFamily: 'Wix Madefor Display',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ).animate()
                    .scale(
                      duration: 200.ms,
                      curve: Curves.easeInOut,
                    ),
                ],
              ),
            ),
            
            // Bottom section with user info and actions
            Positioned(
              bottom: 12.h,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // User info
                    Row(
                      children: [
                        // Avatar
                        Container(
                          width: 18.w,
                          height: 18.h,
                          decoration: BoxDecoration(
                            color: AppTheme.batteryColor,
                            borderRadius: BorderRadius.circular(9.r),
                          ),
                          child: avatarUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(9.r),
                                  child: Image.network(
                                    avatarUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : null,
                        ),
                        
                        SizedBox(width: 8.w),
                        
                        // Username
                        Text(
                          username,
                          style: TextStyle(
                            fontFamily: 'Wix Madefor Display',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    
                    // Action buttons
                    Row(
                      children: [
                        // Share button
                        _buildActionButton(
                          icon: Icons.share,
                          onTap: onShare,
                        ),
                        
                        SizedBox(width: 4.w),
                        
                        // Like button
                        _buildActionButton(
                          icon: isLiked ? Icons.favorite : Icons.favorite_border,
                          onTap: onLike,
                          isActive: isLiked,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    VoidCallback? onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26.w,
        height: 26.h,
        decoration: BoxDecoration(
          color: AppTheme.secondaryColor,
          borderRadius: BorderRadius.circular(13.r),
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.red : AppTheme.textPrimary,
          size: 13.sp,
        ),
      ),
    ).animate(target: isActive ? 1 : 0)
      .scale(
        duration: 200.ms,
        curve: Curves.bounceOut,
      );
  }
}
