import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../../core/theme/app_theme.dart';
import 'models/grab_bag_data.dart';

class GrabBagReviewScreen extends StatefulWidget {
  final GrabBagData grabBagData;
  
  const GrabBagReviewScreen({
    Key? key,
    required this.grabBagData,
  }) : super(key: key);

  @override
  State<GrabBagReviewScreen> createState() => _GrabBagReviewScreenState();
}

class _GrabBagReviewScreenState extends State<GrabBagReviewScreen> {
  
  // Helper method for silver gradient text (same as auction win screen)
  Widget _buildSilverGradientText(String text, double fontSize, {FontWeight fontWeight = FontWeight.w400}) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Colors.white,
          Colors.grey[300]!,
          Colors.grey[400]!,
          Colors.white,
        ],
        stops: [0.0, 0.3, 0.7, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: GoogleFonts.fjallaOne(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [
              Colors.grey.shade800,  // Lighter grey in center
              Colors.grey.shade900,  // Darker grey
              Colors.black,          // Black at edges
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button (same as auction win screen)
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      
                      // Title (same style as auction win screen)
                      Text(
                        'Review\n& Confirm',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: 8.h),
                      
                      // Subtitle
                      Text(
                        'Final check before going live',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[400],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: 20.h),
                      
                      // Main grab bag card (same gradient and styling as auction win screen)
                      Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFFFF59D), // Light yellow (top)
                              Color(0xFFE1BEE7), // Light purple
                              Color(0xFF6A1B9A), // Darker purple (quick transition)
                              Colors.black,      // Black (bottom)
                            ],
                            stops: [0.0, 0.07, 0.30, 0.5],
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            // Grab bag thumbnail (portrait orientation)
                            Container(
                              width: 200.w,
                              height: 280.h,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16.r),
                                image: DecorationImage(
                                  image: AssetImage('assets/waves.jpg'),
                                  fit: BoxFit.cover,
                                  onError: (exception, stackTrace) {
                                    // Fallback if image doesn't exist
                                  },
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: Image.asset(
                                  'assets/waves.jpg',
                                  width: 200.w,
                                  height: 280.h,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildDefaultThumbnail();
                                  },
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 16.h),
                            
                            // Grab bag title (same style as beat title in auction win)
                            _buildSilverGradientText(
                              widget.grabBagData.bagBanner.isNotEmpty 
                                  ? widget.grabBagData.bagBanner 
                                  : 'Livestream name',
                              32.sp,
                            ),
                            
                            SizedBox(height: 20.h),
                            
                            // Grab bag details (same style as achievement badge in auction win)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      // Primary Vibe Tag
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12.r),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(16.w),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(12.r),
                                              border: Border.all(
                                                color: Colors.white.withOpacity(0.3),
                                                width: 1,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Primary Vibe Tag',
                                                  style: GoogleFonts.getFont(
                                                    'Wix Madefor Display',
                                                    fontSize: 14.sp,
                                                    color: Colors.white.withOpacity(0.7),
                                                  ),
                                                ),
                                                SizedBox(height: 8.h),
                                                _buildSilverGradientText(widget.grabBagData.primaryVibeTag, 24.sp),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                      SizedBox(height: 16.h),
                                      
                                      // Pack for Sale
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12.r),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(16.w),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(12.r),
                                              border: Border.all(
                                                color: Colors.white.withOpacity(0.3),
                                                width: 1,
                                              ),
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Pack for Sale',
                                                  style: GoogleFonts.getFont(
                                                    'Wix Madefor Display',
                                                    fontSize: 14.sp,
                                                    color: Colors.white.withOpacity(0.7),
                                                  ),
                                                ),
                                                SizedBox(height: 12.h),
                                                Row(
                                                  children: [
                                                    // Pack thumbnail
                                                    Container(
                                                      width: 60.w,
                                                      height: 60.w,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius: BorderRadius.circular(12.r),
                                                        image: DecorationImage(
                                                          image: AssetImage('assets/waves.jpg'),
                                                          fit: BoxFit.cover,
                                                          onError: (exception, stackTrace) {
                                                            // Fallback if image doesn't exist
                                                          },
                                                        ),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(12.r),
                                                        child: Image.asset(
                                                          'assets/waves.jpg',
                                                          width: 60.w,
                                                          height: 60.w,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context, error, stackTrace) {
                                                            return _buildDefaultPackThumbnail();
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 12.w),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            widget.grabBagData.musicSet,
                                                            style: GoogleFonts.getFont(
                                                              'Wix Madefor Display',
                                                              fontSize: 16.sp,
                                                              fontWeight: FontWeight.w600,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                          SizedBox(height: 4.h),
                                                          Text(
                                                            '6 beats • ${widget.grabBagData.formattedPrice}',
                                                            style: GoogleFonts.getFont(
                                                              'Wix Madefor Display',
                                                              fontSize: 12.sp,
                                                              color: Colors.white.withOpacity(0.7),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 20.h),
                      
                      // Info message (same style as achievement badge)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 24.h),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '🤔',
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    'Everything look good? Once you go live, your grab bag will be visible to everyone in real time, and fans can start buying immediately.',
                                    style: GoogleFonts.getFont(
                                      'Wix Madefor Display',
                                      fontSize: 14.sp,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 20.h),
                      
                      // Bottom buttons (same style as auction win screen)
                      Column(
                        children: [
                          // Start Livestream
                          SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: _startLivestream,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  'Start Livestream',
                                  style: GoogleFonts.fjallaOne(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 12.h),
                          
                          // Go Back
                          SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: _buildSilverGradientText('Go Back', 16.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultThumbnail() {
    return Container(
      width: 200.w,
      height: 280.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFFD700), // Gold
            const Color(0xFFFF6B35), // Orange
            const Color(0xFF8B5CF6), // Purple
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              color: Colors.white,
              size: 48.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              'Grab Bag',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Default Design',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultPackThumbnail() {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF667eea),
            const Color(0xFF764ba2),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.album,
          color: Colors.white,
          size: 24.sp,
        ),
      ),
    );
  }

  void _startLivestream() {
    // TODO: Implement starting the livestream
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting livestream...'),
        backgroundColor: AppTheme.successColor,
      ),
    );
    
    // Navigate back to dashboard or to livestream screen
    Navigator.of(context).pop();
  }
}
