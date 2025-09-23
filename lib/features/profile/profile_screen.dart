import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as Math;
import 'dart:io';
import 'dart:ui';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/dashboard_tiles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'add_beat_info_screen.dart';
import 'add_soundpack_info_screen.dart';
import '../analytics/analytics_screen.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';
import 'qr_profile_screen.dart';
import 'help_support_screen.dart';
import 'about_screen.dart';
import 'services/profile_service.dart';
import 'models/profile_data.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatefulWidget {
  final String userRole; // 'artist' or 'producer'
  final VoidCallback? onNavigateToAnalytics; // Callback to navigate to analytics tab
  final VoidCallback? onNavigateToMyBids; // Callback to navigate to my bids tab
  
  const ProfileScreen({
    super.key,
    this.userRole = 'producer',
    this.onNavigateToAnalytics,
    this.onNavigateToMyBids,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  late TabController _tabController;
  late ProfileData _currentProfile;
  dynamic _profileImage; // Can be File or String (for web)
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProfile();
  }
  
  void _loadProfile() {
    _currentProfile = ProfileService.instance.getCurrentProfile(widget.userRole);
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

  Future<void> _takePhoto() async {
    try {
      // Check camera permission on mobile platforms
      if (!kIsWeb) {
        var status = await Permission.camera.status;
        if (status.isDenied) {
          status = await Permission.camera.request();
          if (status.isDenied) {
            _showPhotoActionResult('Camera permission is required to take photos.');
            return;
          }
        }
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _profileImage = kIsWeb ? image.path : File(image.path);
        });
        _showPhotoActionResult('Photo taken and updated successfully!');
      }
    } catch (e) {
      print('Error taking photo: $e');
      _showPhotoActionResult('Failed to take photo. Please try again.');
    }
  }

  Future<void> _chooseFromGallery() async {
    try {
      // Check photo library permission on mobile platforms
      if (!kIsWeb) {
        var status = await Permission.photos.status;
        if (status.isDenied) {
          status = await Permission.photos.request();
          if (status.isDenied) {
            _showPhotoActionResult('Photo library permission is required to select photos.');
            return;
          }
        }
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _profileImage = kIsWeb ? image.path : File(image.path);
        });
        _showPhotoActionResult('Photo selected and updated successfully!');
      }
    } catch (e) {
      print('Error choosing from gallery: $e');
      _showPhotoActionResult('Failed to select photo. Please try again.');
    }
  }

  Future<void> _editPhoto() async {
    try {
      if (_profileImage == null) {
        // If no current image, let user choose one first
        await _chooseFromGallery();
        return;
      }

      // For now, "editing" means choosing a new photo
      // In a future update, we can add a proper photo editor
      await _chooseFromGallery();
    } catch (e) {
      print('Error editing photo: $e');
      _showPhotoActionResult('Failed to edit photo. Please try again.');
    }
  }


  void _removePhoto() {
    setState(() {
      _profileImage = null;
    });
    _showPhotoActionResult('Profile photo removed successfully!');
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

  void _editProfile() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(userRole: widget.userRole),
      ),
    );
    
    // Reload profile data when returning from edit screen
    if (result != null || mounted) {
      setState(() {
        _loadProfile();
      });
    }
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _shareProfile() {
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
                
                // Title
                Text(
                  'Share Profile',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Share Options
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      _buildShareOption(
                        icon: Icons.qr_code_2_rounded,
                        title: 'QR Code',
                        subtitle: 'Show QR code for quick scanning',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => QRProfileScreen(userRole: widget.userRole),
                            ),
                          );
                        },
                      ),
                      
                      SizedBox(height: 12.h),
                      
                      _buildShareOption(
                        icon: Icons.share_outlined,
                        title: 'Share Link',
                        subtitle: 'Share via messaging apps, social media',
                        onTap: () {
                          Navigator.pop(context);
                          _shareNatively();
                        },
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildShareOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.glassColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.glassBorder,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.accentColor,
                    size: 24.sp,
                  ),
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
                      SizedBox(height: 4.h),
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
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  void _shareNatively() {
    // Generate profile URL
    final profileHandle = '@${_currentProfile.artistName.toLowerCase().replaceAll(' ', '').replaceAll(RegExp(r'[^a-z0-9]'), '')}';
    final profileUrl = 'https://bagr.app/profiles/$profileHandle';
    
    final shareText = '''
🎵 Check out ${_currentProfile.artistName} on BAGR_Z!

${_currentProfile.description}

📍 ${_currentProfile.location}

Visit: $profileUrl

#BAGRZ #Music ${widget.userRole == 'artist' ? '#Artist' : '#Producer'}
    '''.trim();
    
    Share.share(
      shareText,
      subject: '${_currentProfile.artistName} - BAGR_Z Profile',
    );
  }

  void _viewSavedItems() {
    print('🔖 Viewing saved items...');
    _showMenuActionResult('Saved items opened!');
  }

  void _getHelp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HelpSupportScreen(),
      ),
    );
  }

  void _showAbout() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AboutScreen(),
      ),
    );
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



  void _showMyBids() {
    print('🔨 Showing my bids...');
    _showMenuActionResult('My Bids opened!');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 60.h),
          
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
          
          SizedBox(height: 120.h), // Bottom padding for navigation bar
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 0),
      child: Column(
        children: [
          // Profile Picture and Info
          Row(
            children: [
              // Profile Picture (Clickable) with Level Badge
              GestureDetector(
                onTap: _showProfilePhotoOptions,
                child: Stack(
                  clipBehavior: Clip.none, // Allow children to extend beyond bounds
                  children: [
                    Container(
                      width: 88.w,
                      height: 88.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFFD700), // Gold
                            Color(0xFFFFA500), // Orange Gold
                            Color(0xFFFF8C00), // Dark Orange
                            Color(0xFFFFD700), // Gold
                          ],
                          stops: [0.0, 0.33, 0.66, 1.0],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(4.w), // Space for gradient ring
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black, // Background for inner circle
                        ),
                        child: Container(
                          margin: EdgeInsets.all(2.w), // Small margin for clean separation
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1.0,
                            ),
                          ),
                          child: ClipOval(
                            child: _profileImage != null
                                ? kIsWeb
                                    ? Image.network(
                                        _profileImage!,
                                        width: 76.w,
                                        height: 76.h,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          color: AppTheme.glassColor,
                                          child: Center(
                                            child: Icon(
                                              FontAwesomeIcons.music,
                                              color: AppTheme.accentColor,
                                              size: 30.sp,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Image.file(
                                        _profileImage!,
                                        width: 76.w,
                                        height: 76.h,
                                        fit: BoxFit.cover,
                                      )
                                : Container(
                                    color: AppTheme.glassColor,
                                    child: Center(
                                      child: Icon(
                                        FontAwesomeIcons.music,
                                        color: AppTheme.accentColor,
                                        size: 30.sp,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(width: 16.w),
              
              // Name and Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      _currentProfile.artistName,
                      style: _getSilverGradientTextStyle(20.sp),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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
          
          // Location from profile data
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppTheme.errorColor,
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                _currentProfile.location,
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12.h),
          
          // Bio from profile data
          Text(
            _currentProfile.description,
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
    final socialLinks = ProfileService.instance.getSocialLinks();
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSocialButton(
            FontAwesomeIcons.youtube,
            _currentProfile.youtubeUrl.isNotEmpty ? 'youtube.com/${_currentProfile.youtubeUrl}' : 'YouTube',
            AppTheme.errorColor,
            _currentProfile.youtubeUrl.isNotEmpty,
          ),
          _buildSocialButton(
            FontAwesomeIcons.instagram,
            _currentProfile.instagramHandle.isNotEmpty ? _currentProfile.instagramHandle : 'Instagram',
            Colors.purple,
            _currentProfile.instagramHandle.isNotEmpty,
          ),
          _buildSocialButton(
            FontAwesomeIcons.tiktok,
            _currentProfile.tiktokHandle.isNotEmpty ? _currentProfile.tiktokHandle : 'TikTok',
            Colors.white,
            _currentProfile.tiktokHandle.isNotEmpty,
          ),
          _buildSocialButton(
            FontAwesomeIcons.twitter,
            _currentProfile.twitterHandle.isNotEmpty ? _currentProfile.twitterHandle : 'Twitter',
            Colors.blue,
            _currentProfile.twitterHandle.isNotEmpty,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String handle, Color color, [bool isActive = true]) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: isActive ? AppTheme.glassColor : AppTheme.glassColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isActive ? AppTheme.glassBorder : AppTheme.glassBorder.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: isActive ? color : Colors.white.withOpacity(0.3),
                size: 18.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              handle,
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 10.sp,
                color: isActive ? Colors.white.withOpacity(0.7) : Colors.white.withOpacity(0.3),
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
      child: widget.userRole == 'artist' 
        ? Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Analytics',
                  Icons.bar_chart_rounded,
                  AppTheme.glassColor,
                  Colors.white,
                  () {
                    // Use callback to navigate to analytics tab if available
                    if (widget.onNavigateToAnalytics != null) {
                      widget.onNavigateToAnalytics!();
                    } else {
                      // Fallback to opening new screen if callback not provided
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AnalyticsScreen(userRole: widget.userRole),
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildActionButton(
                  'My Bids',
                  Icons.gavel,
                  AppTheme.accentColor,
                  Colors.white,
                  () {
                    // Use callback to navigate to my bids tab if available
                    if (widget.onNavigateToMyBids != null) {
                      widget.onNavigateToMyBids!();
                    } else {
                      // Fallback to existing method if callback not provided
                      _showMyBids();
                    }
                  },
                ),
              ),
            ],
          )
        : Container(
            width: double.infinity,
            child: _buildActionButton(
              'Analytics',
              Icons.bar_chart_rounded,
              AppTheme.glassColor,
              Colors.white,
              () {
                // Use callback to navigate to analytics tab if available
                if (widget.onNavigateToAnalytics != null) {
                  widget.onNavigateToAnalytics!();
                } else {
                  // Fallback to opening new screen if callback not provided
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AnalyticsScreen(userRole: widget.userRole),
                    ),
                  );
                }
              },
            ),
          ),
    );
  }

  // Helper method to create silver gradient text style
  TextStyle _getSilverGradientTextStyle(double fontSize, {FontWeight? fontWeight}) {
    return GoogleFonts.fjallaOne(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.w400,
      foreground: Paint()
        ..shader = LinearGradient(
          colors: [
            Color(0xFFC0C0C0), // Light Silver
            Color(0xFFE5E5E5), // Bright Silver
            Color(0xFF808080), // Medium Silver
            Color(0xFFC0C0C0), // Light Silver
          ],
          stops: [0.0, 0.33, 0.66, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
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
                style: _getSilverGradientTextStyle(14.sp, fontWeight: FontWeight.w400),
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
                    style: _getSilverGradientTextStyle(16.sp),
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
                        style: _getSilverGradientTextStyle(16.sp),
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: _selectedTabIndex == 0
              ? (widget.userRole == 'artist' ? _buildMyMusicGrid() : _buildShopGrid())
              : (widget.userRole == 'artist' ? _buildFavoriteGrid() : _buildCoSignsGrid()),
        ),
      ],
    );
  }

  Widget _buildMyMusicGrid() {
    final musicTitles = [
      'Dreams in Motion',
      'City Nights',
      'Midnight Flow',
      'Summer Vibes',
      'Lost in Sound',
      'Urban Poetry'
    ];
    
    return DashboardTiles.buildCardGrid(
      children: List.generate(6, (index) => _buildMusicCard(
        musicTitles[index % musicTitles.length],
        'Single',
        index,
      )),
      childAspectRatio: 0.75,
      mainAxisSpacing: 2,
    );
  }

  Widget _buildFavoriteGrid() {
    return DashboardTiles.buildCardGrid(
      children: List.generate(8, (index) => _buildBeatCard(
        'Liked Beat ${index + 1}',
        6,
        20,
        '2d 12h',
        index,
      )),
      childAspectRatio: 0.75,
      mainAxisSpacing: 2,
    );
  }

  Widget _buildShopGrid() {
    return DashboardTiles.buildCardGrid(
      children: List.generate(4, (index) => _buildBeatCard(
        'Lo-Fi Chill Vol. 1',
        6,
        20,
        '1d 4h',
        index,
      )),
      childAspectRatio: 0.75,
      mainAxisSpacing: 2,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image tile with overlay content
        DashboardTiles.buildContentCard(
          title: '',
          subtitle: '',
          imageAsset: 'waves.jpg',
          height: 140,
          onTap: () {
            print('Tapped on music: $title');
          },
          overlayContent: Stack(
            children: [
              // Play button
              Center(
                child: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                    size: 28.sp,
                  ),
                ),
              ),
              
              // Favorite button
              Positioned(
                top: 12.h,
                right: 12.w,
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.favorite_outline,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Text below the tile
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: _getSilverGradientTextStyle(14.sp),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Text(
                type,
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
      ],
    );
  }

  Widget _buildBeatCard(String title, int beats, int price, String expires, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image tile with overlay content
        DashboardTiles.buildContentCard(
          title: '',
          subtitle: '',
          imageAsset: 'waves.jpg',
          height: 140,
          onTap: () {
            print('Tapped on beat: $title');
          },
          overlayContent: Stack(
            children: [
              // Expiry badge
              Positioned(
                top: 12.h,
                left: 12.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Expires $expires',
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
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                    size: 28.sp,
                  ),
                ),
              ),
              
            ],
          ),
        ),
        
        // Text below the tile
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: _getSilverGradientTextStyle(14.sp),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Text(
                '$beats beats • \$$price',
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
      ],
    );
  }

  Widget _buildHustlerLevelBadge() {
    return Container(
      width: 32.w,
      height: 32.h,
      child: CustomPaint(
        size: Size(32.w, 32.h),
        painter: GoldHexagonPainter(),
      ),
    );
  }
}

class GoldHexagonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Create hexagon path
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.9;

    // Calculate hexagon points
    for (int i = 0; i < 6; i++) {
      final angle = (i * Math.pi / 3) - (Math.pi / 2); // Start from top
      final x = center.dx + radius * Math.cos(angle);
      final y = center.dy + radius * Math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    // Draw gold gradient hexagon (matching profile circle gradient)
    final rect = Rect.fromCenter(center: center, width: size.width, height: size.height);
    paint.shader = LinearGradient(
      colors: [
        Color(0xFFFFD700), // Gold
        Color(0xFFFFA500), // Orange Gold
        Color(0xFFFF8C00), // Dark Orange
        Color(0xFFFFD700), // Gold
      ],
      stops: [0.0, 0.33, 0.66, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(rect);

    canvas.drawPath(path, paint);

    // Add subtle border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = const Color(0xFFB8860B); // Dark gold border

    canvas.drawPath(path, borderPaint);

    // Add inner glow effect
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = const Color(0xFFFFF8DC); // Light gold glow

    final innerPath = Path();
    final innerRadius = radius * 0.8;
    for (int i = 0; i < 6; i++) {
      final angle = (i * Math.pi / 3) - (Math.pi / 2);
      final x = center.dx + innerRadius * Math.cos(angle);
      final y = center.dy + innerRadius * Math.sin(angle);
      
      if (i == 0) {
        innerPath.moveTo(x, y);
      } else {
        innerPath.lineTo(x, y);
      }
    }
    innerPath.close();

    canvas.drawPath(innerPath, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class VinylWavePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF666666)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2 * 0.9;

    // Draw concentric wave circles
    for (int i = 0; i < 6; i++) {
      final radius = maxRadius * (0.3 + (i * 0.12));
      final opacity = 1.0 - (i * 0.15);
      
      paint.color = Color(0xFF666666).withOpacity(opacity);
      
      // Create wavy circle path
      final path = Path();
      for (double angle = 0; angle < 2 * Math.pi; angle += 0.1) {
        final waveAmplitude = 1.0 + Math.sin(angle * 8) * 0.5;
        final adjustedRadius = radius * waveAmplitude;
        
        final x = center.dx + adjustedRadius * Math.cos(angle);
        final y = center.dy + adjustedRadius * Math.sin(angle);
        
        if (angle == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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

class NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final random = Math.Random(42); // Fixed seed for consistent noise
    
    // Create noise pattern with small rectangles
    for (int i = 0; i < (size.width * size.height / 16).round(); i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final width = random.nextDouble() * 2 + 0.5;
      final height = random.nextDouble() * 2 + 0.5;
      
      canvas.drawRect(
        Rect.fromLTWH(x, y, width, height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
