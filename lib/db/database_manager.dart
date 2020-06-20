import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {

  final CollectionReference collection = Firestore.instance.collection('shopping_lists');

  Stream<QuerySnapshot> getShoppingListStream() {
    return collection.snapshots();
  }

}