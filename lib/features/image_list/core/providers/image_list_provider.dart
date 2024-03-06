import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wisy_app/features/image_list/core/data/models/image.dart';
import 'package:wisy_app/features/image_list/core/data/repository/image_list_repository.dart';
import 'package:wisy_app/features/image_list/core/data/repository/image_list_repository_impl.dart';
import 'package:wisy_app/features/image_list/core/providers/image_list_state.dart';

final imageListProvider =
    StateNotifierProvider<ImageListNotifier, ImageListState>(
  (ref) => ImageListNotifier(
    imageListRepository: ref.read(imageListRepositoryProvider),
  ),
);

class ImageListNotifier extends StateNotifier<ImageListState> {
  final ImageListRepository _imageListRepository;

  ImageListNotifier({
    required ImageListRepository imageListRepository,
  })  : _imageListRepository = imageListRepository,
        super(
          ImageListState(
            images: [],
          ),
        );

  // This function was being used at the begging, but
  // to use stream was a better option.
  void init() {
    getImages();
  }

  Stream<List<Image>> get streamImages => _imageListRepository.streamImages();

  void getImages() async {
    try {
      state = state.copyWith(isLoading: true);
      final images = await _imageListRepository.getImages();
      state = state.copyWith(
        images: images,
        isLoading: false,
      );
    } catch (e) {
      print('Error $e');
    }
  }

  void setImagePreview(File file) {
    final image = Image(
      name: file.uri.pathSegments.last,
      timestamp: DateTime.now().toString(),
      url: file.path,
    );
    state = state.copyWith(imagePreview: image);
  }

  void storeImage() async {
    if (state.imagePreview == null) return;
    try {
      final url =
          await _imageListRepository.storeImage(File(state.imagePreview!.url));
      final image = Image(
        name: state.imagePreview!.name,
        timestamp: state.imagePreview!.timestamp,
        url: url ?? '',
      );
      await _imageListRepository.storeImageMetadata(image);
    } catch (e) {
      print('Error $e');
    }
  }
}
