import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class CoSignProducerScreen extends StatefulWidget {
  final String producerName;
  final String beatTitle;

  const CoSignProducerScreen({
    Key? key,
    required this.producerName,
    required this.beatTitle,
  }) : super(key: key);

  @override
  State<CoSignProducerScreen> createState() => _CoSignProducerScreenState();
}

class _CoSignProducerScreenState extends State<CoSignProducerScreen> with TickerProviderStateMixin {
  final TextEditingController _cosignController = TextEditingController();
  int _rating = 4; // Default to 4 flames
  late AnimationController _flameAnimationController;
  late List<AnimationController> _flameControllers;

  @override
  void initState() {
    super.initState();
    _flameAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    
    // Create individual animation controllers for each flame
    _flameControllers = List.generate(5, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 300 + (index * 100)),
        vsync: this,
      );
    });
  }

  @override
  void dispose() {
    _cosignController.dispose();
    _flameAnimationController.dispose();
    for (var controller in _flameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitCoSign() {
    if (_cosignController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please write a Co-Sign message',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      );
      return;
    }

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Co-Sign submitted successfully! 🔥',
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

    // Navigate back
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(24.w),
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Title
                Text(
                  'Seal the Win with a Co-Sign',
                  style: GoogleFonts.fjallaOne(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8.h),

                // Subtitle
                Text(
                  'Tell the world why you bagged this beat and leave your mark on the culture.',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 24.h),

                // Co-Sign text input
                Container(
                  constraints: BoxConstraints(
                    minHeight: 120.h,
                    maxHeight: 200.h,
                  ),
                  child: TextField(
                    controller: _cosignController,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type your Co-Sign here...make it Legendary.',
                      hintStyle: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(16.w),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Rate this beat section
                Center(
                  child: Column(
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
                          'Rate this beat',
                          style: GoogleFonts.fjallaOne(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _rating = index + 1;
                              });
                              // Animate the selected flame
                              _flameControllers[index].forward().then((_) {
                                _flameControllers[index].reverse();
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              child: AnimatedBuilder(
                                animation: _flameControllers[index],
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: 1.0 + (_flameControllers[index].value * 0.3),
                                    child: Transform.rotate(
                                      angle: _flameControllers[index].value * 0.1,
                                      child: index < _rating 
                                          ? ShaderMask(
                                              shaderCallback: (bounds) => RadialGradient(
                                                colors: [
                                                  Color(0xFFFF6B35), // Bright orange
                                                  Color(0xFFFF8E53), // Light orange
                                                  Color(0xFFFFA726), // Amber
                                                  Color(0xFFFFB74D), // Light amber
                                                ],
                                                stops: [0.0, 0.3, 0.7, 1.0],
                                                center: Alignment.topCenter,
                                                radius: 1.0,
                                              ).createShader(bounds),
                                              child: Icon(
                                                Icons.local_fire_department,
                                                color: Colors.white,
                                                size: 40.sp,
                                              ),
                                            )
                                          : Icon(
                                              Icons.local_fire_department,
                                              color: Colors.grey.withOpacity(0.5),
                                              size: 40.sp,
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),

                // Co-Sign Producer button
                SizedBox(
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: _submitCoSign,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'Co-Sign Producer',
                        style: GoogleFonts.fjallaOne(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Feature explanation
                Text(
                  'A Co-Sign is your permanent, taggable stamp of approval on a producer\'s sound — visible to their entire audience on their profile.',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
