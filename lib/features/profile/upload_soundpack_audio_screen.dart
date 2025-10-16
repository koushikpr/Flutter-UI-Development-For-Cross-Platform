import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_soundpack_audio_screen.dart';

class UploadSoundpackAudioScreen extends StatefulWidget {
  final String soundpackTitle;
  final String soundpackPrice;
  final bool allowBundling;
  final String description;

  const UploadSoundpackAudioScreen({
    super.key,
    required this.soundpackTitle,
    required this.soundpackPrice,
    required this.allowBundling,
    required this.description,
  });

  @override
  State<UploadSoundpackAudioScreen> createState() => _UploadSoundpackAudioScreenState();
}

class _UploadSoundpackAudioScreenState extends State<UploadSoundpackAudioScreen> {
  bool _isAudioUploaded = false;

  void _onContinue() {
    if (_isAudioUploaded) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddSoundpackAudioScreen(
            soundpackTitle: widget.soundpackTitle,
            soundpackPrice: widget.soundpackPrice,
            allowBundling: widget.allowBundling,
            description: widget.description,
            // Pass uploaded audio data here
          ),
        ),
      );
    } else {
      _showUploadResult('Please upload audio files first.');
    }
  }

  void _handleFlStudioImport() {
    setState(() {
      _isAudioUploaded = true;
    });
    _showUploadResult('FL Studio project imported successfully!');
  }

  void _handleAudioUpload() {
    setState(() {
      _isAudioUploaded = true;
    });
    _showUploadResult('Audio files uploaded successfully!');
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
        backgroundColor: _isAudioUploaded ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: 24.sp,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
          children: [
            // Soundpack Cover Art with Wave Pattern
            Container(
              width: 200.w,
              height: 200.h,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: CustomPaint(
                painter: SoundpackWavePatternPainter(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Soundpack Title
            Text(
              widget.soundpackTitle.isNotEmpty ? widget.soundpackTitle : 'Lo-Fi Chill Vol.1',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 40.h),
            
            // Upload Audio Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.upload_file,
                    color: Colors.white.withOpacity(0.7),
                    size: 32.sp,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Upload audio',
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  if (_isAudioUploaded) ...[
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'Audio Uploaded ✓',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Upload Options
            _buildUploadOption(
              title: 'Import from FL Studio',
              subtitle: 'Import your FL Studio project',
              icon: Icons.music_note,
              onTap: _handleFlStudioImport,
            ),
            
            SizedBox(height: 16.h),
            
            _buildUploadOption(
              title: 'Upload .mp3 or .wav',
              subtitle: 'Upload multiple audio files',
              icon: Icons.audiotrack,
              onTap: _handleAudioUpload,
            ),
            
            const Spacer(),
            
            // Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isAudioUploaded ? _onContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isAudioUploaded ? Colors.white : Colors.grey.shade700,
                  foregroundColor: _isAudioUploaded ? Colors.black : Colors.white.withOpacity(0.5),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Continue',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 32.h),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildUploadOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white.withOpacity(0.8),
              size: 24.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.5),
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for soundpack wave pattern
class SoundpackWavePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    final waveHeight = size.height * 0.1;
    final waveLength = size.width / 6;

    // Draw multiple wave lines
    for (int i = 0; i < 8; i++) {
      final y = size.height * 0.2 + (i * size.height * 0.08);
      path.reset();
      path.moveTo(0, y);

      for (double x = 0; x <= size.width; x += waveLength / 10) {
        final waveY = y + waveHeight * 0.5 * (1 + (i % 2 == 0 ? 1 : -1)) * 
                     (0.5 + 0.5 * (x / size.width));
        path.lineTo(x, waveY);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
