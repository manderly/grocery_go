import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_go/db/item_dto.dart';
import 'package:grocery_go/db/shopping_list_dto.dart';
import 'package:grocery_go/db/store_dto.dart';

class DatabaseManager {

  final CollectionReference shoppingLists = Firestore.instance.collection('shopping_lists');
  final CollectionReference stores = Firestore.instance.collection('stores');
  final CollectionReference users = Firestore.instance.collection('user_data');

  Future<DocumentSnapshot> getUser(String userID) {
    return users.document(userID).get();
  }

  CollectionReference getShoppingListsCollection() {
    return shoppingLists;
  }

  CollectionReference getStoresCollection() {
    return stores;
  }

  CollectionReference getItemsCollection(shoppingListID) {
    return shoppingLists.document(shoppingListID).collection('items');
  }

  Stream<QuerySnapshot> getShoppingListStream() {
    return shoppingLists.orderBy('listPositions.default', descending: false).snapshots();
  }

  Stream<QuerySnapshot> getStoresStream() {
    return stores.orderBy('listPositions.default', descending: false).snapshots();
  }

  Stream<QuerySnapshot> getActiveItemsStream(shoppingListID, storeID) {
    print(storeID);
    return shoppingLists.document(shoppingListID).collection('items')
        .where('isCrossedOff', isEqualTo: false)
        .orderBy('listPositions.$storeID')
        .snapshots();
  }

  Stream<QuerySnapshot> getInactiveItemsStream(shoppingListID) {
    return shoppingLists.document(shoppingListID).collection('items')
        .where('isCrossedOff', isEqualTo: true)
        .snapshots();
  }

  Future getItems(shoppingListID, isCrossedOff) async {
    // help with structuring this request:
    // https://github.com/flutter/flutter/issues/34770
    var qn = await shoppingLists.document(shoppingListID).collection('items').where('isCrossedOff', isEqualTo: isCrossedOff).getDocuments();
    return qn.documents;
  }

  Future<List<DocumentSnapshot>> getListItems(shoppingListID, isCrossedOff) async {
    var qn = await shoppingLists.document(shoppingListID).collection('items').where('isCrossedOff', isEqualTo: isCrossedOff).getDocuments();
    return qn.documents;
  }

  Future<DocumentReference> addShoppingList(ShoppingListDTO shoppingList) async {
    // create the new shopping list
    DocumentReference docRef = await shoppingLists.add(shoppingList.toJson());

    // get the user document
    DocumentReference userRef = users.document('Nr2JtF4tqSTrD14gp5Sr');
    DocumentSnapshot userSnapshot = await userRef.get();

    // give the new shopping list a "pos" based on how many shopping lists the user has
    shoppingLists.document(docRef.documentID).updateData({'id':docRef.documentID, 'listPositions.default': userSnapshot['shopping_list_count']+1});

    // increase the total number of shopping lists the user has
    users.document(userRef.documentID).updateData({'shopping_list_count': FieldValue.increment(1)});

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
    // create the new store
    DocumentReference docRef = await stores.add(store.toJson());

    // get the user document
    DocumentReference userRef = users.document('Nr2JtF4tqSTrD14gp5Sr');
    DocumentSnapshot userSnapshot = await userRef.get();

    // give the new store a "pos" based on how many stores the user has
    stores.document(docRef.documentID).updateData({'id':docRef.documentID, 'listPositions.default': userSnapshot['stores_count']+1});

    // increase the total number of stores the user has
    users.document(userRef.documentID).updateData({'stores_count': FieldValue.increment(1)});

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
    // create the new item
    DocumentReference itemDocRef = await shoppingLists.document(parentListID).collection('items').add(item.toJson());

    // get its PARENT LIST
    DocumentReference shoppingListRef = shoppingLists.document(parentListID);
    DocumentSnapshot shoppingListSnap = await shoppingListRef.get();

    // give the new store a "pos" based on how many stores the user has
    itemDocRef.updateData({'id':itemDocRef.documentID, 'listPositions.default':shoppingListSnap.data['totalItems']+1});

    // increase the total number of items this list has
    shoppingLists.document(parentListID).updateData({'totalItems': FieldValue.increment(1)});

    return itemDocRef;
  }

  Future updateItem(String parentListID, ItemDTO item) async {
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
        shoppingLists.document(parentListID).updateData({'activeItems': FieldValue.increment(-1)});
      } else {
        shoppingLists.document(parentListID).updateData({'activeItems': FieldValue.increment(1)});
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

    // add this store to each of the shopping list's items and give it a default position
    // todo: if the user toggles an existing store on/off, the position data will be reset to match default which may not be desired
    addNewStorePositionKeyToItems(shoppingListID, storeID);
  }


  Future addNewStorePositionKeyToItems(String shoppingListID, String storeID) async {
    // get the shopping list that's getting a new store added to it
    var itemsRef = shoppingLists.document(shoppingListID).collection('items');
    //for each item, add listPosition['storeID'] and set value equal to listPosition['default']
    await itemsRef.getDocuments()
        .then((querySnapshot) => {
          querySnapshot.documents.forEach((doc) => {
            if (doc.data['listPositions'][storeID] == null) { // can't use ['stores.$storeID']
              // make the value for this new store match this item's current value for default
              doc.reference.updateData({'listPositions.$storeID': doc.data['listPositions']['default']})
            }
      })
    });
  }

}