import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_go/db/shopping_list_dto.dart';

class DatabaseManager {

  final CollectionReference shoppingLists = Firestore.instance.collection('shopping_lists');
  final CollectionReference stores = Firestore.instance.collection('stores');

  Stream<QuerySnapshot> getShoppingListStream() {
    return shoppingLists.snapshots();
  }

  Stream<QuerySnapshot> getStoresStream() {
    return stores.snapshots();
  }

  Future<DocumentReference> addShoppingList(ShoppingListDTO shoppingList) {
    return shoppingLists.add(shoppingList.toJson());
  }

  Future<void> updateShoppingList(String id, ShoppingListDTO shoppingList) {
    return shoppingLists.document(id).updateData(shoppingList.toJson());
  }

}