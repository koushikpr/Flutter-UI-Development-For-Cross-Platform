import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:ui';
import '../../core/theme/app_theme.dart';

class LiveAuctionScreen extends StatefulWidget {
  final String title;
  final String currentBid;
  final String timeLeft;
  final String bidCount;

  const LiveAuctionScreen({
    Key? key,
    required this.title,
    required this.currentBid,
    required this.timeLeft,
    required this.bidCount,
  }) : super(key: key);

  @override
  State<LiveAuctionScreen> createState() => _LiveAuctionScreenState();
}

class _LiveAuctionScreenState extends State<LiveAuctionScreen> with TickerProviderStateMixin {
  final TextEditingController _commentController = TextEditingController();
  late AnimationController _commentAnimationController;
  late Animation<Offset> _commentSlideAnimation;
  
  final List<Map<String, String>> _comments = [
    {'username': 'DreBeatz', 'message': 'This is an awesome beat that really gets you moving and makes you want to dance!'},
    {'username': 'MusicFan123', 'message': 'Fire beat! This is incredible!'},
    {'username': 'ProducerLife', 'message': 'The drop is insane!'},
    {'username': 'BeatLover', 'message': 'This goes hard! Love it!'},
    {'username': 'HipHopHead', 'message': 'Need this in my playlist ASAP!'},
  ];
  
  int _currentCommentIndex = 0;
  bool _showEmojiMenu = false;
  late AnimationController _emojiMenuController;
  late Animation<Offset> _emojiMenuAnimation;

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
            image: AssetImage('live.jpg'),
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
            
            // Bottom section with comment box, beat info, and bid buttons
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
                    // Stats box (moved to bottom)
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
                              Expanded(child: _buildStatItem('Current Bid', widget.currentBid)),
                              Expanded(child: _buildStatItem('Time Left', widget.timeLeft)),
                              Expanded(child: _buildStatItem('# of Bids', widget.bidCount)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 12.h),
                    
                    // Comments and action buttons section (moved to bottom)
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
                    
                    // Beat Info
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
                              Icons.music_note,
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
                                  'Favella - ManuGTB',
                                  style: GoogleFonts.fjallaOne(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '2:36 • Hip-hop • 143 BPM • C minor',
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
                    
                    // Auto Bid and Bid buttons
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
                              'Auto Bid',
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
                              'Bid',
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

  Widget _buildActionButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
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
    super.dispose();
  }
}
