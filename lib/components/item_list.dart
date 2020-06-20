import 'package:flutter/material.dart';
import 'package:grocery_go/models/shopping_list.dart';
import 'package:grocery_go/models/store.dart';

import 'add_new.dart';
import 'delete_all.dart';
import 'list_item.dart';

class ItemList extends StatelessWidget {

  final List list;
  final String listType;
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
              return AddNew(list: list, listType: listType);
            }
          } else {
            var listItem;

            if (listType == 'shopping list') {
              listItem = ShoppingList(list[index]);
            } else if (listType == 'store') {
              listItem = Store(list[index]);
            }

            return ListItem(item: listItem, listType: listType, count: getCount(listItem), onTap: onItemTap, onInfoTap: onInfoTap);
          }
        }
    );
  }
}



