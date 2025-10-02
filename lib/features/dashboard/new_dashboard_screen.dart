import 'package:flutter/material.dart';
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
      iconData: Icons.favorite_outline,
      selectedIconData: Icons.favorite,
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
                    
                    // Page 3: Favorites (for artists) / Favorites (for producers)
                    _buildFavoritesPage(),
                    
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

  Widget _buildFavoritesPage() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          
          // Search Bar with Filter (same as home page)
          _buildSearchBar(),
          
          SizedBox(height: 24.h),
          
          // My Library Section
          _buildMyLibrarySection(),
          
          SizedBox(height: 40.h),
          
          // My Favorites Section
          _buildMyFavoritesSection(),
          
          // Bottom padding for navigation
          SizedBox(height: 120.h),
        ],
      ),
    );
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
              image: AssetImage('assets/waves.jpg'),
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
      'Breaking Positive Auction',
      'Breaking Positive Auction', 
      'Breaking Positive Auction',
      'Breaking Positive Auction'
    ];
    
    final usernames = [
      'Lumpiaxpapi',
      'Lumpiaxpapi',
      'Lumpiaxpapi', 
      'Lumpiaxpapi'
    ];

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
              image: AssetImage('assets/waves.jpg'),
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
                'My Auctions',
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
        
        // My Auctions Grid
        SizedBox(
          height: 250.h,
          child: PageView.builder(
            itemCount: 2,
            itemBuilder: (context, pageIndex) {
              return Row(
                children: [
                  Expanded(
                    child: _buildAuctionCard(
                      'Dark Trap Symphony',
                      'Current Bid: \$250',
                      '2h 15m left',
                      AppTheme.warningColor,
                      pageIndex * 2,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildAuctionCard(
                      'Lo-Fi Chill Vibes',
                      'Current Bid: \$180',
                      '45m left',
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
                'Previous Auctions',
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
        
        // Previous Auctions Grid with Slider (same as other sections)
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
                      'Sold - \$120',
                      '1m 30sec',
                      AppTheme.successColor,
                      pageIndex * 2,
                    ),
                  ),
                  
                  SizedBox(width: 12.w),
                  
                  // Second previous auction card
                  Expanded(
                    child: _buildPreviousAuctionCard(
                      'Dark Trap Symphony',
                      'Sold - \$420',
                      '2h 45sec',
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
              image: AssetImage('assets/waves.jpg'),
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
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.gavel,
                        color: Colors.white.withOpacity(0.8),
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'AUCTION',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
              image: AssetImage('assets/waves.jpg'),
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
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.white.withOpacity(0.8),
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'SOLD',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
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

  // Add to Store Modal Methods (copied from ProfileScreen)
  void _showAddToStoreModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.3), // Darker barrier for stronger background blur effect
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.4,
          maxChildSize: 0.85,
          builder: (context, scrollController) => ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
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
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                  ),
          child:
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                
                SizedBox(height: 24.h),
                
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
                    'Go Live Now',
                    style: GoogleFonts.fjallaOne(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                SizedBox(height: 8.h),
                
                Text(
                  'What type of stream do you want to run?',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 16.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                
                SizedBox(height: 32.h),
                
                // Store Options
                Column(
                  children: [
                    _buildStoreOption(
                      iconData: Icons.gavel,
                      title: 'Live Auction',
                      subtitle: 'Go live with a banger and let the market decide its value. Artists bid for exclusive rights in real time and can co-sign your sound.',
                      isSelected: false,
                      onTap: () {
                        Navigator.pop(context);
                        _addSingleBeat();
                      },
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    _buildStoreOption(
                      iconData: Icons.shopping_bag,
                      title: 'Grab Bag',
                      subtitle: 'Go live with a non-exclusive beat, sound pack, or loop you want to promote. Fans can buy it instantly in real time — no bidding.',
                      isSelected: false,
                      onTap: () {
                        Navigator.pop(context);
                        _addSoundpack();
                      },
                    ),
                  ],
                ),
                
                SizedBox(height: 40.h),
                
                // Continue Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Container(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _addSingleBeat(); // Default to single beat
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 32.h),
              ],
            ),
                ),
              ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreOption({
    required IconData iconData,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A).withOpacity(0.7),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected 
                ? Colors.white.withOpacity(0.4)
                : Colors.white.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            // Top row with icon and selection indicator
            Row(
              children: [
                // Icon (no background container)
                Icon(
                  iconData,
                  color: Colors.white.withOpacity(0.8),
                  size: 40.sp, // Enlarged icon
                ),
                
                const Spacer(),
                
                // Selection indicator
                Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.white : Colors.transparent,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: Colors.black,
                          size: 12.sp,
                        )
                      : null,
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Text content (full width)
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      title,
                      style: GoogleFonts.fjallaOne(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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


