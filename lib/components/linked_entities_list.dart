import 'package:flutter/material.dart';

class LinkedEntitiesList extends StatelessWidget {
  final linkedEntities;
  final String listType;
  final String entities;

  LinkedEntitiesList(this.linkedEntities, this.listType, this.entities);

  @override
  Widget build(BuildContext context) {
    var _list = linkedEntities != null ? linkedEntities.values.toList() : [];

    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _listTitle(),
          ..._entityList(_list),
          _manageLinksButton(),
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

  _manageLinksButton() {
    return FlatButton(
      onPressed: () => print("pressed"),
      child: Text("Add/Remove $entities"),
      textColor:Colors.blue,
      padding: EdgeInsets.all(0),
    );
  }
}
