import 'package:flutter/material.dart';

class StoreItemCard extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onTap;

  const StoreItemCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.10),
            width: 1,
          ),
          color: Colors.white.withOpacity(0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFFAFAFA),
                fontSize: 20,
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
