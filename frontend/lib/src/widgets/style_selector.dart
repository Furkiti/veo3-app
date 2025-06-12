import 'package:flutter/material.dart';
import '../constants/app_text_styles.dart';

class StyleSelector extends StatelessWidget {
  final List<StyleItem> styles;
  final int selectedIndex;
  final void Function(int) onSelect;
  const StyleSelector({super.key, required this.styles, required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: styles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          final style = styles[i];
          return Tooltip(
            message: style.tooltip,
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: i == selectedIndex ? Colors.white : Colors.white10,
                    child: style.icon != null
                        ? Icon(style.icon, color: i == selectedIndex ? Colors.black : Colors.white, size: 32)
                        : (style.image != null
                            ? ClipOval(child: Image.asset(style.image!, width: 44, height: 44, fit: BoxFit.cover))
                            : null),
                  ),
                  const SizedBox(height: 6),
                  Text(style.label, style: AppTextStyles.subtext.copyWith(color: Colors.white)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class StyleItem {
  final String label;
  final IconData? icon;
  final String? image;
  final String tooltip;
  const StyleItem({required this.label, this.icon, this.image, required this.tooltip});
} 