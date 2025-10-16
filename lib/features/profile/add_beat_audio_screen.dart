import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/custom_status_bar.dart';

class AddBeatAudioScreen extends StatefulWidget {
  final String beatTitle;
  final String beatPrice;
  final bool allowBundling;
  final String description;

  const AddBeatAudioScreen({
    super.key,
    required this.beatTitle,
    required this.beatPrice,
    required this.allowBundling,
    required this.description,
  });

  @override
  State<AddBeatAudioScreen> createState() => _AddBeatAudioScreenState();
}

class _AddBeatAudioScreenState extends State<AddBeatAudioScreen> {
  final TextEditingController _vibeTagController = TextEditingController();
  final TextEditingController _bpmController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  
  String _selectedVibeTag = 'Select tag';
  String _selectedKey = 'Select';
  String _selectedKeyType = 'Major';
  bool _isPlaying = false;
  bool _hasAudioFile = false;

  @override
  void initState() {
    super.initState();
    // Check if we have the audio file for the beat title
    if (widget.beatTitle == 'Lo-Fi Chill Vol. 1') {
      _hasAudioFile = true;
    }
  }

  @override
  void dispose() {
    _vibeTagController.dispose();
    _bpmController.dispose();
    _keyController.dispose();
    super.dispose();
  }

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
                      SizedBox(width: 16.w),
                      Text(
                        'Add beat info',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  
                  // Audio Player Section
                  _buildAudioPlayerSection(),
                  
                  SizedBox(height: 32.h),
                  
                  // Vibe Tag
                  _buildDropdownField(
                    label: 'Vibe Tag',
                    value: _selectedVibeTag,
                    onTap: _showVibeTagOptions,
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // BPM
                  _buildTextField(
                    label: 'BPM',
                    controller: _bpmController,
                    hintText: 'Enter BPM',
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Key
                  _buildKeySection(),
                  
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
          
          // Save Button
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Container(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: _onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  'Save',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayerSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: _hasAudioFile ? _buildExistingAudioPlayer() : _buildUploadAudioSection(),
    );
  }

  Widget _buildExistingAudioPlayer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.beatTitle,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        
        SizedBox(height: 16.h),
        
        // Audio player controls
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isPlaying = !_isPlaying;
                });
              },
              child: Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.black,
                  size: 18.sp,
                ),
              ),
            ),
            
            SizedBox(width: 12.w),
            
            // Progress bar
            Expanded(
              child: Container(
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2.r),
                ),
                child: Stack(
                  children: [
                    Container(
                      width: 40.w, // 20% progress
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(width: 12.w),
            
            // Time
            Text(
              '00:15',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            
            SizedBox(width: 12.w),
            
            // Delete button
            GestureDetector(
              onTap: _showDeleteAudioConfirmation,
              child: Icon(
                Icons.delete_outline,
                color: Colors.white.withOpacity(0.7),
                size: 20.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadAudioSection() {
    return Column(
      children: [
        Icon(
          Icons.music_note,
          color: Colors.white.withOpacity(0.6),
          size: 32.sp,
        ),
        SizedBox(height: 12.h),
        Text(
          'Upload Audio File',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildUploadButton('FL Studio', Icons.music_video, _importFromFLStudio),
            SizedBox(width: 12.w),
            _buildUploadButton('MP3', Icons.audiotrack, _uploadMP3),
            SizedBox(width: 12.w),
            _buildUploadButton('WAV', Icons.graphic_eq, _uploadWAV),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppTheme.accentColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: AppTheme.accentColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppTheme.accentColor,
              size: 16.sp,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 16.sp,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 16.sp,
                color: Colors.white.withOpacity(0.5),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 16.sp,
                    color: value == 'Select tag' || value == 'Select' 
                        ? Colors.white.withOpacity(0.5)
                        : Colors.white,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white.withOpacity(0.5),
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),
        
        // Major/Minor buttons
        Row(
          children: [
            _buildKeyTypeButton('Major', _selectedKeyType == 'Major'),
            SizedBox(width: 12.w),
            _buildKeyTypeButton('Minor', _selectedKeyType == 'Minor'),
          ],
        ),
        
        SizedBox(height: 12.h),
        
        // Key dropdown
        _buildDropdownField(
          label: '',
          value: _selectedKey,
          onTap: _showKeyOptions,
        ),
      ],
    );
  }

  Widget _buildKeyTypeButton(String label, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedKeyType = label;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }

  void _showVibeTagOptions() {
    // TODO: Implement vibe tag selection
    print('🏷️ Showing vibe tag options...');
  }

  void _showKeyOptions() {
    // TODO: Implement key selection
    print('🎼 Showing key options...');
  }

  void _importFromFLStudio() {
    print('🎹 Importing from FL Studio...');
    _showUploadResult('FL Studio import started!');
  }

  void _uploadMP3() {
    print('🎵 Uploading MP3 file...');
    _showUploadResult('MP3 upload started!');
  }

  void _uploadWAV() {
    print('🔊 Uploading WAV file...');
    _showUploadResult('WAV upload started!');
  }

  void _showDeleteAudioConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Delete Audio',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this audio file?',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _hasAudioFile = false;
                _isPlaying = false;
              });
            },
            child: Text(
              'Delete',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 14.sp,
                color: AppTheme.errorColor,
              ),
            ),
          ),
        ],
      ),
    );
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

  void _onSave() {
    // TODO: Save all beat data
    print('💾 Saving beat data...');
    print('Title: ${widget.beatTitle}');
    print('Price: ${widget.beatPrice}');
    print('Allow bundling: ${widget.allowBundling}');
    print('Description: ${widget.description}');
    print('Vibe Tag: $_selectedVibeTag');
    print('BPM: ${_bpmController.text}');
    print('Key: $_selectedKeyType $_selectedKey');
    
    _showUploadResult('Beat saved successfully!');
    
    // Navigate back to profile
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }
}
