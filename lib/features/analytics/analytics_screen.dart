import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../core/theme/app_theme.dart';

class AnalyticsScreen extends StatefulWidget {
  final String userRole;

  const AnalyticsScreen({
    super.key,
    this.userRole = 'producer',
  });

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  
  // Variables for earnings comparison
  double _earningsMultiplier = 2.2; // Can be set dynamically
  bool _isGain = true; // true for gain (green), false for loss (red)

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Method to update earnings comparison (can be called from API or other sources)
  void updateEarningsComparison(double multiplier, bool isGain) {
    setState(() {
      _earningsMultiplier = multiplier;
      _isGain = isGain;
    });
  }

  // Helper method to create silver gradient text style for Fjalla One
  TextStyle _getSilverGradientTextStyle(double fontSize, {FontWeight? fontWeight}) {
    return GoogleFonts.fjallaOne(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w400,
      foreground: Paint()
        ..shader = LinearGradient(
          colors: [
            Color(0xFFC0C0C0), // Light Silver
            Color(0xFFE5E5E5), // Bright Silver
            Color(0xFF808080), // Medium Silver
            Color(0xFFC0C0C0), // Light Silver
          ],
          stops: [0.0, 0.33, 0.66, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
    );
  }

  Widget _buildPerformanceContent() {
    return Column(
      children: [
        // Top Performer at Auction
        _buildTopSellingBeatStyleCard(
          title: 'Top Performer at Auction',
          musicName: 'Favella - ManuGTB',
          subtitle: '2:36 • Hip-hop • 143 BPM • C minor',
          price: '\$280',
        ),
        
        SizedBox(height: 16.h),
        
        // Best Selling Non-exclusive
        _buildTopSellingBeatStyleCard(
          title: 'Best Selling Non-exclusive',
          musicName: 'Urban Nights - SoundCraft',
          subtitle: '3:12 • R&B • 128 BPM • F major',
          price: '\$150',
        ),
        
        SizedBox(height: 16.h),
        
        // Most Viewed
        _buildTopSellingBeatStyleCard(
          title: 'Most Viewed',
          musicName: 'Electric Dreams - NeonBeats',
          subtitle: '2:45 • Electronic • 140 BPM • A minor',
          price: '\$200',
        ),
        
        SizedBox(height: 32.h),
      ],
    );
  }

  Widget _buildTopSellingBeatStyleCard({
    required String title,
    required String musicName,
    required String subtitle,
    required String price,
  }) {
    
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header - Centered
          Text(
            title,
            style: GoogleFonts.fjallaOne(
              fontSize: 14.sp,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Waves image box - Centered (Square)
          Container(
            width: 100.w,
            height: 100.h, // Square dimensions
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.grey.shade800, // Fallback color
              image: DecorationImage(
                image: AssetImage('waves.jpg'), // Using .jpg extension
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  print('Image loading error: $exception');
                },
              ),
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Music Name - Centered
          Text(
            musicName,
            style: GoogleFonts.fjallaOne(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 4.h),
          
          // Subtitle - Centered
          Text(
            subtitle,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 12.sp,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 16.h),
          
          // Price - Centered
          Text(
            price,
            style: _getSilverGradientTextStyle(32.sp),
          ),
          
          SizedBox(height: 24.h),
          
          // Stats box like the image
          _buildPerformanceStatsBox(),
        ],
      ),
    );
  }

  Widget _buildPerformanceStatsBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Views
          Expanded(
            child: Column(
              children: [
                Text(
                  'Views',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '125',
                  style: _getSilverGradientTextStyle(32.sp),
                ),
              ],
            ),
          ),
          
          // Offers
          Expanded(
            child: Column(
              children: [
                Text(
                  'Offers',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '15',
                  style: _getSilverGradientTextStyle(32.sp),
                ),
              ],
            ),
          ),
          
          // Sold for
          Expanded(
            child: Column(
              children: [
                Text(
                  'Sold for',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '\$80',
                  style: _getSilverGradientTextStyle(32.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePeriodFilters() {
    return Row(
      children: [
        _buildFilterChip('Week', false),
        SizedBox(width: 8.w),
        _buildFilterChip('Month', true), // Selected
        SizedBox(width: 8.w),
        _buildFilterChip('Year', false),
        SizedBox(width: 8.w),
        _buildFilterChip('All', false),
        
        const Spacer(),
        
        // Profile avatars
        Row(
          children: [
            _buildProfileAvatar(),
            SizedBox(width: 4.w),
            _buildProfileAvatar(),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.getFont(
          'Wix Madefor Display',
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Container(
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade700,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Icon(
        Icons.person,
        color: Colors.white.withOpacity(0.7),
        size: 16.sp,
      ),
    );
  }

  Widget _buildPerformanceCard(
    String title,
    String trackName,
    String trackDetails, {
    String? views,
    String? offers,
    String? sales,
    String? soldFor,
    String? avgWatchTime,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Profile
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.white.withOpacity(0.7),
                  size: 16.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Beat Cover and Play Button
          Row(
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trackName,
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      trackDetails,
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
          
          SizedBox(height: 20.h),
          
          // Stats Row
          Row(
            children: [
              if (views != null) ...[
                _buildStatColumn('Views', views),
                const Spacer(),
              ],
              if (offers != null) ...[
                _buildStatColumn('Offers', offers),
                const Spacer(),
              ],
              if (sales != null) ...[
                _buildStatColumn('# of Sales', sales),
                const Spacer(),
              ],
              if (soldFor != null) ...[
                _buildStatColumn(
                  sales != null ? 'Last sold for' : 'Sold for', 
                  soldFor,
                ),
              ],
              if (avgWatchTime != null) ...[
                _buildStatColumn('Avg. watch time', avgWatchTime),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 11.sp,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildHeatmapContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Selling Beat Card
        _buildTopSellingBeatCard(),
        
        SizedBox(height: 16.h),
        
        // Most Tipped Stream Card
        _buildMostTippedStreamCard(),
        
        SizedBox(height: 16.h),
        
        // Best Time to Sell Card
        _buildBestTimeToSellCard(),
        
        SizedBox(height: 32.h),
      ],
    );
  }

  Widget _buildTopSellingBeatCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header - Centered
          Text(
            'Top Selling Beat',
            style: GoogleFonts.fjallaOne(
              fontSize: 14.sp,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Waves image box - Centered (Square)
          Container(
            width: 100.w,
            height: 100.h, // Square dimensions
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.grey.shade800, // Fallback color
              image: DecorationImage(
                image: AssetImage('waves.jpg'), // Using .jpg extension
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  print('Image loading error: $exception');
                },
              ),
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Music Name - Centered
          Text(
            'Favella - ManuGTB',
            style: GoogleFonts.fjallaOne(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 4.h),
          
          // Subtitle - Centered
          Text(
            '2:36 • Hip-hop • 143 BPM • C minor',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 12.sp,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 16.h),
          
          // Price - Centered
          Text(
            '\$280',
            style: _getSilverGradientTextStyle(32.sp),
          ),
          
          SizedBox(height: 24.h),
          
          // Beat list with progress bars
          Column(
            children: [
              _buildBeatProgressItem('Favella - ManuGTB', 280, 280),
              SizedBox(height: 12.h),
              _buildBeatProgressItem('Rhythm City - BeatMaster', 180, 280),
              SizedBox(height: 12.h),
              _buildBeatProgressItem('Rhythm City - BeatMaster', 80, 280),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBeatProgressItem(String name, int price, int maxPrice) {
    double progress = price / maxPrice;
    
    return Row(
      children: [
        // Small album art
        Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Icon(
            Icons.music_note,
            color: Colors.white.withOpacity(0.7),
            size: 16.sp,
          ),
        ),
        
        SizedBox(width: 12.w),
        
        // Name and progress bar
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 4.h),
              // Progress bar
              Container(
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2.r),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(width: 12.w),
        
        // Price
        Text(
          '\$$price',
          style: GoogleFonts.fjallaOne(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildBeatListItem(String name, String price) {
    return Row(
      children: [
        // Small album art
        Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Icon(
            Icons.music_note,
            color: Colors.white.withOpacity(0.7),
            size: 16.sp,
          ),
        ),
        
        SizedBox(width: 12.w),
        
        // Name
        Expanded(
          child: Text(
            name,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
        
        // Price
        Text(
          price,
          style: GoogleFonts.fjallaOne(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildMostTippedStreamCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Left side - info (centered)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Most Tipped Stream',
                  style: GoogleFonts.fjallaOne(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 16.h),
                
                Text(
                  '\$120',
                  style: _getSilverGradientTextStyle(28.sp),
                ),
                
                SizedBox(height: 8.h),
                
                Text(
                  'Midnight Echo',
                  style: GoogleFonts.fjallaOne(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                Text(
                  'Jan 24, 2025',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          SizedBox(width: 16.w),
          
          // Right side - waves pattern (covers right side completely)
          Expanded(
            child: Container(
              height: 120.h, // Match card height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
                color: Colors.grey.shade800, // Fallback color
                image: DecorationImage(
                  image: AssetImage('waves.jpg'), // Try with .jpg extension
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    print('Image loading error: $exception');
                  },
                ),
              ),
              child: Stack(
                children: [
                  // View count badge
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.visibility,
                            color: Colors.white,
                            size: 12.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '248',
                            style: GoogleFonts.getFont(
                              'Wix Madefor Display',
                              fontSize: 10.sp,
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
          ),
        ],
      ),
    );
  }

  Widget _buildBestTimeToSellCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Best Time to Sell',
            style: GoogleFonts.fjallaOne(
              fontSize: 14.sp,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 16.h),
          
          Text(
            'Wednesdays',
            style: _getSilverGradientTextStyle(24.sp),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 8.h),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.access_time,
                color: Colors.white.withOpacity(0.7),
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                '8 PM',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Bar chart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBarChartItem('Mon', 0.3),
              _buildBarChartItem('Tue', 0.5),
              _buildBarChartItem('Wed', 1.0),
              _buildBarChartItem('Thu', 0.4),
              _buildBarChartItem('Fri', 0.6),
              _buildBarChartItem('Sat', 0.2),
              _buildBarChartItem('Sun', 0.3),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarChartItem(String day, double height) {
    return Column(
      children: [
        Container(
          width: 24.w,
          height: (height * 60).h,
          decoration: BoxDecoration(
            color: height == 1.0 ? Colors.white : Colors.grey.shade600,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          day,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 10.sp,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildFunnelContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time Period Header
        Text(
          'Last 7 days',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // Filter Tags
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _buildFilterTag('All', true),
            _buildFilterTag('Auction', false),
            _buildFilterTag('Non-exclusive', false),
            _buildFilterTag('Exclusive', false),
          ],
        ),
        
        SizedBox(height: 24.h),
        
        // User Interactions List
        _buildUserInteraction(
          username: '@CloudAce',
          timeAgo: '1h ago',
          action: 'Just dropped a \$20 tip',
          hasThankButton: true,
          isThanked: false,
        ),
        
        SizedBox(height: 16.h),
        
        _buildUserInteraction(
          username: '@NeonDreams',
          timeAgo: '14 ago',
          action: 'Auction won \$84',
          hasThankButton: false,
          isThanked: true,
        ),
        
        SizedBox(height: 16.h),
        
        _buildUserInteraction(
          username: '@BrokeMan',
          timeAgo: '2d ago',
          action: 'Tipped \$9',
          hasThankButton: true,
          isThanked: false,
        ),
        
        SizedBox(height: 16.h),
        
        _buildUserInteraction(
          username: '@TKOTape',
          timeAgo: '2d ago',
          action: 'Auction won \$79',
          hasThankButton: true,
          isThanked: false,
        ),
        
        SizedBox(height: 16.h),
        
        _buildUserInteraction(
          username: '@TKOTape',
          timeAgo: '2d ago',
          action: 'Auction won \$79',
          hasThankButton: true,
          isThanked: false,
        ),
        
        SizedBox(height: 16.h),
        
        _buildUserInteraction(
          username: '@ArtisanSoul',
          timeAgo: '3d ago',
          action: 'Just scored a limited edition for \$150',
          hasThankButton: true,
          isThanked: false,
        ),
        
        SizedBox(height: 16.h),
        
        _buildUserInteraction(
          username: '@VividPixels',
          timeAgo: '3d ago',
          action: 'dropped a generous \$25 tip',
          hasThankButton: true,
          isThanked: false,
        ),
        
        SizedBox(height: 16.h),
        
        _buildUserInteraction(
          username: '@VividPixels',
          timeAgo: '3d ago',
          action: 'dropped a generous \$25 tip',
          hasThankButton: true,
          isThanked: false,
        ),
        
        SizedBox(height: 32.h),
      ],
    );
  }


  Widget _buildFilterTag(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.getFont(
          'Wix Madefor Display',
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.black : Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildUserInteraction({
    required String username,
    required String timeAgo,
    required String action,
    required bool hasThankButton,
    required bool isThanked,
  }) {
    return Row(
      children: [
        // User Avatar
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            color: Colors.white.withOpacity(0.7),
            size: 20.sp,
          ),
        ),
        
        SizedBox(width: 12.w),
        
        // User Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    username,
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    timeAgo,
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                action,
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 13.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(width: 12.w),
        
        // Action Button
        if (isThanked)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: Colors.green.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 14.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Thanked',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          )
        else if (hasThankButton)
          GestureDetector(
            onTap: () {
              _showThankMessage(username);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'Send Thanks',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _showThankMessage(String username) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Thank you message sent to $username!',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20.h),
        
        // Tab Bar
        Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          child:           TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            onTap: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            tabs: [
              _buildTab('Stats', 0),
              _buildTab('Heatmap', 1),
              _buildTab('Fam Funnel', 2),
              _buildTab('Beat Performance', 3),
            ],
            indicatorColor: AppTheme.accentColor,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.6),
            indicatorWeight: 2,
            dividerColor: Colors.transparent,
          ),
        ),
        
        SizedBox(height: 24.h),
        
        // Main Content
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: _selectedTabIndex == 1 
                ? _buildHeatmapContent()
                : _selectedTabIndex == 2 
                    ? _buildFunnelContent()
                    : _selectedTabIndex == 3
                        ? _buildPerformanceContent()
                        : Column(
                        children: [
                          // Total Earned Section (full width at top)
                          _buildTotalEarnedSection(),
                          
                          SizedBox(height: 24.h),
                          
                          // Stats Grid (Auction hosted + Grab Bag Streams side by side)
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Auctions Hosted',
                                  '4',
                                  Icons.gavel,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: _buildStatCard(
                                  'Grab Bag Streams',
                                  '8',
                                  Icons.shopping_bag,
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 24.h),
                          
                          // Current Level Section (full width at bottom)
                          _buildCurrentLevelSection(),
                          
                          SizedBox(height: 32.h),
                        ],
                      ),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return Tab(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Text(
          title,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalEarnedSection() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Total Earned Header
          Text(
            'Total Earned',
            style: GoogleFonts.fjallaOne(
              fontSize: 14.sp,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          
          SizedBox(height: 8.h),
          
          // Amount
          Text(
            '\$1,284',
            style: _getSilverGradientTextStyle(32.sp),
          ),
          
          SizedBox(height: 24.h),
          
          // Progress Bar
          _buildProgressBar(),
          
          SizedBox(height: 16.h),
          
          // Beats and Tips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Beats',
                    style: GoogleFonts.fjallaOne(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '\$1004',
                    style: _getSilverGradientTextStyle(16.sp),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Tips',
                    style: GoogleFonts.fjallaOne(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '\$280',
                    style: _getSilverGradientTextStyle(16.sp),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Earnings Comparison Message
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isGain ? Icons.trending_up : Icons.trending_down,
                  color: _isGain ? Colors.green : Colors.red,
                  size: 16.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  'You earned',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  '${_earningsMultiplier}x',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: _isGain ? Colors.green : Colors.red,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  'more this month',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      height: 8.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        children: [
          // Beats progress (78%)
          Expanded(
            flex: 78,
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.r),
                  bottomLeft: Radius.circular(4.r),
                ),
              ),
            ),
          ),
          
          // Tips progress (22%)
          Expanded(
            flex: 22,
            child: Container(
              height: 8.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4.r),
                  bottomRight: Radius.circular(4.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Title (moved up)
          Text(
            title,
            style: GoogleFonts.fjallaOne(
              fontSize: 12.sp,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 12.h),
          
          // Value (moved down)
          Text(
            value,
            style: _getSilverGradientTextStyle(24.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentLevelSection() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Current Level Header
          Text(
            'Current Level',
            style: GoogleFonts.fjallaOne(
              fontSize: 14.sp,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
          
          SizedBox(height: 20.h),
          
          // Level Icons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLevelIcon('XP', false, false),
              _buildLevelIcon('', true, true), // Current level - hexagon
              _buildLevelIcon('', false, true), // Locked level
            ],
          ),
          
          SizedBox(height: 20.h),
          
          // XP Amount
          Text(
            '500 XP',
            style: _getSilverGradientTextStyle(16.sp),
          ),
          
          SizedBox(height: 8.h),
          
          // Level Name
          Text(
            'Hustler',
            style: _getSilverGradientTextStyle(24.sp),
          ),
          
          SizedBox(height: 12.h),
          
          // Next Level Info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Next Level: Mogul',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                Icons.lock,
                color: Colors.white.withOpacity(0.7),
                size: 12.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                '(100 XP left)',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelIcon(String text, bool isCurrent, bool isLocked) {
    // All icons are now hexagons with silver gradient
    return Container(
      width: 60.w,
      height: 60.h,
      child: CustomPaint(
        painter: SilverGradientHexagonPainter(),
        child: Center(
          child: isCurrent
              ? Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 24.sp,
                )
              : isLocked
                  ? Icon(
                      Icons.lock,
                      color: Colors.white.withOpacity(0.8),
                      size: 20.sp,
                    )
                  : Text(
                      text,
                      style: GoogleFonts.fjallaOne(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
        ),
      ),
    );
  }
}

class HexagonPainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  HexagonPainter({required this.color, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Create proper hexagon path
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 90) * (3.14159 / 180); // Start from top
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SilverGradientHexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    // Create hexagon path
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 90) * (3.14159 / 180); // Start from top
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // Apply silver gradient
    final rect = Rect.fromCenter(center: center, width: size.width, height: size.height);
    paint.shader = LinearGradient(
      colors: [
        Color(0xFFC0C0C0), // Light Silver
        Color(0xFFE5E5E5), // Bright Silver
        Color(0xFF808080), // Medium Silver
        Color(0xFFC0C0C0), // Light Silver
      ],
      stops: [0.0, 0.33, 0.66, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(rect);

    canvas.drawPath(path, paint);

    // Add subtle border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.white.withOpacity(0.3);

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Add cos and sin functions
double cos(double radians) => math.cos(radians);
double sin(double radians) => math.sin(radians);
