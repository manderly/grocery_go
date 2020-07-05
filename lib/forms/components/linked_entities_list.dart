import 'package:flutter/material.dart';
import 'package:grocery_go/views/manage_links.dart';
import '../../db/database_manager.dart';

class LinkedEntitiesList extends StatelessWidget {
  final String parentID;
  final String parentName;
  final String listType;
  final Map linkedEntities;
  final String entities;

  LinkedEntitiesList(this.parentID, this.listType, this.parentName, this.linkedEntities, this.entities);

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

      Navigator.pushNamed(context, ManageLinks.routeName, arguments: ManageLinksArguments(dbStream: stream, linkedEntities: linkedEntities, parentID: parentID, parentName: parentName, parentType: listType));
    }

    var _list = linkedEntities != null ? linkedEntities.values.toList() : [];
    print(_list);

    return Container(
      height:300,
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
    const MAX_LIST_LEN = 4;

    if (list == null || list?.length == 0) {
      return [Text("This $listType is not attached to any $entities yet.")];
    } else {
      var listLen = list.length > MAX_LIST_LEN ? MAX_LIST_LEN : list.length;
      var entityList = List();
      for (var i = 0; i < listLen; i++) {
        entityList.add(Text(list[i].toString()));
      }
      if (list.length > MAX_LIST_LEN) {
        entityList.add(Text('+${list.length - MAX_LIST_LEN} more'));
      }
      return entityList;
    }
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
