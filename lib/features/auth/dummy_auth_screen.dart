import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../auth/screens/login_screen.dart';
import '../dashboard/new_dashboard_screen.dart';

class DummyAuthScreen extends StatefulWidget {
  const DummyAuthScreen({super.key});

  @override
  State<DummyAuthScreen> createState() => _DummyAuthScreenState();
}

class _DummyAuthScreenState extends State<DummyAuthScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 60.h),
              
              // Logo
              _buildLogo(),
              
              SizedBox(height: 80.h),
              
              // Welcome text
              _buildWelcomeText(),
              
              SizedBox(height: 60.h),
              
              // Demo login buttons
              _buildDemoLoginButtons(),
              
              const Spacer(),
              
              // Real auth button
              _buildRealAuthButton(),
              
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    ); 
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Text(
          'BAGR_Z',
          style: GoogleFonts.getFont(
            'Montserrat',
            fontSize: 42.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ).animate()
          .fadeIn(duration: 800.ms, delay: 200.ms)
          .slideY(begin: -0.3, end: 0),
        
        SizedBox(height: 12.h),
        
        Container(
          width: 80.w,
          height: 3.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.accentColor,
                AppTheme.warningColor,
              ],
            ),
            borderRadius: BorderRadius.circular(1.5.r),
          ),
        ).animate()
          .fadeIn(duration: 600.ms, delay: 400.ms)
          .scaleX(begin: 0, end: 1),
      ],
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'Choose Your Experience',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
            letterSpacing: -0.04,
          ),
          textAlign: TextAlign.center,
        ).animate()
          .fadeIn(duration: 600.ms, delay: 600.ms)
          .slideY(begin: 0.2, end: 0),
        
        SizedBox(height: 12.h),
        
        Text(
          'Quick demo access or full authentication',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.textSecondary,
          ),
          textAlign: TextAlign.center,
        ).animate()
          .fadeIn(duration: 600.ms, delay: 800.ms)
          .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildDemoLoginButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Demo Accounts',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ).animate()
          .fadeIn(duration: 600.ms, delay: 1000.ms),
        
        SizedBox(height: 20.h),
        
        // Artist Demo Button
        _buildDemoButton(
          title: 'Artist Dashboard',
          subtitle: 'Explore Live Streams, Auctions & Featured Content',
          icon: Icons.music_note_rounded,
          gradient: LinearGradient(
            colors: [AppTheme.accentColor, AppTheme.successColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          onTap: () => _loginAsArtist(),
        ).animate()
          .fadeIn(duration: 600.ms, delay: 1200.ms)
          .slideX(begin: -0.3, end: 0),
        
        SizedBox(height: 16.h),
        
        // Producer Demo Button
        _buildDemoButton(
          title: 'Producer Dashboard',
          subtitle: 'Manage Auctions, Upload Beats & Track Analytics',
          icon: Icons.library_music_rounded,
          gradient: LinearGradient(
            colors: [AppTheme.warningColor, AppTheme.accentColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          onTap: () => _loginAsProducer(),
        ).animate()
          .fadeIn(duration: 600.ms, delay: 1400.ms)
          .slideX(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildDemoButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
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
          onTap: _isLoading ? null : onTap,
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: gradient.colors.first.withOpacity(0.1) == gradient.colors.first.withOpacity(0.1)
                  ? LinearGradient(
                      colors: [
                        gradient.colors.first.withOpacity(0.1),
                        gradient.colors.last.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 60.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 28.sp,
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
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 13.sp,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                if (_isLoading)
                  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        gradient.colors.first,
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios,
                    color: gradient.colors.first,
                    size: 16.sp,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRealAuthButton() {
    return Column(
      children: [
        // Divider
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1.h,
                color: AppTheme.glassBorder,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'OR',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 12.sp,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1.h,
                color: AppTheme.glassBorder,
              ),
            ),
          ],
        ).animate()
          .fadeIn(duration: 600.ms, delay: 1600.ms),
        
        SizedBox(height: 24.h),
        
        // Real auth button
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
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.rightToBracket,
                    color: AppTheme.textPrimary,
                    size: 18.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Full Authentication',
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).animate()
          .fadeIn(duration: 600.ms, delay: 1800.ms)
          .slideY(begin: 0.2, end: 0),
      ],
    );
  }

  void _loginAsArtist() {
    print('🎨 Artist login button pressed - navigating to dashboard with LiveStreams & Live Auctions');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const NewDashboardScreen(userRole: 'artist'),
      ),
    );
  }

  void _loginAsProducer() {
    print('🎵 Producer login button pressed - navigating to dashboard with My Auctions & Previous Auctions');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const NewDashboardScreen(userRole: 'producer'),
      ),
    );
  }
}
