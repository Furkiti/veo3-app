import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_icons.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkBg,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: AppIcons.aiTools,
            label: 'AI Tools',
            selected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            icon: AppIcons.aiVideo,
            label: 'AI Video',
            selected: currentIndex == 1,
            floating: true,
            onTap: () => onTap(1),
          ),
          _NavItem(
            icon: AppIcons.profile,
            label: 'My Profile',
            selected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool floating;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, required this.selected, this.floating = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accentBlue : AppColors.subtextGray;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (floating)
            Container(
              margin: const EdgeInsets.only(bottom: 2),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentBlue.withOpacity(0.18),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Icon(icon, color: AppColors.accentBlue, size: 30),
            )
          else
            Icon(icon, color: color, size: 26),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: color, fontWeight: selected ? FontWeight.bold : FontWeight.normal, fontSize: 13)),
          if (selected && !floating)
            Container(
              margin: const EdgeInsets.only(top: 2),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.accentBlue,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
} 