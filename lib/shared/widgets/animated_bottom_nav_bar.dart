import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';
import '../models/tab_icon_data.dart';

class AnimatedBottomNavBar extends StatefulWidget {
  const AnimatedBottomNavBar({
    Key? key,
    this.tabIconsList,
    this.changeIndex,
    this.addClick,
    this.userRole = 'artist',
    this.musicPlayerIsPlaying = false,
    this.onRewind,
    this.onPlayPauseChanged,
  }) : super(key: key);

  final Function(int index)? changeIndex;
  final Function()? addClick;
  final List<TabIconData>? tabIconsList;
  final String userRole;
  final bool musicPlayerIsPlaying;
  final VoidCallback? onRewind;
  final VoidCallback? onPlayPauseChanged;

  @override
  _AnimatedBottomNavBarState createState() => _AnimatedBottomNavBarState();
}

class _AnimatedBottomNavBarState extends State<AnimatedBottomNavBar>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  
  // Artist play button state
  int _controlMode = 0; // 0: play/pause, 1: add beats
  AnimationController? _playPauseController;
  AnimationController? _modeController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animationController?.forward();
    
    // Initialize artist-specific animations
    if (widget.userRole == 'artist') {
      _playPauseController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );
      _modeController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );
    }
    
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    _playPauseController?.dispose();
    _modeController?.dispose();
    super.dispose();
  }
  
  void _togglePlayPause() {
    if (widget.userRole != 'artist') return;
    
    // Update animation based on current state
    if (widget.musicPlayerIsPlaying) {
      _playPauseController?.forward();
    } else {
      _playPauseController?.reverse();
    }
    
    // Notify parent about play/pause state change
    widget.onPlayPauseChanged?.call();
    
    // Open music player
    _openMusicPlayer();
  }
  
  void _openMusicPlayer() {
    print('🎵 Play button tapped - Opening music player...');
    // Navigate to music player page (index 2)
    widget.changeIndex?.call(2);
  }
  
  void _switchControlMode() {
    if (widget.userRole != 'artist') return;
    
    setState(() {
      _controlMode = (_controlMode + 1) % 2; // Only 2 modes now
    });
    
    _modeController?.forward().then((_) {
      _modeController?.reverse();
    });
  }
  
  void _handleTap() {
    if (widget.userRole != 'artist') return;
    
    if (_controlMode == 0) {
      // In play/pause mode, toggle play/pause and open music player
      print('🎵 Play button tapped - Opening music player...');
      _togglePlayPause();
    } else {
      // In add beats mode, call add click to open add to store modal
      print('➕ Add button tapped - Opening add to store modal...');
      widget.addClick?.call();
    }
  }
  

  IconData _getCurrentIcon() {
    if (widget.userRole != 'artist') return Icons.add;
    
    switch (_controlMode) {
      case 0: // Play/Pause mode
        return widget.musicPlayerIsPlaying ? Icons.pause : Icons.play_arrow;
      case 1: // Add beats mode
        return Icons.add;
      default:
        return Icons.play_arrow;
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController!,
          builder: (BuildContext context, Widget? child) {
            return Transform(
              transform: Matrix4.translationValues(0.0, 0.0, 0.0),
              child: PhysicalShape(
                color: const Color(0xFF0E1920),
                elevation: 16.0,
                clipper: TabClipper(
                  radius: Tween<double>(begin: 0.0, end: 1.0)
                          .animate(CurvedAnimation(
                              parent: animationController!,
                              curve: Curves.fastOutSlowIn))
                          .value *
                      38.0,
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 62.h,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 8.w,
                          right: 8.w,
                          top: 4.h,
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TabIcons(
                                tabIconData: widget.tabIconsList?[0],
                                removeAllSelect: () {
                                  setRemoveAllSelection(widget.tabIconsList?[0]);
                                  widget.changeIndex!(0);
                                },
                              ),
                            ),
                            Expanded(
                              child: TabIcons(
                                tabIconData: widget.tabIconsList?[1],
                                removeAllSelect: () {
                                  setRemoveAllSelection(widget.tabIconsList?[1]);
                                  widget.changeIndex!(1);
                                },
                              ),
                            ),
                            SizedBox(
                              width: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(CurvedAnimation(
                                          parent: animationController!,
                                          curve: Curves.fastOutSlowIn))
                                      .value *
                                  64.0.w,
                            ),
                            Expanded(
                              child: TabIcons(
                                tabIconData: widget.tabIconsList?[2],
                                removeAllSelect: () {
                                  setRemoveAllSelection(widget.tabIconsList?[2]);
                                  widget.changeIndex!(2);
                                },
                              ),
                            ),
                            Expanded(
                              child: TabIcons(
                                tabIconData: widget.tabIconsList?[3],
                                removeAllSelect: () {
                                  setRemoveAllSelection(widget.tabIconsList?[3]);
                                  widget.changeIndex!(3);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                ),
              ),
            );
          },
        ),
        Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: SizedBox(
            width: 38.w * 2.0,
            height: 38.h + 62.0.h,
            child: Container(
              alignment: Alignment.topCenter,
              color: Colors.transparent,
              child: SizedBox(
                width: 38.w * 2.0,
                height: 38.h * 2.0,
                child: Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: animationController!,
                            curve: Curves.fastOutSlowIn)),
                    child: Transform.scale(
                      scale: 1.0, // Fixed scale
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(8.0.w, 16.0.h),
                                blurRadius: 16.0.r,
                              ),
                            ],
                          ),
                      child: Material(
                        color: Colors.transparent,
                        child: widget.userRole == 'artist' 
                          ? GestureDetector(
                              onTap: _handleTap,
                              onPanEnd: (details) {
                                // Swipe to switch modes
                                if (details.velocity.pixelsPerSecond.dx.abs() > 100) {
                                  _switchControlMode();
                                }
                              },
                              child: AnimatedBuilder(
                                animation: Listenable.merge([_playPauseController, _modeController]),
                                builder: (context, child) {
                                  return AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    transitionBuilder: (Widget child, Animation<double> animation) {
                                      return RotationTransition(
                                        turns: animation,
                                        child: child,
                                      );
                                    },
                                    child: Icon(
                                      _getCurrentIcon(),
                                      key: ValueKey<IconData>(_getCurrentIcon()),
                                      color: const Color(0xFF0E1920),
                                      size: 32.sp,
                                    ),
                                  );
                                },
                              ),
                            )
                          : InkWell(
                              splashColor: AppTheme.accentColor.withOpacity(0.1),
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              onTap: widget.addClick,
                              child: Icon(
                                Icons.add,
                                color: const Color(0xFF0E1920),
                                size: 32.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void setRemoveAllSelection(TabIconData? tabIconData) {
    if (!mounted) return;
    setState(() {
      widget.tabIconsList?.forEach((TabIconData tab) {
        tab.isSelected = false;
        if (tabIconData!.index == tab.index) {
          tab.isSelected = true;
        }
      });
    });
  }
}

class TabIcons extends StatefulWidget {
  const TabIcons({Key? key, this.tabIconData, this.removeAllSelect})
      : super(key: key);

  final TabIconData? tabIconData;
  final Function()? removeAllSelect;

  @override
  _TabIconsState createState() => _TabIconsState();
}

class _TabIconsState extends State<TabIcons> with TickerProviderStateMixin {
  @override
  void initState() {
    widget.tabIconData?.animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          if (!mounted) return;
          widget.removeAllSelect!();
          widget.tabIconData?.animationController?.reverse();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    widget.tabIconData?.animationController?.dispose();
    super.dispose();
  }

  void setAnimation() {
    widget.tabIconData?.animationController?.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            if (!widget.tabIconData!.isSelected) {
              setAnimation();
            }
          },
          child: IgnorePointer(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                ScaleTransition(
                  alignment: Alignment.center,
                  scale: Tween<double>(begin: 0.88, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.tabIconData!.animationController!,
                          curve: const Interval(0.1, 1.0,
                              curve: Curves.fastOutSlowIn))),
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
                    child: Icon(
                      widget.tabIconData!.isSelected 
                          ? (widget.tabIconData!.selectedIconData ?? widget.tabIconData!.iconData)
                          : widget.tabIconData!.iconData,
                      color: widget.tabIconData!.isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.7),
                      size: 24.sp,
                    ),
                  ),
                ),
                Positioned(
                  top: 4.h,
                  left: 6.w,
                  right: 0,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData!.animationController!,
                            curve: const Interval(0.2, 1.0,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 6.w,
                  bottom: 8.h,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData!.animationController!,
                            curve: const Interval(0.5, 0.8,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 4.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6.h,
                  right: 8.w,
                  bottom: 0,
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: widget.tabIconData!.animationController!,
                            curve: const Interval(0.5, 0.6,
                                curve: Curves.fastOutSlowIn))),
                    child: Container(
                      width: 6.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
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
}

class TabClipper extends CustomClipper<Path> {
  TabClipper({this.radius = 38.0});

  final double radius;

  @override
  Path getClip(Size size) {
    final Path path = Path();

    final double v = radius * 2;
    path.lineTo(0, 0);
    path.arcTo(Rect.fromLTWH(0, 0, radius, radius), degreeToRadians(180),
        degreeToRadians(90), false);
    path.arcTo(
        Rect.fromLTWH(
            ((size.width / 2) - v / 2) - radius + v * 0.04, 0, radius, radius),
        degreeToRadians(270),
        degreeToRadians(70),
        false);

    path.arcTo(Rect.fromLTWH((size.width / 2) - v / 2, -v / 2, v, v),
        degreeToRadians(160), degreeToRadians(-140), false);

    path.arcTo(
        Rect.fromLTWH((size.width - ((size.width / 2) - v / 2)) - v * 0.04, 0,
            radius, radius),
        degreeToRadians(200),
        degreeToRadians(70),
        false);
    path.arcTo(Rect.fromLTWH(size.width - radius, 0, radius, radius),
        degreeToRadians(270), degreeToRadians(90), false);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    final double radian = (math.pi / 180) * degree;
    return radian;
  }
}
