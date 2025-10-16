import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';

class CustomStatusBar extends StatelessWidget {
  const CustomStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 393.w,
      height: 44.h,
      padding: EdgeInsets.only(top: 12.h),
      child: Row(
        children: [
          // Time Section
          Expanded(
            child: Center(
              child: Text(
                '9:41', // Default iOS time
                style: TextStyle(
                  fontFamily: 'SF Pro Text',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentColor,
                  letterSpacing: -0.408,
                ),
              ),
            ),
          ),
          
          // Dynamic Island/Notch
          Container(
            width: 126.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(60.r),
            ),
            child: Stack(
              children: [
                // Camera lens
                Positioned(
                  right: 11.9.w,
                  top: 10.4.h,
                  child: Container(
                    width: 11.2.w,
                    height: 11.2.h,
                    decoration: BoxDecoration(
                      color: AppTheme.notchColor,
                      border: Border.all(
                        color: const Color(0xFF1C1932),
                        width: 0.86.w,
                      ),
                      borderRadius: BorderRadius.circular(11.2.r),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 4.31.w,
                          top: 2.15.h,
                          child: Container(
                            width: 2.58.w,
                            height: 2.58.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF686D95),
                              borderRadius: BorderRadius.circular(2.58.r),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 4.74.w,
                          top: 6.89.h,
                          child: Container(
                            width: 2.15.w,
                            height: 2.15.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF52567C),
                              borderRadius: BorderRadius.circular(2.15.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Right Side (Signal, WiFi, Battery)
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Mobile Signal
                  Icon(
                    Icons.signal_cellular_4_bar,
                    color: AppTheme.accentColor,
                    size: 17.sp,
                  ),
                  SizedBox(width: 9.w),
                  
                  // WiFi
                  Icon(
                    Icons.wifi,
                    color: AppTheme.accentColor,
                    size: 17.sp,
                  ),
                  SizedBox(width: 9.w),
                  
                  // Battery
                  Container(
                    width: 27.w,
                    height: 13.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Stack(
                      children: [
                        // Battery body
                        Container(
                          width: 25.w,
                          height: 13.h,
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Container(
                            margin: EdgeInsets.all(1.w),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                          ),
                        ),
                        // Battery tip
                        Positioned(
                          right: 0,
                          top: 4.h,
                          child: Container(
                            width: 2.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor,
                              borderRadius: BorderRadius.circular(1.r),
                            ),
                          ),
                        ),
                      ],
                    ),
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
