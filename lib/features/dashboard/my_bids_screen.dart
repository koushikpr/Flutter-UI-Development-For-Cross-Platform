import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import 'models/bid_models.dart';

class MyBidsScreen extends StatefulWidget {
  const MyBidsScreen({super.key});

  @override
  State<MyBidsScreen> createState() => _MyBidsScreenState();
}

class _MyBidsScreenState extends State<MyBidsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  final List<BidItem> _allBids = MockBidData.getSampleBids();
  int _currentPageIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _pageController = PageController();
    
    // Sync tab controller with page controller
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _pageController.animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<BidItem> _getBidsForStatus(BidStatus status) {
    return _allBids.where((bid) => bid.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with Stats
        _buildHeader(),
        
        // Filter Tabs
        _buildFilterTabs(),
        
        // Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildBidsList(_allBids), // All
              _buildBidsList(_getBidsForStatus(BidStatus.active)), // Active
              _buildBidsList(_getBidsForStatus(BidStatus.won)), // Won
              _buildBidsList(_getBidsForStatus(BidStatus.outbid)), // Outbid
              _buildBidsList([
                ..._getBidsForStatus(BidStatus.lost),
                ..._getBidsForStatus(BidStatus.expired),
              ]), // Lost/Expired
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final totalBids = _allBids.length;
    final activeBids = _getBidsForStatus(BidStatus.active).length;
    final wonBids = _getBidsForStatus(BidStatus.won).length;
    final totalSpent = _allBids
        .where((bid) => bid.status == BidStatus.won)
        .fold(0.0, (sum, bid) => sum + (bid.finalPrice ?? 0));

    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          const Color(0xFFC0C0C0), // Light silver
                          const Color(0xFF808080), // Medium silver
                          const Color(0xFFA8A8A8), // Bright silver
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Text(
                        'My Bids',
                        style: GoogleFonts.fjallaOne(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'Track your beat investments',
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Notification bell
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppTheme.glassColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppTheme.glassBorder,
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                    if (activeBids > 0)
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF5252),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 24.h),
          
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Bids',
                  totalBids.toString(),
                  Icons.gavel_rounded,
                  AppTheme.accentColor,
                ),
              ),
              
              SizedBox(width: 12.w),
              
              Expanded(
                child: _buildStatCard(
                  'Active',
                  activeBids.toString(),
                  Icons.trending_up_rounded,
                  const Color(0xFF4CAF50),
                ),
              ),
              
              SizedBox(width: 12.w),
              
              Expanded(
                child: _buildStatCard(
                  'Won',
                  wonBids.toString(),
                  Icons.emoji_events_rounded,
                  const Color(0xFFFFD700),
                ),
              ),
              
              SizedBox(width: 12.w),
              
              Expanded(
                child: _buildStatCard(
                  'Spent',
                  '\$${totalSpent.toStringAsFixed(0)}',
                  Icons.attach_money_rounded,
                  AppTheme.warningColor,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 600.ms)
      .slideY(begin: -0.2, end: 0);
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.glassColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.glassBorder,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16.sp,
            ),
          ),
          
          SizedBox(height: 8.h),
          
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                const Color(0xFFC0C0C0), // Light silver
                const Color(0xFF808080), // Medium silver
                const Color(0xFFA8A8A8), // Bright silver
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              value,
              style: GoogleFonts.fjallaOne(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          
          Text(
            title,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 10.sp,
              color: Colors.white.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppTheme.glassColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.glassBorder,
          width: 1,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.accentColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(4.w),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.6),
        labelStyle: GoogleFonts.getFont(
          'Wix Madefor Display',
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.getFont(
          'Wix Madefor Display',
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Active'),
          Tab(text: 'Won'),
          Tab(text: 'Outbid'),
          Tab(text: 'Lost'),
        ],
      ),
    ).animate()
      .fadeIn(duration: 600.ms, delay: 200.ms)
      .slideY(begin: 0.2, end: 0);
  }

  Widget _buildBidsList(List<BidItem> bids) {
    if (bids.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemCount: bids.length,
      itemBuilder: (context, index) {
        return _buildBidCard(bids[index], index);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: AppTheme.glassColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppTheme.glassBorder,
                width: 1,
              ),
            ),
            child: Icon(
              Icons.gavel_rounded,
              color: Colors.white.withOpacity(0.5),
              size: 40.sp,
            ),
          ),
          
          SizedBox(height: 24.h),
          
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                const Color(0xFFC0C0C0), // Light silver
                const Color(0xFF808080), // Medium silver
                const Color(0xFFA8A8A8), // Bright silver
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              'No bids found',
              style: GoogleFonts.fjallaOne(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
          
          SizedBox(height: 8.h),
          
          Text(
            'Start bidding on beats to see them here',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBidCard(BidItem bid, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppTheme.glassColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: bid.status == BidStatus.won 
              ? const Color(0xFFFFD700).withOpacity(0.3)
              : AppTheme.glassBorder,
          width: bid.status == BidStatus.won ? 2 : 1,
        ),
        boxShadow: bid.status == BidStatus.won ? [
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: () => _showBidDetails(bid),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Beat Cover
                    Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            bid.statusColor.withOpacity(0.3),
                            bid.statusColor.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: bid.statusColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.music_note_rounded,
                        color: bid.statusColor,
                        size: 28.sp,
                      ),
                    ),
                    
                    SizedBox(width: 16.w),
                    
                    // Beat Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      const Color(0xFFC0C0C0), // Light silver
                                      const Color(0xFF808080), // Medium silver
                                      const Color(0xFFA8A8A8), // Bright silver
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(bounds),
                                  child: Text(
                                    bid.beatTitle,
                                    style: GoogleFonts.fjallaOne(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              
                              // Status Badge
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: bid.statusColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  bid.statusText,
                                  style: GoogleFonts.getFont(
                                    'Wix Madefor Display',
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    color: bid.statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 4.h),
                          
                          Text(
                            'by ${bid.producerName}',
                            style: GoogleFonts.getFont(
                              'Wix Madefor Display',
                              fontSize: 12.sp,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          
                          SizedBox(height: 4.h),
                          
                          Row(
                            children: [
                              _buildBeatTag(bid.genreText),
                              SizedBox(width: 8.w),
                              _buildBeatTag('${bid.bpm} BPM'),
                              SizedBox(width: 8.w),
                              _buildBeatTag(bid.key),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 16.h),
                
                // Bid Information
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildBidStat(
                              'My Bid',
                              '\$${bid.myBidAmount.toStringAsFixed(0)}',
                              bid.isWinning ? const Color(0xFF4CAF50) : Colors.white,
                            ),
                          ),
                          Expanded(
                            child: _buildBidStat(
                              'Current High',
                              '\$${bid.currentHighestBid.toStringAsFixed(0)}',
                              Colors.white,
                            ),
                          ),
                          Expanded(
                            child: _buildBidStat(
                              'Total Bids',
                              bid.totalBids.toString(),
                              Colors.white,
                            ),
                          ),
                        ],
                      ),
                      
                      if (bid.auctionEndDate != null) ...[
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              color: Colors.white.withOpacity(0.6),
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              _getTimeRemaining(bid.auctionEndDate!),
                              style: GoogleFonts.getFont(
                                'Wix Madefor Display',
                                fontSize: 12.sp,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                // Action Buttons
                _buildActionButtons(bid),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: 100 * index))
      .fadeIn(duration: 600.ms)
      .slideX(begin: 0.2, end: 0);
  }

  Widget _buildBeatTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.getFont(
          'Wix Madefor Display',
          fontSize: 9.sp,
          color: AppTheme.accentColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBidStat(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 10.sp,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BidItem bid) {
    List<Widget> buttons = [];

    if (bid.canReBid) {
      buttons.add(
        Expanded(
          child: _buildActionButton(
            'Re-bid',
            Icons.gavel_rounded,
            AppTheme.accentColor,
            () => _showReBidDialog(bid),
          ),
        ),
      );
    }

    if (bid.canSell) {
      if (buttons.isNotEmpty) buttons.add(SizedBox(width: 12.w));
      buttons.add(
        Expanded(
          child: _buildActionButton(
            'Sell',
            Icons.sell_rounded,
            const Color(0xFFFFD700),
            () => _showSellDialog(bid),
          ),
        ),
      );
    }

    if (bid.status == BidStatus.won) {
      if (buttons.isNotEmpty) buttons.add(SizedBox(width: 12.w));
      buttons.add(
        Expanded(
          child: _buildActionButton(
            'Download',
            Icons.download_rounded,
            const Color(0xFF4CAF50),
            () => _downloadBeat(bid),
          ),
        ),
      );
    }

    if (buttons.isEmpty) {
      buttons.add(
        Expanded(
          child: _buildActionButton(
            'View Details',
            Icons.info_outline_rounded,
            Colors.white.withOpacity(0.7),
            () => _showBidDetails(bid),
          ),
        ),
      );
    }

    return Row(children: buttons);
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onTap) {
    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.r),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                text,
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeRemaining(DateTime endDate) {
    final now = DateTime.now();
    final difference = endDate.difference(now);

    if (difference.isNegative) {
      return 'Auction ended';
    }

    if (difference.inDays > 0) {
      return '${difference.inDays}d ${difference.inHours % 24}h remaining';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m remaining';
    } else {
      return '${difference.inMinutes}m remaining';
    }
  }

  // Action Methods
  void _showBidDetails(BidItem bid) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildBidDetailsSheet(bid),
    );
  }

  void _showReBidDialog(BidItem bid) {
    showDialog(
      context: context,
      builder: (context) => _buildReBidDialog(bid),
    );
  }

  void _showSellDialog(BidItem bid) {
    showDialog(
      context: context,
      builder: (context) => _buildSellDialog(bid),
    );
  }

  void _downloadBeat(BidItem bid) {
    _showMessage('Downloading ${bid.beatTitle}...');
  }

  Widget _buildBidDetailsSheet(BidItem bid) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h, bottom: 20.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Beat Title and Producer
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        const Color(0xFFC0C0C0), // Light silver
                        const Color(0xFF808080), // Medium silver
                        const Color(0xFFA8A8A8), // Bright silver
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      bid.beatTitle,
                      style: GoogleFonts.fjallaOne(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  Text(
                    'by ${bid.producerName}',
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 16.sp,
                      color: AppTheme.accentColor,
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Beat Details
                  _buildDetailRow('Genre', bid.genreText),
                  _buildDetailRow('BPM', bid.bpm.toString()),
                  _buildDetailRow('Key', bid.key),
                  _buildDetailRow('Duration', '${bid.duration.inMinutes}:${(bid.duration.inSeconds % 60).toString().padLeft(2, '0')}'),
                  _buildDetailRow('Type', bid.isExclusive ? 'Exclusive' : 'Non-Exclusive'),
                  
                  SizedBox(height: 24.h),
                  
                  // Bid History
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        const Color(0xFFC0C0C0), // Light silver
                        const Color(0xFF808080), // Medium silver
                        const Color(0xFFA8A8A8), // Bright silver
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      'Bid Information',
                      style: GoogleFonts.fjallaOne(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  _buildDetailRow('Starting Price', '\$${bid.startingPrice.toStringAsFixed(0)}'),
                  _buildDetailRow('My Bid', '\$${bid.myBidAmount.toStringAsFixed(0)}'),
                  _buildDetailRow('Current High', '\$${bid.currentHighestBid.toStringAsFixed(0)}'),
                  _buildDetailRow('Total Bids', bid.totalBids.toString()),
                  _buildDetailRow('Status', bid.statusText),
                  
                  if (bid.finalPrice != null)
                    _buildDetailRow('Final Price', '\$${bid.finalPrice!.toStringAsFixed(0)}'),
                  
                  SizedBox(height: 24.h),
                  
                  // Tags
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        const Color(0xFFC0C0C0), // Light silver
                        const Color(0xFF808080), // Medium silver
                        const Color(0xFFA8A8A8), // Bright silver
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      'Tags',
                      style: GoogleFonts.fjallaOne(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 12.h),
                  
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: bid.tags.map((tag) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppTheme.glassColor,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppTheme.glassBorder,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    )).toList(),
                  ),
                  
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReBidDialog(BidItem bid) {
    final TextEditingController bidController = TextEditingController();
    final minimumBid = bid.currentHighestBid + 50;
    
    return AlertDialog(
      backgroundColor: AppTheme.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      title: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [
            const Color(0xFFC0C0C0), // Light silver
            const Color(0xFF808080), // Medium silver
            const Color(0xFFA8A8A8), // Bright silver
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: Text(
          'Re-bid on ${bid.beatTitle}',
          style: GoogleFonts.fjallaOne(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current highest bid: \$${bid.currentHighestBid.toStringAsFixed(0)}',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          
          SizedBox(height: 8.h),
          
          Text(
            'Minimum bid: \$${minimumBid.toStringAsFixed(0)}',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              color: AppTheme.accentColor,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          TextField(
            controller: bidController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 16.sp,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              labelText: 'Your bid amount (\$)',
              labelStyle: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.7),
              ),
              filled: true,
              fillColor: AppTheme.glassColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppTheme.glassBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppTheme.glassBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppTheme.accentColor),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _showMessage('Bid placed successfully!');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            'Place Bid',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSellDialog(BidItem bid) {
    final TextEditingController priceController = TextEditingController();
    
    return AlertDialog(
      backgroundColor: AppTheme.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      title: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [
            const Color(0xFFC0C0C0), // Light silver
            const Color(0xFF808080), // Medium silver
            const Color(0xFFA8A8A8), // Bright silver
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: Text(
          'Sell ${bid.beatTitle}',
          style: GoogleFonts.fjallaOne(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You purchased this beat for \$${bid.finalPrice?.toStringAsFixed(0) ?? bid.myBidAmount.toStringAsFixed(0)}',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          
          SizedBox(height: 16.h),
          
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 16.sp,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              labelText: 'Selling price (\$)',
              labelStyle: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.7),
              ),
              filled: true,
              fillColor: AppTheme.glassColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppTheme.glassBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppTheme.glassBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppTheme.accentColor),
              ),
            ),
          ),
          
          SizedBox(height: 12.h),
          
          Text(
            'Note: Selling will transfer the exclusive rights to the buyer.',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 12.sp,
              color: AppTheme.warningColor,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _showMessage('Beat listed for sale!');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFD700),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Text(
            'List for Sale',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }
}
