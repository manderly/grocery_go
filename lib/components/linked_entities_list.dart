import 'package:flutter/material.dart';

class LinkedEntitiesList extends StatelessWidget {
  final linkedEntities;
  final String listType;
  final String entities;

  LinkedEntitiesList(this.linkedEntities, this.listType, this.entities);

  @override
  Widget build(BuildContext context) {
    var _list = linkedEntities != null ? linkedEntities.values.toList() : [];

    return Container(
      child: Column(
        children: <Widget>[
          _listTitle(),
          ..._entityList(_list),
          _manageLinksButton(),
        ],
      ));
    }

  _listTitle() {
    return Text("$entities", style: TextStyle(fontSize:20));
  }

  _entityList(list) {
    if (list != null && list.length > 0) {
      return list.map((item) => Text(item)).toList();
    } else {
      var shortList = List();
      shortList.add(Text("This $listType is not attached to any $entities yet."));
      return shortList;
    }
  }

  _manageLinksButton() {
    return FlatButton(
      onPressed: () => print("pressed"),
      child: Text("Add/Remove $entities"),
    );
  }
}
