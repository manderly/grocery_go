import 'package:flutter/material.dart';
import 'package:grocery_go/views/manage_links.dart';
import '../../db/database_manager.dart';

class LinkedEntitiesList extends StatefulWidget {
  final String parentID;
  final String parentName;
  final String listType;
  final Map linkedEntities;
  final String entities;

  LinkedEntitiesList(this.parentID, this.listType, this.parentName,
      this.linkedEntities, this.entities);

  @override
  _LinkedEntitiesList createState() => _LinkedEntitiesList();
}

class _LinkedEntitiesList extends State<LinkedEntitiesList> {

  final DatabaseManager db = DatabaseManager();

  @override
  Widget build(BuildContext context) {

    _goToManageLinks() async {
      var stream;
      if (widget.listType == "shopping list") {
        stream = db.getStoresStream();
      } else if (widget.listType == "store") {
        stream = db.getShoppingListStream();
      } else {
        print("Error: unrecognized list type in linked_entities_list.dart");
      }

      await Navigator.pushNamed(context, ManageLinks.routeName, arguments: ManageLinksArguments(stream, widget.linkedEntities, widget.parentID, widget.parentName, widget.listType));
      setState(() {});
    }

    var _list = widget.linkedEntities != null ? widget.linkedEntities.values.toList() : [];

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
    return Text('${widget.entities}', style: TextStyle(fontSize:16, fontWeight: FontWeight.bold));
  }

  _entityList(list) {
    const MAX_LIST_LEN = 4;

    if (list == null || list?.length == 0) {
      return [Text("This ${widget.listType} is not attached to any ${widget.entities} yet.")];
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
      child: Text("Add/Remove ${widget.entities}"),
      textColor:Colors.blue,
      padding: EdgeInsets.all(0),
    );
  }
}
