import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../beat_pack/beat_pack_screen.dart';
import '../single_beat/single_beat_screen.dart';

class ProducerPublicProfileScreen extends StatefulWidget {
  final String producerId;

  const ProducerPublicProfileScreen({
    super.key,
    required this.producerId,
  });

  @override
  State<ProducerPublicProfileScreen> createState() => _ProducerPublicProfileScreenState();
}

class _ProducerPublicProfileScreenState extends State<ProducerPublicProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  double _tipAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopNavBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 24.h),
                    _buildProfileHeader(),
                    SizedBox(height: 20.h),
                    _buildActionButtons(),
                    SizedBox(height: 24.h),
                    _buildTabBar(),
                    _buildTabContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
          GestureDetector(
            onTap: _showActionSheet,
            child: Icon(
              Icons.more_horiz,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileImage(),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLevelBadge(),
                    SizedBox(height: 8.h),
                    _buildProducerName(),
                    SizedBox(height: 4.h),
                    _buildLiveStatus(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildLocation(),
          SizedBox(height: 8.h),
          _buildBio(),
          SizedBox(height: 20.h),
          _buildSocialLinks(),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        Container(
          width: 92.w,
          height: 92.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF444444),
              width: 3,
            ),
          ),
          child: ClipOval(
            child: Container(
              margin: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
              child: Image.network(
                'https://api.builder.io/api/v1/image/assets/TEMP/2437fb4679ce441b10d0af60b91d59b3a9f69378',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: -3.w,
          top: 0,
          child: Image.network(
            'https://api.builder.io/api/v1/image/assets/TEMP/c03d01c46873983c152aec99050a787b2e946a7b',
            width: 26.w,
            height: 28.h,
            errorBuilder: (context, error, stackTrace) => SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget _buildLevelBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Level: ',
              style: GoogleFonts.fjallaOne(
                fontSize: 12.sp,
                color: const Color(0xFF737373),
              ),
            ),
            TextSpan(
              text: 'Hustler',
              style: GoogleFonts.fjallaOne(
                fontSize: 12.sp,
                color: const Color(0xFFFAFAFA),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProducerName() {
    return Text(
      "Producer's Name",
      style: GoogleFonts.wixMadeforDisplay(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: -0.36,
      ),
    );
  }

  Widget _buildLiveStatus() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          height: 20.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Center(
            child: Text(
              'Live',
              style: GoogleFonts.wixMadeforDisplay(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF080808),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          'Livestream name',
          style: GoogleFonts.wixMadeforDisplay(
            fontSize: 14.sp,
            color: const Color(0xFFA3A3A3),
          ),
        ),
      ],
    );
  }

  Widget _buildLocation() {
    return Text(
      '📍 Atlanta, GA',
      style: GoogleFonts.wixMadeforDisplay(
        fontSize: 14.sp,
        color: Colors.white.withOpacity(0.6),
      ),
    );
  }

  Widget _buildBio() {
    return Text(
      '🎧 Based in Atlanta, crafting beats that resonate and inspire. Feel free to DM for exciting collaborations! 💎',
      style: GoogleFonts.wixMadeforDisplay(
        fontSize: 12.sp,
        color: const Color(0xFFA3A3A3),
        height: 1.33,
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSocialLink(Icons.play_circle_outline, 'youtube.com/808wizard'),
              SizedBox(height: 12.h),
              _buildSocialLink(Icons.music_note, '@wizardbeats'),
            ],
          ),
        ),
        SizedBox(width: 24.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSocialLink(Icons.camera_alt, '@808wizard'),
              SizedBox(height: 12.h),
              _buildSocialLink(Icons.cloud, 'soundcloud.com/jordan808'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLink(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: const Color(0xFFE5E5E5),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.wixMadeforDisplay(
              fontSize: 12.sp,
              color: const Color(0xFFE5E5E5),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      size: 20.sp,
                      color: Colors.black,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Favorite',
                      style: GoogleFonts.wixMadeforDisplay(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 16.sp,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Message',
                            style: GoogleFonts.wixMadeforDisplay(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () => _showTippingModal(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: 16.sp,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Tip',
                            style: GoogleFonts.wixMadeforDisplay(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.15),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildTab('Shop', 0),
          _buildTab('Streams', 1),
          _buildTabWithBadge('Co-Signs', 2, '18'),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _tabController.animateTo(index);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 1,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.wixMadeforDisplay(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabWithBadge(String title, int index, String badgeText) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _tabController.animateTo(index);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.wixMadeforDisplay(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                height: 16.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF525252),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.wixMadeforDisplay(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFAFAFA),
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShopGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildShopCard(
                  isPack: true,
                  title: 'Trap Essentials',
                  price: '\$40',
                  expiresIn: '1d 4h',
                  itemType: 'Beat Pack',
                ),
              ),
              SizedBox(width: 19.w),
              Expanded(
                child: _buildShopCard(
                  isPack: false,
                  title: 'Favella - ManuGTB',
                  price: '\$20',
                  expiresIn: '1d 4h',
                  itemType: 'Single Beat',
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: _buildShopCard(
                  isPack: false,
                  title: 'Favella - ManuGTB',
                  price: '\$20',
                  expiresIn: '1d 4h',
                  itemType: 'Single Loop',
                ),
              ),
              SizedBox(width: 19.w),
              Expanded(
                child: _buildShopCard(
                  isPack: true,
                  title: '6 One-Shots',
                  price: '\$40',
                  expiresIn: '1d 4h',
                  itemType: 'Sound Pack',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShopCard({
    required bool isPack,
    required String title,
    required String price,
    required String expiresIn,
    String? itemType,
  }) {
    return GestureDetector(
      onTap: () {
        if (isPack) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BeatPackScreen(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SingleBeatScreen(),
            ),
          );
        }
      },
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 202.h,
              decoration: BoxDecoration(
                color: const Color(0xFF262626),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Stack(
                children: [
                  if (isPack) _buildPackImageStack() else _buildSingleImage(),
                  _buildExpireBadge(expiresIn),
                  _buildItemBadge(isPack),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          title,
          style: GoogleFonts.wixMadeforDisplay(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Text(
              itemType ?? (isPack ? 'Beat Pack' : 'Single Beat'),
              style: GoogleFonts.wixMadeforDisplay(
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              '·',
              style: GoogleFonts.wixMadeforDisplay(
                fontSize: 12.sp,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              price,
              style: GoogleFonts.wixMadeforDisplay(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFFAFAFA),
              ),
            ),
          ],
        ),
      ],
    ),
    );
  }

  Widget _buildPackImageStack() {
    return Positioned(
      left: 18.w,
      top: 40.h,
      child: SizedBox(
        width: 132.w,
        height: 144.h,
        child: Stack(
          children: [
            Positioned(
              left: 18.w,
              top: 0,
              child: Container(
                width: 96.w,
                height: 97.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF404040),
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ),
            Positioned(
              left: 12.w,
              top: 5.h,
              child: Container(
                width: 109.w,
                height: 109.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF525252),
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 11.h,
              child: Container(
                width: 132.w,
                height: 133.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: const Color(0xFFA4A4A4),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    'https://api.builder.io/api/v1/image/assets/TEMP/196688b42235e2da5bc2bb8987afa6c83847a3ab',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSingleImage() {
    return Positioned(
      left: 18.w,
      top: 51.h,
      child: Container(
        width: 132.w,
        height: 133.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: const Color(0xFFA4A4A4),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.network(
            'https://api.builder.io/api/v1/image/assets/TEMP/196688b42235e2da5bc2bb8987afa6c83847a3ab',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[800],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpireBadge(String expiresIn) {
    return Positioned(
      left: 8.w,
      top: 8.h,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(100.r),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 1,
            ),
          ],
        ),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Expires in: ',
                style: GoogleFonts.wixMadeforDisplay(
                  fontSize: 10.sp,
                  color: const Color(0xFFD4D4D4),
                  letterSpacing: -0.2,
                ),
              ),
              TextSpan(
                text: expiresIn,
                style: GoogleFonts.wixMadeforDisplay(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFAFAFA),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemBadge(bool isPack) {
    return Positioned(
      right: 23.w, // 18.w (image left) + 8.w (margin from image edge)
      bottom: 25.h, // Position relative to image area
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        height: 20.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isPack) ...[
              Text(
                '2',
                style: GoogleFonts.wixMadeforDisplay(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF080808),
                  letterSpacing: -0.24,
                  height: 1,
                ),
              ),
              SizedBox(width: 2.w),
              Icon(
                Icons.library_music,
                size: 16.sp,
                color: Colors.black,
              ),
            ] else
              Icon(
                Icons.music_note,
                size: 12.sp,
                color: Colors.black,
              ),
          ],
        ),
      ),
    );
  }

  void _showTippingModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            // Header with close button
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24),
                  Text(
                    'Support the Producer ❤️',
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 24.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Subtitle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                'Show your appreciation for this\namazing producer!',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            SizedBox(height: 32.h),
            
            // Tip amount display
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Text(
                  '\$${_tipAmount.toInt()}',
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
            
            // Tip amount buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTipAmountButton(5),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildTipAmountButton(10),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildTipAmountButton(15),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 32.h),
            
            // Send Tip button with gradient
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: GestureDetector(
                onTap: _tipAmount > 0 ? () {
                  final tipAmountInt = _tipAmount.toInt();
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Tip of \$${tipAmountInt} sent to the producer! 💖',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  );
                  setState(() {
                    _tipAmount = 0.0;
                  });
                } : null,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    gradient: _tipAmount > 0 
                        ? LinearGradient(
                            colors: [Colors.yellow, Colors.green],
                          )
                        : null,
                    color: _tipAmount > 0 ? null : Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.attach_money, 
                        color: _tipAmount > 0 ? Colors.black : Colors.white.withOpacity(0.5), 
                        size: 20.sp
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Send Tip',
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: _tipAmount > 0 ? Colors.black : Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTipAmountButton(int amount) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _tipAmount = amount.toDouble();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: _tipAmount == amount.toDouble() 
              ? Colors.white.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: _tipAmount == amount.toDouble()
                ? Colors.white.withOpacity(0.3)
                : Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Text(
          '+\$${amount}',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildShopGrid();
      case 1:
        return _buildStreamsContent();
      case 2:
        return _buildCoSignsContent();
      default:
        return _buildShopGrid();
    }
  }

  Widget _buildStreamsContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        children: [
          Text(
            'Streams Coming Soon',
            style: GoogleFonts.wixMadeforDisplay(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoSignsContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Column(
        children: [
          // Co-Signs Summary
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 24.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                Text(
                  '4.9 🔥',
                  style: GoogleFonts.wixMadeforDisplay(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Based on 18 Co-Signs',
                  style: GoogleFonts.wixMadeforDisplay(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Co-Signs List
          Column(
            children: [
              _buildCoSignCard(
                username: '@NovaSounds',
                date: 'Mar 11, 2025',
                rating: '4 🔥',
                review: '🌟🌟🌟 Always impresses. A true standout in the industry.',
                songTitle: 'Rhythm City - BeatMaster',
              ),
              SizedBox(height: 8.h),
              _buildCoSignCard(
                username: '@NovaSounds',
                date: 'Mar 11, 2025',
                rating: '5 🔥',
                review: 'Immaculate mix and groove. One of the finest collections I\'ve snagged.',
                songTitle: 'Rhythm City - BeatMaster',
              ),
              SizedBox(height: 8.h),
              _buildCoSignCard(
                username: '@NovaSounds',
                date: 'Mar 11, 2025',
                rating: '3 🔥',
                review: 'Epic drops. Pure motivation.💥',
                songTitle: 'Rhythm City - BeatMaster',
              ),
              SizedBox(height: 8.h),
              _buildCoSignCard(
                username: '@NovaSounds',
                date: 'Mar 11, 2025',
                rating: '4 🔥',
                review: '🔥🔥🔥 Consistently exceptional. A top player in the field.',
                songTitle: 'Rhythm City - BeatMaster',
              ),
              SizedBox(height: 8.h),
              _buildCoSignCard(
                username: '@NovaSounds',
                date: 'Mar 11, 2025',
                rating: '5 🔥',
                review: 'Spotless mix and rhythm. One of the greatest sets I\'ve acquired.',
                songTitle: 'Rhythm City - BeatMaster',
              ),
              SizedBox(height: 8.h),
              _buildCoSignCard(
                username: '@NovaSounds',
                date: 'Mar 11, 2025',
                rating: '3 🔥',
                review: 'Crazy drops. Instant inspiration.🔥',
                songTitle: 'Rhythm City - BeatMaster',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoSignCard({
    required String username,
    required String date,
    required String rating,
    required String review,
    required String songTitle,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              // Avatar
              Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.person,
                  size: 12.sp,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              SizedBox(width: 8.w),
              // Username
              Text(
                username,
                style: GoogleFonts.wixMadeforDisplay(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              Spacer(),
              // Date
              Text(
                date,
                style: GoogleFonts.wixMadeforDisplay(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              SizedBox(width: 8.w),
              // Rating Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Text(
                  rating,
                  style: GoogleFonts.wixMadeforDisplay(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 12.h),
          
          // Review Text
          Text(
            review,
            style: GoogleFonts.wixMadeforDisplay(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // Song Title Row
          Row(
            children: [
              Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(7.2.r),
                ),
                child: Icon(
                  Icons.music_note,
                  size: 9.6.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                songTitle,
                style: GoogleFonts.wixMadeforDisplay(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showActionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // QR Code Option
            _buildActionSheetOption(
              'QR Code',
              () {
                Navigator.pop(context);
                _showQRCodeModal();
              },
            ),
            
            // Divider
            Container(
              height: 1,
              color: Colors.white.withOpacity(0.1),
            ),
            
            // Copy Link Option
            _buildActionSheetOption(
              'Copy Link',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Link copied to clipboard!',
                      style: GoogleFonts.wixMadeforDisplay(
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.blue,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                );
              },
            ),
            
            // Divider
            Container(
              height: 1,
              color: Colors.white.withOpacity(0.1),
            ),
            
            // Block Option
            _buildActionSheetOption(
              'Block',
              () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'User blocked successfully',
                      style: GoogleFonts.wixMadeforDisplay(
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                );
              },
              textColor: Colors.white.withOpacity(0.7),
            ),
            
            SizedBox(height: 8.h),
            
            // Cancel Button
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: _buildActionSheetOption(
                'Cancel',
                () => Navigator.pop(context),
              ),
            ),
            
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSheetOption(String title, VoidCallback onTap, {Color? textColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Text(
          title,
          style: GoogleFonts.wixMadeforDisplay(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: textColor ?? Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _showQRCodeModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          children: [
            // Top Navigation Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            
            // Profile Avatar
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(1016.33.r),
                color: const Color(0xFF262626),
              ),
              child: Icon(
                Icons.person,
                size: 40.sp,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // Username
            Text(
              '@DreBeatz',
              style: GoogleFonts.wixMadeforDisplay(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            
            SizedBox(height: 40.h),
            
            // QR Code Container
            Container(
              width: 231.3.w,
              height: 232.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  // Real QR Code
                  Center(
                    child: QrImageView(
                      data: 'https://bagr.app/producer/${widget.producerId}',
                      version: QrVersions.auto,
                      size: 200.w,
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  
                  // Center Audio Icon
                  Center(
                    child: Container(
                      width: 24.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Icon(
                        Icons.graphic_eq,
                        color: Colors.black,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 40.h),
            
            // Action Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  // Copy Link Button
                  Container(
                    width: double.infinity,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF404040),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Copy Link',
                          style: GoogleFonts.wixMadeforDisplay(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.copy,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 16.h),
                  
                  // Share the Code Button
                  Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(-4, -4),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Share the Code',
                        style: GoogleFonts.wixMadeforDisplay(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Spacer(),
          ],
        ),
      ),
    );
  }

}
