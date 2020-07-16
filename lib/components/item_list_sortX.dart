import 'package:flutter/material.dart';
import 'package:grocery_go/components/item_list.dart';
import 'package:grocery_go/components/item_list_header.dart';
import 'package:grocery_go/db/database_manager.dart';
import 'package:grocery_go/models/item.dart';
import 'package:grocery_go/models/shopping_list.dart';
import 'package:grocery_go/models/store.dart';

import 'add_new.dart';
import 'delete_all.dart';

class ItemListSort extends StatefulWidget {

  final activeItems;
  final inactiveItems;
  final selectedStore;
  final String listType;
  final onInfoTap;
  final ShoppingList parentList;

  ItemListSort(
      {Key key, @required this.activeItems, @required this.inactiveItems, @required this.selectedStore, @required this.listType, @required this.onInfoTap, this.parentList});

  @override
  State createState() => _ItemListSortState();
}

class _ItemListSortState extends State<ItemListSort> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  final DatabaseManager db = DatabaseManager();

  List<Item> activeItems;
  List<Item> inactiveItems;

  @override
  void initState() {
    super.initState();
    setState(() {
      activeItems = widget.activeItems;
      inactiveItems = widget.inactiveItems;
    });
  }

  _getEndItem(snapshot) {
    if (widget.listType == 'crossedOff') {
      if (snapshot.data.length > 0) {
        return DeleteAll();
      } else {
        return Text("");
      }
    } else if (widget.listType == 'item') {
      return AddNew(
          listType: widget.listType,
          parentList: widget.parentList);
    } else {
      return Text("Invalid list type");
    }
  }

  _getListItem(itemAtIndex) {
    if (widget.listType == 'shopping list') {
      return ShoppingList(itemAtIndex);
    } else if (widget.listType == 'store') {
      return Store(itemAtIndex);
    } else if (widget.listType == 'item' || widget.listType == 'crossedOff') {
      return Item(itemAtIndex);
    } else {
      print("Unhandled list item type:" + widget.listType.toString());
      return Text("ERROR item_list_future");
    }
  }

  _updateCrossedOffStatus(Item item, int index) async {

    print(item.name + " isCrossedOff: " + item.isCrossedOff.toString());

    // remove + add to list visually
    if (item.isCrossedOff == true) {
      inactiveItems.removeAt(index);
      item.isCrossedOff = false;
      activeItems.add(item);
    } else {
      activeItems.removeAt(index);
      item.isCrossedOff = true;
      inactiveItems.add(item);
    }

    // change it in the database
    await db.updateItemCrossedOffStatus(
        widget.parentList.id,
        item.id,
        {
          'isCrossedOff': item.isCrossedOff,
          'lastUpdated': DateTime.now().toString()
        }
    );

    // update state
    setState(() {
      activeItems = activeItems;
      inactiveItems = inactiveItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemListHeader(text: "Items"),
        ItemList(
          list: activeItems, //.where((item) => item.isCrossedOff == false).toList(),
          listType: 'item',
          onItemTap: _updateCrossedOffStatus,
          onInfoTap: widget.onInfoTap,
          parentList: widget.parentList,
        ),
        ItemListHeader(text: "Crossed Off"),
        ItemList(
          list: inactiveItems, //.where((item) => item.isCrossedOff == true).toList(),
          listType: 'crossedOff',
          onItemTap: _updateCrossedOffStatus,
          onInfoTap: widget.onInfoTap,
          parentList: widget.parentList,
        ),
      ]
    );
  }
}



