import 'package:cloud_firestore/cloud_firestore.dart';

class Store {
  String id;
  String name;
  String address;
  Map shoppingLists;

  Store(DocumentSnapshot document) {
    this.id = document['id'];
    this.name = document['name'];
    this.address = document['address'];
    this.shoppingLists = document['stores'];
  }
}