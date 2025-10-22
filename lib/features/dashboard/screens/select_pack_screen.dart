import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectPackTypeScreen extends StatefulWidget {
  const SelectPackTypeScreen({Key? key}) : super(key: key);

  @override
  State<SelectPackTypeScreen> createState() => _SelectPackTypeScreenState();
}

class _SelectPackTypeScreenState extends State<SelectPackTypeScreen> {
  String? selectedPackType = 'beat_pack';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 49),
              const Text(
                'Add Pack',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const SizedBox(
                width: 275,
                child: Text(
                  'Choose pack type:',
                  style: TextStyle(
                    color: Color(0xFFA3A3A3),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 43),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      _PackTypeCard(
                        title: 'Beat Pack',
                        description: 'Bundle several finished beats in one drop. More value, more heat.',
                        isSelected: selectedPackType == 'beat_pack',
                        onTap: () {
                          setState(() {
                            selectedPackType = 'beat_pack';
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _PackTypeCard(
                        title: 'Sound Pack',
                        description: 'A mixed bag of sounds — one-shots (808s, kicks, snares, hi-hats, claps), FX, and samples. No melodic or drum loops.',
                        isSelected: selectedPackType == 'sound_pack',
                        onTap: () {
                          setState(() {
                            selectedPackType = 'sound_pack';
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      _PackTypeCard(
                        title: 'Loop Kit',
                        description: 'A collection of melody or drum loops only. No one-shots, just loops.',
                        isSelected: selectedPackType == 'loop_kit',
                        onTap: () {
                          setState(() {
                            selectedPackType = 'loop_kit';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                      },
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        child: const Center(
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.43,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        width: 139,
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
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

class _PackTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _PackTypeCard({
    Key? key,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.10),
            width: 1,
          ),
          color: Colors.white.withOpacity(0.05),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFFAFAFA),
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFFA3A3A3),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.43,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            _buildCheckIcon(isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckIcon(bool isSelected) {
    if (isSelected) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: const Icon(
          Icons.check,
          color: Color(0xFF0D0D0D),
          size: 16,
        ),
      );
    } else {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF454545),
            width: 1,
          ),
        ),
      );
    }
  }
}
