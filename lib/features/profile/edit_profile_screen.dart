import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/custom_status_bar.dart';
import 'services/profile_service.dart';
import 'models/profile_data.dart';

class EditProfileScreen extends StatefulWidget {
  final String userRole;
  
  const EditProfileScreen({
    super.key,
    this.userRole = 'producer',
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for form fields
  final _artistNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _youtubeController = TextEditingController();
  final _tiktokController = TextEditingController();
  final _instagramController = TextEditingController();
  final _twitterController = TextEditingController();
  final _websiteController = TextEditingController();
  
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadCurrentProfile();
  }
  
  @override
  void dispose() {
    _artistNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _youtubeController.dispose();
    _tiktokController.dispose();
    _instagramController.dispose();
    _twitterController.dispose();
    _websiteController.dispose();
    super.dispose();
  }
  
  void _loadCurrentProfile() {
    // Load current profile data from service
    final profileData = ProfileService.instance.getCurrentProfile(widget.userRole);
    
    _artistNameController.text = profileData.artistName;
    _descriptionController.text = profileData.description;
    _locationController.text = profileData.location;
    _youtubeController.text = profileData.youtubeUrl;
    _tiktokController.text = profileData.tiktokHandle;
    _instagramController.text = profileData.instagramHandle;
    _twitterController.text = profileData.twitterHandle;
    _websiteController.text = profileData.websiteUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Column(
        children: [
          const CustomStatusBar(),
          
          // Header
          _buildHeader(),
          
          // Form Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    
                    // Profile Picture Section
                    _buildProfilePictureSection(),
                    
                    SizedBox(height: 32.h),
                    
                    // Basic Information Section
                    _buildSectionHeader('Basic Information'),
                    SizedBox(height: 16.h),
                    _buildTextField(
                      controller: _artistNameController,
                      label: widget.userRole == 'artist' ? 'Artist Name' : 'Producer Name',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 16.h),
                    _buildTextField(
                      controller: _locationController,
                      label: 'Location',
                      icon: Icons.location_on_outlined,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your location';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 16.h),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Bio / Description',
                      icon: Icons.description_outlined,
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 32.h),
                    
                    // Social Media Section
                    _buildSectionHeader('Social Media Links'),
                    SizedBox(height: 16.h),
                    _buildTextField(
                      controller: _youtubeController,
                      label: 'YouTube Username',
                      icon: FontAwesomeIcons.youtube,
                      prefixText: 'youtube.com/',
                    ),
                    
                    SizedBox(height: 16.h),
                    _buildTextField(
                      controller: _tiktokController,
                      label: 'TikTok Handle',
                      icon: FontAwesomeIcons.tiktok,
                      prefixText: '@',
                    ),
                    
                    SizedBox(height: 16.h),
                    _buildTextField(
                      controller: _instagramController,
                      label: 'Instagram Handle',
                      icon: FontAwesomeIcons.instagram,
                      prefixText: '@',
                    ),
                    
                    SizedBox(height: 16.h),
                    _buildTextField(
                      controller: _twitterController,
                      label: 'Twitter/X Handle',
                      icon: FontAwesomeIcons.twitter,
                      prefixText: '@',
                    ),
                    
                    SizedBox(height: 16.h),
                    _buildTextField(
                      controller: _websiteController,
                      label: 'Website',
                      icon: Icons.language_outlined,
                      prefixText: 'https://',
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // Save Button
                    _buildSaveButton(),
                    
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      child: Row(
        children: [
          // Back Button
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppTheme.glassColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppTheme.glassBorder,
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
          
          SizedBox(width: 16.w),
          
          // Title
          Expanded(
            child: Text(
              'Edit Profile',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Center(
      child: Column(
        children: [
          // Profile Picture
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.accentColor,
                width: 3,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60.r),
              child: Container(
                color: AppTheme.glassColor,
                child: Icon(
                  Icons.person,
                  size: 60.sp,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Change Photo Button
          Container(
            decoration: BoxDecoration(
              color: AppTheme.glassColor,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: AppTheme.glassBorder,
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8.r),
                onTap: _changeProfilePhoto,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Change Photo',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.getFont(
        'Wix Madefor Display',
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? prefixText,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.glassColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.glassBorder,
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.getFont(
          'Wix Madefor Display',
          fontSize: 16.sp,
          color: Colors.white,
        ),
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            color: Colors.white.withOpacity(0.7),
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.white.withOpacity(0.7),
            size: 20.sp,
          ),
          prefixText: prefixText,
          prefixStyle: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 16.sp,
            color: Colors.white.withOpacity(0.7),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          errorStyle: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 12.sp,
            color: AppTheme.errorColor,
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.accentColor, AppTheme.warningColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: _isLoading ? null : _saveProfile,
          child: Center(
            child: _isLoading
                ? SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save_outlined,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Save Changes',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void _changeProfilePhoto() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
                
                // Options
                _buildPhotoOption(
                  icon: Icons.camera_alt,
                  title: 'Take Photo',
                  onTap: () {
                    Navigator.pop(context);
                    _showMessage('Photo taken!');
                  },
                ),
                
                _buildPhotoOption(
                  icon: Icons.photo_library,
                  title: 'Choose from Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _showMessage('Photo selected from gallery!');
                  },
                ),
                
                _buildPhotoOption(
                  icon: Icons.delete_outline,
                  title: 'Remove Photo',
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context);
                    _showMessage('Profile photo removed!');
                  },
                ),
                
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhotoOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppTheme.glassColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.glassBorder,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isDestructive ? AppTheme.errorColor : Colors.white,
                  size: 20.sp,
                ),
                SizedBox(width: 16.w),
                Text(
                  title,
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: isDestructive ? AppTheme.errorColor : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Create updated profile data
      final updatedProfile = ProfileData(
        artistName: _artistNameController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        youtubeUrl: _youtubeController.text.trim(),
        tiktokHandle: _tiktokController.text.trim(),
        instagramHandle: _instagramController.text.trim(),
        twitterHandle: _twitterController.text.trim(),
        websiteUrl: _websiteController.text.trim(),
        profileImageUrl: '', // TODO: Handle profile image
      );
      
      // Save using service
      final success = await ProfileService.instance.updateProfile(updatedProfile);
      
      setState(() {
        _isLoading = false;
      });
      
      if (success) {
        _showMessage('Profile updated successfully!');
        // Go back to profile screen
        Navigator.pop(context);
      } else {
        _showMessage('Failed to update profile. Please try again.');
      }
    }
  }

  void _showMessage(String message) {
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
}
