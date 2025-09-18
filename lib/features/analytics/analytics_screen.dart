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
    _tabController = TabController(length: 3, vsync: this);
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

  Widget _buildPerformanceContent() {
    return Column(
      children: [
        // Time Period Filters
        _buildTimePeriodFilters(),
        
        SizedBox(height: 24.h),
        
        // Performance Cards
        _buildPerformanceCard(
          'Top Performer at Auction',
          'Favella - ManuGTB',
          '2:30 - Hip-hop - 143 BPM - C#minor',
          views: '125',
          offers: '15',
          soldFor: '\$80',
        ),
        
        SizedBox(height: 16.h),
        
        _buildPerformanceCard(
          'Best Selling Non-exclusive',
          'Favella - ManuGTB',
          '2:30 - Hip-hop - 143 BPM - C#minor',
          sales: '125',
          soldFor: '\$80',
        ),
        
        SizedBox(height: 16.h),
        
        _buildPerformanceCard(
          'Most Skipped',
          'Favella - ManuGTB',
          '2:30 - Hip-hop - 143 BPM - C#minor',
          views: '125',
          avgWatchTime: '1:25',
        ),
        
        SizedBox(height: 32.h),
      ],
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
        borderRadius: BorderRadius.circular(16.r),
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
              borderRadius: BorderRadius.circular(16.r),
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
                borderRadius: BorderRadius.circular(16.r),
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
          child: TabBar(
            controller: _tabController,
            onTap: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            tabs: [
              _buildTab('Heatmap', 0),
              _buildTab('Funnel', 1),
              _buildTab('Featured', 2),
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
                ? _buildFunnelContent()
                : _selectedTabIndex == 2 
                    ? _buildPerformanceContent()
                    : Column(
                        children: [
                          // Current Level Section
                          _buildCurrentLevelSection(),
                          
                          SizedBox(height: 24.h),
                          
                          // Total Earned Section
                          _buildTotalEarnedSection(),
                          
                          SizedBox(height: 24.h),
                          
                          // Stats Grid
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
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Text(
          title,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
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
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          
          SizedBox(height: 8.h),
          
          // Amount
          Text(
            '\$1,284',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
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
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '\$1004',
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Tips',
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '\$280',
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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
              color: (_isGain ? Colors.green : Colors.red).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
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
                    color: Colors.white.withOpacity(0.8),
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
                    color: Colors.white.withOpacity(0.8),
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
        children: [
          // Icon
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: Colors.white.withOpacity(0.8),
              size: 20.sp,
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // Value
          Text(
            value,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          
          SizedBox(height: 4.h),
          
          // Title
          Text(
            title,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 12.sp,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
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
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.7),
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
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          
          SizedBox(height: 8.h),
          
          // Level Name
          Text(
            'Hustler',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
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
    if (isCurrent) {
      // Hexagon shape for current level
      return Container(
        width: 60.w,
        height: 60.h,
        child: CustomPaint(
          painter: HexagonPainter(
            color: AppTheme.accentColor,
            borderColor: Colors.white,
          ),
          child: Center(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
        ),
      );
    } else {
      // Circle for other levels
      return Container(
        width: 50.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: isLocked 
              ? Colors.grey.shade800 
              : Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: isLocked
              ? Icon(
                  Icons.lock,
                  color: Colors.white.withOpacity(0.5),
                  size: 20.sp,
                )
              : Text(
                  text,
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
        ),
      );
    }
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

// Add cos and sin functions
double cos(double radians) => math.cos(radians);
double sin(double radians) => math.sin(radians);
