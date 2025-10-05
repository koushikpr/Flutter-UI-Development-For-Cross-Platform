import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'cosign_producer_screen.dart';

class AuctionWinScreen extends StatelessWidget {
  final String beatTitle;
  final String producerName;
  final int finalPrice;
  final int liveViewers;
  final String beatDetails;
  final bool isWinner;

  const AuctionWinScreen({
    Key? key,
    required this.beatTitle,
    required this.producerName,
    required this.finalPrice,
    required this.liveViewers,
    required this.beatDetails,
    this.isWinner = true,
  }) : super(key: key);

  // Helper method for silver gradient text
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
              // Header with back button
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
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
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      
                      // Win announcement with exclusive badge (two lines)
                      Column(
                        children: [
                          // Line 1: "You just won"
                          Text(
                            'You just won',
                            style: GoogleFonts.fjallaOne(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4.h),
                          // Line 2: "Exclusive" with glass effect box + "rights!" in Fjalla One
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Glass effect box around "Exclusive" with tilt
                              Transform.rotate(
                                angle: -0.05, // Slight tilt (about -5.7 degrees)
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12.r),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                      child: ShaderMask(
                                        shaderCallback: (bounds) => LinearGradient(
                                          colors: [
                                            Color(0xFFFFD700), // Gold
                                            Color(0xFFFFA500), // Orange
                                            Color(0xFFFFD700), // Gold
                                            Color(0xFFFFA500), // Orange
                                          ],
                                          stops: [0.0, 0.3, 0.7, 1.0],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds),
                                        child: Text(
                                          'Exclusive',
                                          style: GoogleFonts.fjallaOne(
                                            fontSize: 32.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              // "rights!" in Fjalla One
                              Text(
                                'rights!',
                                style: GoogleFonts.fjallaOne(
                                  fontSize: 32.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 20.h),
                      
                      // Beat card
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
                            // Beat artwork placeholder
                            Container(
                              width: 120.w,
                              height: 120.w,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16.r),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/beat_cover.jpg'),
                                  fit: BoxFit.cover,
                                  onError: (exception, stackTrace) {
                                    // Fallback if image doesn't exist
                                  },
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child:                                 Image.asset(
                                  'assets/trap.jpg',
                                  width: 120.w,
                                  height: 120.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 120.w,
                                      height: 120.w,
                                      color: Colors.black,
                                      child: Center(
                                        child: Icon(
                                          Icons.music_note,
                                          color: Colors.white.withOpacity(0.7),
                                          size: 40.sp,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 16.h),
                            
                            // Producer badge and name
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Trap badge (red background)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    'Trap',
                                    style: GoogleFonts.getFont(
                                      'Wix Madefor Display',
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                // Producer indicator
                                Container(
                                  width: 12.w,
                                  height: 12.w,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                // Producer name (no background)
                                Text(
                                  '@$producerName',
                                  style: GoogleFonts.getFont(
                                    'Wix Madefor Display',
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 12.h),
                            
                            // Beat title
                            _buildSilverGradientText(beatTitle, 32.sp),
                            
                            SizedBox(height: 8.h),
                            
                            // Beat details
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.graphic_eq, color: Colors.white.withOpacity(0.7), size: 14.sp),
                                SizedBox(width: 4.w),
                                Text(
                                  beatDetails,
                                  style: GoogleFonts.getFont(
                                    'Wix Madefor Display',
                                    fontSize: 12.sp,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 20.h),
                            
                            // Stats row inside the beat card
                            Row(
                              children: [
                                // Price paid
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        padding: EdgeInsets.all(16.w),
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
                                            'Price paid',
                                            style: GoogleFonts.fjallaOne(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        _buildSilverGradientText('\$$finalPrice', 32.sp),
                                      ],
                                    ),
                                      ),
                                    ),
                                  ),
                                ),
                                
                                SizedBox(width: 12.w),
                                
                                // Live viewers
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        padding: EdgeInsets.all(16.w),
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
                                            'Live Viewers',
                                            style: GoogleFonts.fjallaOne(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 8.h),
                                        _buildSilverGradientText('$liveViewers', 32.sp),
                                      ],
                                    ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 16.h),
                            
                            // Achievement badge inside the beat card
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16.w),
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
                                        'You outbid 2 others in this live auction.',
                                        style: GoogleFonts.getFont(
                                          'Wix Madefor Display',
                                          fontSize: 14.sp,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                      ),
                                      SizedBox(height: 12.h),
                                      _buildSilverGradientText('CERTIFIED STEAL', 32.sp),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 20.h),
                      
                      // Bottom buttons
                      Row(
                        children: [
                          // Co-Sign Producer
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CoSignProducerScreen(
                                      producerName: producerName,
                                      beatTitle: beatTitle,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                decoration: BoxDecoration(
                                  color: Colors.purple.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: _buildSilverGradientText('Co-Sign Producer', 16.sp),
                              ),
                            ),
                          ),
                          
                          SizedBox(width: 12.w),
                          
                          // Share Your Win
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.yellow, Colors.green],
                                ),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child:                                 Text(
                                  'Share Your Win',
                                  style: GoogleFonts.fjallaOne(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
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
}
