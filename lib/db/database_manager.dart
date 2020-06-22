import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_go/db/shopping_list_dto.dart';
import 'package:grocery_go/db/store_dto.dart';

class DatabaseManager {

  final CollectionReference shoppingLists = Firestore.instance.collection('shopping_lists');
  final CollectionReference stores = Firestore.instance.collection('stores');

  Stream<QuerySnapshot> getShoppingListStream() {
    return shoppingLists.orderBy("name").snapshots();
  }

  Stream<QuerySnapshot> getStoresStream() {
    return stores.orderBy("name").snapshots();
  }

  Future<DocumentReference> addShoppingList(ShoppingListDTO shoppingList) async {
    DocumentReference docRef = await shoppingLists.add(shoppingList.toJson());
    shoppingLists.document(docRef.documentID).updateData({'id':docRef.documentID});
    return docRef;
  }

  Future updateShoppingList(String id, ShoppingListDTO shoppingList) async {
    if (id != null && id.length > 0) {
      DocumentReference docRef = shoppingLists.document(id);
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(docRef, shoppingList.toJson());
      }).catchError((e) {
        print(e.toString());
      });
    } else {
      print("ID is null/has no length");
    }
  }

  Future<DocumentReference> addStore(StoreDTO store) async {
    DocumentReference docRef = await stores.add(store.toJson());
    stores.document(docRef.documentID).updateData({'id':docRef.documentID});
    return docRef;
  }

  Future updateStore(String id, StoreDTO store) async {
    if (id != null && id.length > 0) {
      DocumentReference docRef = stores.document(id);
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(docRef, store.toJson());
      }).catchError((e) {
        print(e.toString());
      });
    } else {
      print("ID is null/has no length");
    }
  }

}