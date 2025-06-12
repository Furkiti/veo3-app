import 'package:flutter/material.dart';
import '../constants/app_text_styles.dart';

class DiscoverCard extends StatelessWidget {
  final String imageUrl;
  final String prompt;
  final VoidCallback onTryPrompt;
  const DiscoverCard({super.key, required this.imageUrl, required this.prompt, required this.onTryPrompt});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            imageUrl,
            width: 160,
            height: 110,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              elevation: 0,
            ),
            onPressed: onTryPrompt,
            child: const Text('Try Prompt', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
} 