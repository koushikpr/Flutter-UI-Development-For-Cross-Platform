import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/custom_status_bar.dart';
import 'auction_details_screen.dart';

class SetupLiveAuctionScreen extends StatefulWidget {
  const SetupLiveAuctionScreen({super.key});

  @override
  State<SetupLiveAuctionScreen> createState() => _SetupLiveAuctionScreenState();
}

class _SetupLiveAuctionScreenState extends State<SetupLiveAuctionScreen> {
  final TextEditingController _auctionBannerController = TextEditingController();
  bool _hasStreamCover = false;
  bool _hasAudioFile = false;
  
  // Legal agreement checkboxes
  bool _agreeToTerms = false;
  bool _representWarrant = false;
  bool _acknowledgeDMCA = false;

  @override
  void dispose() {
    _auctionBannerController.dispose();
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
                        'New Livestream',
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
                
                // Progress Indicator (Centered, 3 steps)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildProgressStep(1, true),
                      SizedBox(width: 8.w),
                      _buildProgressStep(2, false),
                      SizedBox(width: 8.w),
                      _buildProgressStep(3, false),
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
                  SizedBox(height: 40.h),
                  
                  // Page Title
                  Center(
                    child: Text(
                      'Set Up Your Live Auction',
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  // Stream Cover Section
                  _buildStreamCoverSection(),
                  
                  SizedBox(height: 32.h),
                  
                  // Auction Banner Section
                  _buildAuctionBannerSection(),
                  
                  SizedBox(height: 32.h),
                  
                  // Select Beat Section
                  _buildSelectBeatSection(),
                  
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
                onPressed: _canProceed() ? _onNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _canProceed() ? Colors.white : Colors.grey.shade600,
                  foregroundColor: Colors.black,
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
                    color: _canProceed() ? Colors.black : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
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

  Widget _buildStreamCoverSection() {
    return Center(
      child: GestureDetector(
      onTap: _showStreamCoverOptions,
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
        child: _hasStreamCover 
            ? _buildStreamCoverPreview()
            : _buildStreamCoverPlaceholder(),
      ),
    ),
  );
  }

  Widget _buildStreamCoverPlaceholder() {
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
          'Add a Stream cover (optional)',
          textAlign: TextAlign.center,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildStreamCoverPreview() {
    return Stack(
      children: [
        // Cover image placeholder
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.accentColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Icon(
            Icons.image,
            color: AppTheme.accentColor,
            size: 48.sp,
          ),
        ),
        
        // Remove button
        Positioned(
          top: 8.h,
          right: 8.w,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _hasStreamCover = false;
              });
            },
            child: Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
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

  Widget _buildAuctionBannerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Auction Banner',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        
        SizedBox(height: 12.h),
        
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
            controller: _auctionBannerController,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 16.sp,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: 'Enter auction banner text',
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

  Widget _buildSelectBeatSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Beat for Auction',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        
        SizedBox(height: 12.h),
        
        GestureDetector(
          onTap: _showAudioUploadOptions,
          child: Container(
            width: double.infinity,
            height: 120.h,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: _hasAudioFile 
                ? _buildAudioFilePreview()
                : _buildAudioUploadPlaceholder(),
          ),
        ),
      ],
    );
  }

  Widget _buildAudioUploadPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: CustomPaint(
        painter: GeometricPatternPainter(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note,
              color: Colors.white.withOpacity(0.6),
              size: 32.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              'Upload Audio File',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioFilePreview() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.audiotrack,
              color: AppTheme.accentColor,
              size: 24.sp,
            ),
          ),
          
