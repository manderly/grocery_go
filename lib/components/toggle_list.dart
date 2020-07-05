import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_go/db/database_manager.dart';

class LinkedEntity {
  String id;
  String name;
  String address;

  LinkedEntity(DocumentSnapshot document) {
    this.id = document['id'];
    this.name = document['name'];
    this.address = document['address'] ?? '';
  }
}

class ToggleList extends StatefulWidget {

  final String parentType;
  final String parentID;
  final String parentName;
  final List list;
  Map linkedEntities;

  ToggleList({Key key, @required this.parentType, @required this.parentID, @required this.parentName, @required this.list, @required this.linkedEntities});

  @override
  _ToggleListState createState() => _ToggleListState();
}

class _ToggleListState extends State<ToggleList> {

  final DatabaseManager db = DatabaseManager();

  toggleItem(entityID, entityName, value) {

    if (widget.linkedEntities == null) {
      print("linkedEntities is null");
        widget.linkedEntities = Map();
    }

    // update "locally"
    if (widget.linkedEntities.containsKey(entityID)) {
      setState(() {
        widget.linkedEntities.remove(entityID);
      });
    } else {
      print("adding entity");
      setState(() {
        widget.linkedEntities[entityID] = entityName;
      });
    }

    // update in database
    // method params: (shoppingListID, storeID, shoppingListName, storeName, value)
    if (widget.parentType == "shopping list") {
      // if we're editing a shopping list then the parent ID is the list ID and the entity is the store
      db.updateStoreShoppingListLink(widget.parentID, entityID, widget.parentName, entityName, value);
    } else if (widget.parentType == "store") {
      // if we're editing a store, then the parent ID is the store ID and the entity is the shopping list
      db.updateStoreShoppingListLink(entityID, widget.parentID, entityName, widget.parentName, value);
    }
  }

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        shrinkWrap: true, // gives it a size
        itemCount: widget.list.length,
        itemBuilder: (BuildContext context, int index) {
          var item = LinkedEntity(widget.list[index]);
          var itemName = item.address.length > 0 ? item.name + ' (${item.address})' : item.name;
          return SwitchListTile(
            title: Text(itemName),
            value: widget.linkedEntities?.containsKey(item.id) ?? false,
            onChanged: (bool value) => toggleItem(item.id, item.name, value),
          );
        }
    );
  }
}



