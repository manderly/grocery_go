import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingList {
  String id;
  String name;
  String listType = 'shopping list';
  String date;
  int itemCount;
  Map stores;

  ShoppingList(DocumentSnapshot document) {
    this.id = document['id'];
    this.name = document['name'];
    this.date = document['date'];
    this.itemCount = document['itemCount'];
    this.stores = document['stores'];
  }
}