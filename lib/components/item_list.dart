import 'package:flutter/material.dart';
import 'package:grocery_go/models/item.dart';
import 'package:grocery_go/models/shopping_list.dart';
import 'package:grocery_go/models/store.dart';

import 'list_item.dart';

class ItemList extends StatefulWidget {

  final List list;
  final String listType;
  final onItemTap;
  final onInfoTap;
  final ShoppingList parentList;

  ItemList(
      {Key key, @required this.list, @required this.listType, @required this.onItemTap, @required this.onInfoTap, this.parentList});

  @override
  State createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {

  @override
  Widget build(BuildContext context) {

    int getCount(item) {
      if (widget.listType == 'shopping list') {
        return item.activeItems;
      } else {
        return widget?.list?.length;
      }
    }

    return ListView.builder(
        key: widget.key,
        shrinkWrap: true, // gives it a size
        primary: false, // so the shopping and store lists don't scroll independently
        itemCount: widget?.list?.length ?? 0 + 1,
        itemBuilder: (BuildContext context, int index) {
          var listItem;

          if (widget.listType == 'shopping list') {
            listItem = ShoppingList(widget.list[index]);
          } else if (widget.listType == 'store') {
            listItem = Store(widget.list[index]);
          } else if (widget.listType == 'item' || widget.listType == 'crossedOff') {
            listItem = Item(widget.list[index]);
          } else {
            print("Unhandled list item type:" + widget.listType.toString());
          }

          return ListItem(item: listItem, index: index, listType: widget.listType, count: getCount(listItem), onTap: widget.onItemTap, onInfoTap: widget.onInfoTap, parentListID: widget.parentList?.id);
        }
    );
  }
}



