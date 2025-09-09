import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/custom_status_bar.dart';
import '../../shared/widgets/glass_search_bar.dart';
import '../../shared/widgets/auction_card.dart';
import '../../shared/widgets/bottom_nav_bar.dart';

class AuctionScreen extends StatefulWidget {
  const AuctionScreen({super.key});

  @override
  State<AuctionScreen> createState() => _AuctionScreenState();
}

class _AuctionScreenState extends State<AuctionScreen> {
  int _currentNavIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Status Bar
              const CustomStatusBar(),
              
              // Search Bar
              SizedBox(height: 12.h),
              const GlassSearchBar(),
              
              // Upcoming Auctions Section
              SizedBox(height: 16.h),
              _buildUpcomingAuctionsCard(),
              
              // Live Auctions Header
              SizedBox(height: 16.h),
              _buildLiveAuctionsHeader(),
              
              // Auction Cards List
              Expanded(
                child: _buildAuctionsList(),
              ),
            ],
          ),
          
          // Bottom Navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNavBar(
              currentIndex: _currentNavIndex,
              onTap: (index) {
                setState(() {
                  _currentNavIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAuctionsCard() {
    return Container(
      width: 345.w,
      height: 106.h,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // Background with blur
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.glassColor,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: AppTheme.glassBorder,
                    width: 1,
                  ),
                ),
              ),
            ),
            
            // Decorative circle
            Positioned(
              right: -66.5.w,
              top: 73.75.h,
              child: Container(
                width: 273.5.w,
                height: 273.5.h,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.textSecondary.withOpacity(0.3),
                    width: 0.91,
                  ),
                  borderRadius: BorderRadius.circular(136.75.r),
                ),
              ),
            ),
            
            // Content
            Positioned(
              left: 24.w,
              top: 24.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upcoming Auctions',
                    style: TextStyle(
                      fontFamily: 'Wix Madefor Display',
                      fontSize: 21.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.04,
                    ),
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  // User avatars
                  Row(
                    children: List.generate(5, (index) {
                      return Container(
                        margin: EdgeInsets.only(right: index < 4 ? 16.w : 0),
                        child: _buildUserAvatar(),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(duration: 600.ms, delay: 200.ms)
      .slideY(begin: 0.2, end: 0);
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 26.w,
      height: 26.h,
      decoration: BoxDecoration(
        color: AppTheme.glassLight,
        borderRadius: BorderRadius.circular(13.r),
      ),
      child: Icon(
        Icons.person,
        color: AppTheme.textPrimary,
        size: 10.sp,
      ),
    );
  }

  Widget _buildLiveAuctionsHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Live Auctions',
            style: TextStyle(
              fontFamily: 'Wix Madefor Display',
              fontSize: 21.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
              letterSpacing: -0.04,
            ),
          ),
          
          Row(
            children: [
              Icon(
                Icons.tune,
                color: AppTheme.filterIconColor,
                size: 14.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                'filter',
                style: TextStyle(
                  fontFamily: 'Wix Madefor Display',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 600.ms, delay: 400.ms)
      .slideX(begin: -0.2, end: 0);
  }

  Widget _buildAuctionsList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(
        top: 16.h,
        bottom: 120.h, // Space for bottom nav
      ),
      itemCount: 4, // Sample count
      itemBuilder: (context, index) {
        return AuctionCard(
          title: 'Breaking Positive Auction',
          username: 'Lumpiaxpapi',
          onContinue: () {
            // Handle continue action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Continue auction ${index + 1}'),
                backgroundColor: AppTheme.glassColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          onShare: () {
            // Handle share action
          },
          onLike: () {
            // Handle like action
          },
        ).animate(delay: (600 + index * 100).ms)
          .fadeIn(duration: 600.ms)
          .slideY(begin: 0.3, end: 0);
      },
    );
  }
}
