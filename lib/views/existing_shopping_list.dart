import 'package:flutter/material.dart';
import 'package:grocery_go/components/item_list.dart';
import 'package:grocery_go/components/item_list_header.dart';
import 'package:grocery_go/components/item_list_stream.dart';
import 'package:grocery_go/db/database_manager.dart';
import 'package:grocery_go/models/item.dart';
import 'package:grocery_go/models/shopping_list.dart';

import 'existing_item.dart';

class ExistingShoppingListArguments {
  final ShoppingList list;
  ExistingShoppingListArguments(this.list);
}

class ExistingShoppingList extends StatelessWidget {

  static const routeName = '/existingShoppingList';

  final DatabaseManager db = DatabaseManager();

  _crossOff(Item item) {
    print("Remove this id from this list: " + item.id);
  }

  _addToList(Item item) {
    print("Add this item to the list: " + item.id);
  }

  @override
  Widget build(BuildContext context) {

    final ExistingShoppingListArguments args = ModalRoute.of(context).settings.arguments;

    _editItem(Item item) {
      Navigator.pushNamed(context, ExistingItem.routeName, arguments: ExistingItemArguments(item));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(args.list.name),
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ItemListHeader(text: "Category/Aisle here"),
                    ItemListStream(dbStream: db.getItemsStream(args.list.itemIDs), listType: 'item', onTap: _crossOff, onInfoTap: _editItem),
                    //ItemList(list: list, listType: 'item', onItemTap: _crossOff, onInfoTap: _editItem),
                    ItemListHeader(text: "Crossed off"),
                    //ItemList(list: crossedOff, listType: "crossedOff", onItemTap: _addToList, onInfoTap: _editItem),
                  ],
                ),
              );
            }),
    );
  }
}