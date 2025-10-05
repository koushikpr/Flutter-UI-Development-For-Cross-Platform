import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui';
import '../../core/theme/app_theme.dart';
import 'cosign_producer_screen.dart';

class AuctionResultsScreen extends StatefulWidget {
  final String title;
  final String status;
  final String timeAgo;

  const AuctionResultsScreen({
    Key? key,
    required this.title,
    required this.status,
    required this.timeAgo,
  }) : super(key: key);

  @override
  State<AuctionResultsScreen> createState() => _AuctionResultsScreenState();
}

class _AuctionResultsScreenState extends State<AuctionResultsScreen> {
  void _shareAuctionResult() {
    final shareText = '''
🎵 Just won "${widget.title}" on BAGR! 

💰 Turned \$20 into \$120 in 90 seconds 🔥
🎤 Producer: @GreBeatz
⏱️ Total time: ${widget.timeAgo}
👥 Live viewers: 389

Who's next? #BAGRbeats #BeatAuction
''';
    
    Share.share(
      shareText,
      subject: 'Won auction on BAGR - ${widget.title}',
    );
  }

  void _coSignProducer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoSignProducerScreen(
          producerName: '@GreBeatz',
          beatTitle: widget.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.transparent,
              Colors.transparent,
              Colors.black.withOpacity(0.8), // Dark overlay at bottom
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background image with blur effect
            Positioned.fill(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Image.asset(
                    'assets/images/trap city.avif',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/live.jpg',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ),
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.8), // Dark overlay at bottom
                    ],
                    stops: [0.0, 0.3, 0.6, 1.0],
                  ),
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
              // Header with close button
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'Trap',
                        style: GoogleFonts.fjallaOne(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    CircleAvatar(
                      radius: 8.r,
                      backgroundColor: Colors.orange,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '@GreBeatz',
                      style: GoogleFonts.fjallaOne(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Trap City',
                  style: GoogleFonts.fjallaOne(
                    fontSize: 32.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 8.h),

              // Stats row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.volume_up, color: Colors.white.withOpacity(0.7), size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      '143 BPM',
                      style: GoogleFonts.fjallaOne(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Icon(Icons.copyright, color: Colors.white.withOpacity(0.7), size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      '1 of 1',
                      style: GoogleFonts.fjallaOne(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Icon(Icons.music_note, color: Colors.white.withOpacity(0.7), size: 16.sp),
                    SizedBox(width: 4.w),
                    Text(
                      'C minor',
                      style: GoogleFonts.fjallaOne(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Auction stats
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    // Top row: Single box with 4 stats
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(child: _buildStatItem('Started at', '\$20')),
                              Expanded(child: _buildStatItem('Total Earned', '\$120')),
                              Expanded(child: _buildStatItem('Tips', '\$40')),
                              Expanded(child: _buildStatItem('Flipped', '5x')),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Bottom row: 2 separate boxes
                    Row(
                      children: [
                        // Total Sell Time box
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: _buildStatItem('Total Sell Time', widget.timeAgo),
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(width: 12.w),
                        
                        // Live Viewers box
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: _buildStatItem('Live Viewers', '389'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Winner section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Winner',
                            style: GoogleFonts.fjallaOne(
                              fontSize: 16.sp,
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20.r,
                                backgroundColor: Colors.grey[600],
                                child: Icon(Icons.person, color: Colors.white, size: 20.sp),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '@Tyga1',
                                      style: GoogleFonts.fjallaOne(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      'bought this beat for \$120',
                                      style: GoogleFonts.fjallaOne(
                                        fontSize: 12.sp,
                                        color: Colors.white.withOpacity(0.7),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.asset(
                                'assets/images/trophy.png',
                                width: 80.w,
                                height: 80.h,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Flex Your Win section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Flex Your Win',
                            style: GoogleFonts.fjallaOne(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          _buildFlexOption('1', 'Post it now', Colors.purple),
                          SizedBox(height: 12.h),
                          _buildFlexOption('2', 'Tag 3 producers', Colors.purple),
                          SizedBox(height: 12.h),
                          _buildFlexOption('3', 'Dare \'em to beat your bag stats', Colors.purple),
                          SizedBox(height: 16.h),
                          Text(
                            'Just turned \$20 into \$120 in 90 seconds 🔥 Who\'s next? 🔥 #BAGRbeats',
                            style: GoogleFonts.fjallaOne(
                              fontSize: 12.sp,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // Action buttons
              Padding(
                padding: EdgeInsets.all(16.w),
                child: SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: _shareAuctionResult,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.yellow, Colors.green],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.share, color: Colors.black, size: 20.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'Share',
                            style: GoogleFonts.fjallaOne(
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.fjallaOne(
            fontSize: 10.sp,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        ShaderMask(
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
            value,
            style: GoogleFonts.fjallaOne(
              fontSize: 32.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildFlexOption(String number, String text, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            number,
            style: GoogleFonts.fjallaOne(
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.fjallaOne(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
