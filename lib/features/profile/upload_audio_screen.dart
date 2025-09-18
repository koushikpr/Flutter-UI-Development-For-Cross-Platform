import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/custom_status_bar.dart';
import 'add_beat_audio_screen.dart';

class UploadAudioScreen extends StatefulWidget {
  final String beatTitle;
  final String beatPrice;
  final bool allowBundling;
  final String description;

  const UploadAudioScreen({
    super.key,
    required this.beatTitle,
    required this.beatPrice,
    required this.allowBundling,
    required this.description,
  });

  @override
  State<UploadAudioScreen> createState() => _UploadAudioScreenState();
}

class _UploadAudioScreenState extends State<UploadAudioScreen> {
  bool _hasUploadedAudio = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Status Bar with Back Button
          Container(
            color: Colors.black,
            child: Column(
              children: [
                const CustomStatusBar(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Main Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  
                  // Beat Cover Art
                  Container(
                    width: 200.w,
                    height: 200.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: CustomPaint(
                      painter: WavePatternPainter(),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Beat Title
                  Text(
                    widget.beatTitle,
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: 60.h),
                  
                  // Upload Audio Section
                  _buildUploadSection(),
                  
                  const Spacer(),
                ],
              ),
            ),
          ),
          
          // Continue Button
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Container(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: _hasUploadedAudio ? _onContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _hasUploadedAudio ? Colors.white : Colors.grey.shade600,
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
                    color: _hasUploadedAudio ? Colors.black : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          // Upload Icon
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.upload_file,
              color: Colors.white.withOpacity(0.8),
              size: 24.sp,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Upload Text
          Text(
            'Upload audio',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          
          SizedBox(height: 24.h),
          
          // Upload Options
          Row(
            children: [
              Expanded(
                child: _buildUploadOption(
                  'FL Studio',
                  Icons.music_video,
                  _uploadFromFLStudio,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildUploadOption(
                  'MP3/WAV',
                  Icons.audiotrack,
                  _uploadAudioFile,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadOption(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppTheme.accentColor,
              size: 24.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _uploadFromFLStudio() {
    print('🎹 Uploading from FL Studio...');
    _showUploadResult('FL Studio file uploaded successfully!');
    setState(() {
      _hasUploadedAudio = true;
    });
  }

  void _uploadAudioFile() {
    print('🎵 Uploading audio file...');
    _showUploadResult('Audio file uploaded successfully!');
    setState(() {
      _hasUploadedAudio = true;
    });
  }

  void _showUploadResult(String message) {
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

  void _onContinue() {
    // Navigate to the preview/audio details screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddBeatAudioScreen(
          beatTitle: widget.beatTitle,
          beatPrice: widget.beatPrice,
          allowBundling: widget.allowBundling,
          description: widget.description,
        ),
      ),
    );
  }
}

class WavePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw wave pattern similar to the screenshot
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Draw multiple concentric wave lines
    for (int i = 0; i < 8; i++) {
      final path = Path();
      final amplitude = 20.0 + (i * 8.0);
      final frequency = 0.02 + (i * 0.005);
      
      for (double x = 0; x <= size.width; x += 2) {
        final y = centerY + amplitude * 
            (0.5 + 0.5 * (x / size.width)) * 
            (1 - (i * 0.1));
        
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
