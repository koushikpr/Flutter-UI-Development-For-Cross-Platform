import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/custom_status_bar.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  int _expandedFAQIndex = -1;

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How do I upload beats for auction?',
      'answer': 'Go to your profile, tap the "+" button, select "Upload Beat", fill in the details including title, genre, BPM, and set your auction parameters like starting price and duration.'
    },
    {
      'question': 'How does the bidding system work?',
      'answer': 'Artists can bid on beats in real-time. The highest bidder when the auction ends wins the exclusive rights to the beat. You\'ll receive notifications for bid updates.'
    },
    {
      'question': 'What are live streaming sessions?',
      'answer': 'Artists can host live streaming sessions to showcase their music, interact with fans, and collaborate with producers in real-time. Tap "Go Live" from your dashboard.'
    },
    {
      'question': 'How do I become a verified artist/producer?',
      'answer': 'Go to Settings > Account Verification. Submit your social media profiles, streaming platform links, and any music industry credentials for review.'
    },
    {
      'question': 'What payment methods are supported?',
      'answer': 'We support major credit cards, PayPal, Apple Pay, Google Pay, and cryptocurrency payments for beat purchases and auction wins.'
    },
    {
      'question': 'How do I download purchased beats?',
      'answer': 'After winning an auction or purchasing a beat, go to "My Music" in your profile. You\'ll find all your purchased beats with download links for different formats (MP3, WAV, stems).'
    },
    {
      'question': 'Can I collaborate with other users?',
      'answer': 'Yes! Use our collaboration features to connect with artists and producers. Send collaboration requests through their profiles or join collaborative live sessions.'
    },
    {
      'question': 'How do I report inappropriate content?',
      'answer': 'Tap the three dots menu on any content and select "Report". Choose the appropriate reason and our moderation team will review it within 24 hours.'
    },
    {
      'question': 'What are sound packs?',
      'answer': 'Sound packs are collections of samples, loops, and one-shots that producers can sell. They\'re perfect for artists looking for specific sounds or producers wanting to monetize their sample libraries.'
    },
    {
      'question': 'How do I change my subscription plan?',
      'answer': 'Go to Settings > Subscription. You can upgrade, downgrade, or cancel your plan. Changes take effect at the next billing cycle.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Column(
        children: [
          const CustomStatusBar(),
          
          // Header
          _buildHeader(),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  
                  // Welcome Section
                  _buildWelcomeSection(),
                  
                  SizedBox(height: 32.h),
                  
                  // Quick Actions
                  _buildQuickActions(),
                  
                  SizedBox(height: 32.h),
                  
                  // FAQ Section
                  _buildFAQSection(),
                  
                  SizedBox(height: 32.h),
                  
                  // Contact Support
                  _buildContactSection(),
                  
                  SizedBox(height: 32.h),
                  
                  // Community Links
                  _buildCommunitySection(),
                  
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
              'Help & Support',
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

  Widget _buildWelcomeSection() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentColor.withOpacity(0.2),
            AppTheme.warningColor.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppTheme.glassBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.support_agent_rounded,
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
                      'How can we help?',
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Find answers, get support, and learn how to make the most of BAGR_Z',
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        
        SizedBox(height: 16.h),
        
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.video_library_outlined,
                title: 'Tutorials',
                subtitle: 'Step-by-step guides',
                onTap: () => _showComingSoon('Video Tutorials'),
              ),
            ),
            
            SizedBox(width: 12.w),
            
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.chat_bubble_outline,
                title: 'Live Chat',
                subtitle: 'Chat with support',
                onTap: () => _showLiveChatDialog(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
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
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.accentColor,
                    size: 20.sp,
                  ),
                ),
                
                SizedBox(height: 12.h),
                
                Text(
                  title,
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 4.h),
                
                Text(
                  subtitle,
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        
        SizedBox(height: 16.h),
        
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _faqs.length,
          separatorBuilder: (context, index) => SizedBox(height: 8.h),
          itemBuilder: (context, index) {
            return _buildFAQItem(index);
          },
        ),
      ],
    );
  }

  Widget _buildFAQItem(int index) {
    final faq = _faqs[index];
    final isExpanded = _expandedFAQIndex == index;
    
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.glassColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isExpanded ? AppTheme.accentColor.withOpacity(0.5) : AppTheme.glassBorder,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            setState(() {
              _expandedFAQIndex = isExpanded ? -1 : index;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        faq['question']!,
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.white.withOpacity(0.6),
                      size: 20.sp,
                    ),
                  ],
                ),
                
                if (isExpanded) ...[
                  SizedBox(height: 12.h),
                  Text(
                    faq['answer']!,
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Support',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        
        SizedBox(height: 16.h),
        
        _buildContactOption(
          icon: Icons.email_outlined,
          title: 'Email Support',
          subtitle: 'support@bagr.app • Response within 24 hours',
          onTap: () => _launchEmail(),
        ),
        
        SizedBox(height: 12.h),
        
        _buildContactOption(
          icon: Icons.phone_outlined,
          title: 'Call Support',
          subtitle: '+1 (555) 123-BAGR • Mon-Fri 9AM-6PM EST',
          onTap: () => _launchPhone(),
        ),
        
        SizedBox(height: 12.h),
        
        _buildContactOption(
          icon: Icons.bug_report_outlined,
          title: 'Report a Bug',
          subtitle: 'Help us improve by reporting issues',
          onTap: () => _showBugReportDialog(),
        ),
        
        SizedBox(height: 12.h),
        
        _buildContactOption(
          icon: Icons.feedback_outlined,
          title: 'Send Feedback',
          subtitle: 'Share your thoughts and suggestions',
          onTap: () => _showFeedbackDialog(),
        ),
      ],
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
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.accentColor,
                    size: 20.sp,
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
                          fontSize: 14.sp,
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

  Widget _buildCommunitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Community',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        
        SizedBox(height: 16.h),
        
        Row(
          children: [
            Expanded(
              child: _buildSocialCard(
                icon: FontAwesomeIcons.discord,
                title: 'Discord',
                subtitle: 'Join our community',
                color: const Color(0xFF5865F2),
                onTap: () => _launchDiscord(),
              ),
            ),
            
            SizedBox(width: 12.w),
            
            Expanded(
              child: _buildSocialCard(
                icon: FontAwesomeIcons.twitter,
                title: 'Twitter',
                subtitle: 'Follow updates',
                color: const Color(0xFF1DA1F2),
                onTap: () => _launchTwitter(),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 12.h),
        
        Row(
          children: [
            Expanded(
              child: _buildSocialCard(
                icon: FontAwesomeIcons.youtube,
                title: 'YouTube',
                subtitle: 'Tutorials & tips',
                color: const Color(0xFFFF0000),
                onTap: () => _launchYouTube(),
              ),
            ),
            
            SizedBox(width: 12.w),
            
            Expanded(
              child: _buildSocialCard(
                icon: FontAwesomeIcons.instagram,
                title: 'Instagram',
                subtitle: 'Behind the scenes',
                color: const Color(0xFFE4405F),
                onTap: () => _launchInstagram(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20.sp,
                  ),
                ),
                
                SizedBox(height: 12.h),
                
                Text(
                  title,
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 4.h),
                
                Text(
                  subtitle,
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 12.sp,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Action Methods
  void _showComingSoon(String feature) {
    _showMessage('$feature coming soon!');
  }

  void _showLiveChatDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Live Chat Support',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          content: Text(
            'Live chat is available Monday-Friday, 9AM-6PM EST. Outside these hours, please send us an email for the fastest response.',
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
                'Close',
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
                _showComingSoon('Live Chat');
              },
              child: Text(
                'Start Chat',
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

  void _showBugReportDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Report a Bug',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          content: Text(
            'Help us improve BAGR_Z by reporting bugs. Please include:\n\n• What you were trying to do\n• What happened instead\n• Your device and app version\n• Screenshots if helpful',
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
                _launchEmail(subject: 'Bug Report - BAGR_Z App');
              },
              child: Text(
                'Send Report',
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

  void _showFeedbackDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            'Send Feedback',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          content: Text(
            'We value your input! Share your thoughts on:\n\n• Features you\'d like to see\n• Improvements to existing features\n• Overall app experience\n• Anything else on your mind',
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
                _launchEmail(subject: 'Feedback - BAGR_Z App');
              },
              child: Text(
                'Send Feedback',
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

  // Launch Methods
  void _launchEmail({String? subject}) async {
    final emailSubject = subject ?? 'Support Request - BAGR_Z App';
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@bagr.app',
      query: 'subject=${Uri.encodeComponent(emailSubject)}',
    );
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showMessage('Could not open email app');
    }
  }

  void _launchPhone() async {
    final uri = Uri(scheme: 'tel', path: '+15551234BAGR');
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      _showMessage('Could not open phone app');
    }
  }

  void _launchDiscord() async {
    const url = 'https://discord.gg/bagrz';
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showMessage('Could not open Discord');
    }
  }

  void _launchTwitter() async {
    const url = 'https://twitter.com/bagrz_app';
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showMessage('Could not open Twitter');
    }
  }

  void _launchYouTube() async {
    const url = 'https://youtube.com/@bagrz';
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showMessage('Could not open YouTube');
    }
  }

  void _launchInstagram() async {
    const url = 'https://instagram.com/bagrz_app';
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showMessage('Could not open Instagram');
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
