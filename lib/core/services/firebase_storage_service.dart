import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseStorageServiceProvider =
    Provider((ref) => FirebaseStorageService());

class FirebaseStorageService {
  final _storageRef = FirebaseStorage.instance.ref();
  Reference? get _imagesRef => _storageRef.child("images");

  Future<String?> saveImage(File image) async {
    final fileName = image.uri.pathSegments.last;
    final imageRef = _imagesRef?.child(fileName);
    await imageRef?.putFile(image);
    final url = await imageRef?.getDownloadURL();
    return url;
  }
}
