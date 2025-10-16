import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';

class GlassSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final TextEditingController? controller;

  const GlassSearchBar({
    super.key,
    this.hintText = 'Search',
    this.onTap,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 345.w,
      height: 56.h,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.glassColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppTheme.glassBorder,
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              child: Row(
                children: [
                  // Search Icon
                  Container(
                    width: 24.w,
                    height: 24.h,
                    child: Icon(
                      Icons.search,
                      color: AppTheme.textSecondary,
                      size: 24.sp,
                    ),
                  ),
                  
                  SizedBox(width: 8.w),
                  
                  // Search Text/Input
                  Expanded(
                    child: controller != null
                        ? TextField(
                            controller: controller,
                            style: TextStyle(
                              fontFamily: 'Wix Madefor Display',
                              fontSize: 14.sp,
                              color: AppTheme.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: hintText,
                              hintStyle: TextStyle(
                                fontFamily: 'Wix Madefor Display',
                                fontSize: 14.sp,
                                color: AppTheme.textSecondary,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          )
                        : GestureDetector(
                            onTap: onTap,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                hintText,
                                style: TextStyle(
                                  fontFamily: 'Wix Madefor Display',
                                  fontSize: 14.sp,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
