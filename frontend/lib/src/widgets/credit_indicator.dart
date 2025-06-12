import 'package:flutter/material.dart';
import '../constants/app_icons.dart';
import '../constants/app_text_styles.dart';

class CreditIndicator extends StatelessWidget {
  final int credits;
  final VoidCallback onTap;
  const CreditIndicator({super.key, required this.credits, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.gem, color: Colors.amberAccent, size: 20),
            const SizedBox(width: 6),
            Text('$credits Credits', style: AppTextStyles.subtext.copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }
} 