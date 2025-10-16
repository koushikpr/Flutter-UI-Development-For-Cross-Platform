import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;
import '../../core/theme/app_theme.dart';

class LiveStreamsScreen extends StatefulWidget {
  final String title;
  final String artistName;
  final String viewerCount;
  final String streamDuration;

  const LiveStreamsScreen({
    Key? key,
    required this.title,
    required this.artistName,
    required this.viewerCount,
    required this.streamDuration,
  }) : super(key: key);

  @override
  State<LiveStreamsScreen> createState() => _LiveStreamsScreenState();
}

class _LiveStreamsScreenState extends State<LiveStreamsScreen> with TickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  late AnimationController _commentAnimationController;
  late Animation<Offset> _commentSlideAnimation;
  
  final List<Map<String, String>> _comments = [
    {'username': 'MusicFan123', 'message': 'This live performance is absolutely incredible! Love the energy!'},
    {'username': 'StreamViewer', 'message': 'Amazing vocals! Keep it going!'},
    {'username': 'BeatLover', 'message': 'The production quality is insane!'},
    {'username': 'LiveMusicFan', 'message': 'This is why I love live streams!'},
    {'username': 'ArtistSupporter', 'message': 'You\'re killing it! 🔥'},
  ];
  
  // List of sample usernames for tip notifications
  final List<String> _tipUsernames = [
    'MusicLover2024',
    'BeatFan',
    'StreamSupporter',
    'ArtistFan',
    'LiveViewer',
    'MusicAddict',
    'SoundLover',
  ];
  
  int _currentCommentIndex = 0;
  bool _showEmojiMenu = false;
  late AnimationController _emojiMenuController;
  late Animation<Offset> _emojiMenuAnimation;
  
  // Tip modal state
  double _tipAmount = 0.0;
  
  // Timer state for duration
  late Timer _durationTimer;
  int _totalSeconds = 15 * 60 + 42; // Start from 15:42 (942 seconds)
  String _currentDuration = '15:42';

  @override
  void initState() {
    super.initState();
    _commentAnimationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    
    _commentSlideAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _commentAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _emojiMenuController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    
    _emojiMenuAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _emojiMenuController,
      curve: Curves.easeInOut,
    ));
    
    _startCommentRotation();
    _startDurationTimer();
  }
  
  void _startDurationTimer() {
    _durationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _totalSeconds++;
          int minutes = _totalSeconds ~/ 60;
          int seconds = _totalSeconds % 60;
          _currentDuration = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
        });
      } else {
        timer.cancel();
      }
    });
  }
  
  void _addTipComment(int tipAmount) {
    // Get random username for the tip
    final randomUsername = _tipUsernames[math.Random().nextInt(_tipUsernames.length)];
    
    // Create tip comment
    final tipComment = {
      'username': randomUsername,
      'message': 'just tipped \$${tipAmount}! 💰✨'
    };
    
    // Add to comments list
    setState(() {
      _comments.insert(0, tipComment);
      // Reset to show the new tip comment immediately
      _currentCommentIndex = 0;
      _commentAnimationController.reset();
      _commentAnimationController.forward();
    });
  }
  
  void _startCommentRotation() {
    Timer.periodic(Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _currentCommentIndex = (_currentCommentIndex + 1) % _comments.length;
        });
        _commentAnimationController.reset();
        _commentAnimationController.forward();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/live.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Close button (top right) - ONLY thing at top
            Positioned(
              top: 40.h,
              right: 16.w,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ),
            
            // Live indicator and viewers (top left)
            Positioned(
              top: 40.h,
              left: 16.w,
              child: SafeArea(
                child: Row(
                  children: [
                    // LIVE indicator
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'LIVE',
                            style: GoogleFonts.fjallaOne(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(width: 8.w),
                    
                    // Viewers count
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20.r),
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
                            widget.viewerCount,
                            style: GoogleFonts.fjallaOne(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Bottom section with comment box, stream info, and action buttons
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Stream stats box
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
                              Expanded(
                                flex: 2,
                                child: _buildStatItem('Artist', widget.artistName)
                              ),
                              Expanded(
                                flex: 1,
                                child: _buildStatItem('Duration', _currentDuration)
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 12.h),
                    
                    // Comments and action buttons section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Comments section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SlideTransition(
                                position: _commentSlideAnimation,
                                child: _buildComment(
                                  _comments[_currentCommentIndex]['username']!,
                                  _comments[_currentCommentIndex]['message']!,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              if (_currentCommentIndex > 0)
                                Opacity(
                                  opacity: 0.7,
                                  child: _buildComment(
                                    _comments[(_currentCommentIndex - 1) % _comments.length]['username']!,
                                    _comments[(_currentCommentIndex - 1) % _comments.length]['message']!,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        
                        SizedBox(width: 16.w),
                        
                        // Action buttons
                        Column(
                          children: [
                            _buildActionButton(Icons.share, 'Share'),
                            SizedBox(height: 24.h),
                            _buildActionButton(Icons.attach_money, 'Tip'),
                          ],
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 12.h),
                    
                    // Comment Box with emoji icon (hidden when emoji menu is open)
                    if (!_showEmojiMenu)
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              style: GoogleFonts.getFont(
                                'Wix Madefor Display',
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Comment...',
                                hintStyle: GoogleFonts.getFont(
                                  'Wix Madefor Display',
                                  fontSize: 14.sp,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.6),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                              ),
                            ),
                          ),
                          
                          SizedBox(width: 12.w),
                          
                          // Emoji button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showEmojiMenu = !_showEmojiMenu;
                              });
                              if (_showEmojiMenu) {
                                _emojiMenuController.forward();
                              } else {
                                _emojiMenuController.reverse();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.emoji_emotions,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    
                    // Emoji slider menu (replaces comment box when open)
                    if (_showEmojiMenu)
                      SlideTransition(
                        position: _emojiMenuAnimation,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Emoji buttons
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _buildEmojiButton('⭐'),
                                    _buildEmojiButton('❤️'),
                                    _buildEmojiButton('😂'),
                                    _buildEmojiButton('😍'),
                                    _buildEmojiButton('🔥'),
                                    _buildEmojiButton('👏'),
                                  ],
                                ),
                              ),
                              
                              SizedBox(width: 8.w),
                              
                              // Close button
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showEmojiMenu = false;
                                  });
                                  _emojiMenuController.reverse();
                                },
                                child: Container(
                                  width: 24.w,
                                  height: 24.w,
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 14.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    SizedBox(height: 12.h),
                    
                    // Stream Info
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.videocam,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: GoogleFonts.fjallaOne(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'Live Performance • HD Quality • Interactive Chat',
                                  style: GoogleFonts.getFont(
                                    'Wix Madefor Display',
                                    fontSize: 10.sp,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 12.h),
                    
                    // Follow and Subscribe buttons
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Follow',
                              style: GoogleFonts.fjallaOne(
                                fontSize: 16.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              'Subscribe',
                              style: GoogleFonts.fjallaOne(
                                fontSize: 16.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
              fontSize: 24.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  void _showTipModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            // Header with close button
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24),
                  Text(
                    'Support the Artist ❤️',
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 24.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Subtitle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'Show your appreciation for this\namazing live performance!',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            SizedBox(height: 32.h),
            
            // Tip amount display
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Text(
                  '\$${_tipAmount.toInt()}',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Tip amount buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTipAmountButton(5),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildTipAmountButton(10),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildTipAmountButton(15),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 32.h),
            
            // Send Tip button with gradient
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: GestureDetector(
                onTap: _tipAmount > 0 ? () {
                  final tipAmountInt = _tipAmount.toInt();
                  Navigator.pop(context);
                  
                  // Add tip comment to live stream
                  _addTipComment(tipAmountInt);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Tip of \$${tipAmountInt} sent to the artist! 💖',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  );
                  setState(() {
                    _tipAmount = 0.0; // Reset tip amount
                  });
                } : null,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    gradient: _tipAmount > 0 
                        ? LinearGradient(
                            colors: [Colors.yellow, Colors.green],
                          )
                        : null,
                    color: _tipAmount > 0 ? null : Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.attach_money, 
                        color: _tipAmount > 0 ? Colors.black : Colors.white.withOpacity(0.5), 
                        size: 20.sp
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Send Tip',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: _tipAmount > 0 ? Colors.black : Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTipAmountButton(int amount) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _tipAmount = amount.toDouble();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: _tipAmount == amount.toDouble() 
              ? Colors.white.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: _tipAmount == amount.toDouble()
                ? Colors.white.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Text(
          '+\$${amount}',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == 'Tip') {
          _showTipModal();
        } else if (label == 'Share') {
          // Handle share functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Share functionality coming soon!',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.blue,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 18.sp,
        ),
      ),
    );
  }

  Widget _buildEmojiButton(String emoji) {
    return GestureDetector(
      onTap: () {
        // Add reaction or send as comment
        setState(() {
          _showEmojiMenu = false;
        });
        _emojiMenuController.reverse();
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        child: Text(
          emoji,
          style: TextStyle(
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildComment(String username, String comment) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          children: [
            TextSpan(
              text: '$username ',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: comment,
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentAnimationController.dispose();
    _emojiMenuController.dispose();
    _durationTimer.cancel();
    super.dispose();
  }
}
