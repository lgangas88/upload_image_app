import 'dart:io';

import 'package:wisy_app/features/image_list/core/data/models/image.dart';

abstract class ImageListRepository {
  Future<String?> storeImage(File image);
  Future<void> storeImageMetadata(Image metadata);
  Future<List<Image>> getImages();
  Stream<List<Image>> streamImages();
}
