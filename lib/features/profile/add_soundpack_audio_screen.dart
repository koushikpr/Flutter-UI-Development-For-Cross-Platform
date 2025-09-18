import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class AddSoundpackAudioScreen extends StatefulWidget {
  final String soundpackTitle;
  final String soundpackPrice;
  final bool allowBundling;
  final String description;

  const AddSoundpackAudioScreen({
    super.key,
    required this.soundpackTitle,
    required this.soundpackPrice,
    required this.allowBundling,
    required this.description,
  });

  @override
  State<AddSoundpackAudioScreen> createState() => _AddSoundpackAudioScreenState();
}

class _AddSoundpackAudioScreenState extends State<AddSoundpackAudioScreen> {
  List<SoundpackTrack> _tracks = [
    SoundpackTrack(
      title: 'Favella - ManuGTB',
      duration: '2:30',
      genre: 'Hip-hop',
      bpm: '143 BPM',
      key: 'C minor',
    ),
    SoundpackTrack(
      title: 'Rhythm City - BeatMaster',
      duration: '3:15',
      genre: 'Hip-hop',
      bpm: '128 BPM',
      key: 'G minor',
    ),
    SoundpackTrack(
      title: 'Urban Vibes - SoundSmith',
      duration: '2:45',
      genre: 'Hip-hop',
      bpm: '140 BPM',
      key: 'F minor',
    ),
    SoundpackTrack(
      title: 'Groove Avenue - DJ Echo',
      duration: '3:00',
      genre: 'Hip-hop',
      bpm: '135 BPM',
      key: 'E minor',
    ),
    SoundpackTrack(
      title: 'Night Pulse - ManuGTB',
      duration: '2:50',
      genre: 'Hip-hop',
      bpm: '142 BPM',
      key: 'C minor',
    ),
  ];

  void _onSave() {
    print('Saving soundpack with ${_tracks.length} tracks');
    for (var track in _tracks) {
      print('Track: ${track.title} - ${track.duration}');
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Soundpack saved successfully!',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
    
    // Navigate back to profile or dashboard
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _removeTrack(int index) {
    setState(() {
      _tracks.removeAt(index);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Track removed from soundpack',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orange,
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
      body: Column(
        children: [
          // Header Section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                // Soundpack Cover Art
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: CustomPaint(
                    painter: SoundpackWavePatternPainter(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                // Soundpack Title
                Text(
                  widget.soundpackTitle.isNotEmpty ? widget.soundpackTitle : 'Lo-Fi Chill Vol.1',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 8.h),
                
                // Upload Audio Button
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.upload_file,
                        color: Colors.white.withOpacity(0.7),
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Upload audio',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 14.sp,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Track Count Header
                Row(
                  children: [
                    Text(
                      '${_tracks.length} Uploaded beats',
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Tracks List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              itemCount: _tracks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _buildTrackCard(_tracks[index], index),
                );
              },
            ),
          ),
          
          // Save Button
          Padding(
            padding: EdgeInsets.all(24.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Save',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackCard(SoundpackTrack track, int index) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Play Button / Track Cover
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          
          SizedBox(width: 12.w),
          
          // Track Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.title,
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
                Text(
                  '${track.duration} - ${track.genre} - ${track.bpm} - ${track.key}',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          SizedBox(width: 12.w),
          
          // More Options Button
          GestureDetector(
            onTap: () => _showTrackOptions(index),
            child: Container(
              padding: EdgeInsets.all(8.w),
              child: Icon(
                Icons.more_vert,
                color: Colors.white.withOpacity(0.7),
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTrackOptions(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Remove Track Option
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Colors.red,
                size: 24.sp,
              ),
              title: Text(
                'Remove from soundpack',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _removeTrack(index);
              },
            ),
            
            // Edit Track Option
            ListTile(
              leading: Icon(
                Icons.edit_outlined,
                color: Colors.white.withOpacity(0.8),
                size: 24.sp,
              ),
              title: Text(
                'Edit track details',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showEditTrackDialog(index);
              },
            ),
            
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  void _showEditTrackDialog(int index) {
    // Placeholder for edit track functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Edit track functionality coming soon!',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}

// Model class for soundpack tracks
class SoundpackTrack {
  final String title;
  final String duration;
  final String genre;
  final String bpm;
  final String key;

  SoundpackTrack({
    required this.title,
    required this.duration,
    required this.genre,
    required this.bpm,
    required this.key,
  });
}

// Custom painter for soundpack wave pattern (reused from upload screen)
class SoundpackWavePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final waveHeight = size.height * 0.08;
    final waveLength = size.width / 5;

    // Draw multiple wave lines
    for (int i = 0; i < 6; i++) {
      final y = size.height * 0.25 + (i * size.height * 0.1);
      path.reset();
      path.moveTo(0, y);

      for (double x = 0; x <= size.width; x += waveLength / 8) {
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
