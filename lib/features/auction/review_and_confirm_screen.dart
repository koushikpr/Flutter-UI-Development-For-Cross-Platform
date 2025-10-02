import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../../core/theme/app_theme.dart';
import 'models/auction_data.dart';

class ReviewAndConfirmScreen extends StatefulWidget {
  final AuctionData auctionData;
  
  const ReviewAndConfirmScreen({
    Key? key,
    required this.auctionData,
  }) : super(key: key);

  @override
  State<ReviewAndConfirmScreen> createState() => _ReviewAndConfirmScreenState();
}

class _ReviewAndConfirmScreenState extends State<ReviewAndConfirmScreen> {
  
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
                      
                      // Main auction card (same gradient and styling as auction win screen)
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
                            // Stream cover artwork placeholder (portrait orientation)
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
                                    return _buildDefaultStreamCover();
                                  },
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 16.h),
                            
                            // Auction title (same style as beat title in auction win)
                            _buildSilverGradientText(
                              widget.auctionData.auctionBanner.isNotEmpty 
                                  ? widget.auctionData.auctionBanner 
                                  : 'Auction Title',
                              32.sp,
                            ),
                            
                            SizedBox(height: 20.h),
                            
                            // Auction parameters in one container (same style as achievement badge)
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
                                  child: Row(
                                    children: [
                                      // Starting Bid
                                      Expanded(
                                        child: Column(
                                          children: [
                                            ShaderMask(
                                              shaderCallback: (bounds) => LinearGradient(
                                                colors: [
                                                  Colors.white.withOpacity(0.7),
                                                  Colors.grey[300]!.withOpacity(0.7),
                                                  Colors.grey[400]!.withOpacity(0.7),
                                                  Colors.white.withOpacity(0.7),
                                                ],
                                                stops: [0.0, 0.3, 0.7, 1.0],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ).createShader(bounds),
                                              child: Text(
                                                'Starting Bid',
                                                style: GoogleFonts.fjallaOne(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            _buildSilverGradientText(widget.auctionData.formattedStartingBid, 32.sp),
                                          ],
                                        ),
                                      ),
                                      
                                      SizedBox(width: 16.w),
                                      
                                      // Auction Duration
                                      Expanded(
                                        child: Column(
                                          children: [
                                            ShaderMask(
                                              shaderCallback: (bounds) => LinearGradient(
                                                colors: [
                                                  Colors.white.withOpacity(0.7),
                                                  Colors.grey[300]!.withOpacity(0.7),
                                                  Colors.grey[400]!.withOpacity(0.7),
                                                  Colors.white.withOpacity(0.7),
                                                ],
                                                stops: [0.0, 0.3, 0.7, 1.0],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ).createShader(bounds),
                                              child: Text(
                                                'Auction Duration',
                                                style: GoogleFonts.fjallaOne(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            _buildSilverGradientText(widget.auctionData.formattedDuration, 32.sp),
                                          ],
                                        ),
                                      ),
                                      
                                      SizedBox(width: 16.w),
                                      
                                      // Buy Now Price
                                      Expanded(
                                        child: Column(
                                          children: [
                                            ShaderMask(
                                              shaderCallback: (bounds) => LinearGradient(
                                                colors: [
                                                  Colors.white.withOpacity(0.7),
                                                  Colors.grey[300]!.withOpacity(0.7),
                                                  Colors.grey[400]!.withOpacity(0.7),
                                                  Colors.white.withOpacity(0.7),
                                                ],
                                                stops: [0.0, 0.3, 0.7, 1.0],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ).createShader(bounds),
                                              child: Text(
                                                'Buy Now Price',
                                                style: GoogleFonts.fjallaOne(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            _buildSilverGradientText(widget.auctionData.formattedBuyNowPrice, 32.sp),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 20.h),
                            
                            // Beat for Auction section (same style as achievement badge in auction win)
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
                                      Text(
                                        'Beat for Auction',
                                        style: GoogleFonts.getFont(
                                          'Wix Madefor Display',
                                          fontSize: 14.sp,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                      ),
                                      SizedBox(height: 12.h),
                                      Row(
                                        children: [
                                          // Beat sleeve (same as beat artwork in auction win)
                                          Container(
                                            width: 80.w,
                                            height: 80.w,
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
                                                width: 80.w,
                                                height: 80.w,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return _buildDefaultBeatSleeve();
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 20.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.auctionData.beatTitle.isNotEmpty 
                                                      ? widget.auctionData.beatTitle 
                                                      : 'Beat Title',
                                                  style: GoogleFonts.getFont(
                                                    'Wix Madefor Display',
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4.h),
                                                Row(
                                                  children: [
                                                    Icon(Icons.graphic_eq, color: Colors.white.withOpacity(0.7), size: 14.sp),
                                                    SizedBox(width: 4.w),
                                                    Expanded(
                                                      child: Text(
                                                        '${widget.auctionData.vibeTag} - ${widget.auctionData.bpm} BPM - ${widget.auctionData.key}',
                                                        style: GoogleFonts.getFont(
                                                          'Wix Madefor Display',
                                                          fontSize: 12.sp,
                                                          color: Colors.white.withOpacity(0.7),
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
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
                                    'Everything look good? Once you go live, your auction will be visible to everyone in real time, and artists can start bidding immediately.',
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
                      Row(
                        children: [
                          // Go Back
                          Expanded(
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
                          
                          SizedBox(width: 12.w),
                          
                          // Start Live Auction
                          Expanded(
                            child: GestureDetector(
                              onTap: _startLiveAuction,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.yellow, Colors.green],
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  'Start Live Auction',
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

  Widget _buildDefaultStreamCover() {
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
              Icons.music_note,
              color: Colors.white,
              size: 48.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              'Stream Cover',
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

  Widget _buildDefaultBeatSleeve() {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
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
          size: 32.sp,
        ),
      ),
    );
  }

  void _startLiveAuction() {
    // TODO: Implement starting the live auction
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting live auction...'),
        backgroundColor: AppTheme.successColor,
      ),
    );
    
    // Navigate back to dashboard or to live auction screen
    Navigator.of(context).pop();
  }
}
