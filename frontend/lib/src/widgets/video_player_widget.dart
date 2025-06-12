import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../constants/app_icons.dart';

class VideoPlayerWidget extends StatelessWidget {
  final ChewieController chewieController;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;
  final String? duration;
  final String? resolution;
  const VideoPlayerWidget({
    super.key,
    required this.chewieController,
    this.onDownload,
    this.onShare,
    this.duration,
    this.resolution,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Chewie(controller: chewieController),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(AppIcons.download),
              onPressed: onDownload,
              tooltip: 'Download',
            ),
            IconButton(
              icon: const Icon(AppIcons.share),
              onPressed: onShare,
              tooltip: 'Share',
            ),
          ],
        ),
        if (duration != null || resolution != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (duration != null)
                  Text(duration!, style: Theme.of(context).textTheme.bodySmall),
                if (duration != null && resolution != null)
                  const SizedBox(width: 12),
                if (resolution != null)
                  Text(resolution!, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
      ],
    );
  }
} 