import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_go/db/item_dto.dart';
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

  Stream<QuerySnapshot> getItemsStream(shoppingListID, storeID) {
    return shoppingLists.document(shoppingListID).collection('items').orderBy('listPositions.$storeID').snapshots();
  }

  Future getItems(shoppingListID, isCrossedOff, storeID) async {
    var qn = await shoppingLists.document(shoppingListID).collection('items').where('isCrossedOff', isEqualTo: isCrossedOff).getDocuments();
    return qn.documents;
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
      updateLinkedStores(shoppingList.id, shoppingList.name);
    } else {
      print("ID is null/has no length");
    }
  }

  Future updateLinkedStores(shoppingListID, newName) async {
    // update all the stores' "shopping lists" maps to use the new shopping list name
    await stores
        .getDocuments()
        .then((querySnapshot) => {
      querySnapshot.documents.forEach((doc) => {
        if (doc.data['shoppingLists'][shoppingListID] != null) {
          doc.reference.updateData({'shoppingLists.$shoppingListID': newName})
        }
      })
    });
  }

  Future addItemToShoppingList(String listID, String itemID) async {
    print("adding item[$itemID] to list[$listID]");
    if (listID != null && listID.length > 0) {
      DocumentReference docRef = shoppingLists.document(listID);
      Firestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot doc = await tx.get(docRef);
        if (doc.exists) {
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
      updateLinkedShoppingLists(store.id, store.name + " (" + store.address + ")");
    } else {
      print("ID is null/has no length");
    }
  }

  Future updateLinkedShoppingLists(storeID, newName) async {
    // update all the shopping lists's "stores" maps to use the new store name
    await shoppingLists
        .getDocuments()
        .then((querySnapshot) => {
          querySnapshot.documents.forEach((doc) => {
            if (doc.data['stores'][storeID] != null) { // can't use ['stores.$storeID']
              doc.reference.updateData({'stores.$storeID': newName})
            }
          })
        });
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

  Future updateItemCrossedOffStatus(String parentListID, String itemID, data) async {
    if (parentListID != null && parentListID.length > 0) {
      // adjust the shopping list's item count accordingly
      if (data['isCrossedOff']) {
        shoppingLists.document(parentListID).updateData({'itemCount': FieldValue.increment(-1)});
      } else {
        shoppingLists.document(parentListID).updateData({'itemCount': FieldValue.increment(1)});
      }
      // update the item itself
      DocumentReference itemDocRef = shoppingLists.document(parentListID).collection('items').document(itemID);
      Firestore.instance.runTransaction((Transaction tx) async {
        await tx.update(itemDocRef, data);
      }).catchError((e) {
        print(e.toString());
      });
    } else {
      print("ID is null/has no length");
    }
  }

  Future updateStoreShoppingListLink(String shoppingListID, String storeID, String shoppingListName, String storeName, bool val) async {
    // add this store to the specified shopping list
    DocumentReference shoppingListRef = shoppingLists.document(shoppingListID);
    val == true ? shoppingListRef.updateData({'stores.$storeID': storeName}) : shoppingListRef.updateData({'stores.$storeID': FieldValue.delete()});

    // and add this shopping list to the specified store
    DocumentReference storeRef =  stores.document(storeID);
    val == true ? storeRef.updateData({'shoppingLists.$shoppingListID': shoppingListName}) : storeRef.updateData({'shoppingLists.$shoppingListID': FieldValue.delete()});
  }

}