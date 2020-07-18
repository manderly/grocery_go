import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_go/components/add_new.dart';
import 'package:grocery_go/components/delete_all.dart';
import 'package:grocery_go/components/item_list_header.dart';
import 'package:grocery_go/components/item_list_stream.dart';
import 'package:grocery_go/db/database_manager.dart';
import 'package:grocery_go/models/item.dart';
import 'package:grocery_go/models/shopping_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_item.dart';

class SelectedStore {
  String id;
  String name;

  SelectedStore(this.id, this.name);
}

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

  var activeItems = List<Item>();
  var inactiveItems = List<Item>();

  var activeItemsStream;
  var inactiveItemsStream;

  String selectedStoreID = 'default';
  String selectedStoreName = '';

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedStoreID = prefs.getString(widget.list.id) ?? 'default';
    setState(() {
      selectedStoreName = _getStoreName(selectedStoreID);
    });
  }

  _setSelectedStore(String id, String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(widget.list.id, id);

    setState(() {
      selectedStoreID = id;
      selectedStoreName = _getStoreName(selectedStoreID);
      activeItemsStream = db.getActiveItemsStream(widget.list.id, id);
      inactiveItemsStream = db.getInactiveItemsStream(widget.list.id);
    });

    Navigator.pop(context, id);
  }

  _getStoreName(String id) {
    return widget.list.stores[id] ?? 'Default';
  }

  @override
  void initState() {
    super.initState();
    selectedStoreID = '';
    getSharedPrefs();
    activeItemsStream = db.getActiveItemsStream(widget.list.id, selectedStoreID);
    inactiveItemsStream = db.getInactiveItemsStream(widget.list.id);
  }

  Future getItems(crossedOff) async {
    var result = await db.getListItems(widget.list.id, crossedOff);
    return result;
  }

  _editItem(Item item) {
    Navigator.pushNamed(context, ExistingItem.routeName, arguments: EditItemArguments(item, widget.list.id, widget.list.name));
  }

  _updateCrossedOffStatus(Item item, int index) async {
    print(item.name + " at index: " + index.toString() + " isCrossedOff: " + item.isCrossedOff.toString());
    await db.updateItemCrossedOffStatus(
        widget.list.id,
        item.id,
        {
          'isCrossedOff': !item.isCrossedOff,
          'lastUpdated': DateTime.now()
        }
    );

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
                          child: Text(selectedStoreName),
                          onPressed: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoActionSheet(
                                  title: Text("Select a store"),
                                  message: Text("Customizing the item order for each store you visit helps streamline your shopping trips."),
                                  actions: [
                                    ..._storeOptions(widget.list, _setSelectedStore),
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    isDefaultAction: true,
                                    child: Text('Default'),
                                    onPressed: () => _setSelectedStore('default', 'Default'),
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

  _storeOptions(list, selectAction) {
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