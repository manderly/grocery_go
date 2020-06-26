import 'package:flutter/material.dart';
import 'package:grocery_go/models/item.dart';
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
  final ShoppingList parentList;

  ItemList({Key key, @required this.list, @required this.listType, @required this.onItemTap, @required this.onInfoTap, this.parentList});

  @override
  Widget build(BuildContext context) {

    int getCount(item) {
      if (listType == 'shopping list') {
        return item.itemCount;
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
            } else if (listType == 'store' || listType == 'shopping list') {
              return AddNew(listType: listType);
            } else if (listType == 'item') {
              return AddNew(listType: listType, parentList: parentList);
            } else {
              return Text("Invalid list type");
            }
          } else {

            var listItem;

            if (listType == 'shopping list') {
              listItem = ShoppingList(list[index]);
            } else if (listType == 'store') {
              listItem = Store(list[index]);
            } else if (listType == 'item' || listType == 'crossedOff') {
              listItem = Item(list[index]);
            } else {
              print("Unhandled list item type");
            }

            return ListItem(item: listItem, listType: listType, count: getCount(listItem), onTap: onItemTap, onInfoTap: onInfoTap);
          }
        }
    );
  }
}



