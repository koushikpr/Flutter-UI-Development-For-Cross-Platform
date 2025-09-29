import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class AuctionSettingsScreen extends StatefulWidget {
  const AuctionSettingsScreen({super.key});

  @override
  State<AuctionSettingsScreen> createState() => _AuctionSettingsScreenState();
}

class _AuctionSettingsScreenState extends State<AuctionSettingsScreen> {
  final TextEditingController _customBidController = TextEditingController();
  final TextEditingController _buyNowPriceController = TextEditingController();
  
  String _selectedBid = '25';
  bool _isCustomBid = false;
  double _auctionDuration = 25.0; // Default 25 minutes
  bool _activateBuyNow = false;

  @override
  void dispose() {
    _customBidController.dispose();
    _buyNowPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.h),
                    
                    // Set Starting Bid Section
                    _buildStartingBidSection(),
                    
                    SizedBox(height: 32.h),
                    
                    // Auction Duration Section
                    _buildAuctionDurationSection(),
                    
                    SizedBox(height: 32.h),
                    
                    // Activate Buy Now Section
                    _buildBuyNowSection(),
                    
                    SizedBox(height: 60.h),
                  ],
                ),
              ),
            ),
            
            // Continue Button
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        children: [
          // Navigation Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              GestureDetector(
                onTap: () => context.pop(),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 24.h),
          
          // Progress Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProgressStep(1, true),
              SizedBox(width: 8.w),
              _buildProgressStep(2, true),
              SizedBox(width: 8.w),
              _buildProgressStep(3, true),
            ],
          ),
          
          SizedBox(height: 24.h),
          
          // Page Title
          Text(
            'Auction Settings',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int step, bool isActive) {
    return Container(
      width: 24.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey.shade600,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }

  Widget _buildStartingBidSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set Starting Bid',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16.h),
        
        // Bid Options
        Row(
          children: [
            Expanded(
              child: _buildBidButton('25', '25'),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildBidButton('50', '50'),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildBidButton('100', '100'),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildBidButton('Custom', 'custom'),
            ),
          ],
        ),
        
        // Custom Bid Input
        if (_isCustomBid) ...[
          SizedBox(height: 16.h),
          Container(
            height: 56.h,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _customBidController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 16.sp,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                prefixText: '\$',
                prefixStyle: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
                hintText: 'Enter amount',
                hintStyle: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 16.sp,
                  color: Colors.white.withOpacity(0.4),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBidButton(String text, String value) {
    final isSelected = _selectedBid == value;
    final isCustom = value == 'custom';
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedBid = value;
          _isCustomBid = isCustom;
        });
      },
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: isCustom && isSelected 
              ? Colors.transparent 
              : (isSelected ? Colors.white : const Color(0xFF2A2A2A)),
          borderRadius: BorderRadius.circular(12.r),
          border: isCustom && isSelected 
              ? Border.all(color: Colors.white, width: 1)
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isSelected 
                  ? (isCustom ? Colors.white : Colors.black)
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuctionDurationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Auction Duration',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              '${_auctionDuration.round()} min',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        
        // Duration Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade600,
            thumbColor: Colors.white,
            overlayColor: Colors.white.withOpacity(0.2),
            trackHeight: 4.h,
          ),
          child: Slider(
            value: _auctionDuration,
            min: 10.0,
            max: 45.0,
            divisions: 35, // 1 minute increments
            onChanged: (value) {
              setState(() {
                _auctionDuration = value;
              });
            },
          ),
        ),
        
        // Min/Max Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '10 min',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            Text(
              '45 min',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 14.sp,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBuyNowSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle Row
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activate Buy Now',
                style: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Switch(
                value: _activateBuyNow,
                onChanged: (value) {
                  setState(() {
                    _activateBuyNow = value;
                  });
                },
                activeColor: Colors.white,
                activeTrackColor: Colors.grey.shade400,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade600,
              ),
            ],
          ),
        ),
        
        SizedBox(height: 8.h),
        
        // Description
        Text(
          'Let buyers skip the bidding and bag your beat right away.',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
        
        // Buy Now Price Input
        if (_activateBuyNow) ...[
          SizedBox(height: 16.h),
          Text(
            'Buy Now Price',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 56.h,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _buyNowPriceController,
              keyboardType: TextInputType.number,
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 16.sp,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                prefixText: '\$',
                prefixStyle: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
                hintText: 'Enter price',
                hintStyle: GoogleFonts.getFont(
                  'Wix Madefor Display',
                  fontSize: 16.sp,
                  color: Colors.white.withOpacity(0.4),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Container(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: _canProceed() ? _onContinue : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _canProceed() ? Colors.white : Colors.grey.shade600,
            foregroundColor: _canProceed() ? Colors.black : Colors.white.withOpacity(0.5),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Text(
            'Continue to Review',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void _showUploadResult(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  bool _canProceed() {
    if (_isCustomBid && _customBidController.text.isEmpty) {
      return false;
    }
    if (_activateBuyNow && _buyNowPriceController.text.isEmpty) {
      return false;
    }
    return true;
  }

  void _onContinue() {
    print('🚀 Proceeding to review...');
    print('Starting Bid: ${_isCustomBid ? _customBidController.text : _selectedBid}');
    print('Auction Duration: ${_auctionDuration.round()} minutes');
    print('Activate Buy Now: $_activateBuyNow');
    if (_activateBuyNow) {
      print('Buy Now Price: ${_buyNowPriceController.text}');
    }
    
    // TODO: Navigate to review screen
    _showUploadResult('Moving to review...');
  }
}
