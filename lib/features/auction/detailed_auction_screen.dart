import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';


class DetailedAuctionScreen extends StatefulWidget {
  final String beatTitle;
  final String producerName;
  final int currentBid;
  final int timeRemaining;

  const DetailedAuctionScreen({
    super.key,
    required this.beatTitle,
    required this.producerName,
    required this.currentBid,
    required this.timeRemaining,
  });

  @override
  State<DetailedAuctionScreen> createState() => _DetailedAuctionScreenState();
}

class _DetailedAuctionScreenState extends State<DetailedAuctionScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _pulseController;
  
  // Background animation controllers (copied from dashboard)
  late AnimationController _backgroundWaveController;
  late AnimationController _notesController;
  late AnimationController _backgroundPulseController;
  late Animation<double> _waveAnimation;
  late Animation<double> _notesAnimation;
  late Animation<double> _pulseAnimation;
  
  bool _isPlaying = false;
  bool _showBidModal = false;
  bool _showWinModal = false;
  bool _showLoseModal = false;
  bool _showReplayModal = false;
  bool _autoBidEnabled = false;
  
  int _currentBid = 30;
  int _userBid = 0;
  int _maxAutoBid = 20;
  String _bidAmount = '';
  
  final TextEditingController _bidController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final List<String> _comments = [
    'Lumpiaxpapi\nWowwwwww',
    'pcgmc\nawesome beat',
    'Lumpiaxpapi\n🔥🔥🔥',
    'pcgmc\nawesome beat',
  ];
  
  List<String> _recentReactions = [];
  
  // Music player state
  bool _isTrackPlaying = false;
  double _trackProgress = 0.0;
  Timer? _progressTimer;
  // Dynamic track info will use widget.beatTitle and widget.producerName
  
  // Emoji reactions
  Timer? _emojiCleanupTimer;

  @override
  void initState() {
    super.initState();
    _currentBid = widget.currentBid;
    
    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    // Initialize background animations (copied from dashboard)
    _backgroundWaveController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
    
    _notesController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();
    
    _backgroundPulseController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    _waveAnimation = Tween<double>(begin: 0, end: 1).animate(_backgroundWaveController);
    _notesAnimation = Tween<double>(begin: 0, end: 1).animate(_notesController);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _backgroundPulseController, curve: Curves.easeInOut),
    );
    
    // Start music player simulation
    _startMusicPlayer();
    
    // Auto-start music player
  }

  @override
  void dispose() {
    _waveController.dispose();
    _pulseController.dispose();
    _bidController.dispose();
    _commentController.dispose();
    
    // Dispose background animation controllers
    _backgroundWaveController.dispose();
    _notesController.dispose();
    _backgroundPulseController.dispose();
    
    // Dispose music player and emoji timers
    _progressTimer?.cancel();
    _emojiCleanupTimer?.cancel();
    
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }
  
  void _startMusicPlayer() {
    setState(() {
      _isTrackPlaying = true;
    });
    
    _progressTimer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_isTrackPlaying && mounted) {
        setState(() {
          _trackProgress += 0.001; // Simulate track progress
          if (_trackProgress >= 1.0) {
            _trackProgress = 0.0; // Loop the track
          }
        });
      }
    });
  }
  
  void _toggleMusicPlayer() {
    setState(() {
      _isTrackPlaying = !_isTrackPlaying;
    });
  }
  

  void _showBidOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBidOptionsModal(),
    );
  }

  void _placeBid(int amount) {
    setState(() {
      _currentBid = amount;
      _userBid = amount;
    });
    Navigator.pop(context);
    
    // Simulate auction ending after bid
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _showAuctionResult();
      }
    });
  }

  void _showAuctionResult() {
    // Randomly determine win/lose for demo
    bool won = DateTime.now().millisecondsSinceEpoch % 2 == 0;
    
    if (won) {
      _showWinningModal();
    } else {
      _showLosingModal();
    }
  }

  void _showWinningModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildWinModal(),
    );
  }

  void _showLosingModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildLoseModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: Stack(
        children: [
          // Animated Music Background (copied from dashboard)
          _buildAnimatedBackground(),
          
          // Main content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
              // Status bar and header
              _buildHeader(),
              
              // Beat title
              _buildBeatTitle(),
              
              // Time progress
              _buildTimeProgress(),
              
              // Beat visualization with overlaid comments
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Beat visualizer (full area)
                    _buildBeatVisualization(),
                    
                    
                    
                    // Side controls (moved inside main content)
                    Positioned(
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildSideButton(Icons.equalizer, 'Beats'),
                          SizedBox(height: 16.h),
                          _buildSideButton(Icons.info_outline, ''),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Bottom controls
              _buildBottomControls(),
            ],
            ),
          ),
          
          // Comments overlay positioned in main stack
          Positioned(
            bottom: 250.h,
            left: 0,
            right: 0,
            child: _buildCommentsSection(),
          ),
          
          // Streaming emojis overlay (temporarily disabled)
          // _buildStreamingEmojisOverlay(),
        ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.h,
        left: 24.w,
        right: 24.w,
        bottom: 16.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppTheme.glassColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppTheme.glassBorder),
                ),
                child: Text(
                  '\$$_currentBid',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppTheme.glassColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppTheme.glassBorder),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.people,
                      color: AppTheme.textPrimary,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '248',
                      style: TextStyle(
                        fontFamily: 'Wix Madefor Display',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBeatTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          // Track info
          Text(
            widget.beatTitle,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
        ],
      ),
    );
  }

  Widget _buildTimeProgress() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Play/pause button
          GestureDetector(
            onTap: _toggleMusicPlayer,
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.glassColor,
                border: Border.all(color: AppTheme.glassBorder),
              ),
              child: Icon(
                _isTrackPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 16.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          
          Text(
            '${(_trackProgress * 180).toInt() ~/ 60}:${((_trackProgress * 180).toInt() % 60).toString().padLeft(2, '0')}',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 12.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              height: 2.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(1.r),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _trackProgress,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.r),
                  ),
                ),
              ),
            ),
          ),
          Text(
            '3:00',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 12.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentBidInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppTheme.glassColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTheme.glassBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '\$${_currentBid}',
            style: TextStyle(
              fontFamily: 'Wix Madefor Display',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeatVisualization() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Music Visualizer Background
          AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              return CustomPaint(
                size: Size(280.w, 280.w),
                painter: MusicVisualizerPainter(
                  animation: _waveController.value,
                  isPlaying: _isTrackPlaying,
                ),
              );
            },
          ),
          
          // Main beat circle
          Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.glassColor,
                  AppTheme.backgroundColor,
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Wave pattern
                CustomPaint(
                  size: Size(180.w, 180.w),
                  painter: WavePainter(
                    animation: _waveController,
                    isPlaying: _isPlaying,
                  ),
                ),
                
                // Play/pause controls
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _togglePlay,
                      child: Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.glassColor,
                          border: Border.all(color: AppTheme.glassBorder),
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: AppTheme.textPrimary,
                          size: 24.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'LIVE',
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.7),
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

  Widget _buildSideButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.1),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20.sp,
          ),
        ),
        if (label.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Wix Madefor Display',
              fontSize: 10.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEmojiSection() {
    return Container(
      height: 45.h,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildEmojiButton('❤️'),
          _buildEmojiButton('🔥'),
          _buildEmojiButton('😍'),
          _buildEmojiButton('🎵'),
          _buildEmojiButton('👏'),
        ],
      ),
    );
  }

  Widget _buildEmojiButton(String emoji) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  emoji,
                  style: TextStyle(fontSize: 32.sp),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Reacted!',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.black.withOpacity(0.9),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: 200.h,
              left: 20.w,
              right: 20.w,
            ),
            duration: Duration(milliseconds: 2000),
          ),
        );
      },
      child: Container(
        width: 35.w,
        height: 35.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Center(
          child: Text(
            emoji,
            style: TextStyle(fontSize: 20.sp),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Container(
      height: 150.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ListView.builder(
        itemCount: _comments.length,
        itemBuilder: (context, index) {
          final comment = _comments[index].split('\n');
          return Container(
            margin: EdgeInsets.only(bottom: 6.h),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment[0],
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      if (comment.length > 1)
                        Text(
                          comment[1],
                          style: GoogleFonts.getFont(
                            'Wix Madefor Display',
                            fontSize: 11.sp,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          // Recent reactions display
          if (_recentReactions.isNotEmpty)
            Container(
              height: 40.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _recentReactions.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      _recentReactions[index],
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ).animate(delay: (index * 100).ms)
                    .fadeIn(duration: 300.ms)
                    .scale(begin: Offset(0.5, 0.5), end: Offset(1.0, 1.0));
                },
              ),
            ),
          
          if (_recentReactions.isNotEmpty) SizedBox(height: 16.h),
          
          // Emoji reactions
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ['😍', '🔥', '😮', '😎', '🔥', '😊'].asMap().entries.map((entry) {
              int index = entry.key;
              String emoji = entry.value;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _recentReactions.add(emoji);
                    // Keep only last 5 reactions
                    if (_recentReactions.length > 5) {
                      _recentReactions.removeAt(0);
                    }
                  });
                  
                  // Show floating emoji animation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            emoji,
                            style: TextStyle(fontSize: 32.sp),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Reacted!',
                            style: GoogleFonts.getFont(
                              'Wix Madefor Display',
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      duration: Duration(milliseconds: 2000),
                      backgroundColor: Colors.black.withOpacity(0.9),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                        bottom: 200.h,
                        left: 50.w,
                        right: 50.w,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ).animate(delay: (index * 100).ms)
                  .fadeIn(duration: 600.ms)
                  .scale(begin: Offset(0.8, 0.8), end: Offset(1.0, 1.0))
                  .then()
                  .animate(target: 0)
                  .scale(
                    duration: 200.ms,
                    curve: Curves.bounceOut,
                  ),
              );
            }).toList(),
          ),
          
          SizedBox(height: 16.h),
          
          
          SizedBox(height: 16.h),
          
          // Emoji section above comment input
          _buildEmojiSection(),
          
          SizedBox(height: 12.h),
          
          // Comment input
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: TextField(
              controller: _commentController,
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 14.sp,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Say something...',
                hintStyle: TextStyle(
                  fontFamily: 'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
                border: InputBorder.none,
                suffixIcon: GestureDetector(
                  onTap: () {
                    if (_commentController.text.isNotEmpty) {
                      setState(() {
                        _comments.insert(0, 'You\n${_commentController.text}');
                        _commentController.clear();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green, size: 20.sp),
                              SizedBox(width: 8.w),
                              Text(
                                'Comment posted!',
                                style: GoogleFonts.getFont(
                                  'Wix Madefor Display',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          duration: Duration(milliseconds: 1500),
                          backgroundColor: Colors.black.withOpacity(0.8),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Bid buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showAutoBidModal(),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: AppTheme.glassColor,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppTheme.glassBorder),
                    ),
                    child: Text(
                      'Auto Bid \$${_maxAutoBid}',
                      style: TextStyle(
                        fontFamily: 'Wix Madefor Display',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: GestureDetector(
                  onTap: _showBidOptions,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      'Bid',
                      style: TextStyle(
                        fontFamily: 'Wix Madefor Display',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBidOptionsModal() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                // Auto Bid Option
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _showAutoBidModal();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppTheme.glassColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppTheme.glassBorder),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Auto-Bid',
                          style: TextStyle(
                            fontFamily: 'Wix Madefor Display',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Set your max bid and let the\nsystem handle the rest',
                          style: TextStyle(
                            fontFamily: 'Wix Madefor Display',
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                // Custom Bid Option
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _showCustomBidModal();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: AppTheme.glassColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppTheme.glassBorder),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Custom Bid',
                          style: TextStyle(
                            fontFamily: 'Wix Madefor Display',
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Place your own bid and see\nthe result instantly',
                          style: TextStyle(
                            fontFamily: 'Wix Madefor Display',
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAutoBidModal() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppTheme.glassBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Auto-Bid',
                    style: TextStyle(
                      fontFamily: 'Wix Madefor Display',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: AppTheme.textPrimary,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16.h),
              
              Text(
                'Set your max bid and let the\nsystem handle the rest',
                style: TextStyle(
                  fontFamily: 'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 24.h),
              
              Text(
                'Max Bid',
                style: TextStyle(
                  fontFamily: 'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              
              SizedBox(height: 8.h),
              
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppTheme.glassColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppTheme.glassBorder),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setModalState(() {
                          if (_maxAutoBid > 5) _maxAutoBid -= 5;
                        });
                        setState(() {}); // Update parent widget too
                      },
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    Text(
                      '\$$_maxAutoBid',
                      style: TextStyle(
                        fontFamily: 'Wix Madefor Display',
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setModalState(() {
                          _maxAutoBid += 5;
                        });
                        setState(() {}); // Update parent widget too
                      },
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24.h),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _placeBid(_maxAutoBid);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.textPrimary,
                    foregroundColor: AppTheme.backgroundColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Confirm Max-Bid',
                    style: TextStyle(
                      fontFamily: 'Wix Madefor Display',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
        ),
    );
  }

  void _showCustomBidModal() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppTheme.glassBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Custom Bid',
                    style: TextStyle(
                      fontFamily: 'Wix Madefor Display',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: AppTheme.textPrimary,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16.h),
              
              Text(
                'Place your own bid and see\nthe result instantly',
                style: TextStyle(
                  fontFamily: 'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: 24.h),
              
              Text(
                'Your Bid',
                style: TextStyle(
                  fontFamily: 'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              
              SizedBox(height: 8.h),
              
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppTheme.glassColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppTheme.glassBorder),
                ),
                child: TextField(
                  controller: _bidController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      color: Colors.white.withOpacity(0.7),
                    ),
                    border: InputBorder.none,
                    prefixText: '\$',
                    prefixStyle: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _bidAmount = value;
                    });
                  },
                ),
              ),
              
              SizedBox(height: 24.h),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    int bidAmount = int.tryParse(_bidController.text) ?? 55;
                    Navigator.pop(context);
                    _placeBid(bidAmount);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.textPrimary,
                    foregroundColor: AppTheme.backgroundColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Place Bid',
                    style: TextStyle(
                      fontFamily: 'Wix Madefor Display',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWinModal() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppTheme.glassBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Confetti animation background
            Container(
              width: double.infinity,
              height: 200.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated particles
                  ...List.generate(20, (index) {
                    return Positioned(
                      left: (index * 15.0) % 300,
                      top: (index * 10.0) % 150,
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: [
                            Colors.yellow,
                            Colors.blue,
                            Colors.red,
                            Colors.green,
                          ][index % 4],
                        ),
                      ).animate(delay: (index * 100).ms)
                        .fadeIn(duration: 600.ms)
                        .scale(begin: Offset(0, 0), end: Offset(1, 1))
                        .then()
                        .shake(duration: 1000.ms),
                    );
                  }),
                  
                  // Main content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You won\nthe beat!',
                        style: TextStyle(
                          fontFamily: 'Wix Madefor Display',
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: 16.h),
                      
                      Text(
                        'Congrats! This beat is yours now.',
                        style: TextStyle(
                          fontFamily: 'Wix Madefor Display',
                          fontSize: 16.sp,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Download button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Handle download
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Beat downloaded successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.textPrimary,
                  foregroundColor: AppTheme.backgroundColor,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Download License',
                  style: TextStyle(
                    fontFamily: 'Wix Madefor Display',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Share buttons
            Text(
              'Share this with your friends',
              style: TextStyle(
                fontFamily: 'Wix Madefor Display',
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            
            SizedBox(height: 16.h),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildShareButton(Icons.camera_alt),
                SizedBox(width: 16.w),
                _buildShareButton(Icons.music_note),
                SizedBox(width: 16.w),
                _buildShareButton(Icons.close),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoseModal() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppTheme.glassBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.close,
                  color: AppTheme.textPrimary,
                  size: 24.sp,
                ),
              ),
            ),
            
            SizedBox(height: 16.h),
            
            Text(
              'Auction Ended',
              style: TextStyle(
                fontFamily: 'Wix Madefor Display',
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            
            SizedBox(height: 8.h),
            
            Text(
              'Final Price: \$168',
              style: TextStyle(
                fontFamily: 'Wix Madefor Display',
                fontSize: 16.sp,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            Text(
              'You didn\'t win this time. Try again or\nfollow the producer!',
              style: TextStyle(
                fontFamily: 'Wix Madefor Display',
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 24.h),
            
            // Producer info
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppTheme.glassColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppTheme.glassBorder),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.batteryColor,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: SizedBox(), // Empty space where William Grace text was
                  ),
                  Icon(
                    Icons.add,
                    color: AppTheme.textPrimary,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Watch replay button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showReplayScreen();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.textPrimary,
                  foregroundColor: AppTheme.backgroundColor,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Watch replay',
                  style: TextStyle(
                    fontFamily: 'Wix Madefor Display',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton(IconData icon) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.glassColor,
        border: Border.all(color: AppTheme.glassBorder),
      ),
      child: Icon(
        icon,
        color: AppTheme.textPrimary,
        size: 20.sp,
      ),
    );
  }

  void _showReplayScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AuctionReplayScreen(
          beatTitle: widget.beatTitle,
          producerName: widget.producerName,
          finalPrice: 168,
        ),
      ),
    );
  }
}

// Custom painter for wave visualization
class WavePainter extends CustomPainter {
  final Animation<double> animation;
  final bool isPlaying;

  WavePainter({required this.animation, required this.isPlaying});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.textPrimary.withOpacity(0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    if (isPlaying) {
      // Draw animated wave lines
      for (int i = 0; i < 8; i++) {
        final waveRadius = radius * 0.3 + (radius * 0.4 * (i / 8));
        final animatedRadius = waveRadius + (10 * (animation.value + i * 0.1) % 1);
        
        final path = Path();
        for (double angle = 0; angle < 2 * 3.14159; angle += 0.1) {
          final waveHeight = 5 * (1 + 0.5 * (animation.value * 2 + angle) % 1);
          final x = center.dx + (animatedRadius + waveHeight) * cos(angle);
          final y = center.dy + (animatedRadius + waveHeight) * sin(angle);
          
          if (angle == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }
        }
        path.close();
        
        paint.color = AppTheme.textPrimary.withOpacity(0.3 - i * 0.03);
        canvas.drawPath(path, paint);
      }
    } else {
      // Draw static concentric circles
      for (int i = 0; i < 6; i++) {
        final circleRadius = radius * 0.3 + (radius * 0.1 * i);
        paint.color = AppTheme.textPrimary.withOpacity(0.2 - i * 0.03);
        canvas.drawCircle(center, circleRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Add the animated background method and MusicBackgroundPainter (copied from dashboard)
extension DetailedAuctionScreenBackground on _DetailedAuctionScreenState {
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
            sin((x / waveLength * 2 * pi) + waveProgress + (i * 0.5)) * 
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
      final animatedY = baseY + sin(notesProgress * 2 * pi * speed) * 20;
      
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
      final frequency = sin(normalizedI * pi * 4) * 
                       sin(waveProgress * 3 + normalizedI * 6);
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

// Auction Replay Screen
class AuctionReplayScreen extends StatelessWidget {
  final String beatTitle;
  final String producerName;
  final int finalPrice;

  const AuctionReplayScreen({
    super.key,
    required this.beatTitle,
    required this.producerName,
    required this.finalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16.h,
              left: 24.w,
              right: 24.w,
              bottom: 16.h,
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppTheme.textPrimary,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Text(
                  'Auction Replay',
                  style: TextStyle(
                    fontFamily: 'Wix Madefor Display',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          
          // Beat visualization (same as main screen)
          Expanded(
            child: Container(
              margin: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppTheme.glassColor,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppTheme.glassBorder),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200.w,
                      height: 200.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.glassColor,
                            AppTheme.backgroundColor,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.play_arrow,
                          color: AppTheme.textPrimary,
                          size: 48.sp,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    Text(
                      beatTitle,
                      style: TextStyle(
                        fontFamily: 'Wix Madefor Display',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Comments section (same as main screen)
          Container(
            height: 120.h,
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                final comments = [
                  'Lumpiaxpapi\nWowwwwww',
                  'pcgmc\nawesome beat',
                  'Lumpiaxpapi\n🔥🔥🔥',
                  'pcgmc\nawesome beat',
                ];
                final comment = comments[index].split('\n');
                
                return Container(
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppTheme.glassColor,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppTheme.glassBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.batteryColor,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment[0],
                              style: TextStyle(
                                fontFamily: 'Wix Madefor Display',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            if (comment.length > 1)
                              Text(
                                comment[1],
                                style: TextStyle(
                                  fontFamily: 'Wix Madefor Display',
                                  fontSize: 11.sp,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Bottom buttons
          Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                // Tip the Producer button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tip sent to producer!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.textPrimary,
                      foregroundColor: AppTheme.backgroundColor,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Tip the Producer',
                      style: TextStyle(
                        fontFamily: 'Wix Madefor Display',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                // Share Replay button
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: AppTheme.glassColor,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppTheme.glassBorder),
                  ),
                  child: Text(
                    'Share Replay',
                    style: TextStyle(
                      fontFamily: 'Wix Madefor Display',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
}

// Music Visualizer Painter
class MusicVisualizerPainter extends CustomPainter {
  final double animation;
  final bool isPlaying;
  
  MusicVisualizerPainter({required this.animation, required this.isPlaying});
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    if (isPlaying) {
      // Draw professional frequency bars
      for (int i = 0; i < 64; i++) {
        final angle = (i / 64) * 2 * pi;
        
        // Create different frequency patterns
        final freq1 = sin(animation * 4 * pi + i * 0.3) * 0.5 + 0.5;
        final freq2 = sin(animation * 6 * pi + i * 0.2) * 0.3 + 0.3;
        final freq3 = sin(animation * 8 * pi + i * 0.1) * 0.2 + 0.2;
        
        final barHeight = 15 + (freq1 * 25) + (freq2 * 15) + (freq3 * 10);
        
        // Different colors for different frequency ranges
        Color barColor;
        if (i % 4 == 0) {
          barColor = Colors.white.withOpacity(0.8); // Bass
        } else if (i % 3 == 0) {
          barColor = Colors.white.withOpacity(0.6); // Mid
        } else {
          barColor = Colors.white.withOpacity(0.4); // High
        }
        
        final paint = Paint()
          ..color = barColor
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;
        
        final startRadius = radius - 50;
        final endRadius = startRadius - barHeight;
        
        final start = Offset(
          center.dx + cos(angle) * startRadius,
          center.dy + sin(angle) * startRadius,
        );
        
        final end = Offset(
          center.dx + cos(angle) * endRadius,
          center.dy + sin(angle) * endRadius,
        );
        
        canvas.drawLine(start, end, paint);
      }
      
      // Draw multiple pulsing rings
      for (int ring = 0; ring < 3; ring++) {
        final ringPaint = Paint()
          ..color = Colors.white.withOpacity(0.1 + ring * 0.05)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;
        
        final pulseRadius = radius - 30 - (ring * 15) + (sin(animation * 3 * pi + ring) * 8);
        canvas.drawCircle(center, pulseRadius, ringPaint);
      }
      
      // Draw center glow
      final glowPaint = Paint()
        ..color = Colors.white.withOpacity(0.1)
        ..style = PaintingStyle.fill;
      
      final glowRadius = 40 + (sin(animation * 2 * pi) * 5);
      canvas.drawCircle(center, glowRadius, glowPaint);
      
    } else {
      // Draw static professional circles when paused
      final staticPaint = Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      
      for (int i = 0; i < 3; i++) {
        canvas.drawCircle(center, radius - 30 - (i * 20), staticPaint);
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
