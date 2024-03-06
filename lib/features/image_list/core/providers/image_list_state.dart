import 'package:wisy_app/features/image_list/core/data/models/image.dart';

class ImageListState {
  final List<Image> images;
  final Image? imagePreview;
  final bool isLoading;

  ImageListState({
    required this.images,
    this.imagePreview,
    this.isLoading = false,
  });

  ImageListState copyWith({
    List<Image>? images,
    Image? imagePreview,
    bool? isLoading,
  }) {
    return ImageListState(
      images: images ?? this.images,
      imagePreview: imagePreview ?? this.imagePreview,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
