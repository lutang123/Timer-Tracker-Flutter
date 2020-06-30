import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  //adding private constructor, and the firestoreService can only be accessible
  // by a singleton, the reason is that we may need to create multi classes
  // to communicate with FireStore, but I don't want multi instance of FireStoreServices

  //object of firestore services can not be created
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final reference = Firestore.instance.document(path);
    print('$path: $data');
    await reference.setData(data);
  }

  Future<void> deleteData({@required String path}) async {
    final reference = Firestore.instance.document(path);
    print('delete: $path');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data, documentID),
  }) {
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((collectionSnapshot) => collectionSnapshot.documents
        .map((documentSnapshot) => builder(
              documentSnapshot.data,
              documentSnapshot.documentID,
            ))
        .toList());
  }
}
