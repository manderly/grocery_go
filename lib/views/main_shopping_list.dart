import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_go/components/add_new.dart';
import 'package:grocery_go/components/delete_all.dart';
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

  // todo: save user's last-selected list (locally)
  var selectedStore = SelectedStore("default", "Default");
  var activeItems = List<Item>();
  var inactiveItems = List<Item>();

  var activeItemsStream;
  var inactiveItemsStream;

  @override
  void initState() {
    super.initState();
    activeItemsStream = db.getItemsStream(widget.list.id, selectedStore.id, false);
    inactiveItemsStream = db.getItemsStream(widget.list.id, selectedStore.id, true);
  }

  Future getItems(crossedOff) async {

    var result = await db.getListItems(widget.list.id, crossedOff);
    return result;
  }

  _editItem(Item item) {
    Navigator.pushNamed(context, ExistingItem.routeName, arguments: EditItemArguments(item, widget.list.id, widget.list.name));
  }

  _selectStoreAction(String id, String name) {
    setState(() {
      selectedStore = SelectedStore(id, name);
      activeItemsStream = db.getItemsStream(widget.list.id, selectedStore.id, false);
      inactiveItemsStream = db.getItemsStream(widget.list.id, selectedStore.id, true);
    });
    Navigator.pop(context, id);
  }

  _updateCrossedOffStatus(Item item, int index) async {

    print(item.name + " at index: " + index.toString() + " isCrossedOff: " + item.isCrossedOff.toString());

    // change it in the database
    await db.updateItemCrossedOffStatus(
        widget.list.id,
        item.id,
        {
          'isCrossedOff': !item.isCrossedOff,
          'lastUpdated': DateTime.now().toString()
        }
    );

    // update state
    setState(() {
      activeItemsStream = activeItemsStream;
      inactiveItemsStream = inactiveItemsStream;
    });
  }

  @override
  Widget build(BuildContext context) {

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
                                    ..._storeActions(widget.list, _selectStoreAction),
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    isDefaultAction: true,
                                    child: Text('Default'),
                                    onPressed: () => _selectStoreAction("default", "Default"),
                                  ),
                                );
                              },
                            );
                          }
                        ),
                      ],
                      ),
                    ),
                    ItemListHeader(text: "Items"),
                    ItemListStream(dbStream: activeItemsStream, listType: 'item', onTap: _updateCrossedOffStatus, onInfoTap: _editItem, parentList: widget.list),
                    AddNew(listType: 'item', parentList: widget.list),
                    ItemListHeader(text: "Crossed Off"),
                    ItemListStream(dbStream: inactiveItemsStream, listType: 'crossedOff', onTap: _updateCrossedOffStatus, onInfoTap: _editItem, parentList: widget.list),
                    DeleteAll(), // todo: don't show if the crossedOff list length is zero 
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