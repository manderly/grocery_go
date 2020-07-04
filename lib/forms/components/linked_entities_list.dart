import 'package:flutter/material.dart';
import 'package:grocery_go/views/manage_links.dart';
import '../../db/database_manager.dart';

class LinkedEntitiesList extends StatelessWidget {
  final String parentID;
  final String listType;
  final linkedEntities;
  final String entities;

  LinkedEntitiesList(this.parentID, this.listType, this.linkedEntities, this.entities);

  final DatabaseManager db = DatabaseManager();

  @override
  Widget build(BuildContext context) {

    _goToManageLinks() {
      var stream;
      if (listType == "shopping list") {
        stream = db.getStoresStream();
      } else if (listType == "store") {
        stream = db.getShoppingListStream();
      } else {
        print("Error: unrecognized list type in linked_entities_list.dart");
      }

      Navigator.pushNamed(context, ManageLinks.routeName, arguments: ManageLinksArguments(dbStream: stream, linkedEntities: linkedEntities, parentID: parentID, parentType: listType));
    }

    var _list = linkedEntities != null ? linkedEntities.values.toList() : [];

    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _listTitle(),
          ..._entityList(_list),
          _manageLinksButton(_goToManageLinks),
        ],
      ));
    }

  _listTitle() {
    return Text("$entities", style: TextStyle(fontSize:16, fontWeight: FontWeight.bold));
  }

  _entityList(list) {
    var shortList = List();
    shortList.add(Text("This $listType is not attached to any $entities yet."));
    // if 'list' is empty, default to shortList which is guaranteed to have something
    return list?.map((item) => Text(item, style: TextStyle(height: 1.6)))?.toList() ?? shortList;
  }

  _manageLinksButton(onPressedAction) {

    return FlatButton(
      onPressed: () => onPressedAction(),
      child: Text("Add/Remove $entities"),
      textColor:Colors.blue,
      padding: EdgeInsets.all(0),
    );
  }
}
