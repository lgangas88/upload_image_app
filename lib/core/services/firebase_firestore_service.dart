import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseFirestoreServiceProvider =
    Provider((ref) => FirebaseFirestoreService());

class FirebaseFirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<List<T>> getCollection<T>(
    String path,
    T Function(dynamic json) fromJson,
  ) async {
    final collection = await _db.collection(path).get();
    return collection.docs.map((e) {
      final data = {
        ...e.data(),
        'id': e.id,
      };
      return fromJson(data);
    }).toList();
  }

  Future<void> storeDocument(
    String path,
    Map<String, dynamic> body,
  ) async {
    await _db.collection(path).doc().set(body);
  }

  Stream<List<T>> streamCollection<T>(
    String path,
    T Function(dynamic json) fromJson,
  ) {
    return _db.collection(path).snapshots().map((event) => event.docs.map((e) {
          final data = {
            ...e.data(),
            'id': e.id,
          };
          return fromJson(data);
        }).toList());
  }
}
