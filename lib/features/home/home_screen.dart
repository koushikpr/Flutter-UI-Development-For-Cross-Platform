import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/animated_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    // Trigger content animation after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _showContent = true);
      }
    });
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
              Color(0xFFF093FB),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppConstants.spacingL.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeader(),
                
                SizedBox(height: 40.h),
                
                // Welcome Card
                _buildWelcomeCard(),
                
                SizedBox(height: 30.h),
                
                // Feature Cards
                _buildFeatureCards(),
                
                const Spacer(),
                
                // Bottom Action Buttons
                _buildActionButtons(),
                
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ).animate(target: _showContent ? 1 : 0)
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideX(begin: -0.3, end: 0),
            
            Text(
              'Bagrz',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
            ).animate(target: _showContent ? 1 : 0)
              .fadeIn(duration: 600.ms, delay: 400.ms)
              .slideX(begin: -0.3, end: 0),
          ],
        ),
        
        // Animated Profile Avatar
        AnimatedBuilder(
          animation: _floatingController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatingController.value * 10),
              child: Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            );
          },
        ).animate(target: _showContent ? 1 : 0)
          .fadeIn(duration: 600.ms, delay: 600.ms)
          .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppConstants.spacingL.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.rocket_launch,
                color: Colors.white,
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Get Started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Experience the power of Flutter animations and beautiful UI components designed for modern mobile applications.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate(target: _showContent ? 1 : 0)
      .fadeIn(duration: 800.ms, delay: 800.ms)
      .slideY(begin: 0.3, end: 0)
      .shimmer(
        duration: 2000.ms,
        delay: 1500.ms,
        color: Colors.white.withOpacity(0.3),
      );
  }

  Widget _buildFeatureCards() {
    final features = [
      {
        'icon': Icons.palette,
        'title': 'Beautiful UI',
        'description': 'Stunning designs with smooth animations',
        'color': const Color(0xFF6366F1),
      },
      {
        'icon': Icons.speed,
        'title': 'High Performance',
        'description': '60fps animations and optimized rendering',
        'color': const Color(0xFF8B5CF6),
      },
      {
        'icon': Icons.devices,
        'title': 'Cross Platform',
        'description': 'Works seamlessly on iOS and Android',
        'color': const Color(0xFF06B6D4),
      },
    ];

    return Column(
      children: features.asMap().entries.map((entry) {
        final index = entry.key;
        final feature = entry.value;
        
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          child: _buildFeatureCard(
            icon: feature['icon'] as IconData,
            title: feature['title'] as String,
            description: feature['description'] as String,
            color: feature['color'] as Color,
            delay: 1000 + (index * 200),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required int delay,
  }) {
    return Container(
      padding: EdgeInsets.all(AppConstants.spacingM.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
            ),
            child: Icon(
              icon,
              color: Colors.white,
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
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate(target: _showContent ? 1 : 0)
      .fadeIn(duration: 600.ms, delay: delay.ms)
      .slideX(begin: 0.3, end: 0);
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        PrimaryButton(
          text: 'Explore Features',
          width: double.infinity,
          onPressed: () {
            // TODO: Navigate to features screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Features coming soon!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          icon: Icon(Icons.explore, size: 20.sp),
        ).animate(target: _showContent ? 1 : 0)
          .fadeIn(duration: 600.ms, delay: 1800.ms)
          .slideY(begin: 0.3, end: 0),
        
        SizedBox(height: 12.h),
        
        SecondaryButton(
          text: 'View Documentation',
          width: double.infinity,
          onPressed: () {
            // TODO: Navigate to documentation
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Documentation coming soon!'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          icon: Icon(Icons.book, size: 20.sp),
        ).animate(target: _showContent ? 1 : 0)
          .fadeIn(duration: 600.ms, delay: 2000.ms)
          .slideY(begin: 0.3, end: 0),
      ],
    );
  }
}