          SizedBox(width: 12.w),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Audio File Selected',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Ready for auction',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          
          GestureDetector(
            onTap: () {
              setState(() {
                _hasAudioFile = false;
              });
            },
            child: Icon(
              Icons.close,
              color: Colors.white.withOpacity(0.6),
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  void _showStreamCoverOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: EdgeInsets.only(top: 12.h, bottom: 20.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                
                // Title
                Text(
                  'Add Stream Cover',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Upload options
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      _buildUploadOption(
                        icon: Icons.camera_alt,
                        title: 'Take Photo',
                        subtitle: 'Use camera to capture cover',
                        onTap: () {
                          Navigator.pop(context);
                          _takePhoto();
                        },
                      ),
                      
                      SizedBox(height: 12.h),
                      
                      _buildUploadOption(
                        icon: Icons.photo_library,
                        title: 'Choose from Gallery',
                        subtitle: 'Select from your photos',
                        onTap: () {
                          Navigator.pop(context);
                          _chooseFromGallery();
                        },
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 32.h),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAudioUploadOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: EdgeInsets.only(top: 12.h, bottom: 20.h),
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                
                // Title
                Text(
                  'Upload Audio File',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Upload options
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      _buildUploadOption(
                        icon: Icons.music_video,
                        title: 'FL Studio',
                        subtitle: 'Upload FL Studio project',
                        onTap: () {
                          Navigator.pop(context);
                          _showLegalAgreementModal();
                        },
                      ),
                      
                      SizedBox(height: 12.h),
                      
                      _buildUploadOption(
                        icon: Icons.audiotrack,
                        title: 'MP3/WAV',
                        subtitle: 'Upload audio files',
                        onTap: () {
                          Navigator.pop(context);
                          _showLegalAgreementModal();
                        },
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 32.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: AppTheme.accentColor,
                size: 20.sp,
              ),
            ),
            
            SizedBox(width: 12.w),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.4),
              size: 12.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _takePhoto() {
    print('📸 Taking photo for stream cover...');
    setState(() {
      _hasStreamCover = true;
    });
    _showUploadResult('Stream cover photo captured!');
  }

  void _chooseFromGallery() {
    print('🖼️ Choosing from gallery for stream cover...');
    setState(() {
      _hasStreamCover = true;
    });
    _showUploadResult('Stream cover selected from gallery!');
  }

  void _uploadFromFLStudio() {
    print('🎹 Uploading from FL Studio...');
    setState(() {
      _hasAudioFile = true;
    });
    _showUploadResult('FL Studio file uploaded successfully!');
  }

  void _uploadAudioFile() {
    print('🎵 Uploading audio file...');
    setState(() {
      _hasAudioFile = true;
    });
    _showUploadResult('Audio file uploaded successfully!');
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

  bool _canProceed() {
    return _hasAudioFile; // Only require audio file, stream cover is optional
  }

  void _showLegalAgreementModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                  maxWidth: MediaQuery.of(context).size.width * 0.95,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              'Before You Upload',
                              style: GoogleFonts.getFont(
                                'Wix Madefor Display',
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Your First Beat',
                              style: GoogleFonts.getFont(
                                'Wix Madefor Display',
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                  
                  SizedBox(height: 16.h),
                  
                  // Instruction text
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'By checking the box and clicking ',
                          style: GoogleFonts.getFont(
                            'Wix Madefor Display',
                            fontSize: 14.sp,
                            color: Colors.grey[400],
                          ),
                        ),
                        TextSpan(
                          text: 'I Agree & Upload, you:',
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
                  
                  SizedBox(height: 24.h),
                  
                  // Agreement checkboxes
                  _buildSelectableAgreementItem(
                    'agree to the BAGR Terms of Service;',
                    _agreeToTerms,
                    (value) => setModalState(() => _agreeToTerms = value),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  _buildSelectableAgreementItem(
                    'represent and warrant that you own or control all rights needed to upload and license this beat (master and any underlying composition), that it contains no uncleared samples or third-party content, and that your upload isn\'t subject to conflicting licenses;',
                    _representWarrant,
                    (value) => setModalState(() => _representWarrant = value),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  _buildSelectableAgreementItem(
                    'acknowledge our DMCA policy and that repeat infringement may lead to removal and account termination.',
                    _acknowledgeDMCA,
                    (value) => setModalState(() => _acknowledgeDMCA = value),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Reminder section
                  Text(
                    'Reminder:',
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  Text(
                    'BAGR acts as a neutral platform. You are legally responsible for the content you upload.',
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 14.sp,
                      color: Colors.grey[400],
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Terms of Service link
                  GestureDetector(
                    onTap: () {
                      print('Opening Terms of Service...');
                    },
                    child: Row(
                      children: [
                        Text(
                          'View Terms of Service',
                          style: GoogleFonts.getFont(
                            'Wix Madefor Display',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.open_in_new,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Action buttons
                  Column(
                    children: [
                      // I Agree & Upload button
                      Container(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: _canProceedWithUpload() ? () {
                            Navigator.pop(context);
                            _proceedWithUpload();
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _canProceedWithUpload() ? Colors.white : Colors.grey.shade600,
                            foregroundColor: _canProceedWithUpload() ? Colors.black : Colors.white.withOpacity(0.5),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Text(
                            'I Agree & Upload',
                            style: GoogleFonts.getFont(
                              'Wix Madefor Display',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 12.h),
                      
                      // Cancel button
                      Container(
                        width: double.infinity,
                        height: 56.h,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A2A2A),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.getFont(
                              'Wix Madefor Display',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                        ),
                      ),
                    ),
                    
                    // Close button
                    Positioned(
                      top: 16.h,
                      right: 16.w,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
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
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSelectableAgreementItem(String text, bool isSelected, Function(bool) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.transparent,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(
                color: isSelected ? Colors.green : Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14.sp,
                  )
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 14.sp,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgreementItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Icon(
            Icons.check,
            color: Colors.white,
            size: 14.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  bool _canProceedWithUpload() {
    return _agreeToTerms && _representWarrant && _acknowledgeDMCA;
  }

  void _proceedWithUpload() {
    print('✅ User agreed to terms, proceeding with upload...');
    setState(() {
      _hasAudioFile = true;
    });
    _showUploadResult('Audio file uploaded successfully!');
  }

  void _onNext() {
    print('🚀 Proceeding to next step...');
    print('Auction Banner: ${_auctionBannerController.text}');
    print('Has Stream Cover: $_hasStreamCover');
    print('Has Audio File: $_hasAudioFile');
    
    // Navigate to Auction Details screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AuctionDetailsScreen(),
      ),
    );
  }
}

class GeometricPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw geometric pattern
    final spacing = 20.0;
    
    // Vertical lines
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }
    
    // Horizontal lines
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
    
    // Diagonal lines
    for (int i = 0; i < 3; i++) {
      final offset = i * spacing * 0.5;
      canvas.drawLine(
        Offset(offset, 0),
        Offset(size.width, size.height - offset),
        paint,
      );
      canvas.drawLine(
        Offset(0, offset),
        Offset(size.width - offset, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
