import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingList {
  String id;
  String name;
  String listType = 'shopping list';
  List itemIDs;
  String date;

  ShoppingList(DocumentSnapshot document) {
    this.id = document['id'];
    this.name = document['name'];
    this.itemIDs = document['itemIDs'];
    this.date = document['date'];
  }
}