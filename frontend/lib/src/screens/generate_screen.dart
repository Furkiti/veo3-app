import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../widgets/credit_indicator.dart';
import '../widgets/credit_modal.dart';
import '../widgets/style_selector.dart';
import '../widgets/discover_card.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final TextEditingController _promptController = TextEditingController();
  int _selectedStyle = 0;
  int _credits = 12;
  bool _showPromptClear = false;

  final List<StyleItem> _styles = const [
    StyleItem(label: 'Futuristic', icon: Icons.android, tooltip: 'Sci-fi, neon, tech'),
    StyleItem(label: 'B&W', icon: Icons.filter_b_and_w, tooltip: 'Black & white, classic'),
    StyleItem(label: 'Cartoonize', icon: Icons.face_retouching_natural, tooltip: 'Anime look with soft focus'),
    StyleItem(label: 'Watercolor', icon: Icons.brush, tooltip: 'Painted, soft colors'),
    StyleItem(label: 'Other', icon: Icons.more_horiz, tooltip: 'Other creative styles'),
  ];

  final List<Map<String, String>> _discover = const [
    {
      'img': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
      'prompt': 'A futuristic pilot with VR helmet, blue sky, clouds',
    },
    {
      'img': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
      'prompt': 'A neon-lit city street at night, rain, reflections',
    },
  ];

  void _openCreditModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => CreditModal(
        onBuy: (count) {
          setState(() => _credits += count);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkBg,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('AI Video', style: AppTextStyles.appBarTitle),
                  CreditIndicator(credits: _credits, onTap: _openCreditModal),
                ],
              ),
              const SizedBox(height: 24),
              // Prompt Section
              Text('Enter Prompt', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 10),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 18, 40, 18),
                    decoration: BoxDecoration(
                      color: AppColors.charcoal,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _promptController,
                      style: AppTextStyles.body.copyWith(color: Colors.white),
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Generate a tranquil beach sunset with waves…',
                        hintStyle: TextStyle(color: AppColors.subtextGray),
                        isCollapsed: true,
                      ),
                      onChanged: (v) => setState(() => _showPromptClear = v.isNotEmpty),
                    ),
                  ),
                  if (_showPromptClear)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          _promptController.clear();
                          setState(() => _showPromptClear = false);
                        },
                        child: const Icon(Icons.close, color: AppColors.subtextGray, size: 22),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              // Style Selector
              Text('Choose Style', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 10),
              StyleSelector(
                styles: _styles,
                selectedIndex: _selectedStyle,
                onSelect: (i) => setState(() => _selectedStyle = i),
              ),
              const SizedBox(height: 28),
              // Create Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: const Text('Create', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
              ),
              const SizedBox(height: 32),
              // Discover
              Text('Discover', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 14),
              Row(
                children: _discover.map((d) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: DiscoverCard(
                    imageUrl: d['img']!,
                    prompt: d['prompt']!,
                    onTryPrompt: () {
                      setState(() {
                        _promptController.text = d['prompt']!;
                        _showPromptClear = true;
                      });
                    },
                  ),
                )).toList(),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
} 