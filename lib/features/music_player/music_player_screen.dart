import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String producerName;
  final String trackTitle;
  final String artistName;
  final String? coverImage;
  final double? rating;
  final String packTitle;
  final String packType;
  final double price;
  final bool isPack;

  const MusicPlayerScreen({
    super.key,
    required this.producerName,
    required this.trackTitle,
    required this.artistName,
    this.coverImage,
    this.rating,
    required this.packTitle,
    required this.packType,
    required this.price,
    this.isPack = false,
  });

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  double _currentPosition = 86.0;
  final double _totalDuration = 135.0;
  bool _isPlaying = false;

  String _formatDuration(double seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toInt().toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // Center all circles properly
    final centerX = screenWidth / 2;
    final centerY = screenHeight / 2;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Outer circle - centered, moved down a wee bit more
          Positioned(
            left: centerX - 300, // Half of 600
            top: centerY - 390,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 0.5,
                ),
                color: Colors.white.withOpacity(0.01),
              ),
            ),
          ),
          // Middle circle - centered with same offset
          Positioned(
            left: centerX - 200,
            top: centerY - 290,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 0.5,
                ),
                color: Colors.white.withOpacity(0.01),
              ),
            ),
          ),
          // Inner circle with beat image - centered
          Positioned(
            left: centerX - 106,
            top: centerY - 190,
            child: Container(
              width: 213.33,
              height: 213.33,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
                child: ClipOval(
                child: Transform.scale(
                  scale: 1.3,
                  child: widget.coverImage != null
                      ? Image.network(
                          widget.coverImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              'https://api.builder.io/api/v1/image/assets/TEMP/196688b42235e2da5bc2bb8987afa6c83847a3ab',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[800],
                              ),
                            );
                          },
                        )
                      : Image.network(
                          'https://api.builder.io/api/v1/image/assets/TEMP/196688b42235e2da5bc2bb8987afa6c83847a3ab',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[800],
                          ),
                        ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 1,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Container(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.producerName,
                                style: GoogleFonts.getFont(
                                  'Wix Madefor Display',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  height: 16 / 12,
                                ),
                              ),
                              if (widget.rating != null) ...[
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 10,
                                      color: Color(0xB3FFFFFF),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      widget.rating!.toStringAsFixed(1),
                                      style: GoogleFonts.getFont(
                                        'Wix Madefor Display',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xB3FFFFFF),
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(width: 24),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 8,
                                  top: 11,
                                  child: Container(
                                    width: 9,
                                    height: 1,
                                    color: const Color(0xFF262626),
                                  ),
                                ),
                                Positioned(
                                  left: 11,
                                  top: 8,
                                  child: Container(
                                    width: 1,
                                    height: 9,
                                    color: const Color(0xFF262626),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(64),
                          color: Colors.white.withOpacity(0.16),
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0xFF999999),
                        Colors.white,
                      ],
                    ).createShader(bounds);
                  },
                  child: Text(
                    '${widget.trackTitle} - ${widget.artistName}',
                    style: GoogleFonts.getFont(
                      'Fjalla One',
                      fontSize: 40,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 125),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            _formatDuration(_currentPosition),
                            style: GoogleFonts.getFont(
                              'Wix Madefor Display',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.60),
                              height: 20 / 12,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: SizedBox(
                              height: 8,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 2,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: 4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: const Color(0xFF404040),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 2,
                                    left: 0,
                                    child: Container(
                                      width: (_currentPosition / _totalDuration) * 277,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: (_currentPosition / _totalDuration) * 277 - 4,
                                    top: 0,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatDuration(_totalDuration),
                            style: GoogleFonts.getFont(
                              'Wix Madefor Display',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.60),
                              height: 20 / 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 48,
                            height: 48,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              icon: Transform.rotate(
                                angle: 3.14159,
                                child: const Icon(
                                  Icons.fast_forward,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPlaying = !_isPlaying;
                                });
                              },
                              icon: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          SizedBox(
                            width: 48,
                            height: 48,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {},
                              icon: const Icon(
                                Icons.fast_forward,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFF404040),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.packTitle,
                                style: GoogleFonts.getFont(
                                  'Wix Madefor Display',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFFAFAFA),
                                  height: 20 / 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${widget.packType} · ${widget.isPack ? "Beat Pack" : "Single Beat"} · ',
                                      style: GoogleFonts.getFont(
                                        'Wix Madefor Display',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFFD4D4D4),
                                        height: 16 / 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\$${widget.price.toInt()}',
                                      style: GoogleFonts.getFont(
                                        'Wix Madefor Display',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFFAFAFA),
                                        height: 16 / 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              'Buy now',
                              style: GoogleFonts.getFont(
                                'Wix Madefor Display',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                height: 20 / 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 44),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
