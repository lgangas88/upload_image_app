import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wisy_app/core/services/firebase_firestore_service.dart';
import 'package:wisy_app/core/services/firebase_storage_service.dart';
import 'package:wisy_app/features/image_list/core/data/models/image.dart';
import 'package:wisy_app/features/image_list/core/data/repository/image_list_repository.dart';

final imageListRepositoryProvider = Provider(
  (ref) => ImageListRepositoryImpl(
    firebaseFirestoreService: ref.read(firebaseFirestoreServiceProvider),
    firebaseStorageService: ref.read(firebaseStorageServiceProvider),
  ),
);

class ImageListRepositoryImpl implements ImageListRepository {
  final FirebaseFirestoreService _firebaseFirestoreService;
  final FirebaseStorageService _firebaseStorageService;

  ImageListRepositoryImpl({
    required FirebaseFirestoreService firebaseFirestoreService,
    required FirebaseStorageService firebaseStorageService,
  })  : _firebaseFirestoreService = firebaseFirestoreService,
        _firebaseStorageService = firebaseStorageService;

  @override
  Future<String?> storeImage(File image) {
    return _firebaseStorageService.saveImage(image);
  }

  @override
  Future<void> storeImageMetadata(Image metadata) async {
    await _firebaseFirestoreService.storeDocument(
      'images',
      metadata.toJson(),
    );
  }

  @override
  Future<List<Image>> getImages() {
    return _firebaseFirestoreService.getCollection<Image>(
      'images',
      Image.fromJson,
    );
  }

  @override
  Stream<List<Image>> streamImages() {
    return _firebaseFirestoreService.streamCollection(
      'images',
      Image.fromJson,
    );
  }
}
