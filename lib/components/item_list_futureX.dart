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
  final onInfoTap;
  final ShoppingList parentList;

  ItemListFuture(
      {Key key, @required this.selectedStore, @required this.listType, @required this.onInfoTap, this.parentList});

  @override
  State createState() => _ItemListFutureState();
}

class _ItemListFutureState extends State<ItemListFuture> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  final DatabaseManager db = DatabaseManager();

  var activeItems;
  var inactiveItems;

  @override
  void initState() {
    super.initState();
    getActiveItems().then((result) {
      activeItems = result.documents;
    });
    getActiveItems().then((result) {
      inactiveItems = result.getInactiveItems();
    });
  }


  Future getActiveItems() async {
    var result = await db.getItems(widget.parentList.id, true);
    return result;
  }

  Future getInactiveItems() async {
    var result = await db.getItems(widget.parentList.id, false);
    return result;
  }

  _getEndItem(snapshot) {
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

  _updateCrossedOffStatus(Item item) async {
    if (item.isCrossedOff) {
      print("removing from active list");
    } else {
      print("adding to active list");
    }

    await db.updateItemCrossedOffStatus(
        widget.parentList.id,
        item.id,
        {
          'isCrossedOff': !item.isCrossedOff,
          'lastUpdated': DateTime.now().toString()
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: widget.listType == 'crossedOff' ? getInactiveItems() : getActiveItems(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.none && snapshot.hasData == null) {
          return Container();
        }

        if (snapshot.hasData && snapshot.data != null) {
          return AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: ListView.builder(
              key: ValueKey(1),
              shrinkWrap: true,
              primary: false,
              itemCount: snapshot.data.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == snapshot.data.length) {
                  return _getEndItem(snapshot);
                } else {
                  var listItem = _getListItem(snapshot.data[index]);
                  return ListItem(
                      item: listItem,
                      listType: widget.listType,
                      count: 0,
                      onTap: _updateCrossedOffStatus,
                      onInfoTap: widget.onInfoTap,
                      parentListID: widget.parentList?.id);
                }
              }
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}



