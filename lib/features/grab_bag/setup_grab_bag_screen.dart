import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import 'models/grab_bag_data.dart';
import 'grab_bag_review_screen.dart';

class SetupGrabBagScreen extends StatefulWidget {
  const SetupGrabBagScreen({Key? key}) : super(key: key);

  @override
  State<SetupGrabBagScreen> createState() => _SetupGrabBagScreenState();
}

class _SetupGrabBagScreenState extends State<SetupGrabBagScreen> {
  final TextEditingController _bagBannerController = TextEditingController();
  String _selectedMusicSet = '';
  String _selectedVibeTag = '';
  bool _hasThumbnail = false;

  final List<String> _musicSets = [
    'Trap Essentials - Vol. 1',
    'Hip Hop Classics',
    'R&B Vibes',
    'Electronic Dreams',
    'Jazz Fusion',
  ];

  final List<String> _vibeTags = [
    'Trap',
    'Hip Hop',
    'R&B',
    'Electronic',
    'Jazz',
    'Pop',
    'Rock',
    'Alternative',
  ];

  @override
  void dispose() {
    _bagBannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    
                    // Title
                    Text(
                      'Set Up Your\nGrab Bag',
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: 8.h),
                    
                    // Subtitle
                    Text(
                      'Create your instant sale package',
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[400],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Thumbnail upload section
                    _buildThumbnailSection(),
                    
                    SizedBox(height: 32.h),
                    
                    // Bag Banner input
                    _buildInputField(
                      label: 'Bag Banner',
                      controller: _bagBannerController,
                      hintText: 'Livestream name',
                    ),
                    
                    SizedBox(height: 32.h),
                    
                    // Music Set dropdown
                    _buildDropdownField(
                      label: 'Beat, Pack, or Loop for Instant Sale',
                      value: _selectedMusicSet,
                      items: _musicSets,
                      hintText: 'Music set to promote',
                      onChanged: (value) {
                        setState(() {
                          _selectedMusicSet = value ?? '';
                        });
                      },
                    ),
                    
                    SizedBox(height: 32.h),
                    
                    // Price info
                    if (_selectedMusicSet.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'You have set the price for this item: \$9.99',
                          style: GoogleFonts.getFont(
                            'Wix Madefor Display',
                            fontSize: 14.sp,
                            color: Colors.green,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    
                    SizedBox(height: 32.h),
                    
                    // Primary Vibe Tag dropdown
                    _buildDropdownField(
                      label: 'Primary Vibe Tag',
                      value: _selectedVibeTag,
                      items: _vibeTags,
                      hintText: 'Select tag',
                      onChanged: (value) {
                        setState(() {
                          _selectedVibeTag = value ?? '';
                        });
                      },
                    ),
                    
                    SizedBox(height: 60.h),
                  ],
                ),
              ),
            ),
            
            // Next Button
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Container(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: _canContinue() ? _onContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canContinue() ? Colors.white : Colors.grey.shade600,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Continue to Review',
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
      ),
    );
  }

  Widget _buildThumbnailPreview() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple.withOpacity(0.3),
                Colors.blue.withOpacity(0.3),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.image,
              color: Colors.white.withOpacity(0.7),
              size: 48.sp,
            ),
          ),
        ),
        // Remove button
        Positioned(
          top: 12.h,
          right: 12.w,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _hasThumbnail = false;
              });
            },
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 16.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnailPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          color: Colors.white.withOpacity(0.7),
          size: 48.sp,
        ),
        SizedBox(height: 12.h),
        Text(
          'Add Thumbnail',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          '(optional)',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnailSection() {
    return Center(
      child: GestureDetector(
        onTap: _showThumbnailOptions,
        child: Container(
          width: 200.w,
          height: 300.h,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: _hasThumbnail 
              ? _buildThumbnailPreview()
              : _buildThumbnailPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildInputField({
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
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
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
              color: Colors.grey[400],
            ),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required String hintText,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.isEmpty ? null : value,
              hint: Text(
                hintText,
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 16.sp,
                  color: Colors.grey[400],
                ),
              ),
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 16.sp,
                color: Colors.white,
              ),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 24.sp,
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  bool _canContinue() {
    return _bagBannerController.text.isNotEmpty &&
           _selectedMusicSet.isNotEmpty &&
           _selectedVibeTag.isNotEmpty;
  }

  void _showThumbnailOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Thumbnail',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: _buildUploadOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _hasThumbnail = true;
                      });
                    },
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildUploadOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        _hasThumbnail = true;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onContinue() {
    // Create grab bag data
    final grabBagData = GrabBagData(
      thumbnailImagePath: _hasThumbnail ? 'assets/images/grab_bag_thumbnail.png' : null,
      bagBanner: _bagBannerController.text,
      musicSet: _selectedMusicSet,
      primaryVibeTag: _selectedVibeTag,
      price: 9.99,
    );
    
    // Navigate to review screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GrabBagReviewScreen(
          grabBagData: grabBagData,
        ),
      ),
    );
  }
}
