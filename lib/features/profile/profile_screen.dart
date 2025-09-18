import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as Math;
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/custom_status_bar.dart';
import 'add_beat_info_screen.dart';
import 'add_soundpack_info_screen.dart';
import '../analytics/analytics_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userRole; // 'artist' or 'producer'
  
  const ProfileScreen({
    super.key,
    this.userRole = 'producer',
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showProfilePhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Handle bar
                      Container(
                        margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      
                      // Title
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                        child: Text(
                          'Profile Photo',
                          style: GoogleFonts.getFont(
                            'Wix Madefor Display',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      // Options
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Column(
                          children: [
                            _buildPhotoOption(
                              icon: Icons.camera_alt,
                              title: 'Take Photo',
                              subtitle: 'Use camera to take a new photo',
                              onTap: () {
                                Navigator.pop(context);
                                _takePhoto();
                              },
                            ),
                            
                            SizedBox(height: 8.h),
                            
                            _buildPhotoOption(
                              icon: Icons.photo_library,
                              title: 'Choose from Gallery',
                              subtitle: 'Select an existing photo',
                              onTap: () {
                                Navigator.pop(context);
                                _chooseFromGallery();
                              },
                            ),
                            
                            SizedBox(height: 8.h),
                            
                            _buildPhotoOption(
                              icon: Icons.edit,
                              title: 'Edit Photo',
                              subtitle: 'Crop or apply filters',
                              onTap: () {
                                Navigator.pop(context);
                                _editPhoto();
                              },
                            ),
                            
                            SizedBox(height: 8.h),
                            
                            _buildPhotoOption(
                              icon: Icons.delete_outline,
                              title: 'Remove Photo',
                              subtitle: 'Use default avatar',
                              onTap: () {
                                Navigator.pop(context);
                                _removePhoto();
                              },
                              isDestructive: true,
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPhotoOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isDestructive 
                    ? AppTheme.errorColor.withOpacity(0.3)
                    : Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: isDestructive 
                        ? AppTheme.errorColor.withOpacity(0.15)
                        : AppTheme.accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive ? AppTheme.errorColor : AppTheme.accentColor,
                    size: 20.sp,
                  ),
                ),
                
                SizedBox(width: 14.w),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: isDestructive 
                              ? AppTheme.errorColor 
                              : Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: 8.w),
                
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.4),
                  size: 12.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _takePhoto() {
    // TODO: Implement camera functionality
    print('📸 Taking photo with camera...');
    _showPhotoActionResult('Photo taken successfully!');
  }

  void _chooseFromGallery() {
    // TODO: Implement gallery picker
    print('🖼️ Choosing photo from gallery...');
    _showPhotoActionResult('Photo selected from gallery!');
  }

  void _editPhoto() {
    // TODO: Implement photo editing
    print('✏️ Opening photo editor...');
    _showPhotoActionResult('Photo edited successfully!');
  }

  void _removePhoto() {
    // TODO: Implement photo removal
    print('🗑️ Removing profile photo...');
    _showPhotoActionResult('Profile photo removed!');
  }

  void _showPhotoActionResult(String message) {
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

  void _showProfileMenuOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Handle bar
                      Container(
                        margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      
                      // Title
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                        child: Text(
                          'Profile Options',
                          style: GoogleFonts.getFont(
                            'Wix Madefor Display',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      // Options
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Column(
                          children: [
                            _buildMenuOption(
                              icon: Icons.edit_outlined,
                              title: 'Edit Profile',
                              subtitle: 'Update your profile information',
                              onTap: () {
                                Navigator.pop(context);
                                _editProfile();
                              },
                            ),
                            
                            SizedBox(height: 8.h),
                            
                            _buildMenuOption(
                              icon: Icons.settings_outlined,
                              title: 'Settings',
                              subtitle: 'Privacy, notifications, and more',
                              onTap: () {
                                Navigator.pop(context);
                                _openSettings();
                              },
                            ),
                            
                            SizedBox(height: 8.h),
                            
                            _buildMenuOption(
                              icon: Icons.share_outlined,
                              title: 'Share Profile',
                              subtitle: 'Share your profile with others',
                              onTap: () {
                                Navigator.pop(context);
                                _shareProfile();
                              },
                            ),
                            
                            SizedBox(height: 8.h),
                            
                            _buildMenuOption(
                              icon: Icons.bookmark_outline,
                              title: 'Saved Items',
                              subtitle: 'View your bookmarked content',
                              onTap: () {
                                Navigator.pop(context);
                                _viewSavedItems();
                              },
                            ),
                            
                            SizedBox(height: 8.h),
                            
                            _buildMenuOption(
                              icon: Icons.help_outline,
                              title: 'Help & Support',
                              subtitle: 'Get help or contact support',
                              onTap: () {
                                Navigator.pop(context);
                                _getHelp();
                              },
                            ),
                            
                            SizedBox(height: 8.h),
                            
                            _buildMenuOption(
                              icon: Icons.info_outline,
                              title: 'About',
                              subtitle: 'App version and information',
                              onTap: () {
                                Navigator.pop(context);
                                _showAbout();
                              },
                            ),
                            
                            SizedBox(height: 16.h),
                            
                            // Logout (separate styling)
                            _buildMenuOption(
                              icon: Icons.logout,
                              title: 'Log Out',
                              subtitle: 'Sign out of your account',
                              onTap: () {
                                Navigator.pop(context);
                                _showLogoutConfirmation();
                              },
                              isDestructive: true,
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isDestructive 
                    ? AppTheme.errorColor.withOpacity(0.3)
                    : Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: isDestructive 
                        ? AppTheme.errorColor.withOpacity(0.15)
                        : AppTheme.accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    color: isDestructive ? AppTheme.errorColor : AppTheme.accentColor,
                    size: 20.sp,
                  ),
                ),
                
                SizedBox(width: 14.w),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: isDestructive 
                              ? AppTheme.errorColor 
                              : Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: 8.w),
                
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.4),
                  size: 12.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editProfile() {
    print('✏️ Opening edit profile...');
    _showMenuActionResult('Edit Profile opened!');
  }

  void _openSettings() {
    print('⚙️ Opening settings...');
    _showMenuActionResult('Settings opened!');
  }

  void _shareProfile() {
    print('📤 Sharing profile...');
    _showMenuActionResult('Profile shared successfully!');
  }

  void _viewSavedItems() {
    print('🔖 Viewing saved items...');
    _showMenuActionResult('Saved items opened!');
  }

  void _getHelp() {
    print('❓ Opening help & support...');
    _showMenuActionResult('Help & Support opened!');
  }

  void _showAbout() {
    print('ℹ️ Showing about page...');
    _showMenuActionResult('About page opened!');
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Log Out',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          content: Text(
            'Are you sure you want to log out of your account?',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
              child: Text(
                'Log Out',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.errorColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() {
    print('🔐 Logging out...');
    // TODO: Implement actual logout logic
    _showMenuActionResult('Logged out successfully!');
    
    // Navigate back to auth screen after logout
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    });
  }

  void _showMenuActionResult(String message) {
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

  void _showAddToStoreModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.85,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: SafeArea(
                  child: Column(
                    children: [
                      // Header with close button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 24), // Spacer
                            Text(
                              'Add to Store',
                              style: GoogleFonts.getFont(
                                'Wix Madefor Display',
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 24.w,
                                height: 24.h,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Subtitle
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          'Select the type of item you want to add.',
                          style: GoogleFonts.getFont(
                            'Wix Madefor Display',
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      SizedBox(height: 32.h),
                      
                      // Options
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          children: [
                            _buildStoreOption(
                              iconData: Icons.music_note,
                              title: 'Single beat',
                              subtitle: 'One beat sold on its own.\nPerfect to highlight a standout track.',
                              isSelected: true,
                              onTap: () {
                                Navigator.pop(context);
                                _addSingleBeat();
                              },
                            ),
                            
                            SizedBox(height: 16.h),
                            
                            _buildStoreOption(
                              iconData: Icons.album,
                              title: 'Soundpack',
                              subtitle: 'A small collection of beats sold as one pack.\nGreat for themed drops or mini-albums.',
                              isSelected: false,
                              onTap: () {
                                Navigator.pop(context);
                                _addSoundpack();
                              },
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 40.h),
                      
                      // Continue Button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Container(
                          width: double.infinity,
                          height: 56.h,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _addSingleBeat(); // Default to single beat
                            },
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
                      
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStoreOption({
    required IconData iconData,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected 
                ? Colors.white.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            // Top row with icon and selection indicator
            Row(
              children: [
                // Icon (no background container)
                Icon(
                  iconData,
                  color: Colors.white.withOpacity(0.8),
                  size: 40.sp,
                ),
                
                const Spacer(),
                
                // Selection indicator
                Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.white : Colors.transparent,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: Colors.black,
                          size: 12.sp,
                        )
                      : null,
                ),
              ],
            ),
            
            SizedBox(height: 16.h),
            
            // Text content (full width)
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 14.sp,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addSingleBeat() {
    print('🎵 Adding single beat...');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddBeatInfoScreen(),
      ),
    );
  }

  void _addSoundpack() {
    print('📦 Adding soundpack...');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddSoundpackInfoScreen(),
      ),
    );
  }

  void _showMyBids() {
    print('🔨 Showing my bids...');
    _showMenuActionResult('My Bids opened!');
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
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
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
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        'Profile',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
              child: Column(
                children: [
                  // Profile Header
                  _buildProfileHeader(),
                  
                  // Social Links
                  _buildSocialLinks(),
                  
                  SizedBox(height: 20.h),
                  
                  // Action Buttons
                  _buildActionButtons(),
                  
                  SizedBox(height: 20.h),
                  
                  // Content Tabs and Grid
                  _buildContentSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          // Profile Picture and Info
          Row(
            children: [
              // Profile Picture (Clickable)
              GestureDetector(
                onTap: _showProfilePhotoOptions,
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.accentColor,
                        AppTheme.warningColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.all(2.w),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Colors.grey.shade800,
                              Colors.grey.shade900,
                            ],
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Icon(
                                FontAwesomeIcons.music,
                                color: AppTheme.accentColor,
                                size: 32.sp,
                              ),
                            ),
                            // Edit indicator overlay
                            Positioned(
                              bottom: 2.h,
                              right: 2.w,
                              child: Container(
                                width: 20.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  color: AppTheme.accentColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 10.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(width: 16.w),
              
              // Name and Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name based on role
                    Text(
                      widget.userRole == 'artist' ? 'Artist\'s Name' : 'Producer\'s Name',
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    
                    SizedBox(height: 4.h),
                    
                    // User Tag
                    Text(
                      widget.userRole == 'artist' ? '@artist' : '@producer',
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 14.sp,
                        color: AppTheme.accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Menu Button
              IconButton(
                onPressed: _showProfileMenuOptions,
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Location
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppTheme.errorColor,
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                'Atlanta, GA',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12.h),
          
          // Bio based on role
          Text(
            widget.userRole == 'artist' 
                ? 'Passionate artist from Atlanta. Creating music that tells stories. Always looking for fresh beats and collaborations 🎤'
                : 'Based in Atlanta. Crafting beats that resonate and inspire. Feel free to DM for exciting collaborations 🎵',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSocialButton(
            FontAwesomeIcons.youtube,
            'youtube.com/808wizard',
            AppTheme.errorColor,
          ),
          _buildSocialButton(
            FontAwesomeIcons.instagram,
            '@808wizard',
            Colors.purple,
          ),
          _buildSocialButton(
            FontAwesomeIcons.tiktok,
            '@wizardbeats',
            Colors.white,
          ),
          _buildSocialButton(
            FontAwesomeIcons.soundcloud,
            'soundcloud.com/jorda...',
            AppTheme.warningColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String handle, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
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
              child: Icon(
                icon,
                color: color,
                size: 18.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              handle,
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 10.sp,
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              'Analytics',
              Icons.bar_chart_rounded,
              AppTheme.glassColor,
              Colors.white,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AnalyticsScreen(userRole: widget.userRole),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildActionButton(
              widget.userRole == 'artist' ? 'My Bids' : 'Add Item',
              widget.userRole == 'artist' ? Icons.gavel : Icons.add,
              AppTheme.accentColor,
              Colors.white,
              () {
                if (widget.userRole == 'producer') {
                  _showAddToStoreModal();
                } else {
                  _showMyBids();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    IconData icon,
    Color backgroundColor,
    Color textColor,
    VoidCallback onPressed,
  ) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: backgroundColor == AppTheme.glassColor
            ? Border.all(color: AppTheme.glassBorder, width: 1)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                text,
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Column(
      children: [
        // Tab Bar
        Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          child: TabBar(
            controller: _tabController,
            onTap: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            tabs: [
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    widget.userRole == 'artist' ? 'My Music' : 'Shop',
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.userRole == 'artist' ? 'Favorite' : 'Co-Signs',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppTheme.accentColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          widget.userRole == 'artist' ? '24' : '18',
                          style: GoogleFonts.getFont(
                            'Wix Madefor Display',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            indicatorColor: AppTheme.accentColor,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.6),
            indicatorWeight: 2,
          ),
        ),
        
        SizedBox(height: 20.h),
        
        // Content Grid
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: _selectedTabIndex == 0
              ? (widget.userRole == 'artist' ? _buildMyMusicGrid() : _buildShopGrid())
              : (widget.userRole == 'artist' ? _buildFavoriteGrid() : _buildCoSignsGrid()),
        ),
      ],
    );
  }

  Widget _buildMyMusicGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        final musicTitles = [
          'Dreams in Motion',
          'City Nights',
          'Midnight Flow',
          'Summer Vibes',
          'Lost in Sound',
          'Urban Poetry'
        ];
        return _buildMusicCard(
          musicTitles[index % musicTitles.length],
          'Single',
          index,
        );
      },
    );
  }

  Widget _buildFavoriteGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.8,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return _buildBeatCard(
          'Liked Beat ${index + 1}',
          6,
          20,
          '2d 12h',
          index,
        );
      },
    );
  }

  Widget _buildShopGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.8,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return _buildBeatCard(
          'Lo-Fi Chill Vol. 1',
          6,
          20,
          '1d 4h',
          index,
        );
      },
    );
  }

  Widget _buildCoSignsGrid() {
    return Container(
      height: 200.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star_outline,
              color: Colors.white.withOpacity(0.5),
              size: 48.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              'No Co-Signs Yet',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Co-signs from other artists will appear here',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMusicCard(String title, String type, int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.glassColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.glassBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Music Cover
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accentColor.withOpacity(0.3),
                    AppTheme.warningColor.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Music wave pattern
                  Positioned.fill(
                    child: CustomPaint(
                      painter: MusicWavePatternPainter(),
                    ),
                  ),
                  
                  // Play button
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Music Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(12.w),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const Spacer(),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        type,
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      Icon(
                        Icons.favorite,
                        color: AppTheme.errorColor,
                        size: 16.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeatCard(String title, int beats, int price, String expires, int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.glassColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.glassBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Beat Cover with Expiry
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                gradient: RadialGradient(
                  colors: [
                    Colors.grey.shade700,
                    Colors.grey.shade900,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Wave pattern overlay
                  Positioned.fill(
                    child: CustomPaint(
                      painter: WavePatternPainter(),
                    ),
                  ),
                  
                  // Expiry badge
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'Expires in $expires',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 10.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  // Play button
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Beat Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(12.w),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const Spacer(),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$beats beats',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '\$$price',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.successColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
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
      ..strokeWidth = 1.5;

    // Draw wave pattern
    final path = Path();
    final waveHeight = 20.0;
    final waveLength = size.width / 3;

    for (int i = 0; i < 4; i++) {
      final yOffset = size.height * 0.2 + (i * size.height * 0.2);
      path.reset();

      for (double x = 0; x <= size.width; x += 2) {
        final y = yOffset + 
            (waveHeight * 0.5) * 
            (1 + (i * 0.3)) * 
            (0.5 + 0.5 * (x / size.width));

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

class MusicWavePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw music wave pattern
    final path = Path();
    final centerY = size.height * 0.5;
    final waveHeight = 15.0;

    for (int i = 0; i < 5; i++) {
      final xOffset = (size.width / 6) * (i + 1);
      final amplitude = waveHeight * (0.3 + (i * 0.2));
      
      path.reset();
      path.moveTo(xOffset, centerY + amplitude);
      path.lineTo(xOffset, centerY - amplitude);
      
      canvas.drawPath(path, paint);
    }

    // Draw connecting curves
    final curvePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final curvePath = Path();
    curvePath.moveTo(0, centerY);
    
    for (double x = 0; x <= size.width; x += 4) {
      final y = centerY + (waveHeight * 0.3) * 
          Math.sin((x / size.width) * Math.pi * 4);
      curvePath.lineTo(x, y);
    }
    
    canvas.drawPath(curvePath, curvePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
