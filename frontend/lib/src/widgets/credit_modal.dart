import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_icons.dart';
import '../constants/app_text_styles.dart';

class CreditModal extends StatelessWidget {
  final void Function(int count) onBuy;
  const CreditModal({super.key, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: Text('Get More Credits', style: AppTextStyles.sectionTitle)),
          const SizedBox(height: 24),
          _CreditCard(
            count: 1,
            price: '\$0.99',
            onTap: () => onBuy(1),
          ),
          const SizedBox(height: 12),
          _CreditCard(
            count: 3,
            price: '\$1.99',
            onTap: () => onBuy(3),
          ),
          const SizedBox(height: 12),
          _CreditCard(
            count: 5,
            price: '\$2.99',
            highlight: true,
            highlightText: 'Most Popular',
            highlightIcon: AppIcons.flame,
            onTap: () => onBuy(5),
          ),
          const SizedBox(height: 12),
          _CreditCard(
            count: 10,
            price: '\$4.99',
            highlight: true,
            highlightText: 'Best Value',
            highlightIcon: AppIcons.badge,
            glow: true,
            onTap: () => onBuy(10),
          ),
        ],
      ),
    );
  }
}

class _CreditCard extends StatelessWidget {
  final int count;
  final String price;
  final bool highlight;
  final String? highlightText;
  final IconData? highlightIcon;
  final bool glow;
  final VoidCallback onTap;
  const _CreditCard({
    required this.count,
    required this.price,
    this.highlight = false,
    this.highlightText,
    this.highlightIcon,
    this.glow = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        decoration: BoxDecoration(
          color: AppColors.charcoal,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            if (glow)
              BoxShadow(
                color: AppColors.accentBlue.withOpacity(0.3),
                blurRadius: 18,
                spreadRadius: 2,
              ),
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: highlight ? Border.all(color: AppColors.accentBlue, width: 2) : null,
        ),
        child: Row(
          children: [
            Icon(AppIcons.gem, color: Colors.amberAccent, size: 28),
            const SizedBox(width: 16),
            Text('$count Prompt${count > 1 ? 's' : ''}', style: AppTextStyles.body.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            const Spacer(),
            if (highlight && highlightIcon != null && highlightText != null)
              Row(
                children: [
                  Icon(highlightIcon, color: AppColors.accentBlue, size: 20),
                  const SizedBox(width: 4),
                  Text(highlightText!, style: AppTextStyles.body.copyWith(color: AppColors.accentBlue, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                ],
              ),
            Text(price, style: AppTextStyles.body.copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }
} 