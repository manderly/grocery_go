import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class MainShoppingListArguments {
  final ShoppingList list;
  MainShoppingListArguments(this.list);
}

class MainShoppingList extends StatefulWidget {

  static const routeName = '/mainShoppingList';

  MainShoppingList({Key key});

  @override
  _MainShoppingListState createState() => _MainShoppingListState();
}

class _MainShoppingListState extends State<MainShoppingList> {

  final DatabaseManager db = DatabaseManager();

  // todo: save user's last-selected list (locally)
  var selectedStore = SelectedStore("default", "Default");

  @override
  Widget build(BuildContext context) {

    final MainShoppingListArguments args = ModalRoute.of(context).settings.arguments;

    _editItem(Item item) {
      Navigator.pushNamed(context, ExistingItem.routeName, arguments: EditItemArguments(item, args.list.id, args.list.name));
    }

    _updateCrossedOffStatus(Item item) async {
      await db.updateItemCrossedOffStatus(
        args.list.id,
        item.id,
        {
          'isCrossedOff': !item.isCrossedOff,
          'lastUpdated': DateTime.now().toString()
        }
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(args.list.name),
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {

              _selectAction(String id, String name) {
                print("id: " + id);
                setState(() {
                  selectedStore = SelectedStore(id, name);
                });
                Navigator.pop(context, id);
              }

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
                                    ..._storeActions(args.list, _selectAction),
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    isDefaultAction: true,
                                    child: Text('Default'),
                                    onPressed: () { print("default"); },
                                  ),
                                );
                              },
                            );
                          }
                        ),
                      ],
                      ),
                    ),
                    ItemListHeader(text: args.list.id), // getCrossedOffStream
                    ItemListStream(dbStream: db.getItemsStream(args.list.id, false, 'NjT2lc4ZczXh3AEcip7R'), listType: 'item', onTap: _updateCrossedOffStatus, onInfoTap: _editItem, parentList: args.list),
                    ItemListHeader(text: "Crossed off"),
                    ItemListStream(dbStream: db.getItemsStream(args.list.id, true, 'NjT2lc4ZczXh3AEcip7R'), listType: 'crossedOff', onTap: _updateCrossedOffStatus, onInfoTap: _editItem, parentList: args.list),
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