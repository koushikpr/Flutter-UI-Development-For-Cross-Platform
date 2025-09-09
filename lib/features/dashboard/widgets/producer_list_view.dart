import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class ProducerListView extends StatelessWidget {
  const ProducerListView({
    Key? key,
    this.producerData,
    this.callback,
  }) : super(key: key);

  final VoidCallback? callback;
  final ProducerData? producerData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 8.h,
        bottom: 16.h,
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: callback,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16.r)),
            color: AppTheme.glassColor,
            border: Border.all(
              color: AppTheme.glassBorder,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(16.r)),
            child: Stack(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    // Producer Profile Image
                    Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          bottomLeft: Radius.circular(16.r),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          bottomLeft: Radius.circular(16.r),
                        ),
                        child: Container(
                          width: 100.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.orange.withOpacity(0.8),
                                Colors.red.withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40.sp,
                          ),
                        ),
                      ),
                    ),
                    
                    // Producer Info
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Producer Name
                            Text(
                              producerData!.name,
                              style: GoogleFonts.getFont(
                                'Wix Madefor Display',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            
                            SizedBox(height: 4.h),
                            
                            // Location & Specialty
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 14.sp,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  producerData!.location,
                                  style: GoogleFonts.getFont(
                                    'Wix Madefor Display',
                                    fontSize: 12.sp,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    producerData!.specialty,
                                    style: GoogleFonts.getFont(
                                      'Wix Madefor Display',
                                      fontSize: 10.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 8.h),
                            
                            // Stats Row
                            Row(
                              children: <Widget>[
                                // Rating
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 14.sp,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      producerData!.rating.toString(),
                                      style: GoogleFonts.getFont(
                                        'Wix Madefor Display',
                                        fontSize: 12.sp,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 16.w),
                                // Beats Count
                                Row(
                                  children: [
                                    Icon(
                                      Icons.music_note_outlined,
                                      size: 14.sp,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '${producerData!.beatsCount} beats',
                                      style: GoogleFonts.getFont(
                                        'Wix Madefor Display',
                                        fontSize: 12.sp,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Follow Button & Price Range
                    Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '\$${producerData!.priceRange}',
                            style: GoogleFonts.getFont(
                              'Wix Madefor Display',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'avg price',
                            style: GoogleFonts.getFont(
                              'Wix Madefor Display',
                              fontSize: 10.sp,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: producerData!.isFollowing 
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: producerData!.isFollowing 
                                  ? Border.all(color: Colors.white, width: 1)
                                  : null,
                            ),
                            child: Text(
                              producerData!.isFollowing ? 'Following' : 'Follow',
                              style: GoogleFonts.getFont(
                                'Wix Madefor Display',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: producerData!.isFollowing 
                                    ? Colors.white 
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Online Status
                if (producerData!.isOnline)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      width: 12.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                
                // Verified Badge
                if (producerData!.isVerified)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.verified,
                        color: Colors.white,
                        size: 12.sp,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProducerData {
  final String name;
  final String location;
  final String specialty;
  final double rating;
  final int beatsCount;
  final String priceRange;
  final String profileImage;
  final bool isFollowing;
  final bool isOnline;
  final bool isVerified;

  ProducerData({
    required this.name,
    required this.location,
    required this.specialty,
    required this.rating,
    required this.beatsCount,
    required this.priceRange,
    required this.profileImage,
    this.isFollowing = false,
    this.isOnline = false,
    this.isVerified = false,
  });
}