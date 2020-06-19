import 'package:flutter/material.dart';

import 'add_new.dart';
import 'delete_all.dart';
import 'list_item.dart';

class ItemList extends StatelessWidget {

  final list;
  final listType;
  final onItemTap;
  final onInfoTap;

  ItemList({Key key, @required this.list, @required this.listType, @required this.onItemTap, @required this.onInfoTap});

  @override
  Widget build(BuildContext context) {

    int getCount(item) {
      if (listType == 'shopping list') {
        return item.itemIDs.length;
      } else {
        return list.length;
      }
    }

    return ListView.builder(
        shrinkWrap: true, // gives it a size
        primary: false, // so the shopping and store lists don't scroll independently
        itemCount: list.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == list.length) {
            if (listType == 'crossedOff') {
              return DeleteAll();
            } else { // store, shopping list
              return AddNew(listType: listType);
            }
          } else {
            return ListItem(item: list[index], listType: listType, count: getCount(list[index]), onTap: onItemTap, onInfoTap: onInfoTap);
          }
        }
    );
  }
}



