import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/custom_status_bar.dart';
import 'services/profile_service.dart';

class QRProfileScreen extends StatefulWidget {
  final String userRole;
  
  const QRProfileScreen({
    super.key,
    this.userRole = 'producer',
  });

  @override
  State<QRProfileScreen> createState() => _QRProfileScreenState();
}

class _QRProfileScreenState extends State<QRProfileScreen> {
  late String _profileUrl;
  late String _profileHandle;
  
  @override
  void initState() {
    super.initState();
    _generateProfileUrl();
  }
  
  void _generateProfileUrl() {
    final profile = ProfileService.instance.getCurrentProfile(widget.userRole);
    
    // Generate handle from artist name (remove spaces, convert to lowercase, add @)
    _profileHandle = '@${profile.artistName.toLowerCase().replaceAll(' ', '').replaceAll(RegExp(r'[^a-z0-9]'), '')}';
    
    // Generate profile URL
    _profileUrl = 'https://bagr.app/profiles/$_profileHandle';
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
          
          // QR Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  
                  // Title Section
                  _buildTitleSection(),
                  
                  SizedBox(height: 40.h),
                  
                  // QR Code Card
                  _buildQRCodeCard(),
                  
                  SizedBox(height: 32.h),
                  
                  // Profile Info
                  _buildProfileInfo(),
                  
                  SizedBox(height: 32.h),
                  
                  // Action Buttons
                  _buildActionButtons(),
                  
                  SizedBox(height: 24.h),
                ],
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
              'Profile QR Code',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          
          // Share Button
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
                onTap: _shareProfile,
                child: Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        Icon(
          Icons.qr_code_2_rounded,
          color: AppTheme.accentColor,
          size: 48.sp,
        ),
        
        SizedBox(height: 16.h),
        
        Text(
          'Scan to Connect',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        
        SizedBox(height: 8.h),
        
        Text(
          'Share your BAGR_Z profile instantly',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 16.sp,
            color: Colors.white.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildQRCodeCard() {
    return Container(
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // QR Code
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: QrImageView(
              data: _profileUrl,
              version: QrVersions.auto,
              size: 200.w,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              errorCorrectionLevel: QrErrorCorrectLevel.M,
              embeddedImage: null, // Could add BAGR_Z logo here
              embeddedImageStyle: const QrEmbeddedImageStyle(
                size: Size(40, 40),
              ),
            ),
          ),
          
          SizedBox(height: 20.h),
          
          // BAGR_Z Logo/Text
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              'BAGR_Z',
              style: GoogleFonts.getFont(
                'Montserrat',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    final profile = ProfileService.instance.getCurrentProfile(widget.userRole);
    
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppTheme.glassColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.glassBorder,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Profile Picture
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.accentColor.withOpacity(0.2),
              border: Border.all(
                color: AppTheme.accentColor,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.person,
              color: AppTheme.accentColor,
              size: 30.sp,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Name
          Text(
            profile.artistName,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 4.h),
          
          // Handle
          Text(
            _profileHandle,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 16.sp,
              color: AppTheme.accentColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 8.h),
          
          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.white.withOpacity(0.6),
                size: 14.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                profile.location,
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // URL
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.link,
                  color: Colors.white.withOpacity(0.7),
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    _profileUrl,
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Share Button
        Container(
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
              onTap: _shareProfile,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.share_outlined,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Share Profile',
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
        
        SizedBox(height: 12.h),
        
        // Copy Link Button
        Container(
          width: double.infinity,
          height: 56.h,
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
              onTap: _copyLink,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.copy_outlined,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Copy Link',
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
      ],
    );
  }

  void _shareProfile() {
    final profile = ProfileService.instance.getCurrentProfile(widget.userRole);
    
    final shareText = '''
🎵 Check out ${profile.artistName} on BAGR_Z!

${profile.description}

📍 ${profile.location}

Visit: $_profileUrl

#BAGRZ #Music ${widget.userRole == 'artist' ? '#Artist' : '#Producer'}
    '''.trim();
    
    Share.share(
      shareText,
      subject: '${profile.artistName} - BAGR_Z Profile',
    );
  }

  void _copyLink() {
    Clipboard.setData(ClipboardData(text: _profileUrl));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profile link copied to clipboard!',
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
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
