import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

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
  String? _selectedImagePath;
  String? _base64Image;

  @override
  void dispose() {
    _promptController.dispose();
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImagePath = image.path;
        _base64Image = base64Encode(bytes);
      });
    }
  }

  Future<void> _generateVideo() async {
    if (!_formKey.currentState!.validate()) return;

    final videoProvider = context.read<VideoProvider>();
    await videoProvider.generateVideo(
      _promptController.text,
      referenceImage: _base64Image,
    );

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
    if (provider.status != VideoGenerationStatus.generating) return const SizedBox();

    return Column(
      children: [
        const SizedBox(height: 16),
        LinearProgressIndicator(value: provider.progress),
        const SizedBox(height: 8),
        Text(
          provider.statusMessage,
          style: const TextStyle(fontStyle: FontStyle.italic),
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
                        maxLength: 800,
                        decoration: const InputDecoration(
                          labelText: 'Video Description',
                          hintText: 'Describe the video you want to generate...',
                          border: OutlineInputBorder(),
                          counterText: null,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          if (value.length > 800) {
                            return 'Description cannot exceed 800 characters';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '${_promptController.text.length}/800 characters',
                          style: TextStyle(
                            color: _promptController.text.length > 800 
                              ? Theme.of(context).colorScheme.error 
                              : Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text('Select Reference Image'),
                      ),
                      if (_selectedImagePath != null) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_selectedImagePath!),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
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
                if (videoProvider.videoUrl != null) ...[
                  const SizedBox(height: 24),
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _chewieController != null
                        ? Chewie(controller: _chewieController!)
                        : const Center(child: CircularProgressIndicator()),
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