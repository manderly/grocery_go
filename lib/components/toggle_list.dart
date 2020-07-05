import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_go/db/database_manager.dart';

class LinkedEntity {
  String id;
  String name;

  LinkedEntity(DocumentSnapshot document) {
    this.id = document['id'];
    this.name = document['name'];
  }
}

class ToggleList extends StatefulWidget {

  final String parentType;
  final String parentID;
  final List list;
  Map linkedEntities;

  ToggleList({Key key, @required this.parentType, @required this.parentID, @required this.list, @required this.linkedEntities});

  @override
  _ToggleListState createState() => _ToggleListState();
}

class _ToggleListState extends State<ToggleList> {

  final DatabaseManager db = DatabaseManager();

  toggleItem(entityID, entityName, value) {

    if (widget.linkedEntities == null) {
        widget.linkedEntities = Map();
    }

    // update "locally"
    if (widget.linkedEntities.containsKey(entityID)) {
      setState(() {
        widget.linkedEntities.remove(entityID);
      });
    } else {
      setState(() {
        widget.linkedEntities[entityID] = entityName;
      });
    }
    // update in database
    if (widget.parentType == "shopping list") {
      db.updateStoreLink(widget.parentID, entityID, entityName, value);
    } else if (widget.parentType == "store") {
      db.updateShoppingListLink(widget.parentID, entityID, entityName, value);
    }
  }

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        shrinkWrap: true, // gives it a size
        itemCount: widget.list.length,
        itemBuilder: (BuildContext context, int index) {
          var item = LinkedEntity(widget.list[index]);

          return SwitchListTile(
            title: Text(item.name),
            value: widget.linkedEntities?.containsKey(item.id) ?? false,
            onChanged: (bool value) => toggleItem(item.id, item.name, value),
          );
        }
    );
  }
}



