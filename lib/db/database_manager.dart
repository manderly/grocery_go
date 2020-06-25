import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery_go/db/item_dto.dart';
import 'package:grocery_go/db/shopping_list_dto.dart';
import 'package:grocery_go/db/store_dto.dart';

class DatabaseManager {

  final CollectionReference shoppingLists = Firestore.instance.collection('shopping_lists');
  final CollectionReference stores = Firestore.instance.collection('stores');
  final CollectionReference items = Firestore.instance.collection('items');

  Stream<QuerySnapshot> getShoppingListStream() {
    return shoppingLists.orderBy("name").snapshots();
  }

  Stream<QuerySnapshot> getStoresStream() {
    return stores.orderBy("name").snapshots();
  }

  Stream<QuerySnapshot> getItemsStream(shoppingListID) {
    return shoppingLists.document(shoppingListID).collection('items').snapshots();
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

  Future addItemToShoppingList(String listID, String itemID) async {
    print("adding item[$itemID] to list[$listID]");
    if (listID != null && listID.length > 0) {
      DocumentReference docRef = shoppingLists.document(listID);
      Firestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot doc = await tx.get(docRef);
        if (doc.exists) {
          // idea #1 - make a copy of the itemIDs array and put the ID into it, then overwrite the whole array
          // List<String> itemIDsArr = new List<String>.from(doc.data['itemIDs']);
          // itemIDsArr.add(itemID);

          //await tx.update(docRef, {
          //  'itemIDs': itemIDsArr,
          //});

          // idea #2 - use union to "union" on an array of one item...
          // might be better for long existing lists of IDs?
          List<String> newItemIDArr = [];
          newItemIDArr.add(itemID);
          await tx.update(docRef, {'itemIDs': FieldValue.arrayUnion(newItemIDArr)},);

        }
      }).catchError((e) {
        print(e.toString());
      });
    } else {
      print("List id is null/has no length");
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

  Future<DocumentReference> createItem(String parentListID, ItemDTO item) async {
    shoppingLists.document(parentListID).updateData({'itemCount': FieldValue.increment(1)});
    DocumentReference itemDocRef = await shoppingLists.document(parentListID).collection('items').add(item.toJson());
    print(itemDocRef.documentID);
    itemDocRef.updateData({'id':itemDocRef.documentID});
    return itemDocRef;
  }

  Future updateItem(String parentListID, ItemDTO item) async {
    print("item:" + item.toString());
    if (parentListID != null && parentListID.length > 0) {
      DocumentReference itemDocRef = shoppingLists.document(parentListID).collection('items').document(item.id);
      Firestore.instance.runTransaction((Transaction tx) async {
        await tx.update(itemDocRef, item.toJson());
        }).catchError((e) {
          print(e.toString());
        });
    } else {
      print("ID is null/has no length");
    }
  }

}