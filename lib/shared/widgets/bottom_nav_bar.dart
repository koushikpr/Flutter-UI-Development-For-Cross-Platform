import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade700,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 70.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.live_tv,
                label: 'Live Feed',
                isActive: currentIndex == 0,
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.store,
                label: 'Marketplace',
                isActive: currentIndex == 1,
              ),
              _buildNavItem(
                index: 2,
                icon: Icons.add_circle_outline,
                label: 'Add Beats',
                isActive: currentIndex == 2,
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.favorite_outline,
                label: 'Favorites',
                isActive: currentIndex == 3,
              ),
              _buildNavItem(
                index: 4,
                icon: Icons.person_outline,
                label: 'Profile',
                isActive: currentIndex == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: 60.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: isActive 
                    ? AppTheme.accentColor
                    : AppTheme.primaryColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                icon,
                color: isActive 
                    ? Colors.white
                    : Colors.grey.shade400,
                size: 16.sp,
              ),
            ),
            
            SizedBox(height: 4.h),
            
            // Label
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Wix Madefor Display',
                fontSize: 9.sp,
                fontWeight: FontWeight.w400,
                color: isActive 
                    ? Colors.white
                    : Colors.grey.shade400,
                letterSpacing: -0.04,
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
}
