import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/custom_status_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Settings state variables
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _liveStreamNotifications = true;
  bool _auctionNotifications = true;
  bool _newFollowerNotifications = true;
  bool _messageNotifications = true;
  bool _darkMode = true;
  bool _publicProfile = true;
  bool _showOnlineStatus = true;
  bool _allowDownloads = false;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Column(
        children: [
          const CustomStatusBar(),
          
          // Header
          _buildHeader(),
          
          // Settings Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  
                  // Account Section
                  _buildSection(
                    title: 'Account',
                    children: [
                      _buildSettingItem(
                        icon: Icons.person_outline,
                        title: 'Profile Settings',
                        subtitle: 'Manage your public profile',
                        onTap: () => _showComingSoon('Profile Settings'),
                      ),
                      _buildSettingItem(
                        icon: Icons.security_outlined,
                        title: 'Privacy & Security',
                        subtitle: 'Password, 2FA, privacy controls',
                        onTap: () => _showPrivacySettings(),
                      ),
                      _buildSettingItem(
                        icon: Icons.verified_user_outlined,
                        title: 'Account Verification',
                        subtitle: 'Verify your artist/producer account',
                        onTap: () => _showComingSoon('Account Verification'),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Notifications Section
                  _buildSection(
                    title: 'Notifications',
                    children: [
                      _buildSwitchItem(
                        icon: Icons.notifications_outlined,
                        title: 'Push Notifications',
                        subtitle: 'Receive push notifications',
                        value: _pushNotifications,
                        onChanged: (value) => setState(() => _pushNotifications = value),
                      ),
                      _buildSwitchItem(
                        icon: Icons.email_outlined,
                        title: 'Email Notifications',
                        subtitle: 'Receive email updates',
                        value: _emailNotifications,
                        onChanged: (value) => setState(() => _emailNotifications = value),
                      ),
                      _buildSwitchItem(
                        icon: Icons.live_tv_outlined,
                        title: 'Live Stream Alerts',
                        subtitle: 'Notify when followed artists go live',
                        value: _liveStreamNotifications,
                        onChanged: (value) => setState(() => _liveStreamNotifications = value),
                      ),
                      _buildSwitchItem(
                        icon: Icons.gavel_outlined,
                        title: 'Auction Updates',
                        subtitle: 'Bidding updates and auction results',
                        value: _auctionNotifications,
                        onChanged: (value) => setState(() => _auctionNotifications = value),
                      ),
                      _buildSwitchItem(
                        icon: Icons.person_add_outlined,
                        title: 'New Followers',
                        subtitle: 'When someone follows you',
                        value: _newFollowerNotifications,
                        onChanged: (value) => setState(() => _newFollowerNotifications = value),
                      ),
                      _buildSwitchItem(
                        icon: Icons.message_outlined,
                        title: 'Messages',
                        subtitle: 'Direct messages and mentions',
                        value: _messageNotifications,
                        onChanged: (value) => setState(() => _messageNotifications = value),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Appearance Section
                  _buildSection(
                    title: 'Appearance',
                    children: [
                      _buildSwitchItem(
                        icon: Icons.dark_mode_outlined,
                        title: 'Dark Mode',
                        subtitle: 'Use dark theme',
                        value: _darkMode,
                        onChanged: (value) => setState(() => _darkMode = value),
                      ),
                      _buildDropdownItem(
                        icon: Icons.language_outlined,
                        title: 'Language',
                        subtitle: 'App language',
                        value: _selectedLanguage,
                        options: ['English', 'Spanish', 'French', 'German', 'Japanese'],
                        onChanged: (value) => setState(() => _selectedLanguage = value!),
                      ),
                      _buildDropdownItem(
                        icon: Icons.attach_money_outlined,
                        title: 'Currency',
                        subtitle: 'Display currency',
                        value: _selectedCurrency,
                        options: ['USD', 'EUR', 'GBP', 'JPY', 'CAD'],
                        onChanged: (value) => setState(() => _selectedCurrency = value!),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Privacy Section
                  _buildSection(
                    title: 'Privacy',
                    children: [
                      _buildSwitchItem(
                        icon: Icons.public_outlined,
                        title: 'Public Profile',
                        subtitle: 'Make your profile discoverable',
                        value: _publicProfile,
                        onChanged: (value) => setState(() => _publicProfile = value),
                      ),
                      _buildSwitchItem(
                        icon: Icons.circle_outlined,
                        title: 'Show Online Status',
                        subtitle: 'Let others see when you\'re online',
                        value: _showOnlineStatus,
                        onChanged: (value) => setState(() => _showOnlineStatus = value),
                      ),
                      _buildSwitchItem(
                        icon: Icons.download_outlined,
                        title: 'Allow Downloads',
                        subtitle: 'Let others download your content',
                        value: _allowDownloads,
                        onChanged: (value) => setState(() => _allowDownloads = value),
                      ),
                      _buildSettingItem(
                        icon: Icons.block_outlined,
                        title: 'Blocked Users',
                        subtitle: 'Manage blocked accounts',
                        onTap: () => _showComingSoon('Blocked Users'),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Content Section
                  _buildSection(
                    title: 'Content & Data',
                    children: [
                      _buildSettingItem(
                        icon: Icons.cloud_download_outlined,
                        title: 'Data Usage',
                        subtitle: 'Manage download and streaming quality',
                        onTap: () => _showComingSoon('Data Usage'),
                      ),
                      _buildSettingItem(
                        icon: Icons.storage_outlined,
                        title: 'Storage',
                        subtitle: 'Cached data and offline content',
                        onTap: () => _showStorageSettings(),
                      ),
                      _buildSettingItem(
                        icon: Icons.backup_outlined,
                        title: 'Backup & Sync',
                        subtitle: 'Cloud backup settings',
                        onTap: () => _showComingSoon('Backup & Sync'),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Support Section
                  _buildSection(
                    title: 'Support',
                    children: [
                      _buildSettingItem(
                        icon: Icons.help_outline,
                        title: 'Help Center',
                        subtitle: 'FAQs and support articles',
                        onTap: () => _showComingSoon('Help Center'),
                      ),
                      _buildSettingItem(
                        icon: Icons.contact_support_outlined,
                        title: 'Contact Support',
                        subtitle: 'Get help from our team',
                        onTap: () => _showContactSupport(),
                      ),
                      _buildSettingItem(
                        icon: Icons.bug_report_outlined,
                        title: 'Report a Bug',
                        subtitle: 'Help us improve the app',
                        onTap: () => _showComingSoon('Bug Report'),
                      ),
                      _buildSettingItem(
                        icon: Icons.feedback_outlined,
                        title: 'Send Feedback',
                        subtitle: 'Share your thoughts',
                        onTap: () => _showComingSoon('Feedback'),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Legal Section
                  _buildSection(
                    title: 'Legal',
                    children: [
                      _buildSettingItem(
                        icon: Icons.description_outlined,
                        title: 'Terms of Service',
                        subtitle: 'Read our terms and conditions',
                        onTap: () => _showComingSoon('Terms of Service'),
                      ),
                      _buildSettingItem(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        subtitle: 'How we handle your data',
                        onTap: () => _showComingSoon('Privacy Policy'),
                      ),
                      _buildSettingItem(
                        icon: Icons.copyright_outlined,
                        title: 'Licenses',
                        subtitle: 'Open source licenses',
                        onTap: () => _showComingSoon('Licenses'),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Danger Zone
                  _buildSection(
                    title: 'Account Actions',
                    isDanger: true,
                    children: [
                      _buildSettingItem(
                        icon: Icons.logout_outlined,
                        title: 'Sign Out',
                        subtitle: 'Sign out of your account',
                        onTap: () => _showSignOutDialog(),
                        isDanger: true,
                      ),
                      _buildSettingItem(
                        icon: Icons.delete_forever_outlined,
                        title: 'Delete Account',
                        subtitle: 'Permanently delete your account',
                        onTap: () => _showDeleteAccountDialog(),
                        isDanger: true,
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  // App Version
                  Center(
                    child: Text(
                      'BAGR_Z v1.0.0',
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                  
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
              'Settings',
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

  Widget _buildSection({
    required String title,
    required List<Widget> children,
    bool isDanger = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: isDanger ? AppTheme.errorColor : Colors.white,
          ),
        ),
        SizedBox(height: 16.h),
        ...children,
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppTheme.glassColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDanger ? AppTheme.errorColor.withOpacity(0.3) : AppTheme.glassBorder,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isDanger ? AppTheme.errorColor : Colors.white,
                  size: 20.sp,
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
                          fontWeight: FontWeight.w500,
                          color: isDanger ? AppTheme.errorColor : Colors.white,
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
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppTheme.glassColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.glassBorder,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20.sp,
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
                      fontWeight: FontWeight.w500,
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
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppTheme.accentColor,
              activeTrackColor: AppTheme.accentColor.withOpacity(0.3),
              inactiveThumbColor: Colors.white.withOpacity(0.5),
              inactiveTrackColor: Colors.white.withOpacity(0.1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppTheme.glassColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.glassBorder,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20.sp,
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
                      fontWeight: FontWeight.w500,
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
            DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              dropdownColor: const Color(0xFF1A1A1A),
              underline: const SizedBox(),
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 14.sp,
                color: Colors.white,
              ),
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    _showMessage('$feature coming soon!');
  }

  void _showPrivacySettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          child: SafeArea(
            child: Column(
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
                  'Privacy & Security',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        _buildSettingItem(
                          icon: Icons.lock_outline,
                          title: 'Change Password',
                          subtitle: 'Update your account password',
                          onTap: () => _showComingSoon('Change Password'),
                        ),
                        _buildSettingItem(
                          icon: Icons.security,
                          title: 'Two-Factor Authentication',
                          subtitle: 'Add extra security to your account',
                          onTap: () => _showComingSoon('Two-Factor Authentication'),
                        ),
                        _buildSettingItem(
                          icon: Icons.devices,
                          title: 'Login Activity',
                          subtitle: 'See where you\'re logged in',
                          onTap: () => _showComingSoon('Login Activity'),
                        ),
                        _buildSettingItem(
                          icon: Icons.download_for_offline,
                          title: 'Download Data',
                          subtitle: 'Download a copy of your data',
                          onTap: () => _showComingSoon('Download Data'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showStorageSettings() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Storage Usage',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStorageItem('Cached Audio', '245 MB'),
              _buildStorageItem('Cached Images', '89 MB'),
              _buildStorageItem('Offline Content', '1.2 GB'),
              _buildStorageItem('User Data', '12 MB'),
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppTheme.glassColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppTheme.glassBorder,
                    width: 1,
                  ),
                ),
                child: Text(
                  'Total: 1.5 GB',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Clear Cache',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: AppTheme.errorColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: AppTheme.accentColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStorageItem(String type, String size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            type,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
          Text(
            size,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactSupport() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Contact Support',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Need help? Choose how you\'d like to contact us:',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              SizedBox(height: 16.h),
              _buildContactOption(
                icon: Icons.email_outlined,
                title: 'Email Support',
                subtitle: 'support@bagrz.com',
                onTap: () => _showComingSoon('Email Support'),
              ),
              SizedBox(height: 8.h),
              _buildContactOption(
                icon: Icons.chat_outlined,
                title: 'Live Chat',
                subtitle: 'Chat with our team',
                onTap: () => _showComingSoon('Live Chat'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: AppTheme.accentColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
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
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 20.sp,
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
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
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
        ),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Sign Out',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out of your account?',
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
                _showMessage('Signed out successfully!');
              },
              child: Text(
                'Sign Out',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: AppTheme.errorColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Delete Account',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.errorColor,
            ),
          ),
          content: Text(
            'This action cannot be undone. All your data, including beats, auctions, and followers will be permanently deleted.',
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
                _showMessage('Account deletion requested. Check your email for confirmation.');
              },
              child: Text(
                'Delete Account',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: AppTheme.errorColor,
                ),
              ),
            ),
          ],
        );
      },
    );
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
