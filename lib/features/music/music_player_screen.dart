import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class MusicPlayerScreen extends StatefulWidget {
  final bool? initialPlayState;
  final VoidCallback? onPlayStateChanged;
  final VoidCallback? onRewind;
  
  const MusicPlayerScreen({
    super.key,
    this.initialPlayState,
    this.onPlayStateChanged,
    this.onRewind,
  });

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _notesController;
  late AnimationController _pulseController;
  late AnimationController _visualizerController;
  
  late Animation<double> _waveAnimation;
  late Animation<double> _notesAnimation;
  late Animation<double> _pulseAnimation;
  
  bool _isPlaying = false;
  double _progress = 0.0;
  Timer? _progressTimer;
  
  // Song data
  int _currentSongIndex = 0;
  final List<Map<String, String>> _songs = [
    {
      'title': 'Midnight Waves',
      'artist': 'Unknown Artist',
      'image': 'assets/waves.jpg',
    },
    {
      'title': 'Ocean Dreams',
      'artist': 'Mystic Sounds',
      'image': 'assets/waves.jpg',
    },
    {
      'title': 'Digital Horizon',
      'artist': 'Future Beats',
      'image': 'assets/waves.jpg',
    },
    {
      'title': 'Neon Nights',
      'artist': 'Cyber Wave',
      'image': 'assets/waves.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    
    // Set initial play state from navigation bar
    _isPlaying = widget.initialPlayState ?? false;
    
    // Initialize animation controllers
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _notesController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _visualizerController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    )..repeat();
    
    // Initialize animations
    _waveAnimation = Tween<double>(begin: 0, end: 1).animate(_waveController);
    _notesAnimation = Tween<double>(begin: 0, end: 1).animate(_notesController);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut)
    );
    
    // Start progress if initially playing
    if (_isPlaying) {
      _startProgress();
    }
  }

  @override
  void didUpdateWidget(MusicPlayerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update play state when external state changes
    if (widget.initialPlayState != oldWidget.initialPlayState) {
      setState(() {
        _isPlaying = widget.initialPlayState ?? false;
      });
      
      if (_isPlaying) {
        _startProgress();
      } else {
        _progressTimer?.cancel();
      }
    }
    
  }

  @override
  void dispose() {
    _waveController.dispose();
    _notesController.dispose();
    _pulseController.dispose();
    _visualizerController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    
    if (_isPlaying) {
      _startProgress();
    } else {
      _progressTimer?.cancel();
    }
    
    // Notify parent about play state change
    widget.onPlayStateChanged?.call();
  }

  void _startProgress() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress += 0.001;
        if (_progress >= 1.0) {
          _progress = 1.0;
          _isPlaying = false;
          timer.cancel();
        }
      });
    });
  }
  
  void _nextSong() {
    setState(() {
      _currentSongIndex = (_currentSongIndex + 1) % _songs.length;
      _progress = 0.0; // Reset progress for new song
    });
    
    // Restart progress if currently playing
    if (_isPlaying) {
      _startProgress();
    }
  }
  
  void _previousSong() {
    setState(() {
      _currentSongIndex = (_currentSongIndex - 1 + _songs.length) % _songs.length;
      _progress = 0.0; // Reset progress for new song
    });
    
    // Restart progress if currently playing
    if (_isPlaying) {
      _startProgress();
    }
  }
  
  Map<String, String> get _currentSong => _songs[_currentSongIndex];
  
  void rewindSong() {
    setState(() {
      // Rewind by 10 seconds or to beginning if less than 10 seconds
      double rewindAmount = 10.0 / 180.0; // 10 seconds out of 3 minutes
      _progress = (_progress - rewindAmount).clamp(0.0, 1.0);
    });
    
    // Restart progress if currently playing
    if (_isPlaying) {
      _startProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // Animated Music Background (same as home page)
            _buildAnimatedBackground(),
            
            // Main Content
            Column(
              children: [
                // Header
                _buildHeader(),
            
            // Album Art with Visualizer
            _buildAlbumArtSection(),
            
            SizedBox(height: 20.h),
            
            // Song Info
            _buildSongInfo(),
            
            SizedBox(height: 16.h),
            
            // Progress Bar
            _buildProgressBar(),
            
            // Spacer to push content up
            Expanded(child: SizedBox()),
            
            SizedBox(height: 40.h),
              ],
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

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
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
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ),
          ),
          
          Expanded(
            child: Center(
              child: Text(
                'Now Playing',
                style: GoogleFonts.fjallaOne(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
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
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: () {},
                child: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumArtSection() {
    return Center(
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Detect swipe direction
          if (details.primaryVelocity != null) {
            if (details.primaryVelocity! > 100) {
              // Swipe right - previous song
              _previousSong();
            } else if (details.primaryVelocity! < -100) {
              // Swipe left - next song
              _nextSong();
            }
          }
        },
        child: Container(
          width: 280.w,
          height: 280.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Circular effects behind the image
              AnimatedBuilder(
                animation: _visualizerController,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(280.w, 280.h),
                    painter: CircularEffectsPainter(
                      animation: _visualizerController.value,
                      isPlaying: _isPlaying,
                    ),
                  );
                },
              ),
              
              // Circular Album Art
              Container(
                width: 200.w,
                height: 200.w, // Use width for both to ensure perfect circle
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(_currentSong['image']!),
                        fit: BoxFit.cover,
                      ),
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

  Widget _buildSongInfo() {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Detect swipe direction
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! > 100) {
            // Swipe right - previous song
            _previousSong();
          } else if (details.primaryVelocity! < -100) {
            // Swipe left - next song
            _nextSong();
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 8.h),
        child: Column(
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
                _currentSong['title']!,
                style: GoogleFonts.fjallaOne(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            SizedBox(height: 8.h),
            
            Text(
              _currentSong['artist']!,
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16.r),
              activeTrackColor: AppTheme.accentColor,
              inactiveTrackColor: Colors.white.withOpacity(0.2),
              thumbColor: AppTheme.accentColor,
              overlayColor: AppTheme.accentColor.withOpacity(0.2),
            ),
            child: Slider(
              value: _progress,
              onChanged: (value) {
                setState(() {
                  _progress = value;
                });
              },
            ),
          ),
          
          SizedBox(height: 8.h),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_progress * 180), // 3 minutes total
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              Text(
                '3:00',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  String _formatDuration(double seconds) {
    int minutes = (seconds / 60).floor();
    int secs = (seconds % 60).floor();
    return '${minutes}:${secs.toString().padLeft(2, '0')}';
  }
}

// Circular Effects Painter for behind the waves.jpg
class CircularEffectsPainter extends CustomPainter {
  final double animation;
  final bool isPlaying;
  
  CircularEffectsPainter({required this.animation, required this.isPlaying});
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    if (isPlaying) {
      _drawAnimatedCircles(canvas, center, paint);
    } else {
      _drawStaticCircles(canvas, center, paint);
    }
  }
  
  void _drawAnimatedCircles(Canvas canvas, Offset center, Paint paint) {
    // Draw pulsing concentric circles only
    for (int i = 0; i < 4; i++) {
      final baseRadius = 130.0 + (i * 40.0);
      final radius = baseRadius + (sin(animation * 2 * pi + i * 0.5) * 8.0);
      paint.color = Colors.white.withOpacity(0.08 - i * 0.015);
      paint.strokeWidth = 1.5;
      canvas.drawCircle(center, radius, paint);
    }
  }
  
  void _drawStaticCircles(Canvas canvas, Offset center, Paint paint) {
    // Draw static concentric circles
    for (int i = 0; i < 3; i++) {
      final radius = 130.0 + (i * 40.0);
      paint.color = Colors.white.withOpacity(0.06 - i * 0.015);
      paint.strokeWidth = 1.5;
      canvas.drawCircle(center, radius, paint);
    }
  }
  
  @override
  bool shouldRepaint(CircularEffectsPainter oldDelegate) => 
    animation != oldDelegate.animation || isPlaying != oldDelegate.isPlaying;
}

// Music Visualizer Painter
class MusicVisualizerPainter extends CustomPainter {
  final double animation;
  final bool isPlaying;
  
  MusicVisualizerPainter({required this.animation, required this.isPlaying});
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    
    if (isPlaying) {
      _drawActiveVisualizer(canvas, center, radius);
    } else {
      _drawStaticVisualizer(canvas, center, radius);
    }
  }
  
  void _drawActiveVisualizer(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // Draw animated circles
    for (int i = 0; i < 5; i++) {
      final circleRadius = radius * (0.3 + i * 0.15) * (1 + sin(animation * 2 * pi + i) * 0.1);
      paint.color = Colors.white.withOpacity(0.3 - i * 0.05);
      canvas.drawCircle(center, circleRadius, paint);
    }
    
    // Draw frequency bars in circle
    paint.style = PaintingStyle.fill;
    final barCount = 32;
    for (int i = 0; i < barCount; i++) {
      final angle = (i / barCount) * 2 * pi;
      final barHeight = 20 + 30 * sin(animation * 4 * pi + i * 0.5);
      final startRadius = radius * 0.6;
      final endRadius = startRadius + barHeight;
      
      final startX = center.dx + cos(angle) * startRadius;
      final startY = center.dy + sin(angle) * startRadius;
      final endX = center.dx + cos(angle) * endRadius;
      final endY = center.dy + sin(angle) * endRadius;
      
      paint.color = Colors.white.withOpacity(0.4);
      paint.strokeWidth = 3;
      paint.style = PaintingStyle.stroke;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }
  
  void _drawStaticVisualizer(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    // Draw static concentric circles
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(center, radius * (0.4 + i * 0.2), paint);
    }
  }
  
  @override
  bool shouldRepaint(MusicVisualizerPainter oldDelegate) => 
    animation != oldDelegate.animation || isPlaying != oldDelegate.isPlaying;
}

// Music Background Painter (same as home page)
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
    // Simple musical note representation
    final rect = Rect.fromCenter(
      center: position,
      width: size * 0.6,
      height: size * 0.8,
    );
    canvas.drawOval(rect, paint);
    
    // Note stem
    final stemPaint = Paint()
      ..color = paint.color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    canvas.drawLine(
      Offset(position.dx + size * 0.3, position.dy),
      Offset(position.dx + size * 0.3, position.dy - size * 1.5),
      stemPaint,
    );
  }

  void _drawPulsingCircles(Canvas canvas, Size size, Paint paint) {
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    paint.color = Colors.white.withOpacity(0.02);
    
    final center = Offset(size.width / 2, size.height / 2);
    
    for (int i = 0; i < 5; i++) {
      final radius = (80 + i * 40) * pulseScale;
      canvas.drawCircle(center, radius, paint);
    }
  }

  void _drawFrequencyBars(Canvas canvas, Size size, Paint paint) {
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white.withOpacity(0.02);
    
    final barWidth = size.width / 25;
    final maxHeight = size.height * 0.15;
    
    for (int i = 0; i < 25; i++) {
      final x = i * barWidth;
      final height = maxHeight * (0.3 + 0.7 * sin(waveProgress * 3 + i * 0.5));
      
      canvas.drawRect(
        Rect.fromLTWH(x, size.height - height, barWidth * 0.8, height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(MusicBackgroundPainter oldDelegate) => true;
}
