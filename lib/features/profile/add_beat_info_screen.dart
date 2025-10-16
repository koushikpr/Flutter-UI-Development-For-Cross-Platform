import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/custom_status_bar.dart';
import 'upload_audio_screen.dart';

class AddBeatInfoScreen extends StatefulWidget {
  const AddBeatInfoScreen({super.key});

  @override
  State<AddBeatInfoScreen> createState() => _AddBeatInfoScreenState();
}

class _AddBeatInfoScreenState extends State<AddBeatInfoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _allowBundling = true;

  @override
  void initState() {
    super.initState();
    // Set default values
    _titleController.text = 'Lo-Fi Chill Vol. 1';
    _priceController.text = '\$20';
    _descriptionController.text = 'Each beat is designed to transport you to a serene soundscape, perfect for relaxation or inspiration.';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
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
                  
                  // Upload Beat Sleeve Section
                  _buildUploadSection(),
                  
                  SizedBox(height: 32.h),
                  
                  // Beat Title
                  _buildTextField(
                    label: 'Beat Title',
                    controller: _titleController,
                    hintText: 'Enter beat title',
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Price
                  _buildTextField(
                    label: 'Price',
                    controller: _priceController,
                    hintText: 'Enter price',
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Allow bundling toggle
                  _buildToggleSection(),
                  
                  SizedBox(height: 24.h),
                  
                  // Description
                  _buildTextField(
                    label: 'Description',
                    controller: _descriptionController,
                    hintText: 'Enter description',
                    maxLines: 3,
                  ),
                  
                  SizedBox(height: 40.h),
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
                onPressed: _onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
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

  Widget _buildUploadSection() {
    return GestureDetector(
      onTap: _showUploadOptions,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              color: Colors.white.withOpacity(0.6),
              size: 32.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              'Upload Beat Sleeve',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              '(Your beat\'s cover art)',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUploadOptions() {
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
                  'Upload Beat Sleeve',
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
                        subtitle: 'Use camera to capture cover art',
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
                      
                      SizedBox(height: 12.h),
                      
                      _buildUploadOption(
                        icon: Icons.design_services,
                        title: 'Create Custom Design',
                        subtitle: 'Design your own cover art',
                        onTap: () {
                          Navigator.pop(context);
                          _createCustomDesign();
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
    print('📸 Taking photo for beat sleeve...');
    _showUploadResult('Photo captured successfully!');
  }

  void _chooseFromGallery() {
    print('🖼️ Choosing from gallery for beat sleeve...');
    _showUploadResult('Image selected from gallery!');
  }

  void _createCustomDesign() {
    print('🎨 Creating custom design for beat sleeve...');
    _showUploadResult('Custom design tool opened!');
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
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
            maxLines: maxLines,
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

  Widget _buildToggleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Allow bundling',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Switch(
              value: _allowBundling,
              onChanged: (value) {
                setState(() {
                  _allowBundling = value;
                });
              },
              activeColor: AppTheme.accentColor,
              activeTrackColor: AppTheme.accentColor.withOpacity(0.3),
              inactiveThumbColor: Colors.white.withOpacity(0.5),
              inactiveTrackColor: Colors.white.withOpacity(0.1),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          'Show this beat in bundles with tracks from other producers at up to 20% off.',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.6),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  void _onContinue() {
    // TODO: Validate form fields
    print('📝 Beat info submitted:');
    print('Title: ${_titleController.text}');
    print('Price: ${_priceController.text}');
    print('Allow bundling: $_allowBundling');
    print('Description: ${_descriptionController.text}');
    
    // Navigate to upload audio page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UploadAudioScreen(
          beatTitle: _titleController.text,
          beatPrice: _priceController.text,
          allowBundling: _allowBundling,
          description: _descriptionController.text,
        ),
      ),
    );
  }
}
