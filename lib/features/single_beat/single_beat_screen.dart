import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'models/single_beat_model.dart';
import '../music_player/music_player_screen.dart';
import '../cart/models/cart_item_model.dart';
import '../cart/checkout_screen.dart';
import '../cart/state/cart_cubit.dart';

class SingleBeatScreen extends StatefulWidget {
  final SingleBeatModel? singleBeat;

  const SingleBeatScreen({
    super.key,
    this.singleBeat,
  });

  @override
  State<SingleBeatScreen> createState() => _SingleBeatScreenState();
}

class _SingleBeatScreenState extends State<SingleBeatScreen> {
  late SingleBeatModel _singleBeat;

  @override
  void initState() {
    super.initState();
    _singleBeat = widget.singleBeat ?? _getDummySingleBeat();
  }

  SingleBeatModel _getDummySingleBeat() {
    return SingleBeatModel(
      id: '1',
      producerName: "Producer's Name",
      beatTitle: 'Favella',
      artistName: 'ManuGTB',
      price: 20.0,
      description:
          'Each beat is designed to transport you to a serene soundscape, perfect for relaxation or inspiration. Don\'t hesitate to reach out for collaborations or inquiries! 💎',
      expiryDate: DateTime.now().add(const Duration(days: 1, hours: 4)),
      hasLicenseSplit: true,
      duration: '1:02',
      vibeTag: 'Throwback',
      bpm: 143,
      key: 'C min',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 24.h),
            _buildBuyButton(),
            SizedBox(height: 8.h),
            _buildDetailsSection(),
            SizedBox(height: 16.h),
            _buildBeatMetricsSection(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 351.h,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 351.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF4F4F4F),
                  Colors.black.withOpacity(0),
                  Colors.black,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 46.w,
                          height: 46.h,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 46.w,
                          height: 46.h,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.ios_share,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MusicPlayerScreen(
                                producerName: _singleBeat.producerName,
                                trackTitle: _singleBeat.beatTitle,
                                artistName: _singleBeat.artistName,
                                coverImage: _singleBeat.beatImage,
                                rating: 4.1,
                                packTitle: _singleBeat.beatTitle,
                                packType: _singleBeat.vibeTag,
                                price: _singleBeat.price,
                                isPack: false,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.black,
                            size: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        _singleBeat.producerName,
                        style: GoogleFonts.wixMadeforDisplay(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFA3A3A3),
                          height: 1.43,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _singleBeat.fullTitle,
                        style: GoogleFonts.wixMadeforDisplay(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Text(
                            'Single Beat',
                            style: GoogleFonts.wixMadeforDisplay(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.6),
                              height: 1.5,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(100.r),
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  color: const Color(0xFFA3A3A3),
                                  size: 16.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'License split',
                                  style: GoogleFonts.wixMadeforDisplay(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    height: 1.33,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GestureDetector(
        onTap: () {
          final item = CartItemModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            coverImageUrl: _singleBeat.beatImage ?? 'https://api.builder.io/api/v1/image/assets/TEMP/196688b42235e2da5bc2bb8987afa6c83847a3ab',
            producerName: '@${_singleBeat.producerName.replaceAll(" ", "").toLowerCase()}',
            producerAvatarUrl: 'https://via.placeholder.com/16',
            title: _singleBeat.fullTitle,
            type: CartItemType.singleBeat,
            genre: _singleBeat.vibeTag,
            price: _singleBeat.price,
            isDeletable: false,
          );
          context.read<CartCubit>().replaceWithSingleItem(item);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CheckoutScreen(),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(-4, -4),
                spreadRadius: 0,
                blurStyle: BlurStyle.inner,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(4, 4),
                spreadRadius: 0,
                blurStyle: BlurStyle.inner,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            'Buy This Beat — \$${_singleBeat.price.toInt()}',
            style: GoogleFonts.wixMadeforDisplay(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Details',
            style: GoogleFonts.wixMadeforDisplay(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(100.r),
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  color: const Color(0xFFA3A3A3),
                  size: 16.sp,
                ),
                SizedBox(width: 4.w),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.wixMadeforDisplay(
                      fontSize: 12.sp,
                      height: 1.33,
                    ),
                    children: [
                      TextSpan(
                        text: 'Expires in: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      TextSpan(
                        text: _singleBeat.getTimeRemaining(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            _singleBeat.description,
            style: GoogleFonts.wixMadeforDisplay(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFA3A3A3),
              height: 1.43,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeatMetricsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildMetricCard('Duration', '1:02', 90.w),
                SizedBox(width: 4.w),
                _buildMetricCard('Vibe tag', 'Throwback', 116.w),
                SizedBox(width: 4.w),
                _buildMetricCard('BPM', '143 BPM', 99.w),
                SizedBox(width: 4.w),
                _buildMetricCard('Key', 'C min', 92.w),
                SizedBox(width: 20.w), // Add padding at the end
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, double width) {
    return Container(
      width: width,
      height: 58.h, // Further reduced height to eliminate tiny overflow
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h), // Further reduced padding
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
        children: [
          Text(
            label,
            style: GoogleFonts.wixMadeforDisplay(
              fontSize: 11.sp, // Slightly smaller font
              fontWeight: FontWeight.w600,
              color: const Color(0xFFA3A3A3),
              height: 1.2, // Reduced line height
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h), // Reduced spacing
          Text(
            value,
            style: GoogleFonts.wixMadeforDisplay(
              fontSize: 13.sp, // Slightly smaller font
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.2, // Reduced line height
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
