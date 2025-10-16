import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';

class LiveAuctionCard extends StatefulWidget {
  final int peopleCount;
  final String theme;
  final String title;
  final String artist;
  final bool isLive;
  final VoidCallback? onStart;
  final VoidCallback? onShare;
  final VoidCallback? onLike;
  final bool isLiked;

  const LiveAuctionCard({
    super.key,
    required this.peopleCount,
    required this.theme,
    required this.title,
    required this.artist,
    this.isLive = false,
    this.onStart,
    this.onShare,
    this.onLike,
    this.isLiked = false,
  });

  @override
  State<LiveAuctionCard> createState() => _LiveAuctionCardState();
}

class _LiveAuctionCardState extends State<LiveAuctionCard> {
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200.h,
      margin: EdgeInsets.only(bottom: 16.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // Background with glassmorphism
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
            
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.accentColor.withOpacity(0.1),
                    Colors.transparent,
                    AppTheme.accentColor.withOpacity(0.05),
                  ],
                ),
              ),
            ),
            
            // Wave pattern background
            Positioned.fill(
              child: CustomPaint(
                painter: WavePainter(),
              ),
            ),
            
            // Content
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row with people count and theme
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // People count
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.glassLight,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: AppTheme.glassBorder,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people,
                              color: AppTheme.textSecondary,
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${widget.peopleCount}',
                              style: TextStyle(
                                fontFamily: 'Wix Madefor Display',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Theme tag
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.textPrimary,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          widget.theme,
                          style: TextStyle(
                            fontFamily: 'Wix Madefor Display',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.backgroundColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Artist info
                  Row(
                    children: [
                      Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: AppTheme.batteryColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.person,
                          color: AppTheme.textPrimary,
                          size: 12.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        widget.artist,
                        style: TextStyle(
                          fontFamily: 'Wix Madefor Display',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  // Title
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: 'Wix Madefor Display',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.04,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Bottom row with actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Start button
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.textPrimary,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.textPrimary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: widget.onStart,
                          child: Text(
                            widget.isLive ? 'Join' : 'Start',
                            style: TextStyle(
                              fontFamily: 'Wix Madefor Display',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.backgroundColor,
                            ),
                          ),
                        ),
                      ),
                      
                      // Action buttons
                      Row(
                        children: [
                          // Share button
                          _buildActionButton(
                            icon: Icons.share,
                            onTap: widget.onShare,
                          ),
                          
                          SizedBox(width: 8.w),
                          
                          // Like button
                          _buildActionButton(
                            icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                            onTap: () {
                              setState(() {
                                _isLiked = !_isLiked;
                              });
                              widget.onLike?.call();
                            },
                            isActive: _isLiked,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Live indicator
            if (widget.isLive)
              Positioned(
                top: 16.h,
                right: 16.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ).animate(onPlay: (controller) => controller.repeat())
                        .fadeIn(duration: 500.ms)
                        .then()
                        .fadeOut(duration: 500.ms),
                      SizedBox(width: 4.w),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          fontFamily: 'Wix Madefor Display',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
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
        width: 36.w,
        height: 36.h,
        decoration: BoxDecoration(
          color: AppTheme.glassLight,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: AppTheme.glassBorder,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.red : AppTheme.textPrimary,
          size: 16.sp,
        ),
      ),
    ).animate(target: isActive ? 1 : 0)
      .scale(
        duration: 200.ms,
        curve: Curves.bounceOut,
      );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.textSecondary.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    for (int i = 0; i < 8; i++) {
      final y = size.height * 0.3 + (i * 15);
      path.moveTo(0, y);
      
      for (double x = 0; x <= size.width; x += 20) {
        final waveY = y + (10 * (i % 2 == 0 ? 1 : -1)) * 
            (0.5 + 0.5 * (x / size.width));
        path.lineTo(x, waveY);
      }
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
