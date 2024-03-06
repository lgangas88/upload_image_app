import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wisy_app/features/image_list/core/providers/image_list_provider.dart';
import 'package:wisy_app/features/image_list/core/data/models/image.dart'
    as image_model;

class CameraScreen extends ConsumerWidget {
  const CameraScreen({super.key});

  void showImagePreview(BuildContext context, image_model.Image? image) {
    if (image == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => _PreviewImage(image),
    );
  }

  @override
  Widget build(BuildContext context, ref) {

    // Listen only when imagePreview is setted
    ref.listen(
      imageListProvider.select(
        (value) => value.imagePreview,
      ),
      (_, next) => showImagePreview(context, next),
    );

    return Scaffold(
      body: CameraAwesomeBuilder.custom(
        saveConfig: SaveConfig.photo(),
        builder: (state, preview) {
          return state.when(
            onPhotoMode: (photoState) => Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.4),
                ),
                child: GestureDetector(
                  onTap: () async {
                    final photo = await photoState.takePhoto();
                    final file = File(photo.path ?? '');
                    ref.read(imageListProvider.notifier).setImagePreview(file);
                  },
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PreviewImage extends ConsumerWidget {
  const _PreviewImage(this.image);

  final image_model.Image image;

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(
            File(image.url),
            height: 120,
            width: 120,
          ),
          const SizedBox(height: 24),
          Text(
            image.name,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Date: ${image.timestamp}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/',
                (route) => false,
              );
              ref.read(imageListProvider.notifier).storeImage();
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }
}
