import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String? selectedEmotion;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isAnonymous = false;

  @override
  void dispose() {
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: Column(
            children: [
              // Status Bar
              Container(
                height: 44,
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Time
                    const SizedBox(
                      width: 133.5,
                      child: Text(
                        '9:41',
                        style: TextStyle(
                          fontFamily: 'SF Pro Text',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          height: 1.43,
                          letterSpacing: -0.408,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Dynamic Island
                    Container(
                      width: 126,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Stack(
                        children: [
                          // Camera lens
                          Positioned(
                            right: 10.4,
                            top: 10.4,
                            child: Container(
                              width: 11.2,
                              height: 11.2,
                              decoration: BoxDecoration(
                                color: const Color(0xFF06092E),
                                border: Border.all(
                                  color: const Color(0xFF1C1932),
                                  width: 0.86,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Right side icons
                    const SizedBox(
                      width: 133.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.signal_cellular_4_bar, color: Colors.white, size: 17),
                          SizedBox(width: 9),
                          Icon(Icons.wifi, color: Colors.white, size: 17),
                          SizedBox(width: 9),
                          Icon(Icons.battery_full, color: Colors.white, size: 27),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Main Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      // Header
                      const Text(
                        "What's on your mind?",
                        style: TextStyle(
                          fontFamily: 'Wix Madefor Display',
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                          height: 1.27,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Got an idea, request, or issue? Drop it here — we're listening.",
                        style: TextStyle(
                          fontFamily: 'Wix Madefor Display',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 1.43,
                          color: Color(0x99FFFFFF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      // Email Input
                      _buildEmailInput(),
                      const SizedBox(height: 24),
                      // Emotion Selection
                      _buildEmotionSelection(),
                      const SizedBox(height: 24),
                      // Message Input
                      _buildMessageInput(),
                      const SizedBox(height: 24),
                      // Anonymous Toggle
                      _buildAnonymousToggle(),
                      const SizedBox(height: 24),
                      // Submit Button
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
              // Bottom Navigation
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
            fontFamily: 'Wix Madefor Display',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.43,
            letterSpacing: -0.04,
            color: Color(0xFFFAFAFA),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF171717),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _emailController,
                  style: const TextStyle(
                    fontFamily: 'Wix Madefor Display',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1.43,
                    color: Color(0xFF737373),
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(
                      fontFamily: 'Wix Madefor Display',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.43,
                      color: Color(0xFF737373),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmotionSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How are you feeling?',
          style: TextStyle(
            fontFamily: 'Wix Madefor Display',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.43,
            letterSpacing: -0.04,
            color: Color(0xFFFAFAFA),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: _buildEmotionPill(
                emoji: '😊',
                label: 'Fire (Keep This)',
                value: 'happy',
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildEmotionPill(
                emoji: '😐',
                label: 'Mid (Average)',
                value: 'neutral',
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildEmotionPill(
                emoji: '😡',
                label: 'Nah (Needs Work)',
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
          color: const Color(0xFF171717),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(
                fontFamily: 'Wix Madefor Display',
                fontWeight: FontWeight.w400,
                fontSize: 28,
                height: 1.14,
                color: Color(0xFFD4D4D4),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Wix Madefor Display',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.43,
                color: isSelected ? Colors.white : const Color(0xFFD4D4D4),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Message',
          style: TextStyle(
            fontFamily: 'Wix Madefor Display',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.43,
            letterSpacing: -0.04,
            color: Color(0xFFFAFAFA),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 232,
          decoration: BoxDecoration(
            color: const Color(0xFF171717),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _messageController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(
                fontFamily: 'Wix Madefor Display',
                fontWeight: FontWeight.w400,
                fontSize: 14,
                height: 1.43,
                color: Color(0xFF737373),
              ),
              decoration: const InputDecoration(
                hintText: "Type your thoughts here… don't worry, we got thick skin.",
                hintStyle: TextStyle(
                  fontFamily: 'Wix Madefor Display',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 1.43,
                  color: Color(0xFF737373),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnonymousToggle() {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0x1AFFFFFF),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Send anonymously',
            style: TextStyle(
              fontFamily: 'Wix Madefor Display',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.43,
              letterSpacing: -0.04,
              color: Color(0xFFFAFAFA),
            ),
          ),
          const Spacer(),
          Transform.scale(
            scaleX: -1,
            child: Switch(
              value: _isAnonymous,
              onChanged: (value) {
                setState(() {
                  _isAnonymous = value;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: const Color(0x1FFFFFFF),
              inactiveThumbColor: const Color(0x6BFFFFFF),
              inactiveTrackColor: const Color(0x1FFFFFFF),
            ),
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
        color: const Color(0x4DFFFFFF),
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
          child: const Center(
            child: Text(
              'Next',
              style: TextStyle(
                fontFamily: 'Wix Madefor Display',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 1.5,
                color: Color(0xFFD4D4D4),
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
          style: TextStyle(
            fontFamily: 'Wix Madefor Display',
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
    print('Email: ${_emailController.text}');
    print('Message: ${_messageController.text}');
    print('Emotion: $selectedEmotion');
    print('Anonymous: $_isAnonymous');
    
    // Show success message or navigate back
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feedback submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    
    Navigator.of(context).pop();
  }
}
