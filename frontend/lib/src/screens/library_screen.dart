import 'package:flutter/material.dart';
import '../widgets/video_grid_item.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data
    final videos = List.generate(8, (i) => {
      'thumbnail': 'https://placehold.co/320x180?text=Video+${i+1}',
      'title': 'Video ${i+1}',
      'duration': '0${i+1}:23',
    });
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: videos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 16/11,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, i) {
          final v = videos[i];
          return VideoGridItem(
            thumbnailUrl: v['thumbnail']!,
            title: v['title']!,
            duration: v['duration']!,
            onTap: () {},
            onLongPress: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.share),
                        title: const Text('Share'),
                        onTap: () => Navigator.pop(ctx),
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete_outline),
                        title: const Text('Delete'),
                        onTap: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 