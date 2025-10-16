import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // Selected filters
  List<String> selectedGenres = ['Trap', 'Boom Bap'];
  List<String> selectedStreamTypes = [];
  double minBpm = 90;
  double maxBpm = 120;
  String selectedTempo = 'Medium';
  List<String> selectedKeys = [];
  
  // Filter options
  final List<String> genres = [
    'Trap', 'Drill', 'Rap Rock', 'Boom Bap', 'Emo Rap', 
    'Pop Rap', 'Experimental Rap', 'Throwback'
  ];
  
  final List<String> streamTypes = ['Auction', 'Grab Bag'];
  
  final List<String> tempos = ['Very Slow', 'Slow', 'Medium', 'Fast', 'Very Fast'];
  
  final List<String> keyTypes = ['Major', 'Minor'];
  
  final List<String> keys = [
    'C# / Db', 'D# / Eb', 'F# / Gb', 'G# / Ab',
    'A# / Bb', 'C', 'D', 'E', 'F', 'G', 'A', 'B'
  ];

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
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    
                    // Genres
                    _buildGenreSection(),
                    
                    SizedBox(height: 32.h),
                    
                    // Stream Type
                    _buildStreamTypeSection(),
                    
                    SizedBox(height: 32.h),
                    
                    // BPM
                    _buildBpmSection(),
                    
                    SizedBox(height: 32.h),
                    
                    // Key
                    _buildKeySection(),
                    
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
            
            // Bottom buttons
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          Text(
            'Filters',
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Genres grid
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: genres.map((genre) {
            final isSelected = selectedGenres.contains(genre);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedGenres.remove(genre);
                  } else {
                    selectedGenres.add(genre);
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  genre,
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStreamTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Stream type',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.keyboard_arrow_up,
              color: Colors.white,
              size: 20.sp,
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        Row(
          children: streamTypes.map((type) {
            final isSelected = selectedStreamTypes.contains(type);
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedStreamTypes.remove(type);
                    } else {
                      selectedStreamTypes.add(type);
                    }
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: type == streamTypes.first ? 12.w : 0),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      type,
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBpmSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'BPM',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.keyboard_arrow_up,
              color: Colors.white,
              size: 20.sp,
            ),
          ],
        ),
        
        SizedBox(height: 24.h),
        
        // BPM Slider
        RangeSlider(
          values: RangeValues(minBpm, maxBpm),
          min: 60,
          max: 200,
          divisions: 140,
          activeColor: Colors.white,
          inactiveColor: Colors.grey.withOpacity(0.3),
          onChanged: (RangeValues values) {
            setState(() {
              minBpm = values.start;
              maxBpm = values.end;
            });
          },
        ),
        
        SizedBox(height: 16.h),
        
        // BPM Values
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    minBpm.round().toString(),
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            
            SizedBox(width: 20.w),
            
            Text(
              '—',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
            
            SizedBox(width: 20.w),
            
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    maxBpm.round().toString(),
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        SizedBox(height: 20.h),
        
        // Tempo presets
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: tempos.map((tempo) {
            final isSelected = selectedTempo == tempo;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTempo = tempo;
                  // Set BPM ranges based on tempo
                  switch (tempo) {
                    case 'Very Slow':
                      minBpm = 60; maxBpm = 80;
                      break;
                    case 'Slow':
                      minBpm = 80; maxBpm = 100;
                      break;
                    case 'Medium':
                      minBpm = 100; maxBpm = 120;
                      break;
                    case 'Fast':
                      minBpm = 120; maxBpm = 140;
                      break;
                    case 'Very Fast':
                      minBpm = 140; maxBpm = 180;
                      break;
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  tempo,
                  style: GoogleFonts.getFont(
                    'Wix Madefor Display',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildKeySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Key',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.keyboard_arrow_up,
              color: Colors.white,
              size: 20.sp,
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // Major/Minor
        Row(
          children: keyTypes.map((type) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: type == keyTypes.first ? 12.w : 0),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    type,
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        
        SizedBox(height: 20.h),
        
        // Keys grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 2.2,
          ),
          itemCount: keys.length,
          itemBuilder: (context, index) {
            final key = keys[index];
            final isSelected = selectedKeys.contains(key);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedKeys.remove(key);
                  } else {
                    selectedKeys.add(key);
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                  border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                ),
                child: Center(
                  child: Text(
                    key,
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    final selectedCount = selectedGenres.length + selectedStreamTypes.length + selectedKeys.length;
    
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedGenres.clear();
                  selectedStreamTypes.clear();
                  selectedKeys.clear();
                  selectedTempo = 'Medium';
                  minBpm = 90;
                  maxBpm = 120;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Center(
                  child: Text(
                    'Clear ($selectedCount)',
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          SizedBox(width: 16.w),
          
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context, {
                  'genres': selectedGenres,
                  'streamTypes': selectedStreamTypes,
                  'minBpm': minBpm,
                  'maxBpm': maxBpm,
                  'tempo': selectedTempo,
                  'keys': selectedKeys,
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Center(
                  child: Text(
                    'Done',
                    style: GoogleFonts.getFont(
                      'Wix Madefor Display',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
