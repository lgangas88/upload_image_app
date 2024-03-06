import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wisy_app/features/image_list/core/providers/image_list_provider.dart';

class ImageListScreen extends ConsumerWidget {
  const ImageListScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image App'),
      ),
      body: StreamBuilder(
        stream: ref.read(imageListProvider.notifier).streamImages,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final images = snapshot.data!;

          return ListView.builder(
            itemCount: images.length,
            itemBuilder: (_, index) {
              final image = images[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(image.url),
                ),
                title: Text(image.name),
                subtitle: Text('Date: ${image.timestamp}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/camera'),
        child: const Icon(Icons.camera),
      ),
    );
  }
}
