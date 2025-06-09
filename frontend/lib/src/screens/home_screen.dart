import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _promptController = TextEditingController();
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void dispose() {
    _promptController.dispose();
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _generateVideo() async {
    if (!_formKey.currentState!.validate()) return;

    final videoProvider = context.read<VideoProvider>();
    await videoProvider.generateVideo(_promptController.text);

    if (videoProvider.status == VideoGenerationStatus.completed && mounted) {
      await _initializeVideo(videoProvider.videoUrl!);
    }
  }

  Future<void> _initializeVideo(String url) async {
    _videoController?.dispose();
    _chewieController?.dispose();

    _videoController = VideoPlayerController.network(url);
    await _videoController!.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: true,
    );

    setState(() {});
  }

  Widget _buildProgressIndicator(VideoProvider provider) {
    if (provider.status != VideoGenerationStatus.generating) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 24),
        LinearProgressIndicator(
          value: provider.progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          provider.statusMessage,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veo3 Video Generator'),
        centerTitle: true,
      ),
      body: Consumer<VideoProvider>(
        builder: (context, videoProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _promptController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Video Description',
                          hintText: 'Describe the video you want to generate...',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: videoProvider.status == VideoGenerationStatus.generating
                            ? null
                            : _generateVideo,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                        child: videoProvider.status == VideoGenerationStatus.generating
                            ? const SpinKitWave(
                                color: Colors.white,
                                size: 24.0,
                              )
                            : const Text(
                                'Generate Video',
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                    ],
                  ),
                ),
                _buildProgressIndicator(videoProvider),
                if (videoProvider.error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    videoProvider.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (_chewieController != null) ...[
                  const SizedBox(height: 24),
                  AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: Chewie(controller: _chewieController!),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
} 