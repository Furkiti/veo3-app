import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_icons.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const CustomBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: AppIcons.aiTools,
                  label: 'AI Tools',
                  selected: currentIndex == 0,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTap(0);
                  },
                  accent: false,
                ),
                _NavItem(
                  icon: AppIcons.aiVideo,
                  label: 'AI Video',
                  selected: currentIndex == 1,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTap(1);
                  },
                  accent: true,
                ),
                _NavItem(
                  icon: AppIcons.profile,
                  label: 'My Profile',
                  selected: currentIndex == 2,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onTap(2);
                  },
                  accent: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool accent;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap, this.accent = false});

  @override
  Widget build(BuildContext context) {
    final Color activeColor = Color(0xFF007AFF);
    final Color inactiveColor = Color(0xFF888888);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: accent ? 80 : 68,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (selected && accent)
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: activeColor.withOpacity(0.45),
                            blurRadius: 18,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  Icon(
                    icon,
                    size: accent ? 34 : 28,
                    color: selected ? activeColor : inactiveColor,
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: selected ? activeColor : inactiveColor,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 