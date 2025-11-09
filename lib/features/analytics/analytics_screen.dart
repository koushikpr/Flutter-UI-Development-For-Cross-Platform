import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

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
  String _selectedActivityFilter = 'all';

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
          musicName: 'Trap City - ManuGTB',
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
                image: AssetImage('assets/waves.jpg'), // Using .jpg extension
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
        _buildHeatmapSectionTitle('Top Sales This Week'),
        SizedBox(height: 20.h),
        _buildHeatmapTopBeatCard(),
        SizedBox(height: 12.h),
        _buildHeatmapTopPackCard(),
        SizedBox(height: 12.h),
        _buildHeatmapPopularStoreItemCard(),
        SizedBox(height: 48.h),
        _buildHeatmapSectionTitle('Platform Insights This Week'),
        SizedBox(height: 20.h),
        _buildHeatmapBpmTrendsCard(),
        SizedBox(height: 12.h),
        _buildHeatmapTopSearchesCard(),
        SizedBox(height: 12.h),
        _buildHeatmapSalesTrendsCard(),
        SizedBox(height: 12.h),
        _buildHeatmapPeakHoursCard(),
        SizedBox(height: 32.h),
      ],
    );
  }

  Widget _buildHeatmapSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.wixMadeforDisplay(
        color: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        height: 1.25,
      ),
    );
  }

  Widget _buildHeatmapTopBeatCard() {
    return _buildHeatmapProductCard(
      title: 'Top Beat',
      name: 'Favella - ManuGTB',
      primaryStatLabel: 'Earned',
      primaryStatValue: '\$312',
      secondaryStatLabel: 'Sold',
      secondaryStatValue: '54',
    );
  }

  Widget _buildHeatmapTopPackCard() {
    return _buildHeatmapProductCard(
      title: 'Top Pack',
      name: 'Lo-Fi Chill Vol. 1',
      primaryStatLabel: 'Sold',
      primaryStatValue: '54',
      secondaryStatLabel: 'Earned',
      secondaryStatValue: '\$312',
    );
  }

  Widget _buildHeatmapPopularStoreItemCard() {
    return _buildHeatmapProductCard(
      title: 'Most Popular Store Item',
      name: 'Favella - ManuGTB',
      primaryStatLabel: 'Sold',
      primaryStatValue: '54',
      secondaryStatLabel: 'Earned',
      secondaryStatValue: '\$312',
    );
  }

  Widget _buildHeatmapProductCard({
    required String title,
    required String name,
    required String primaryStatLabel,
    required String primaryStatValue,
    required String secondaryStatLabel,
    required String secondaryStatValue,
  }) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
          width: 1,
        ),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              children: [
                Text(
                  title,
                  style: GoogleFonts.fjallaOne(
                    color: const Color(0xFFA3A3A3),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                _buildHeatmapMusicIcon(),
                SizedBox(height: 12.h),
                Text(
                  name,
                  style: GoogleFonts.fjallaOne(
                    color: const Color(0xFFE5E5E5),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _buildHeatmapStatBox(primaryStatLabel, primaryStatValue),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildHeatmapStatBox(secondaryStatLabel, secondaryStatValue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapMusicIcon() {
    return Container(
      width: 80.w,
      height: 80.w,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white.withOpacity(0.25),
      ),
      child: Icon(
        Icons.music_note,
        color: Colors.white,
        size: 16.sp,
      ),
    );
  }

  Widget _buildHeatmapStatBox(String label, String value) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white.withOpacity(0.07),
      ),
      child: Column(
        children: [
          if (label.isNotEmpty)
            Text(
              label,
              style: GoogleFonts.fjallaOne(
                color: const Color(0xFFA3A3A3),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.14,
              ),
              textAlign: TextAlign.center,
            ),
          SizedBox(height: label.isNotEmpty ? 12.h : 0),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment(0.3, 0.0),
              end: Alignment(1.05, 1.0),
              colors: [Color(0xFFFFFFFF), Color(0xFF999999)],
              stops: [0.30, 1.0],
            ).createShader(bounds),
            child: Text(
              value,
              style: GoogleFonts.fjallaOne(
                color: Colors.white,
                fontSize: 32.sp,
                fontWeight: FontWeight.w400,
                height: 1.25,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapBpmTrendsCard() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
          width: 1,
        ),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              children: [
                Text(
                  'BPM Trends',
                  style: GoogleFonts.fjallaOne(
                    color: const Color(0xFFA3A3A3),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Beats at 140–150 BPM sold 2.4x more this week',
                  style: GoogleFonts.wixMadeforDisplay(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.67,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _buildHeatmapStatBox('', '140–150'),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildHeatmapStatBox('', '2.4x'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapTopSearchesCard() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
          width: 1,
        ),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              children: [
                Text(
                  'Top Searches',
                  style: GoogleFonts.fjallaOne(
                    color: const Color(0xFFA3A3A3),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'The two most-searched vibes this week.',
                  style: GoogleFonts.wixMadeforDisplay(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.67,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(12.w, 16.h, 12.w, 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.white.withOpacity(0.07),
            ),
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment(0.3, 0.0),
                end: Alignment(1.05, 1.0),
                colors: [Color(0xFFFFFFFF), Color(0xFF999999)],
                stops: [0.30, 1.0],
              ).createShader(bounds),
              child: Text(
                'Drill + Trap',
                style: GoogleFonts.fjallaOne(
                  color: Colors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapSalesTrendsCard() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
          width: 1,
        ),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              children: [
                Text(
                  'Sales Trends',
                  style: GoogleFonts.fjallaOne(
                    color: const Color(0xFFA3A3A3),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Sales of trap beats were up 32% this week across the platform.',
                  style: GoogleFonts.wixMadeforDisplay(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.67,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _buildHeatmapStatBox('', 'Trap'),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildHeatmapStatBox('', '+32%'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapPeakHoursCard() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
          width: 1,
        ),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              children: [
                Text(
                  'Peak Hours',
                  style: GoogleFonts.fjallaOne(
                    color: const Color(0xFFA3A3A3),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Peak hours show times of highest demand or activity on average throughout the week.',
                  style: GoogleFonts.wixMadeforDisplay(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.67,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(12.w, 24.h, 12.w, 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.white.withOpacity(0.07),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildHeatmapBarChartItem('12am', 56.h),
                SizedBox(width: 4.w),
                _buildHeatmapBarChartItem('3am', 81.h),
                SizedBox(width: 4.w),
                _buildHeatmapBarChartItem('6am', 112.h),
                SizedBox(width: 4.w),
                _buildHeatmapBarChartItem('9am', 65.h),
                SizedBox(width: 4.w),
                _buildHeatmapBarChartItem('12pm', 45.h),
                SizedBox(width: 4.w),
                _buildHeatmapBarChartItem('3pm', 45.h),
                SizedBox(width: 4.w),
                _buildHeatmapBarChartItem('6pm', 14.h),
                SizedBox(width: 4.w),
                _buildHeatmapBarChartItem('9pm', 14.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatmapBarChartItem(String time, double height) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.r),
              color: const Color(0xFFA3A3A3),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            time,
            style: GoogleFonts.fjallaOne(
              color: const Color(0xFFD4D4D4),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 1.33,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFamFunnelContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFamFunnelSectionTitle('Last 7 Days Summary'),
        SizedBox(height: 18.h),
        Row(
          children: [
            Expanded(
              child: _buildFamFunnelSummaryCard(
                label: 'Unique Buyers',
                value: '32',
                description: '# of unique buyers backing your sound',
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildFamFunnelSummaryCard(
                label: 'Favorited By',
                value: '14',
                description: '# of fans who got you as a favorite',
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildFamFunnelTopBuyerCard(
                label: 'Top Buyer by Sales',
                username: '@LoFiLover',
                description: 'Spent \$280',
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildFamFunnelTopBuyerCard(
                label: 'Top Buyer by Orders',
                username: '@BrokeMan',
                description: 'Placed 6 orders',
              ),
            ),
          ],
        ),
        SizedBox(height: 48.h),
        _buildFamFunnelSectionTitle('Recent Activity'),
        SizedBox(height: 16.h),
        _buildFamFunnelActivityFilters(),
        SizedBox(height: 8.h),
        _buildFamFunnelActivityList(),
        SizedBox(height: 32.h),
      ],
    );
  }

  Widget _buildFamFunnelSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.fjallaOne(
        color: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        height: 1.25,
      ),
    );
  }

  Widget _buildFamFunnelSummaryCard({
    required String label,
    required String value,
    required String description,
  }) {
    return Container(
      constraints: BoxConstraints(minHeight: 168.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
          width: 1,
        ),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.fjallaOne(
              color: const Color(0xFFA3A3A3),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment(0.3, 0.0),
              end: Alignment(1.05, 1.0),
              colors: [Color(0xFFFFFFFF), Color(0xFF999999)],
              stops: [0.30, 1.0],
            ).createShader(bounds),
            child: Text(
              value,
              style: GoogleFonts.fjallaOne(
                color: Colors.white,
                fontSize: 32.sp,
                fontWeight: FontWeight.w400,
                height: 1.25,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            description,
            style: GoogleFonts.wixMadeforDisplay(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 1.33,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFamFunnelTopBuyerCard({
    required String label,
    required String username,
    required String description,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
          width: 1,
        ),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.fjallaOne(
              color: const Color(0xFFA3A3A3),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Column(
            children: [
              SizedBox(
                height: 76.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 32.w,
                      height: 32.w,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        color: Colors.white.withOpacity(0.25),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      username,
                      style: GoogleFonts.fjallaOne(
                        color: const Color(0xFFE5E5E5),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.67,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                description,
                style: GoogleFonts.wixMadeforDisplay(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.33,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFamFunnelActivityFilters() {
    final filters = [
      {'label': 'All', 'value': 'all'},
      {'label': 'Auction Wins', 'value': 'auction_wins'},
      {'label': 'Storefront', 'value': 'storefront'},
      {'label': 'Tips', 'value': 'tips'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < filters.length; i++) ...[
            if (i > 0) SizedBox(width: 8.w),
            _buildFamFunnelFilterButton(
              label: filters[i]['label'] as String,
              value: filters[i]['value'] as String,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFamFunnelFilterButton({required String label, required String value}) {
    final isSelected = _selectedActivityFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedActivityFilter = value;
        });
      },
      child: Container(
        height: 32.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: isSelected ? const Color(0xFFFAFAFA) : const Color(0xFF404040),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.fjallaOne(
              color: isSelected ? const Color(0xFF080808) : const Color(0xFFFAFAFA),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 1.33,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildFamFunnelActivityList() {
    final activities = [
      {
        'username': '@CloudAce',
        'time': '1h ago',
        'description': 'just dropped a \$20 tip',
        'buttonText': 'Send Thanks',
        'buttonStyle': 'primary',
        'type': 'tips',
      },
      {
        'username': '@NeonDreams',
        'time': '1d ago',
        'description': 'Auction win \$84',
        'buttonText': '✅ Thanked',
        'buttonStyle': 'secondary',
        'type': 'auction_wins',
      },
      {
        'username': '@BrokeMan',
        'time': '2d ago',
        'description': 'Tipped \$9',
        'buttonText': 'Send Thanks',
        'buttonStyle': 'primary',
        'type': 'tips',
      },
      {
        'username': '@TKOTape',
        'time': '2d ago',
        'description': 'Auction win \$79',
        'buttonText': 'Send Thanks',
        'buttonStyle': 'primary',
        'type': 'auction_wins',
      },
      {
        'username': '@ArtisanSoul',
        'time': '3d ago',
        'description': 'just scored a limited edition for \$150',
        'buttonText': 'Send Thanks',
        'buttonStyle': 'primary',
        'type': 'storefront',
      },
      {
        'username': '@VividPixels',
        'time': '3d ago',
        'description': 'dropped a generous \$25 tip',
        'buttonText': 'Send Thanks',
        'buttonStyle': 'primary',
        'type': 'tips',
      },
      {
        'username': '@RogueArtist',
        'time': '4d ago',
        'description': 'Auctioned off a piece for \$300',
        'buttonText': null,
        'buttonStyle': null,
        'type': 'auction_wins',
      },
      {
        'username': '@SonicWave',
        'time': '4d ago',
        'description': 'picked up a bundle for \$60',
        'buttonText': null,
        'buttonStyle': null,
        'type': 'storefront',
      },
      {
        'username': '@CreativeMind',
        'time': '5d ago',
        'description': 'left a glowing review with a \$15 tip',
        'buttonText': null,
        'buttonStyle': null,
        'type': 'tips',
      },
      {
        'username': '@PixelPioneer',
        'time': '5d ago',
        'description': 'just bought a unique digital painting for \$200',
        'buttonText': null,
        'buttonStyle': null,
        'type': 'storefront',
      },
      {
        'username': '@ArtLover99',
        'time': '6d ago',
        'description': 'dropped a \$30 tip on a new release',
        'buttonText': null,
        'buttonStyle': null,
        'type': 'tips',
      },
      {
        'username': '@DesignGuru',
        'time': '6d ago',
        'description': 'snagged a collaboration piece for \$120',
        'buttonText': null,
        'buttonStyle': null,
        'type': 'storefront',
      },
    ];

    final filteredActivities = (_selectedActivityFilter == 'all'
            ? activities
            : activities
                .where((activity) => activity['type'] == _selectedActivityFilter)
                .toList())
        .where((activity) =>
            activity['buttonText'] != null && activity['buttonStyle'] != null)
        .toList();

    return Column(
      children: [
        for (int i = 0; i < filteredActivities.length; i++) ...[
          if (i == 0) _buildFamFunnelDivider(),
          _buildFamFunnelActivityItem(
            username: filteredActivities[i]['username'] as String,
            time: filteredActivities[i]['time'] as String,
            description: filteredActivities[i]['description'] as String,
            buttonText: filteredActivities[i]['buttonText'] as String,
            buttonStyle: filteredActivities[i]['buttonStyle'] as String,
          ),
          if (i < filteredActivities.length - 1) _buildFamFunnelDivider(),
        ],
      ],
    );
  }

  Widget _buildFamFunnelDivider() {
    return Container(
      width: double.infinity,
      height: 1.h,
      color: Colors.white.withOpacity(0.10),
    );
  }

  Widget _buildFamFunnelActivityItem({
    required String username,
    required String time,
    required String description,
    required String buttonText,
    required String buttonStyle,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 20.w,
                      height: 20.w,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        color: Colors.white.withOpacity(0.25),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      username,
                      style: GoogleFonts.fjallaOne(
                        color: const Color(0xFFE5E5E5),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.67,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '·',
                      style: GoogleFonts.fjallaOne(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.67,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      time,
                      style: GoogleFonts.wixMadeforDisplay(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        height: 2.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: GoogleFonts.wixMadeforDisplay(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.67,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            height: 32.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: buttonStyle == 'primary'
                  ? Colors.white
                  : const Color(0xFF1F1F1F),
            ),
            child: Center(
              child: Text(
                buttonText,
                style: GoogleFonts.fjallaOne(
                  color: buttonStyle == 'primary' ? Colors.black : Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.33,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildHeader(),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildTitle(),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildTabBarContainer(),
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 100.h),
                child: _buildSelectedTabContent(),
              ),
            ),
            _buildHomeIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 20.sp,
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      'Analytics',
      style: GoogleFonts.getFont(
        'Wix Madefor Display',
        color: Colors.white,
        fontSize: 22.sp,
        fontWeight: FontWeight.w500,
        height: 1.27,
      ),
    );
  }

  Widget _buildTabBarContainer() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        onTap: (index) {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Heatmap'),
          Tab(text: 'Fam Funnel'),
          Tab(text: 'Performance'),
        ],
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: Colors.white, width: 1),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        labelPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        labelStyle: GoogleFonts.getFont(
          'Wix Madefor Display',
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.5),
        unselectedLabelStyle: GoogleFonts.getFont(
          'Wix Madefor Display',
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
        dividerColor: Colors.transparent,
      ),
    );
  }

  Widget _buildSelectedTabContent() {
    switch (_selectedTabIndex) {
      case 1:
        return _buildHeatmapContent();
      case 2:
        return _buildFamFunnelContent();
      case 3:
        return _buildPerformanceContent();
      default:
        return _buildOverviewContent();
    }
  }

  Widget _buildOverviewContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOverviewTotalEarnedCard(),
        SizedBox(height: 10.h),
        _buildOverviewPeerComparisonCard(),
        SizedBox(height: 10.h),
        _buildOverviewStatsRow1(),
        SizedBox(height: 10.h),
        _buildOverviewStatsRow2(),
        SizedBox(height: 10.h),
        _buildOverviewSalesSpreadCard(),
        SizedBox(height: 10.h),
        _buildOverviewCurrentLevelCard(),
      ],
    );
  }

  Widget _buildOverviewTotalEarnedCard() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
          width: 1,
        ),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            child: Column(
              children: [
                Text(
                  'Total Earned',
                  style: GoogleFonts.fjallaOne(
                    color: const Color(0xFFA3A3A3),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFFFFF), Color(0xFF999999)],
                  ).createShader(bounds),
                  child: Text(
                    '\$1,284',
                    style: GoogleFonts.fjallaOne(
                      color: Colors.white,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                flex: 504,
                child: Container(
                  height: 12.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      bottomLeft: Radius.circular(12.r),
                    ),
                    color: const Color(0xFFF3F3F3),
                  ),
                ),
              ),
              Container(
                width: 96.w,
                height: 12.h,
                color: const Color(0xFFA3A3A3),
              ),
              Container(
                width: 49.w,
                height: 12.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.r),
                    bottomRight: Radius.circular(12.r),
                  ),
                  color: const Color(0xFF737373),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildOverviewEarningCategory(
                  color: const Color(0xFFF3F3F3),
                  label: 'Auctions',
                  amount: '\$504',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildOverviewEarningCategory(
                  color: const Color(0xFFA3A3A3),
                  label: 'Storefront',
                  amount: '\$500',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildOverviewEarningCategory(
                  color: const Color(0xFF737373),
                  label: 'Tips',
                  amount: '\$280',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewEarningCategory({
    required Color color,
    required String label,
    required String amount,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white.withOpacity(0.07),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8.r,
                height: 8.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.r),
                  color: color,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: GoogleFonts.fjallaOne(
                  color: const Color(0xFFA3A3A3),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.33,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            amount,
            style: GoogleFonts.fjallaOne(
              color: const Color(0xFFFAFAFA),
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              height: 1.56,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewPeerComparisonCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
          width: 1,
        ),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Column(
        children: [
          Text(
            'Peer Comparison',
            style: GoogleFonts.fjallaOne(
              color: const Color(0xFFA3A3A3),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Text(
            'You\'re ranking in the top 15% of all BAGR producers: sales, streams, and tips. Keep pushing 💪',
            style: GoogleFonts.fjallaOne(
              color: const Color(0xFFD4D4D4),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 1.33,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewStatsRow1() {
    return Row(
      children: [
        Expanded(
          child: _buildOverviewStatCard(
            label: 'Auctions Hosted',
            value: '14',
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildOverviewStatCard(
            label: 'Grab Bag Streams',
            value: '38',
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewStatsRow2() {
    return Row(
      children: [
        Expanded(
          child: _buildOverviewStatCard(
            label: 'Avg. Order Value',
            value: '\$85.40',
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _buildOverviewStatCard(
            label: 'Avg. Order Count',
            value: '2.7',
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewStatCard({
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
          width: 1,
        ),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.fjallaOne(
              color: const Color(0xFFA3A3A3),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment(0.5, 0.0),
              end: Alignment(1.5, 1.0),
              colors: [Color(0xFFFFFFFF), Color(0xFF999999)],
            ).createShader(bounds),
            child: Text(
              value,
              style: GoogleFonts.fjallaOne(
                color: Colors.white,
                fontSize: 26.sp,
                fontWeight: FontWeight.w400,
                height: 1.23,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewSalesSpreadCard() {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
          width: 1,
        ),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              children: [
                Text(
                  'Sales Spread',
                  style: GoogleFonts.fjallaOne(
                    color: const Color(0xFFA3A3A3),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: 168.w,
                  height: 168.w,
                  child: CustomPaint(
                    painter: DonutChartPainter(
                      segments: [
                        ChartSegment(percentage: 0.40, color: const Color(0xFFD4D4D4)),
                        ChartSegment(percentage: 0.30, color: const Color(0xFF737373)),
                        ChartSegment(percentage: 0.30, color: const Color(0xFF404040)),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              begin: Alignment(-0.5, -1.0),
                              end: Alignment(1.0, 0.5),
                              colors: [Color(0xFFFFFFFF), Color(0xFF999999)],
                            ).createShader(bounds),
                            child: Text(
                              '325',
                              style: GoogleFonts.fjallaOne(
                                color: Colors.white,
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Text(
                            'total # of sales',
                            style: GoogleFonts.fjallaOne(
                              color: const Color(0xFFA3A3A3),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
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
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: _buildOverviewSalesCategory(
                  color: const Color(0xFFD4D4D4),
                  label: 'Auctions',
                  percentage: '40%',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildOverviewSalesCategory(
                  color: const Color(0xFF737373),
                  label: 'Beats/Loops',
                  percentage: '30%',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildOverviewSalesCategory(
                  color: const Color(0xFF404040),
                  label: 'Packs/Kits',
                  percentage: '30%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewSalesCategory({
    required Color color,
    required String label,
    required String percentage,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white.withOpacity(0.07),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8.r,
                height: 8.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.r),
                  color: color,
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.fjallaOne(
                    color: const Color(0xFFA3A3A3),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            percentage,
            style: GoogleFonts.fjallaOne(
              color: const Color(0xFFFAFAFA),
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              height: 1.56,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCurrentLevelCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.10),
          width: 1,
        ),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Column(
        children: [
          Text(
            'Current Level',
            style: GoogleFonts.fjallaOne(
              color: const Color(0xFFA3A3A3),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildOverviewLevelIcon(size: 44.w, isLocked: false, isActive: false),
              SizedBox(width: 48.w),
              _buildOverviewLevelIcon(size: 73.33.w, isLocked: false, isActive: true),
              SizedBox(width: 48.w),
              _buildOverviewLevelIcon(size: 44.w, isLocked: true, isActive: false),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 6.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              color: Colors.white.withOpacity(0.12),
            ),
            child: Text(
              '500 XP',
              style: GoogleFonts.fjallaOne(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                height: 1.33,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 8.h),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFFFF), Color(0xFF999999)],
            ).createShader(bounds),
            child: Text(
              'Hustler',
              style: GoogleFonts.fjallaOne(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.w400,
                height: 1.33,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Next Level: Mogul 🔓 (100 XP left)',
            style: GoogleFonts.fjallaOne(
              color: const Color(0xFFD4D4D4),
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              height: 1.33,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewLevelIcon({
    required double size,
    required bool isLocked,
    required bool isActive,
  }) {
    return SizedBox(
      width: size,
      height: size * 48 / 44,
      child: CustomPaint(
        painter: HexagonIconPainter(
          isLocked: isLocked,
          isActive: isActive,
        ),
      ),
    );
  }

  Widget _buildHomeIndicator() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 8.h),
      child: Center(
        child: Container(
          width: 139.w,
          height: 5.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.r),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class ChartSegment {
  final double percentage;
  final Color color;

  ChartSegment({required this.percentage, required this.color});
}

class DonutChartPainter extends CustomPainter {
  final List<ChartSegment> segments;

  DonutChartPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final innerRadius = radius * 0.62;

    final bgPaint = Paint()
      ..color = const Color(0xFF404040)
      ..style = PaintingStyle.fill;

    final bgStrokePaint = Paint()
      ..color = const Color(0xFF0D0D0D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius - 1, bgPaint);
    canvas.drawCircle(center, radius - 1, bgStrokePaint);

    double startAngle = -math.pi / 2;

    for (final segment in segments) {
      final sweepAngle = 2 * math.pi * segment.percentage;

      final segmentPaint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.fill;

      final segmentStrokePaint = Paint()
        ..color = const Color(0xFF0D0D0D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, segmentPaint);
      canvas.drawPath(path, segmentStrokePaint);

      startAngle += sweepAngle;
    }

    final innerCirclePaint = Paint()
      ..color = const Color(0xFF0D0D0D)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, innerRadius, innerCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HexagonIconPainter extends CustomPainter {
  final bool isLocked;
  final bool isActive;

  HexagonIconPainter({required this.isLocked, required this.isActive});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final path = Path();
    final centerX = width / 2;
    final centerY = height / 2;
    final hexRadius = width * 0.45;

    for (int i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i - math.pi / 6;
      final x = centerX + hexRadius * math.cos(angle);
      final y = centerY + hexRadius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    final fillPaint = Paint()
      ..color = const Color(0xFF262626)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    final strokePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.6),
          Colors.white.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    canvas.drawPath(path, strokePaint);

    if (isLocked) {
      final lockPaint = Paint()
        ..shader = LinearGradient(
          begin: const Alignment(-0.2, -1.0),
          end: const Alignment(1.5, 1.5),
          colors: [
            Colors.white.withOpacity(0.9),
            const Color(0xFFE5E5E5).withOpacity(0.4),
            const Color(0xFF999999),
          ],
          stops: const [0.0, 0.36, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, width, height))
        ..style = PaintingStyle.fill;

      final lockPath = Path();
      final lockCenterX = centerX;
      final lockCenterY = centerY + height * 0.05;
      final lockWidth = width * 0.4;
      final lockHeight = height * 0.45;

      lockPath.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(lockCenterX, lockCenterY),
            width: lockWidth,
            height: lockHeight * 0.7,
          ),
          const Radius.circular(2),
        ),
      );

      final arcRect = Rect.fromCenter(
        center: Offset(lockCenterX, lockCenterY - lockHeight * 0.25),
        width: lockWidth * 0.6,
        height: lockHeight * 0.5,
      );
      lockPath.addArc(arcRect, math.pi, math.pi);

      canvas.drawPath(lockPath, lockPaint);
    } else {
      final textPainter = TextPainter(
        text: TextSpan(
          text: 'XP',
          style: TextStyle(
            color: Colors.white.withOpacity(isActive ? 0.8 : 0.3),
            fontSize: width * 0.25,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          centerX - textPainter.width / 2,
          centerY - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
