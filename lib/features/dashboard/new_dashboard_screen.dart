import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/custom_status_bar.dart';
import '../../shared/widgets/animated_bottom_nav_bar.dart';
import '../../shared/models/tab_icon_data.dart';
import 'filter_screen.dart';
import 'widgets/beat_list_view.dart';
import 'data/sample_data.dart';

class NewDashboardScreen extends StatefulWidget {
  const NewDashboardScreen({super.key});

  @override
  State<NewDashboardScreen> createState() => _NewDashboardScreenState();
}

class _NewDashboardScreenState extends State<NewDashboardScreen>
    with TickerProviderStateMixin {
  int _currentNavIndex = 0;
  List<TabIconData> tabIconsList = <TabIconData>[];
  PageController _livestreamController = PageController();
  late AnimationController _liveAnimationController;
  
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
      index: 2,
      isSelected: false,
    ));
    tabIconsList.add(TabIconData(
      iconData: Icons.person_outline,
      selectedIconData: Icons.person,
      index: 3,
      isSelected: false,
    ));
  }

  @override
  void dispose() {
    _livestreamController.dispose();
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
      body: Stack(
        children: [
          // Animated Music Background
          _buildAnimatedBackground(),
          
          // Main content
          Column(
            children: [
              // Status Bar
              Container(
                color: Colors.black,
                child: const CustomStatusBar(),
              ),
              
              // Main scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      
                      // Search Bar with Filter
                      _buildSearchBar(),
                      
                      SizedBox(height: 24.h),
                      
                      // Livestreams Section
                      _buildLivestreamsSection(),
                      
                      SizedBox(height: 40.h),
                      
                      // Featured Beats Section
                      _buildFeaturedBeatsSection(),
                      
                      
                      // Bottom padding for navigation
                      SizedBox(height: 120.h),
                    ],
                  ),
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
              tabIconsList: tabIconsList,
              changeIndex: (int index) {
                setState(() {
                  _currentNavIndex = index;
                });
              },
              addClick: () {
                print('Add button tapped!');
              },
            ),
          ),
        ],
      ),
    );
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

  Widget _buildLivestreamsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Livestreams',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
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
          height: 160.h,
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
    return Container(
      height: 160.h,
      decoration: BoxDecoration(
        color: AppTheme.glassColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.glassBorder,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: LinearGradient(
                colors: [
                  AppTheme.glassLight,
                  AppTheme.glassColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          
          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Live indicator with animation
                AnimatedBuilder(
                  animation: _liveAnimationController,
                  builder: (context, child) {
                    final animationValue = _liveAnimationController.value;
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(
                            0.3 + (0.7 * animationValue),
                          ),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(
                              0.2 * animationValue,
                            ),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.radio_button_checked,
                            color: Colors.white.withOpacity(
                              0.7 + (0.3 * animationValue),
                            ),
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
                
                const Spacer(),
                
                // Title
                Text(
                  title,
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: 4.h),
                
                // Subtitle
                Text(
                  subtitle,
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: 8.h),
                
                // Viewers count
                Row(
                  children: [
                    Icon(
                      Icons.visibility,
                      color: accentColor,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      viewers,
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedBeatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Featured Auctions',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: beatsData.length,
          itemBuilder: (context, index) {
            return BeatListView(
              beatData: beatsData[index],
              callback: () {
                print('Beat tapped: ${beatsData[index].title}');
              },
            );
          },
        ),
      ],
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
