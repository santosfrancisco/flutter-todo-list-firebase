import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('todos');

class Database {
  static String? userUid;

  static Future<void> addItem({
    required String title,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc();

    Map<String, dynamic> data = <String, dynamic>{
      'title': title,
      'completed': false,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print('Todo item added to the database'))
        .catchError((error) => print(error));
  }

  static Stream<QuerySnapshot> readItems() {
    CollectionReference todosCollection =
        _mainCollection.doc(userUid).collection('items');

    return todosCollection.snapshots();
  }

  static Future<void> updateItem({
    required String docId,
    required String title,
    required bool completed,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      'title': title,
      'completed': completed,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print('Todo item updated to the database'))
        .catchError((error) => print(error));
  }

  static Future<void> deleteItem({
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Todo item updated to the database'))
        .catchError((error) => print(error));
  }
}
