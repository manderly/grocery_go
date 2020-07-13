import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_go/db/database_manager.dart';
import 'package:grocery_go/models/item.dart';
import 'package:grocery_go/models/shopping_list.dart';
import 'package:grocery_go/models/store.dart';

import 'add_new.dart';
import 'delete_all.dart';
import 'list_item.dart';

class ItemListFuture extends StatefulWidget {

  final selectedStore;
  final String listType;
  final onItemTap;
  final onInfoTap;
  final ShoppingList parentList;

  ItemListFuture(
      {Key key, @required this.selectedStore, @required this.listType, @required this.onItemTap, @required this.onInfoTap, this.parentList});

  @override
  State createState() => _ItemListFutureState();
}

class _ItemListFutureState extends State<ItemListFuture> {

  final DatabaseManager db = DatabaseManager();

  Future getActiveItems() async {
    var result = await db.getItems(widget.parentList.id, true, widget.selectedStore.id);
    return result;
  }

  Future getInactiveItems() async {
    var result = await db.getItems(widget.parentList.id, false, widget.selectedStore.id);
    return result;
  }


  @override
  Widget build(BuildContext context) {

    /*
    int getCount(item) {
      if (widget.listType == 'shopping list') {
        return item.itemCount;
      } else {
        return widget.list.length;
      }
    } */

    return FutureBuilder(
      future: widget.listType == 'crossedOff' ? getInactiveItems() : getActiveItems(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.none && snapshot.hasData == null) {
          return Container();
        }

        if (snapshot.hasData && snapshot.data != null) {
          return ListView.builder(
              key: widget.key,
              shrinkWrap: true,
              // gives it a size
              primary: false,
              // so the shopping and store lists don't scroll independently
              itemCount: snapshot.data.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == snapshot.data.length) {
                  if (widget.listType == 'crossedOff') {
                    if (snapshot.data.length > 0) {
                      return DeleteAll();
                    } else {
                      return Text("");
                    }
                  } else if (widget.listType == 'store' ||
                      widget.listType == 'shopping list') {
                    return AddNew(listType: widget.listType);
                  } else if (widget.listType == 'item') {
                    return AddNew(
                        listType: widget.listType,
                        parentList: widget.parentList);
                  } else {
                    return Text("Invalid list type");
                  }
                } else {
                  var listItem;
                  if (widget.listType == 'shopping list') {
                    listItem = ShoppingList(snapshot.data[index]);
                  } else if (widget.listType == 'store') {
                    listItem = Store(snapshot.data[index]);
                  } else if (widget.listType == 'item' ||
                      widget.listType == 'crossedOff') {
                    listItem = Item(snapshot.data[index]);
                  } else {
                    print("Unhandled list item type:" + widget.listType.toString());
                  }
                  return ListItem(item: listItem,
                      listType: widget.listType,
                      count: 1214,
                      //getCount(listItem),
                      onTap: widget.onItemTap,
                      onInfoTap: widget.onInfoTap,
                      parentListID: widget.parentList?.id);
                }
              }
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}



