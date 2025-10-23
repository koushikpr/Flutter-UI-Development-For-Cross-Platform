import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String? selectedEmotion;
  String? selectedCategory;
  String? selectedFollowUp;
  final TextEditingController _messageController = TextEditingController();
  bool _isAnonymous = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      // Man Vector Image
                      _buildManVectorImage(),
                      const SizedBox(height: 32),
                      // Header
                      Text(
                        "What's on your mind?",
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          height: 1.2,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Got an idea, request, or issue?\n Drop it here — we're listening.",
                        style: GoogleFonts.getFont(
                          'Wix Madefor Display',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.43,
                          color: const Color(0x99FFFFFF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Category Selection
                      _buildCategorySelection(),
                      const SizedBox(height: 24),
                      // Overall Impression
                      _buildOverallImpression(),
                      const SizedBox(height: 24),
                      // Main Message Input
                      _buildMainMessageInput(),
                      const SizedBox(height: 24),
                      // Follow-up Selection
                      _buildFollowUpSelection(),
                      const SizedBox(height: 24),
                      // Submit Button
                      _buildSubmitButton(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // Bottom Navigation
              _buildBottomNavigation(),
            ],
          ),
        ),
      );
  }

  Widget _buildManVectorImage() {
    return Center(
      child: SvgPicture.asset(
        'assets/images/man vector.svg',
        width: 92,
        height: 92,
        fit: BoxFit.contain,
        placeholderBuilder: (BuildContext context) => Container(
          width: 92,
          height: 92,
          color: const Color(0xFF3D3D3D),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelection() {
    final categories = ['Auction', 'Mobile', 'User Support', 'Payment'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose what it\'s about',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.43,
            letterSpacing: -0.04,
            color: const Color(0xFFFAFAFA),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCategory ?? 'Auction',
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 24,
              ),
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 1.43,
                color: const Color(0xFF737373),
              ),
              dropdownColor: const Color(0xFF171717),
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      category,
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.43,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildOverallImpression() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overall impression',
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.43,
            letterSpacing: -0.04,
            color: const Color(0xFFFAFAFA),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildEmotionPill(
                emoji: '😊',
                label: 'Fire\n(Keep This)',
                value: 'happy',
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildEmotionPill(
                emoji: '😐',
                label: 'Mid\n(Average)',
                value: 'neutral',
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildEmotionPill(
                emoji: '😡',
                label: 'Nah\n(Needs Work)',
                value: 'angry',
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildEmotionPill({
    required String emoji,
    required String label,
    required String value,
  }) {
    final isSelected = selectedEmotion == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEmotion = value;
        });
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontWeight: FontWeight.w400,
                fontSize: 28,
                height: 1.14,
                color: const Color(0xFFD4D4D4),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.2,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainMessageInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: const BoxConstraints(
            minHeight: 120,
            maxHeight: 200,
          ),
          child: TextField(
            controller: _messageController,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: GoogleFonts.getFont(
              'Wix Madefor Display',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              hintText: "Type your thoughts here…\ndon't worry, we got thick skin.",
              hintStyle: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.white.withOpacity(0.5),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${_messageController.text.length} / 500',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: const Color(0xFF737373),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFollowUpSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'I\'d like a follow-up from BAGR team.',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 1.43,
                color: Colors.white,
              ),
            ),
          ),
                  Switch(
                    value: _isAnonymous,
                    onChanged: (bool value) {
                      setState(() {
                        _isAnonymous = value;
                      });
                    },
                    activeThumbColor: Colors.white,
                    activeTrackColor: Colors.white.withOpacity(0.3),
                    inactiveThumbColor: Colors.white.withOpacity(0.4),
                    inactiveTrackColor: Colors.white.withOpacity(0.1),
                  ),
        ],
      ),
    );
  }


  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle submit
            _handleSubmit();
          },
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              'Give My Feedback',
              style: GoogleFonts.getFont(
                'Wix Madefor Display',
                fontWeight: FontWeight.w600,
                fontSize: 18,
                height: 1.3,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 102,
      color: Colors.black,
      child: Column(
        children: [
          const SizedBox(height: 34),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home_outlined, 'Home', false),
              _buildNavItem(Icons.favorite_outline, 'Favorites', false),
              _buildNavItem(Icons.inbox_outlined, 'Inbox', false),
              _buildNavItem(Icons.feedback_outlined, 'Feedback', true),
              _buildNavItem(Icons.person_outline, 'Profile', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0x14FFFFFF),
            borderRadius: BorderRadius.circular(66.67),
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : const Color(0x99FFFFFF),
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.getFont(
            'Wix Madefor Display',
            fontWeight: FontWeight.w500,
            fontSize: 10,
            height: 1.2,
            letterSpacing: -0.04,
            color: isActive ? Colors.white : const Color(0x99FFFFFF),
          ),
        ),
      ],
    );
  }

  void _handleSubmit() {
    // Handle feedback submission
    print('Category: $selectedCategory');
    print('Emotion: $selectedEmotion');
    print('Message: ${_messageController.text}');
    print('Follow-up: $selectedFollowUp');
    
    // Show thank you modal
    _showThankYouModal();
  }

  void _showThankYouModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Praying hands emoji
                    const Text(
                      '🙏',
                      style: TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 16),
                    
                    // Thank You title
                    Text(
                      'Thank You Fam.',
                      style: GoogleFonts.getFont(
                        'Fjalla One',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    
                    // Description
                    Text(
                      'Your feedback helps shape BAGR into\n the go-to app for hip-hop creators\n and enthusiasts across the globe.',
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    
                    // Response info box
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                '✉️',
                                style: TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Expect a response from us\n within 24 hours.',
                                style: GoogleFonts.getFont(
                                  'Wix Madefor Display',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Motivational message
                    Text(
                      'Keep showing up — we\'re writing\n the future one bar at a time.',
                      style: GoogleFonts.getFont(
                        'Wix Madefor Display',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    
                    // Got it button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Got it',
                          style: GoogleFonts.getFont(
                            'Wix Madefor Display',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
