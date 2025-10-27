import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/beat_pack_model.dart';
import '../music_player/music_player_screen.dart';

class BeatPackScreen extends StatefulWidget {
  final BeatPackModel? beatPack;

  const BeatPackScreen({
    super.key,
    this.beatPack,
  });

  @override
  State<BeatPackScreen> createState() => _BeatPackScreenState();
}

class _BeatPackScreenState extends State<BeatPackScreen> {
  late BeatPackModel _beatPack;
  bool _showLicenseModal = false;

  @override
  void initState() {
    super.initState();
    _beatPack = widget.beatPack ?? _getDummyBeatPack();
  }

  BeatPackModel _getDummyBeatPack() {
    return BeatPackModel(
      id: '1',
      producerName: "Producer's Name",
      packTitle: 'Trap Essentials',
      price: 20.0,
      beatCount: 6,
      description:
          'Each beat is designed to transport you to a serene soundscape, perfect for relaxation or inspiration. Don\'t hesitate to reach out for collaborations or inquiries! 💎',
      expiryDate: DateTime.now().add(const Duration(days: 1, hours: 4)),
      hasLicenseSplit: true,
      beats: [
        BeatModel(
          id: '1',
          title: 'Favella',
          artistName: 'ManuGTB',
          duration: '2:36',
          genre: 'Hip-hop',
          bpm: 143,
          key: 'C minor',
        ),
        BeatModel(
          id: '2',
          title: 'Rhythm City',
          artistName: 'BeatMaster',
          duration: '2:36',
          genre: 'Hip-hop',
          bpm: 143,
          key: 'C minor',
        ),
        BeatModel(
          id: '3',
          title: 'Urban Vibes',
          artistName: 'SoundSmith',
          duration: '2:36',
          genre: 'Hip-hop',
          bpm: 143,
          key: 'C minor',
        ),
        BeatModel(
          id: '4',
          title: 'Groove Avenue',
          artistName: 'DJ Echo',
          duration: '2:36',
          genre: 'Hip-hop',
          bpm: 143,
          key: 'C minor',
        ),
        BeatModel(
          id: '5',
          title: 'Favella',
          artistName: 'ManuGTB',
          duration: '2:36',
          genre: 'Hip-hop',
          bpm: 143,
          key: 'C minor',
        ),
        BeatModel(
          id: '6',
          title: 'Favella',
          artistName: 'ManuGTB',
          duration: '2:36',
          genre: 'Hip-hop',
          bpm: 143,
          key: 'C minor',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(height: 24.h),
                _buildBuyButton(),
                SizedBox(height: 8.h),
                _buildDetailsSection(),
                SizedBox(height: 16.h),
                _buildBeatsSection(),
                SizedBox(height: 40.h),
              ],
            ),
          ),
          if (_showLicenseModal) _buildLicenseModal(),
        ],
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
                          if (_beatPack.beats.isNotEmpty) {
                            final firstBeat = _beatPack.beats.first;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MusicPlayerScreen(
                                  producerName: _beatPack.producerName,
                                  trackTitle: firstBeat.title,
                                  artistName: firstBeat.artistName,
                                  coverImage: firstBeat.coverImage,
                                  rating: 4.1,
                                  packTitle: _beatPack.packTitle,
                                  packType: 'Hip-hop',
                                  price: _beatPack.price,
                                  isPack: true,
                                ),
                              ),
                            );
                          }
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
                        _beatPack.producerName,
                        style: GoogleFonts.wixMadeforDisplay(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFA3A3A3),
                          height: 1.43,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _beatPack.packTitle,
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
                            'Beat Pack',
                            style: GoogleFonts.wixMadeforDisplay(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.6),
                              height: 1.5,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showLicenseModal = true;
                              });
                            },
                            child: Container(
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
        onTap: () {},
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
            'Buy This Pack — \$${_beatPack.price.toInt()}',
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
                        text: _beatPack.getTimeRemaining(),
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
            _beatPack.description,
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

  Widget _buildBeatsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_beatPack.beatCount} Beats',
            style: GoogleFonts.wixMadeforDisplay(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          SizedBox(height: 16.h),
          ..._beatPack.beats.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildBeatItem(entry.value, entry.key),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBeatItem(BeatModel beat, int index) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.music_note,
            color: Colors.white,
            size: 16.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                beat.fullTitle,
                style: GoogleFonts.wixMadeforDisplay(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: index == 4 ? Colors.white : const Color(0xFFE5E5E5),
                  height: 1.43,
                ),
              ),
              Text(
                beat.metadata,
                style: GoogleFonts.wixMadeforDisplay(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.6),
                  height: 1.67,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLicenseModal() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showLicenseModal = false;
        });
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xCC000000),
        child: GestureDetector(
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF242424),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                  border: Border.all(
                    color: const Color(0x26FFFFFF),
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 43.75.w,
                      top: 34.h,
                      child: Container(
                        width: 226.w,
                        height: 226.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(
                            colors: [
                              Color(0x1FEDC5FC),
                              Color(0x00EDC5FC),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 52.h, 20.w, 0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Text(
                                _beatPack.packTitle,
                                style: GoogleFonts.wixMadeforDisplay(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFA3A3A3),
                                  height: 1.43,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Non-Exclusive License',
                                style: GoogleFonts.wixMadeforDisplay(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  height: 1.27,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 24.h),
                              Container(
                                width: double.infinity,
                                height: 140.h,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 16.h),
                                decoration: BoxDecoration(
                                  color: const Color(0x0DFFFFFF),
                                  borderRadius: BorderRadius.circular(16.r),
                                  border: Border.all(
                                    color: const Color(0x1AFFFFFF),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Ownership',
                                      style: GoogleFonts.fjallaOne(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFFA3A3A3),
                                        height: 1.14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 12.h),
                                    ShaderMask(
                                      shaderCallback: (bounds) => const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFF999999),
                                          Color(0xFFFFFFFF),
                                        ],
                                      ).createShader(bounds),
                                      child: const Text(
                                        '0%',
                                        style: TextStyle(
                                          fontFamily: 'Fjalla One',
                                          fontSize: 40,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                          height: 1.2,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Text(
                                      'Producer retains ownership',
                                      style: GoogleFonts.wixMadeforDisplay(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0x99FFFFFF),
                                        height: 1.67,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 100.h,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 16.h),
                                      decoration: BoxDecoration(
                                        color: const Color(0x0DFFFFFF),
                                        borderRadius: BorderRadius.circular(16.r),
                                        border: Border.all(
                                          color: const Color(0x1AFFFFFF),
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Credits',
                                            style: GoogleFonts.fjallaOne(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFFA3A3A3),
                                              height: 1.14,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 12.h),
                                          Text(
                                            '100% to Producer',
                                            style: GoogleFonts.fjallaOne(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFFFAFAFA),
                                              height: 1.56,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Container(
                                      height: 100.h,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 16.h),
                                      decoration: BoxDecoration(
                                        color: const Color(0x0DFFFFFF),
                                        borderRadius: BorderRadius.circular(16.r),
                                        border: Border.all(
                                          color: const Color(0x1AFFFFFF),
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Royalties',
                                            style: GoogleFonts.fjallaOne(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFFA3A3A3),
                                              height: 1.14,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 12.h),
                                          Text(
                                            '80% to Producer',
                                            style: GoogleFonts.fjallaOne(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFFFAFAFA),
                                              height: 1.56,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 32.h),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showLicenseModal = false;
                              });
                            },
                            child: Container(
                              height: 56.h,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 16.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'View Full License',
                                style: GoogleFonts.wixMadeforDisplay(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  height: 1.43,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Container(
                            height: 21.h,
                            alignment: Alignment.center,
                            child: Container(
                              width: 139.w,
                              height: 5.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 16.w,
                      top: 16.h,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showLicenseModal = false;
                          });
                        },
                        child: Container(
                          width: 20.w,
                          height: 20.h,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20.sp,
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
    );
  }

}
