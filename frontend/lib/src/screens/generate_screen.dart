import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../widgets/credit_indicator.dart';
import '../widgets/credit_modal.dart';
import '../widgets/prompt_input.dart';
import '../widgets/style_selector.dart';
import '../widgets/create_button.dart';
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
  bool _isLoading = false;
  List<String> _promptHistory = [
    'A futuristic pilot with VR helmet, blue sky, clouds',
    'A neon-lit city street at night, rain, reflections',
    'A tranquil beach sunset with waves',
  ];

  final List<StyleItem> _styles = const [
    StyleItem(label: 'Futuristic', svgAsset: 'assets/icons/brain.svg', tooltip: 'Futuristic: sleek sci‑fi look'),
    StyleItem(label: 'B&W', svgAsset: 'assets/icons/neural.svg', tooltip: 'B&W: classic black and white'),
    StyleItem(label: 'Cartoonize', svgAsset: 'assets/icons/film.svg', tooltip: 'Cartoonize: animated, fun'),
    StyleItem(label: 'Watercolor', svgAsset: 'assets/icons/pixel.svg', tooltip: 'Watercolor: painted, soft colors'),
    StyleItem(label: 'Other', svgAsset: 'assets/icons/magic.svg', tooltip: 'Other: creative, experimental'),
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
    {
      'img': 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=400&q=80',
      'prompt': 'A tranquil beach sunset with waves',
    },
    {
      'img': 'https://images.unsplash.com/photo-1465101178521-c1a9136a3b43?auto=format&fit=crop&w=400&q=80',
      'prompt': 'A magical forest with glowing plants',
    },
    {
      'img': 'https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=400&q=80',
      'prompt': 'A cyberpunk cityscape at night',
    },
    {
      'img': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca?auto=format&fit=crop&w=400&q=80',
      'prompt': 'A dreamy mountain landscape, misty morning',
    },
    {
      'img': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=400&q=80',
      'prompt': 'A futuristic robot in a garden',
    },
    {
      'img': 'https://images.unsplash.com/photo-1465101178521-c1a9136a3b43?auto=format&fit=crop&w=400&q=80',
      'prompt': 'A watercolor painting of a city',
    },
    {
      'img': 'https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=400&q=80',
      'prompt': 'A pixel art night sky',
    },
    {
      'img': 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=400&q=80',
      'prompt': 'A magical castle on a hill',
    },
  ];

  void _openCreditModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => CreditModal(
        onBuy: (count) {
          setState(() => _credits += count);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _useSamplePrompt() {
    setState(() {
      _promptController.text = 'A tranquil beach sunset with waves';
    });
  }

  void _onCreate() async {
    if (_credits == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have no credits left!'), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // Simüle API
    setState(() {
      _isLoading = false;
      _credits--;
      _promptHistory.insert(0, _promptController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkBg,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          children: [
            const SizedBox(height: 8),
            // App Bar
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('AI Video', style: AppTextStyles.appBarTitle),
                ),
                const Spacer(),
                CreditIndicator(credits: _credits, onTap: _openCreditModal),
              ],
            ),
            const SizedBox(height: 28),
            // Prompt Input
            Text('Enter Prompt', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 10),
            PromptInput(
              controller: _promptController,
              promptHistory: _promptHistory,
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
            CreateButton(
              label: 'Create',
              isLoading: _isLoading,
              onPressed: _onCreate,
            ),
            if (_isLoading) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(value: null, color: AppColors.accentBlue),
            ],
            const SizedBox(height: 32),
            // Discover
            Text('Discover', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 14),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _discover.length,
              itemBuilder: (context, i) {
                final d = _discover[i];
                return DiscoverCard(
                  imageUrl: d['img']!,
                  prompt: d['prompt']!,
                  onTryPrompt: () {
                    setState(() {
                      _promptController.text = d['prompt']!;
                    });
                  },
                  onShare: (platform) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Shared to $platform!')),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
} 