import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import 'models/auction_data.dart';
import 'auction_settings_screen.dart';

class AuctionDetailsScreen extends StatefulWidget {
  final AuctionData auctionData;
  
  const AuctionDetailsScreen({
    super.key,
    required this.auctionData,
  });

  @override
  State<AuctionDetailsScreen> createState() => _AuctionDetailsScreenState();
}

class _AuctionDetailsScreenState extends State<AuctionDetailsScreen> {
  final TextEditingController _beatTitleController = TextEditingController();
  final TextEditingController _bpmController = TextEditingController();
  
  String _selectedVibeTag = '';
  String _selectedKey = '';
  bool _isMajor = true;
  bool _hasBeatSleeve = false;

  @override
  void dispose() {
    _beatTitleController.dispose();
    _bpmController.dispose();
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
            _buildHeader(),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.h),
                    
                    // Upload Beat Sleeve Section
                    _buildBeatSleeveSection(),
                    
                    SizedBox(height: 32.h),
                    
                    // Beat Title
                    _buildBeatTitleField(),
                    
                    SizedBox(height: 24.h),
                    
                    // Vibe Tag
                    _buildVibeTagField(),
                    
                    SizedBox(height: 24.h),
                    
                    // BPM
                    _buildBPMField(),
                    
                    SizedBox(height: 24.h),
                    
                    // Key Section
                    _buildKeySection(),
                    
                    SizedBox(height: 60.h),
                  ],
                ),
              ),
            ),
            
            // Next Button
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        children: [
          // Navigation Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              GestureDetector(
                onTap: () => context.pop(),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 24.h),
          
          // Progress Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProgressStep(1, true),
              SizedBox(width: 8.w),
              _buildProgressStep(2, true),
              SizedBox(width: 8.w),
              _buildProgressStep(3, false),
            ],
          ),
          
          SizedBox(height: 24.h),
          
          // Page Title
          Text(
            'Auction Details',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int step, bool isActive) {
    return Container(
      width: 24.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey.shade600,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }

  Widget _buildBeatSleeveSection() {
    return Center(
      child: GestureDetector(
        onTap: _showBeatSleeveOptions,
        child: Container(
          width: 200.w,
          height: 200.h,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: _hasBeatSleeve
              ? _buildBeatSleevePreview()
              : _buildBeatSleevePlaceholder(),
        ),
      ),
    );
  }

  Widget _buildBeatSleevePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          color: Colors.white.withOpacity(0.6),
          size: 48.sp,
        ),
        SizedBox(height: 12.h),
        Text(
          'Upload Beat Sleeve',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '(Your beat\'s cover art)',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildBeatSleevePreview() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        image: const DecorationImage(
          image: NetworkImage('https://via.placeholder.com/200x200/4A4A4A/FFFFFF?text=Beat+Art'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Overlay for better text visibility
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          // Replace button
          Positioned(
            top: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: _showBeatSleeveOptions,
              child: Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 16.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeatTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Beat Title',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _beatTitleController,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 16.sp,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Enter beat title',
              hintStyle: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 16.sp,
                color: Colors.white.withOpacity(0.4),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVibeTagField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vibe Tag',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: _showVibeTagOptions,
          child: Container(
            height: 56.h,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedVibeTag.isEmpty ? 'Select tag' : _selectedVibeTag,
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 16.sp,
                        color: _selectedVibeTag.isEmpty 
                            ? Colors.white.withOpacity(0.4)
                            : Colors.white,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white.withOpacity(0.6),
                    size: 24.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBPMField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BPM',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 56.h,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _bpmController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 16.sp,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Enter BPM',
              hintStyle: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 16.sp,
                color: Colors.white.withOpacity(0.4),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.h),
        
        // Major/Minor buttons
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isMajor = true),
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: _isMajor ? Colors.white : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Major',
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: _isMajor ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _isMajor = false),
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: !_isMajor ? Colors.white : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Minor',
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: !_isMajor ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 12.h),
        
        // Key selection dropdown
        GestureDetector(
          onTap: _showKeyOptions,
          child: Container(
            height: 56.h,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedKey.isEmpty ? 'Select' : _selectedKey,
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 16.sp,
                        color: _selectedKey.isEmpty 
                            ? Colors.white.withOpacity(0.4)
                            : Colors.white,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white.withOpacity(0.6),
                    size: 24.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Container(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: _canProceed() ? _onNext : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _canProceed() ? Colors.white : Colors.grey.shade600,
            foregroundColor: _canProceed() ? Colors.black : Colors.white.withOpacity(0.5),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Text(
            'Next',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void _showBeatSleeveOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Upload Beat Sleeve',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 24.h),
            
            _buildUploadOption(
              icon: Icons.camera_alt,
              title: 'Take Photo',
              onTap: () {
                Navigator.pop(context);
                _uploadBeatSleeve('camera');
              },
            ),
            
            SizedBox(height: 16.h),
            
            _buildUploadOption(
              icon: Icons.photo_library,
              title: 'Choose from Gallery',
              onTap: () {
                Navigator.pop(context);
                _uploadBeatSleeve('gallery');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: const Color(0xFF3A3A3A),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            SizedBox(width: 16.w),
            Icon(icon, color: Colors.white, size: 24.sp),
            SizedBox(width: 16.w),
            Text(
              title,
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _uploadBeatSleeve(String source) {
    print('📸 Uploading beat sleeve from $source...');
    setState(() {
      _hasBeatSleeve = true;
    });
    _showUploadResult('Beat sleeve uploaded successfully!');
  }

  void _showVibeTagOptions() {
    final vibeTags = [
      'Trap', 'Hip Hop', 'R&B', 'Pop', 'Drill', 'Afrobeat',
      'Jazz', 'Soul', 'Funk', 'Electronic', 'Rock', 'Alternative'
    ];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        height: 400.h,
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Text(
              'Select Vibe Tag',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: vibeTags.length,
                itemBuilder: (context, index) {
                  final tag = vibeTags[index];
                  return ListTile(
                    title: Text(
                      tag,
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      setState(() => _selectedVibeTag = tag);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showKeyOptions() {
    final keys = _isMajor 
        ? ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
        : ['Cm', 'C#m', 'Dm', 'D#m', 'Em', 'Fm', 'F#m', 'Gm', 'G#m', 'Am', 'A#m', 'Bm'];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        height: 400.h,
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Text(
              'Select Key',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                itemCount: keys.length,
                itemBuilder: (context, index) {
                  final key = keys[index];
                  return ListTile(
                    title: Text(
                      key,
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      setState(() => _selectedKey = key);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
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
      ),
    );
  }

  bool _canProceed() {
    return _beatTitleController.text.isNotEmpty && 
           _selectedVibeTag.isNotEmpty && 
           _bpmController.text.isNotEmpty && 
           _selectedKey.isNotEmpty;
  }

  void _onNext() {
    // Create updated auction data with details
    final updatedAuctionData = widget.auctionData.copyWith(
      beatTitle: _beatTitleController.text,
      vibeTag: _selectedVibeTag,
      bpm: _bpmController.text,
      key: '$_selectedKey ${_isMajor ? 'Major' : 'Minor'}',
      beatSleeveImagePath: _hasBeatSleeve ? 'assets/images/beat_sleeve.png' : null,
    );
    
    // Navigate to Auction Settings screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AuctionSettingsScreen(
          auctionData: updatedAuctionData,
        ),
      ),
    );
  }
}
