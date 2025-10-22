import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/animated_bottom_nav_bar.dart';
import '../../shared/models/tab_icon_data.dart';
import 'filter_screen.dart';
import 'widgets/beat_list_view.dart';
import 'data/sample_data.dart';
import '../../auth/screens/auth_test_screen.dart';
import '../profile/profile_screen.dart';
import '../profile/add_beat_info_screen.dart';
import '../auction/auction_results_screen.dart';
import '../auction/live_auction_screen.dart';
import '../auction/live_streams_screen.dart';
import '../auction/setup_live_auction_screen.dart';
import '../profile/add_soundpack_info_screen.dart';
import '../analytics/analytics_screen.dart';
import 'my_bids_screen.dart';
import '../music/music_player_screen.dart';
import 'widgets/store_item_card.dart';
import 'screens/feedback_screen.dart';

class NewDashboardScreen extends StatefulWidget {
  final String userRole; // 'artist' or 'producer'
  
  const NewDashboardScreen({
    super.key, 
    this.userRole = 'artist', // default to artist
  });

  @override
  State<NewDashboardScreen> createState() => _NewDashboardScreenState();
}

class _NewDashboardScreenState extends State<NewDashboardScreen>
    with TickerProviderStateMixin {
  int _currentNavIndex = 0;
  List<TabIconData> tabIconsList = <TabIconData>[];
  PageController _livestreamController = PageController();
  PageController _mainPageController = PageController();
  late AnimationController _liveAnimationController;
  
  // Music player state
  bool _musicPlayerIsPlaying = false;
  
  // Music background animation controllers
  late AnimationController _waveController;
  late AnimationController _notesController;
  late AnimationController _pulseController;
  late Animation<double> _waveAnimation;
  late Animation<double> _notesAnimation;
  late Animation<double> _pulseAnimation;
  
  // List data
  List<BeatData> beatsData = [];

  @override
  void initState() {
    super.initState();
    
    // Initialize live animation
    _liveAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    // Initialize music background animation controllers
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _notesController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Create music animations
    _waveAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.linear,
    ));
    
    _notesAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _notesController,
      curve: Curves.easeInOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Start music animations
    _waveController.repeat();
    _notesController.repeat();
    _pulseController.repeat(reverse: true);
    
    // Load sample data
    beatsData = SampleData.getBeatsData();
    
    // Initialize navigation tabs
    tabIconsList.add(TabIconData(
      iconData: Icons.radio_button_unchecked,
      selectedIconData: Icons.radio_button_checked,
      index: 0,
      isSelected: true,
    ));
    tabIconsList.add(TabIconData(
      iconData: Icons.attach_money_outlined,
      selectedIconData: Icons.attach_money,
      index: 1,
      isSelected: false,
    ));
    tabIconsList.add(TabIconData(
      iconData: Icons.feedback_outlined,
      selectedIconData: Icons.feedback,
      index: 3,
      isSelected: false,
    ));
    tabIconsList.add(TabIconData(
      iconData: Icons.person_outline,
      selectedIconData: Icons.person,
      index: 4,
      isSelected: false,
    ));
  }

  @override
  void dispose() {
    _livestreamController.dispose();
    _mainPageController.dispose();
    _liveAnimationController.dispose();
    _waveController.dispose();
    _notesController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
        children: [
          // Animated Music Background
          _buildAnimatedBackground(),
          
          // Main content
          Column(
            children: [
              // Swipeable main content
              Expanded(
                child: PageView(
                  controller: _mainPageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentNavIndex = index;
                      // Update tab selection based on actual tab indices
                      for (int i = 0; i < tabIconsList.length; i++) {
                        tabIconsList[i].isSelected = tabIconsList[i].index == index;
                      }
                    });
                  },
                  children: [
                    // Page 0: Home/Dashboard
                    _buildHomePage(),
                    
                    // Page 1: My Bids (for artists) / Analytics (for producers)
                    _buildSecondPage(),
                    
                    // Page 2: Music Player
                    _buildMusicPlayerPage(),
                    
                    // Page 3: Feedback
                    _buildFeedbackPage(),
                    
                    // Page 4: Profile (for both artists and producers)
                    _buildProfilePage(),
                  ],
                ),
              ),
            ],
          ),
          
          // Bottom Navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedBottomNavBar(
              userRole: widget.userRole,
              tabIconsList: tabIconsList,
              musicPlayerIsPlaying: _musicPlayerIsPlaying,
              onRewind: () {
                // For now, just print the rewind action
                print('🔄 Rewind triggered from navigation bar!');
                // TODO: Implement proper rewind connection
              },
              changeIndex: (int index) {
                setState(() {
                  _currentNavIndex = index;
                  // Update tab selection based on actual tab indices
                  for (int i = 0; i < tabIconsList.length; i++) {
                    tabIconsList[i].isSelected = tabIconsList[i].index == index;
                  }
                });
                
                _mainPageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              addClick: () {
                print('Add button tapped!');
                if (widget.userRole == 'producer') {
                  _showAddToStoreModal();
                } else {
                  // For artists, show add beats modal when in add beats mode
                  _showAddToStoreModal();
                }
              },
              onPlayPauseChanged: () {
                setState(() {
                  _musicPlayerIsPlaying = !_musicPlayerIsPlaying;
                });
              },
            ),
          ),
        ],
        ),
      ),
    );
  }

  // Page builders for swipeable content
  Widget _buildHomePage() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          
          // Search Bar with Filter
          _buildSearchBar(),
          
          SizedBox(height: 16.h),
          
          // Auth Test Button
          _buildAuthTestButton(),
          
          SizedBox(height: 24.h),
          
          // Role-based content sections
          if (widget.userRole == 'artist') ...[
            // Artist sections
            _buildLivestreamsSection(),
            SizedBox(height: 40.h),
            _buildFeaturedBeatsSection(),
          ] else ...[
            // Producer sections  
            _buildMyAuctionsSection(),
            SizedBox(height: 40.h),
            _buildPreviousAuctionsSection(),
          ],
          
          // Bottom padding for navigation
          SizedBox(height: 120.h),
        ],
      ),
    );
  }

  Widget _buildSecondPage() {
    if (widget.userRole == 'artist') {
      // My Bids page for artists
      return const MyBidsScreen();
    } else {
      // Analytics or other content for producers
      return _buildProducerAnalytics();
    }
  }

  Widget _buildFeedbackPage() {
    return FeedbackScreen();
  }

  Widget _buildMusicPlayerPage() {
    return MusicPlayerScreen(
      initialPlayState: _musicPlayerIsPlaying,
      onPlayStateChanged: () {
        setState(() {
          _musicPlayerIsPlaying = !_musicPlayerIsPlaying;
        });
      },
    );
  }

  Widget _buildProfilePage() {
    return ProfileScreen(
      userRole: widget.userRole,
      onNavigateToAnalytics: () {
        // Navigate to analytics tab (index 1) for producers
        if (widget.userRole == 'producer') {
          setState(() {
            _currentNavIndex = 1;
            // Update tab selection
            for (int i = 0; i < tabIconsList.length; i++) {
              tabIconsList[i].isSelected = i == 1;
            }
          });
          
          _mainPageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      onNavigateToMyBids: () {
        // Navigate to my bids tab (index 1) for artists
        if (widget.userRole == 'artist') {
          setState(() {
            _currentNavIndex = 1;
            // Update tab selection
            for (int i = 0; i < tabIconsList.length; i++) {
              tabIconsList[i].isSelected = i == 1;
            }
          });
          
          _mainPageController.animateToPage(
            1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  Widget _buildProducerAnalytics() {
    return AnalyticsScreen(userRole: widget.userRole);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      child: Row(
        children: [
          // Search input field
          Expanded(
            child: TextField(
              onChanged: (String txt) {},
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppTheme.glassColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(38.r),
                  borderSide: BorderSide(
                    color: AppTheme.glassBorder,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(38.r),
                  borderSide: BorderSide(
                    color: AppTheme.glassBorder,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(38.r),
                  borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                hintText: 'Search beats, artists, livestreams...',
                hintStyle: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.5),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                  vertical: 16.h,
                ),
              ),
            ),
          ),
          
          SizedBox(width: 12.w),
          
          // Search button
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(38.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(38.r),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  print('Search tapped');
                },
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Icon(
                    Icons.search,
                    size: 20.sp,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(width: 12.w),
          
          // Filter button
          Container(
            decoration: BoxDecoration(
              color: AppTheme.glassColor,
              borderRadius: BorderRadius.circular(38.r),
              border: Border.all(
                color: AppTheme.glassBorder,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(38.r),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FilterScreen(),
                      fullscreenDialog: true,
                    ),
                  );
                  if (result != null) {
                    print('Filters applied: $result');
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Icon(
                    Icons.tune,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthTestButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentColor.withOpacity(0.1),
            AppTheme.accentColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AuthTestScreen(),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(
                  Icons.security,
                  color: AppTheme.accentColor,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test Authentication',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Login, Register, and test auth features',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 12.sp,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.accentColor,
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLivestreamsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                'Livestreams',
                style: GoogleFonts.fjallaOne(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.accentColor.withOpacity(0.6),
              size: 16.sp,
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // Livestream Grid with Slider
        SizedBox(
          height: 250.h,
          child: PageView.builder(
            controller: _livestreamController,
            itemCount: 3, // Number of pages
            itemBuilder: (context, pageIndex) {
              return Row(
                children: [
                  // First livestream card
                  Expanded(
                    child: _buildLivestreamCard(
                      'Beat Battle Live',
                      'DJ Mike vs DJ Sarah',
                      '1.2K watching',
                      AppTheme.warningColor,
                      pageIndex * 2,
                    ),
                  ),
                  
                  SizedBox(width: 12.w),
                  
                  // Second livestream card
                  Expanded(
                    child: _buildLivestreamCard(
                      'Hip Hop Session',
                      'Producer Showcase',
                      '856 watching',
                      AppTheme.successColor,
                      pageIndex * 2 + 1,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        
        SizedBox(height: 12.h),
        
        // Page Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accentColor.withOpacity(0.3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildLivestreamCard(
    String title,
    String subtitle,
    String viewers,
    Color accentColor,
    int index,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LiveStreamsScreen(
                title: title,
                artistName: subtitle,
                viewerCount: viewers,
                streamDuration: '15:42', // You can make this dynamic
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        
        // THE RECTANGLE - waves background with live indicator
        Container(
          height: 160.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            image: DecorationImage(
              image: AssetImage('assets/images/live.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Live indicator (same style as people count)
              Positioned(
                top: 12.h,
                left: 12.w,
                child: AnimatedBuilder(
                  animation: _liveAnimationController,
                  builder: (context, child) {
                    final animationValue = _liveAnimationController.value;
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.8 + (0.2 * animationValue)),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.radio_button_checked,
                            color: Colors.white.withOpacity(0.8),
                            size: 12.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'LIVE',
                            style: GoogleFonts.getFont(
                              'Wix Madefor Display',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 10.h),
        
        // Title below rectangle
        Text(
          title,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        SizedBox(height: 6.h),
        
        // Subtitle below title (like throwback tag)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            subtitle,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 10.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
        ],
        ),
      ),
    );
  }

  Widget _buildFeaturedBeatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
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
                'Grab Bags',
                style: GoogleFonts.fjallaOne(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                'See all',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        // 2x2 Grid Layout
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 11.h,
            childAspectRatio: 0.7, // Reasonable ratio - let Expanded control rectangle height
          ),
          itemCount: 4, // Show 4 items in 2x2 grid
          itemBuilder: (context, index) {
            return _buildGrabBagCard(index);
          },
        ),
      ],
    );
  }

  Widget _buildGrabBagCard(int index) {
    final grabBagTitles = [
      'Midnight Rage',
      'Remember The Name', 
      'Breaking Positive Auction',
      'Breaking Positive Auction'
    ];
    
    final usernames = [
      'Lumpiaxpapi',
      'Lumpiaxpapi',
      'Lumpiaxpapi', 
      'Lumpiaxpapi'
    ];

    // Determine tag, gradient, and image based on title
    String tag;
    List<Color> gradientColors;
    String imagePath;
    if (grabBagTitles[index] == 'Midnight Rage') {
      tag = 'Throwback';
      gradientColors = [
        Colors.orange.shade500,
        Colors.pink.shade600,
        Colors.purple.shade700,
      ];
      imagePath = 'assets/images/throwback.png';
    } else if (grabBagTitles[index] == 'Remember The Name') {
      tag = 'Rap Rock';
      gradientColors = [
        Colors.indigo.shade500,
        Colors.deepPurple.shade600,
        Colors.black,
      ];
      imagePath = 'assets/images/raprock.png';
    } else {
      tag = 'STORE';
      gradientColors = [Colors.grey.shade400, Colors.grey.shade600];
      imagePath = 'assets/images/bagr_logo.png';
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to grab bag details screen
          print('Tapped on Grab Bag: ${grabBagTitles[index]}');
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
        // Username at top
        Row(
          children: [
            CircleAvatar(
              radius: 6.r,
              backgroundColor: Colors.grey[600],
            ),
            SizedBox(width: 6.w),
            Text(
              usernames[index],
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 8.h),
        
        // THE RECTANGLE - just one! (simple fixed height)
        Container(
          height: 150.h, // Reduced height to prevent overflow
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // People count button (same style as throwback)
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people,
                        color: Colors.white.withOpacity(0.8),
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '248',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 10.sp,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Play button bottom right (or add button for last card)
              Positioned(
                bottom: 12.h,
                right: 12.w,
                child: Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: index == 3 ? Colors.white : Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    index == 3 ? Icons.add : Icons.play_arrow,
                    color: Colors.black,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 2.h),
        
        // Title below rectangle
        Text(
          grabBagTitles[index],
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        SizedBox(height: 4.h),
        
        // Tag below title
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            'Throwback',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 10.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
        ],
        ),
      ),
    );
  }

  // Producer sections
  Widget _buildMyAuctionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                'Live Auctions',
                style: GoogleFonts.fjallaOne(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.accentColor.withOpacity(0.6),
              size: 16.sp,
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // Live Auctions Grid
        SizedBox(
          height: 250.h,
          child: PageView.builder(
            itemCount: 2,
            itemBuilder: (context, pageIndex) {
              return Row(
                children: [
                  Expanded(
                    child: _buildAuctionCard(
                      'Midnight Mayhem',
                      'Current Bid: \$30',
                      '0:10 left',
                      AppTheme.warningColor,
                      pageIndex * 2,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildAuctionCard(
                      'Lets Lurk',
                      'Current Bid: \$180',
                      '13:20 left',
                      AppTheme.successColor,
                      pageIndex * 2 + 1,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPreviousAuctionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
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
                'Grab Bags',
                style: GoogleFonts.fjallaOne(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                'See all',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        
        // Grab Bags Grid with Slider (same as other sections)
        SizedBox(
          height: 250.h,
          child: PageView.builder(
            itemCount: 2, // Number of pages
            itemBuilder: (context, pageIndex) {
              return Row(
                children: [
                  // First previous auction card
                  Expanded(
                    child: _buildPreviousAuctionCard(
                      'Midnight Rage',
                      '\$120',
                      '1m 30sec',
                      AppTheme.successColor,
                      pageIndex * 2,
                    ),
                  ),
                  
                  SizedBox(width: 12.w),
                  
                  // Second previous auction card
                  Expanded(
                    child: _buildPreviousAuctionCard(
                      'Remember The Name',
                      '\$420',
                      '10m 45sec',
                      AppTheme.successColor,
                      pageIndex * 2 + 1,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        
        SizedBox(height: 12.h),
        
        // Page Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(2, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accentColor.withOpacity(0.3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAuctionCard(
    String title,
    String subtitle,
    String timeLeft,
    Color accentColor,
    int index,
  ) {
    // Determine genre, gradient colors, and image based on title
    String genre;
    List<Color> gradientColors;
    String imagePath;
    if (title == 'Midnight Mayhem') {
      genre = 'Trap';
      gradientColors = [
        Colors.red.shade500,
        Colors.purple.shade600,
        Colors.blue.shade700,
      ];
      imagePath = 'assets/images/trap.jpg';
    } else if (title == 'Lets Lurk') {
      genre = 'Drill';
      gradientColors = [
        Colors.cyan.shade400,
        Colors.teal.shade600,
        Colors.green.shade700,
      ];
      imagePath = 'assets/images/drill.png';
    } else {
      genre = 'AUCTION';
      gradientColors = [Colors.grey.shade400, Colors.grey.shade600];
      imagePath = 'assets/images/trap.jpg';
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LiveAuctionScreen(
                title: title,
                currentBid: '\$120',
                timeLeft: '1:30',
                bidCount: '48',
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        // THE RECTANGLE - waves background with auction indicator
        Container(
          height: 160.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Auction indicator (same style as live indicator)
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 0.5, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors[0].withOpacity(0.4),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: gradientColors[gradientColors.length - 1].withOpacity(0.2),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    genre,
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Time left indicator (bottom right like play button)
              Positioned(
                bottom: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.schedule,
                        color: accentColor,
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        timeLeft,
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
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
        
        SizedBox(height: 10.h),
        
        // Title below rectangle
        Text(
          title,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        SizedBox(height: 6.h),
        
        // Subtitle below title (like throwback tag)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            subtitle,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 10.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
        ],
        ),
      ),
    );
  }

  Widget _buildPreviousAuctionCard(
    String title,
    String status,
    String timeAgo,
    Color accentColor,
    int index,
  ) {
    // Determine tag, gradient, and image based on title
    String tag;
    List<Color> gradientColors;
    String imagePath;
    if (title == 'Midnight Rage') {
      tag = 'Throwback';
      gradientColors = [
        Colors.orange.shade500,
        Colors.pink.shade600,
        Colors.purple.shade700,
      ];
      imagePath = 'assets/images/throwback.png';
    } else if (title == 'Remember The Name') {
      tag = 'Rap Rock';
      gradientColors = [
        Colors.indigo.shade500,
        Colors.deepPurple.shade600,
        Colors.black,
      ];
      imagePath = 'assets/images/raprock.png';
    } else {
      tag = 'STORE';
      gradientColors = [Colors.grey.shade400, Colors.grey.shade600];
      imagePath = 'assets/images/trophy.png';
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AuctionResultsScreen(
                title: title,
                status: status,
                timeAgo: timeAgo,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        // THE RECTANGLE - waves background with sold indicator
        Container(
          height: 160.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              // Status indicator (top-left)
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 0.5, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors[0].withOpacity(0.4),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: gradientColors[gradientColors.length - 1].withOpacity(0.2),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    tag,
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Total sell time indicator (bottom right)
              Positioned(
                bottom: 12.h,
                right: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer,
                        color: Colors.white.withOpacity(0.8),
                        size: 10.sp,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        timeAgo,
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
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
        
        SizedBox(height: 10.h),
        
        // Title below rectangle
        Text(
          title,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        SizedBox(height: 6.h),
        
        // Status below title (like throwback tag)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            status,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 10.sp,
              color: accentColor,
            ),
          ),
        ),
        ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: Listenable.merge([_waveAnimation, _notesAnimation, _pulseAnimation]),
      builder: (context, child) {
        return CustomPaint(
          painter: MusicBackgroundPainter(
            waveProgress: _waveAnimation.value,
            notesProgress: _notesAnimation.value,
            pulseScale: _pulseAnimation.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  // Add to Store Modal Methods
  void _showAddToStoreModal() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddToStoreScreen(),
      ),
    );
  }


  Widget _buildMyLibrarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.library_music_rounded,
                  color: AppTheme.accentColor,
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'My Library',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                print('View all library items');
              },
              child: Text(
                'View All',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.accentColor,
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // Library stats row
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Downloaded',
                '12',
                Icons.download_rounded,
                const Color(0xFF4CAF50),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                'Purchased',
                '8',
                Icons.shopping_bag_rounded,
                AppTheme.accentColor,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildStatCard(
                'Playlists',
                '3',
                Icons.playlist_play_rounded,
                const Color(0xFFFF9800),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 20.h),
        
        // Library content grid
        _buildLibraryGrid(),
      ],
    );
  }

  Widget _buildMyFavoritesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.favorite_rounded,
                  color: Colors.red,
                  size: 24.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'My Favorites',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                print('View all favorites');
              },
              child: Text(
                'View All',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.accentColor,
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // Favorites categories
        Row(
          children: [
            Expanded(
              child: _buildFavoriteCategory(
                'Beats',
                '24',
                Icons.music_note_rounded,
                AppTheme.accentColor,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildFavoriteCategory(
                'Producers',
                '7',
                Icons.person_rounded,
                const Color(0xFF9C27B0),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildFavoriteCategory(
                'Albums',
                '5',
                Icons.album_rounded,
                const Color(0xFF00BCD4),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 20.h),
        
        // Favorites content grid
        _buildFavoritesGrid(),
      ],
    );
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
          
          Text(
            value,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
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

  Widget _buildFavoriteCategory(String title, String count, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        print('$title category tapped');
      },
      child: Container(
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
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20.sp,
              ),
            ),
            
            SizedBox(height: 12.h),
            
            Text(
              count,
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            
            Text(
              title,
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLibraryGrid() {
    final libraryItems = [
      {'title': 'Smooth Vibes', 'producer': 'BeatMaker Pro', 'type': 'Beat', 'status': 'Downloaded'},
      {'title': 'Urban Flow', 'producer': 'SoundWave', 'type': 'Beat', 'status': 'Purchased'},
      {'title': 'Chill Pack Vol.1', 'producer': 'LoFi Master', 'type': 'Pack', 'status': 'Downloaded'},
      {'title': 'Hip Hop Essentials', 'producer': 'RhymeTime', 'type': 'Playlist', 'status': 'Created'},
    ];

    return Column(
      children: libraryItems.map((item) => Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppTheme.glassColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppTheme.glassBorder,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () {
              print('${item['title']} tapped');
            },
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  // Item icon
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.accentColor.withOpacity(0.3),
                          AppTheme.accentColor.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      item['type'] == 'Beat' ? Icons.music_note_rounded :
                      item['type'] == 'Pack' ? Icons.library_music_rounded :
                      Icons.playlist_play_rounded,
                      color: AppTheme.accentColor,
                      size: 24.sp,
                    ),
                  ),
                  
                  SizedBox(width: 16.w),
                  
                  // Item info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: GoogleFonts.getFont(
                            'Wix Madefor Display',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'by ${item['producer']}',
                          style: GoogleFonts.getFont(
                            'Wix Madefor Display',
                            fontSize: 12.sp,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Status badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: _getStatusColor(item['status']!).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      item['status']!,
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(item['status']!),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildFavoritesGrid() {
    final favoriteItems = [
      {'title': 'Midnight Dreams', 'producer': 'NightBeats', 'type': 'Beat', 'liked': '2 days ago'},
      {'title': 'Trap King', 'producer': 'BassLine', 'type': 'Producer', 'liked': '1 week ago'},
      {'title': 'Lo-Fi Sunset', 'producer': 'ChillWave', 'type': 'Beat', 'liked': '3 days ago'},
      {'title': 'Golden Hits', 'producer': 'RetroSound', 'type': 'Album', 'liked': '5 days ago'},
    ];

    return Column(
      children: favoriteItems.map((item) => Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppTheme.glassColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppTheme.glassBorder,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: () {
              print('${item['title']} tapped');
            },
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  // Item icon
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.withOpacity(0.3),
                          Colors.red.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      item['type'] == 'Beat' ? Icons.music_note_rounded :
                      item['type'] == 'Producer' ? Icons.person_rounded :
                      Icons.album_rounded,
                      color: Colors.red,
                      size: 24.sp,
                    ),
                  ),
                  
                  SizedBox(width: 16.w),
                  
                  // Item info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: GoogleFonts.getFont(
                            'Wix Madefor Display',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          item['type'] == 'Producer' ? 'Producer' : 'by ${item['producer']}',
                          style: GoogleFonts.getFont(
                            'Wix Madefor Display',
                            fontSize: 12.sp,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Heart icon and time
                  Column(
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        color: Colors.red,
                        size: 20.sp,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        item['liked']!,
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 9.sp,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      )).toList(),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Downloaded':
        return const Color(0xFF4CAF50);
      case 'Purchased':
        return AppTheme.accentColor;
      case 'Created':
        return const Color(0xFF00BCD4);
      default:
        return Colors.grey;
    }
  }

  void _addSingleBeat() {
    print('🎵 Starting Live Auction setup...');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SetupLiveAuctionScreen(),
      ),
    );
  }

  void _addSoundpack() {
    print('📦 Adding soundpack...');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddSoundpackInfoScreen(),
      ),
    );
  }
}

class MusicBackgroundPainter extends CustomPainter {
  final double waveProgress;
  final double notesProgress;
  final double pulseScale;

  MusicBackgroundPainter({
    required this.waveProgress,
    required this.notesProgress,
    required this.pulseScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw sound waves
    _drawSoundWaves(canvas, size, paint);
    
    // Draw floating musical notes
    _drawFloatingNotes(canvas, size, paint);
    
    // Draw pulsing circles
    _drawPulsingCircles(canvas, size, paint);
    
    // Draw frequency bars
    _drawFrequencyBars(canvas, size, paint);
  }

  void _drawSoundWaves(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.white.withOpacity(0.05);
    
    final path = Path();
    final waveHeight = 30.0;
    final waveLength = size.width / 3;
    
    for (int i = 0; i < 4; i++) {
      final yOffset = size.height * 0.2 + (i * size.height * 0.2);
      path.reset();
      
      for (double x = 0; x <= size.width; x += 2) {
        final y = yOffset + 
            math.sin((x / waveLength * 2 * math.pi) + waveProgress + (i * 0.5)) * 
            waveHeight * (0.5 + i * 0.2);
        
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      
      canvas.drawPath(path, paint);
    }
  }

  void _drawFloatingNotes(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.white.withOpacity(0.03);
    paint.style = PaintingStyle.fill;
    
    final notes = [
      {'x': 0.15, 'y': 0.25, 'size': 16.0, 'speed': 1.0},
      {'x': 0.8, 'y': 0.4, 'size': 12.0, 'speed': 0.7},
      {'x': 0.3, 'y': 0.65, 'size': 14.0, 'speed': 1.2},
      {'x': 0.75, 'y': 0.8, 'size': 10.0, 'speed': 0.9},
      {'x': 0.1, 'y': 0.85, 'size': 18.0, 'speed': 0.6},
      {'x': 0.9, 'y': 0.15, 'size': 11.0, 'speed': 1.1},
    ];
    
    for (final note in notes) {
      final x = note['x']! * size.width;
      final baseY = note['y']! * size.height;
      final noteSize = note['size']!;
      final speed = note['speed']!;
      
      // Floating animation
      final animatedY = baseY + math.sin(notesProgress * 2 * math.pi * speed) * 20;
      
      // Draw musical note
      _drawMusicalNote(canvas, Offset(x, animatedY), noteSize, paint);
    }
  }

  void _drawMusicalNote(Canvas canvas, Offset position, double size, Paint paint) {
    // Note head (circle)
    canvas.drawCircle(position, size * 0.3, paint);
    
    // Note stem
    final stemStart = Offset(position.dx + size * 0.25, position.dy);
    final stemEnd = Offset(position.dx + size * 0.25, position.dy - size * 1.5);
    canvas.drawLine(stemStart, stemEnd, paint..strokeWidth = size * 0.1);
    
    // Note flag (simple curve)
    final flagPath = Path();
    flagPath.moveTo(stemEnd.dx, stemEnd.dy);
    flagPath.quadraticBezierTo(
      stemEnd.dx + size * 0.4, 
      stemEnd.dy + size * 0.3,
      stemEnd.dx + size * 0.2, 
      stemEnd.dy + size * 0.8,
    );
    canvas.drawPath(flagPath, paint..style = PaintingStyle.stroke);
    
    paint.style = PaintingStyle.fill;
  }

  void _drawPulsingCircles(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.white.withOpacity(0.02);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.0;
    
    final centers = [
      Offset(size.width * 0.2, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.7),
      Offset(size.width * 0.9, size.height * 0.2),
      Offset(size.width * 0.1, size.height * 0.8),
    ];
    
    for (int i = 0; i < centers.length; i++) {
      final center = centers[i];
      final baseRadius = 40.0 + (i * 10);
      final animatedRadius = baseRadius * pulseScale;
      
      // Draw multiple concentric circles
      for (int j = 0; j < 3; j++) {
        final radius = animatedRadius + (j * 15);
        final opacity = (0.02 / (j + 1));
        paint.color = Colors.white.withOpacity(opacity);
        canvas.drawCircle(center, radius, paint);
      }
    }
  }

  void _drawFrequencyBars(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.white.withOpacity(0.03);
    paint.style = PaintingStyle.fill;
    
    final barCount = 20;
    final barWidth = size.width / (barCount * 2);
    final maxBarHeight = size.height * 0.15;
    
    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth * 2;
      final normalizedI = i / barCount;
      
      // Create frequency-like pattern
      final frequency = math.sin(normalizedI * math.pi * 4) * 
                       math.sin(waveProgress * 3 + normalizedI * 6);
      final barHeight = (frequency.abs() * maxBarHeight * pulseScale).clamp(5.0, maxBarHeight);
      
      final rect = Rect.fromLTWH(
        x, 
        size.height - barHeight, 
        barWidth, 
        barHeight,
      );
      
      canvas.drawRect(rect, paint);
      
      // Mirror on the other side
      final mirrorRect = Rect.fromLTWH(
        size.width - x - barWidth, 
        size.height - barHeight, 
        barWidth, 
        barHeight,
      );
      
      canvas.drawRect(mirrorRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final random = math.Random(42); // Fixed seed for consistent noise
    
    // Create noise pattern with small rectangles
    for (int i = 0; i < (size.width * size.height / 16).round(); i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final width = random.nextDouble() * 2 + 0.5;
      final height = random.nextDouble() * 2 + 0.5;
      
      canvas.drawRect(
        Rect.fromLTWH(x, y, width, height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AddToStoreScreen extends StatelessWidget {
  const AddToStoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 49),
            const Text(
              'Add to Store',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w700,
                height: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const SizedBox(
              width: 275,
              child: Text(
                'Select the type of item you want to add.',
                style: TextStyle(
                  color: Color(0xFFA3A3A3),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.43,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  StoreItemCard(
                    title: 'Single Item',
                    icon: _buildSingleItemIcon(),
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  StoreItemCard(
                    title: 'Pack',
                    icon: _buildPackIcon(),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SelectPackTypeScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleItemIcon() {
    return SizedBox(
      width: 58,
      height: 64,
      child: CustomPaint(
        painter: SingleItemIconPainter(),
      ),
    );
  }

  Widget _buildPackIcon() {
    return SizedBox(
      width: 64,
      height: 64,
      child: CustomPaint(
        painter: PackIconPainter(),
      ),
    );
  }
}

class SingleItemIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    
    path.moveTo(28.05, 31.05);
    path.cubicTo(29.85, 29.69, 30.65, 27.41, 30.17, 25.27);
    path.lineTo(26.08, 27.63);
    path.lineTo(28.05, 31.05);
    path.close();

    path.moveTo(29.30, 43.39);
    path.cubicTo(28.48, 43.86, 28.21, 44.90, 28.67, 45.71);
    path.cubicTo(29.14, 46.52, 30.18, 46.80, 30.99, 46.33);
    path.cubicTo(31.80, 45.86, 32.08, 44.82, 31.62, 44.01);
    path.cubicTo(31.15, 43.20, 30.11, 42.92, 29.30, 43.39);
    path.close();

    canvas.drawPath(path, paint);

    final pathOutline = Path();
    pathOutline.moveTo(18.91, 6.83);
    pathOutline.cubicTo(19.30, 6.60, 19.76, 6.54, 20.20, 6.66);
    pathOutline.lineTo(34.12, 10.39);
    pathOutline.cubicTo(34.55, 10.50, 34.93, 10.79, 35.15, 11.18);
    pathOutline.lineTo(52.48, 41.19);
    pathOutline.cubicTo(53.88, 43.62, 53.04, 46.74, 50.61, 48.15);
    pathOutline.lineTo(30.02, 60.04);
    pathOutline.cubicTo(27.58, 61.44, 24.46, 60.61, 23.06, 58.17);
    pathOutline.lineTo(5.73, 28.16);
    pathOutline.cubicTo(5.51, 27.77, 5.45, 27.31, 5.56, 26.88);
    pathOutline.lineTo(9.29, 12.95);
    pathOutline.cubicTo(9.41, 12.52, 9.69, 12.15, 10.08, 11.92);
    pathOutline.lineTo(13.03, 10.22);
    pathOutline.lineTo(16.82, 16.79);
    pathOutline.cubicTo(17.29, 17.61, 18.33, 17.89, 19.14, 17.42);
    pathOutline.cubicTo(19.95, 16.95, 20.23, 15.91, 19.76, 15.10);
    pathOutline.lineTo(15.97, 8.53);
    pathOutline.lineTo(18.91, 6.83);
    pathOutline.close();

    canvas.drawPath(pathOutline, paint);

    final pathBottom = Path();
    pathBottom.moveTo(13.64, 4.50);
    pathBottom.cubicTo(13.17, 3.69, 12.13, 3.41, 11.32, 3.88);
    pathBottom.cubicTo(10.51, 4.35, 10.23, 5.39, 10.70, 6.20);
    pathBottom.lineTo(13.02, 10.22);
    pathBottom.lineTo(15.96, 8.53);
    pathBottom.lineTo(13.64, 4.50);
    pathBottom.close();

    canvas.drawPath(pathBottom, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PackIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    
    path.moveTo(61.89, 53.30);
    path.lineTo(53.30, 14.00);
    path.lineTo(15.09, 19.48);
    path.lineTo(9.61, 7.97);
    path.lineTo(15.46, 57.32);
    path.lineTo(15.46, 62.98);
    path.lineTo(61.89, 53.30);
    path.close();

    canvas.drawPath(path, paint);

    final path2 = Path();
    path2.moveTo(14.00, 62.98);
    path2.lineTo(14.00, 56.95);
    path2.lineTo(7.86, 3.86);
    path2.cubicTo(5.67, 11.54, 2.11, 52.93, 2.11, 52.93);
    path2.lineTo(14.00, 62.98);
    path2.close();

    canvas.drawPath(path2, paint);

    final path3 = Path();
    path3.moveTo(16.19, 17.47);
    path3.lineTo(53.30, 12.17);
    path3.lineTo(48.36, 1.02);
    path3.lineTo(7.78, 1.93);
    path3.lineTo(16.19, 17.47);
    path3.close();

    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SelectPackTypeScreen extends StatefulWidget {
  const SelectPackTypeScreen({Key? key}) : super(key: key);

  @override
  State<SelectPackTypeScreen> createState() => _SelectPackTypeScreenState();
}

class _SelectPackTypeScreenState extends State<SelectPackTypeScreen> {
  String? selectedPackType = 'beat_pack';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 49),
              const Text(
                'Add Pack',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const SizedBox(
                width: 275,
                child: Text(
                  'Choose pack type:',
                  style: TextStyle(
                    color: Color(0xFFA3A3A3),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 43),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      _PackTypeCard(
                        title: 'Beat Pack',
                        description: 'Bundle several finished beats in one drop. More value, more heat.',
                        isSelected: selectedPackType == 'beat_pack',
                        onTap: () {
                          setState(() {
                            selectedPackType = 'beat_pack';
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _PackTypeCard(
                        title: 'Sound Pack',
                        description: 'A mixed bag of sounds — one-shots (808s, kicks, snares, hi-hats, claps), FX, and samples. No melodic or drum loops.',
                        isSelected: selectedPackType == 'sound_pack',
                        onTap: () {
                          setState(() {
                            selectedPackType = 'sound_pack';
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _PackTypeCard(
                        title: 'Loop Kit',
                        description: 'A collection of melody or drum loops only. No one-shots, just loops.',
                        isSelected: selectedPackType == 'loop_kit',
                        onTap: () {
                          setState(() {
                            selectedPackType = 'loop_kit';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                      },
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        child: const Center(
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.43,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 139,
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PackTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _PackTypeCard({
    Key? key,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.10),
            width: 1,
          ),
          color: Colors.white.withOpacity(0.05),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFFAFAFA),
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFFA3A3A3),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            _buildCheckIcon(isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckIcon(bool isSelected) {
    if (isSelected) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: const Icon(
          Icons.check,
          color: Color(0xFF0D0D0D),
          size: 16,
        ),
      );
    } else {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF454545),
            width: 1,
          ),
        ),
      );
    }
  }
}



