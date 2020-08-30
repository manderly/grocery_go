import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingList {
  String id;
  String name;
  String listType = 'shopping list';
  String date;
  int activeItems;
  int totalItems;
  Map stores;

  ShoppingList(DocumentSnapshot document) {
    this.id = document['id'];
    this.name = document['name'];
    this.date = document['date'];
    this.activeItems = document['activeItems'];
    this.totalItems = document['totalItems'];
    this.stores = document['stores'];
  }
}