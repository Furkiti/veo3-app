import 'package:flutter/material.dart';
import '../constants/app_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';

class StyleSelector extends StatelessWidget {
  final List<StyleItem> styles;
  final int selectedIndex;
  final void Function(int) onSelect;
  const StyleSelector({super.key, required this.styles, required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: styles.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          final style = styles[i];
          return _AnimatedBounce(
            trigger: selectedIndex == i,
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (selectedIndex == i)
                          BoxShadow(
                            color: AppColors.accentBlue.withOpacity(0.25),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: selectedIndex == i ? Colors.white : Colors.white10,
                      child: style.svgAsset != null
                          ? SvgPicture.asset(
                              style.svgAsset!,
                              width: 48,
                              height: 48,
                              color: selectedIndex == i ? AppColors.accentBlue : Colors.white,
                              fit: BoxFit.contain,
                            )
                          : (style.image != null
                              ? Image.asset(style.image!, width: 48, height: 48, fit: BoxFit.contain)
                              : Icon(style.icon, color: selectedIndex == i ? AppColors.accentBlue : Colors.white, size: 40)),
                    ),
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

class _AnimatedBounce extends StatefulWidget {
  final Widget child;
  final bool trigger;
  const _AnimatedBounce({required this.child, required this.trigger});
  @override
  State<_AnimatedBounce> createState() => _AnimatedBounceState();
}

class _AnimatedBounceState extends State<_AnimatedBounce> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 180));
    _scale = Tween<double>(begin: 1, end: 1.12).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    if (widget.trigger) _controller.forward();
  }
  @override
  void didUpdateWidget(covariant _AnimatedBounce oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _controller.forward(from: 0);
    } else if (!widget.trigger && oldWidget.trigger) {
      _controller.reverse();
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}

class StyleItem {
  final String label;
  final IconData? icon;
  final String? image;
  final String? svgAsset;
  final String tooltip;
  const StyleItem({required this.label, this.icon, this.image, this.svgAsset, required this.tooltip});
} 