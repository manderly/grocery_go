import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_go/components/item_list.dart';
import 'package:grocery_go/components/item_list_future.dart';
import 'package:grocery_go/components/item_list_header.dart';
import 'package:grocery_go/components/item_list_stream.dart';
import 'package:grocery_go/db/database_manager.dart';
import 'package:grocery_go/models/item.dart';
import 'package:grocery_go/models/shopping_list.dart';

import 'edit_item.dart';

class SelectedStore {
  String id;
  String name;

  SelectedStore(this.id, this.name);
}

// todo: refactor this out
class MainShoppingListArguments {
  final ShoppingList list;
  MainShoppingListArguments(this.list);
}

class MainShoppingList extends StatefulWidget {

  static const routeName = '/mainShoppingList';

  final ShoppingList list;
  MainShoppingList({Key key, this.list});

  @override
  _MainShoppingListState createState() => _MainShoppingListState();
}

class _MainShoppingListState extends State<MainShoppingList> {

  final DatabaseManager db = DatabaseManager();

  var itemsStream;
  var itemsActive;
  var itemsCrossedOff;

  // todo: save user's last-selected list (locally)
  var selectedStore = SelectedStore("default", "Default");

  @override
  void initState() {
    super.initState();
    itemsStream = db.getItemsStream(widget.list.id, selectedStore.id);

    itemsActive = db.getItems(widget.list.id, true, selectedStore.id);
    itemsCrossedOff = db.getItems(widget.list.id, false, selectedStore.id);
  }

  _editItem(Item item) {
    Navigator.pushNamed(context, ExistingItem.routeName, arguments: EditItemArguments(item, widget.list.id, widget.list.name));
  }

  _selectAction(String id, String name) {
    setState(() {
      selectedStore = SelectedStore(id, name);
    });
    Navigator.pop(context, id);
  }

  _updateCrossedOffStatus(Item item) async {

    await db.updateItemCrossedOffStatus(
        widget.list.id,
        item.id,
        {
          'isCrossedOff': !item.isCrossedOff,
          'lastUpdated': DateTime.now().toString()
        }
    );

    await new Future.delayed(const Duration(milliseconds : 1000));

    setState(() {
      itemsStream = db.getItemsStream(widget.list.id, selectedStore.id);

      itemsActive = db.getItems(widget.list.id, true, selectedStore.id);
      itemsCrossedOff = db.getItems(widget.list.id, false, selectedStore.id);
    });
  }

  @override
  Widget build(BuildContext context) {


    //final MainShoppingListArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.list.name),
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.blue,
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.more_horiz),
                        FlatButton(
                          child: Text(selectedStore.name),
                          onPressed: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoActionSheet(
                                  title: Text("Select a store"),
                                  message: Text("Customizing the item order for each store you visit helps streamline your shopping trips."),
                                  actions: [
                                    ..._storeActions(widget.list, _selectAction),
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    isDefaultAction: true,
                                    child: Text('Default'),
                                    onPressed: () => _selectAction("default", "Default"),
                                  ),
                                );
                              },
                            );
                          }
                        ),
                      ],
                      ),
                    ),
                    ItemListHeader(text: widget.list.id),
                    ItemListFuture(
                      selectedStore: selectedStore,
                      listType: 'item',
                      onItemTap: _updateCrossedOffStatus,
                      onInfoTap: _editItem,
                      parentList: widget.list
                    ),
                    /*
                    ItemListStream(
                        dbStream: itemsActive,
                        listType: 'item',
                        onTap: _updateCrossedOffStatus,
                        onInfoTap: _editItem,
                        parentList: widget.list), */
                    ItemListHeader(text: "Crossed off"),
                    ItemListFuture(
                      selectedStore: selectedStore,
                      listType: 'crossedOff',
                      onItemTap: _updateCrossedOffStatus,
                      onInfoTap: _editItem,
                      parentList: widget.list
                    ),
                    /*
                    ItemListStream(
                        dbStream: itemsCrossedOff,
                        listType: 'crossedOff',
                        onTap: _updateCrossedOffStatus,
                        onInfoTap: _editItem,
                        parentList: widget.list), */
                  ],
                ),
              );
            }),
    );
  }

  _storeActions(list, selectAction) {
    var stores = List();

    list.stores.forEach((id, name) => {
      stores.add(
        CupertinoActionSheetAction(
          onPressed: () => {selectAction(id, name)},
          child: Text(name)
        )
      )
    });

    return stores;
  }
}