import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DiscoverCard extends StatelessWidget {
  final String imageUrl;
  final String prompt;
  final VoidCallback onTryPrompt;
  final void Function(String platform)? onShare;
  const DiscoverCard({super.key, required this.imageUrl, required this.prompt, required this.onTryPrompt, this.onShare});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
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
          Positioned(
            bottom: 10,
            right: 12,
            child: Row(
              children: [
                _ShareIcon(
                  asset: 'assets/icons/tiktok.svg',
                  onTap: () => onShare?.call('tiktok'),
                ),
                const SizedBox(width: 8),
                _ShareIcon(
                  asset: 'assets/icons/instagram.svg',
                  onTap: () => onShare?.call('instagram'),
                ),
                const SizedBox(width: 8),
                _ShareIcon(
                  asset: 'assets/icons/whatsapp.svg',
                  onTap: () => onShare?.call('whatsapp'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareIcon extends StatelessWidget {
  final String asset;
  final VoidCallback? onTap;
  const _ShareIcon({required this.asset, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(asset, width: 24, height: 24, color: Colors.white),
    );
  }
} 