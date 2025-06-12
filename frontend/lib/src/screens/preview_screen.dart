import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import '../widgets/video_player_widget.dart';

class PreviewScreen extends StatelessWidget {
  final ChewieController chewieController;
  final String duration;
  final String resolution;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;
  const PreviewScreen({
    super.key,
    required this.chewieController,
    required this.duration,
    required this.resolution,
    this.onDownload,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: VideoPlayerWidget(
        chewieController: chewieController,
        duration: duration,
        resolution: resolution,
        onDownload: onDownload,
        onShare: onShare,
      ),
    );
  }
} 