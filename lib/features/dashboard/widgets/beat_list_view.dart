import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class BeatListView extends StatelessWidget {
  const BeatListView({
    Key? key,
    this.beatData,
    this.callback,
  }) : super(key: key);

  final VoidCallback? callback;
  final BeatData? beatData;

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
                    // Beat Cover Image with padding
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          width: 84.w, // Reduced to account for padding
                          height: 84.h, // Reduced to account for padding
                          child: Stack(
                            children: [
                              // Image with fade overlay
                              Stack(
                                children: [
                                  Image.network(
                                    'https://picsum.photos/200/200?random=${beatData!.title.hashCode}',
                                    width: 84.w,
                                    height: 84.h,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 84.w,
                                        height: 84.h,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Colors.purple.withOpacity(0.8),
                                              Colors.blue.withOpacity(0.8),
                                            ],
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.music_note,
                                          color: Colors.white,
                                          size: 30.sp,
                                        ),
                                      );
                                    },
                                  ),
                                  // Right fade overlay
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.3),
                                            Colors.black.withOpacity(0.6),
                                          ],
                                          stops: const [0.0, 0.4, 0.8, 1.0],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Play button overlay
                              Center(
                                child: Container(
                                  width: 32.w,
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: Colors.black,
                                    size: 18.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Beat Info
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Beat Title
                            Text(
                              beatData!.title,
                              style: GoogleFonts.getFont(
                                'Wix Madefor Display',
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            
                            SizedBox(height: 4.h),
                            
                            // Producer
                            Text(
                              beatData!.producer,
                              style: GoogleFonts.getFont(
                                'Wix Madefor Display',
                                fontSize: 14.sp,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            
                            SizedBox(height: 8.h),
                            
                            // Genre
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                beatData!.genre,
                                style: GoogleFonts.getFont(
                                  'Wix Madefor Display',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Bid Button - Bottom Right
                Positioned(
                  bottom: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Bid',
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                
                // Like and Share Buttons
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Like Button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(32.r)),
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              beatData!.isFavorite 
                                  ? Icons.favorite 
                                  : Icons.favorite_border,
                              color: beatData!.isFavorite 
                                  ? Colors.red 
                                  : Colors.white,
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(width: 8.w),
                      
                      // Share Button
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(32.r)),
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 16.sp,
                            ),
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
      ),
    );
  }
}

class BeatData {
  final String title;
  final String producer;
  final String genre;
  final int bpm;
  final String key;
  final double price;
  final String license;
  final String imagePath;
  final bool isFavorite;
  final String status; // 'trending', 'new', or ''

  BeatData({
    required this.title,
    required this.producer,
    required this.genre,
    required this.bpm,
    required this.key,
    required this.price,
    required this.license,
    required this.imagePath,
    this.isFavorite = false,
    this.status = '',
  });
}