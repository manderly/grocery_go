import 'package:flutter/material.dart';
import 'package:grocery_go/components/item_list_header.dart';
import 'package:grocery_go/components/item_list_stream.dart';
import 'package:grocery_go/db/database_manager.dart';
import 'package:grocery_go/db/item_dto.dart';
import 'package:grocery_go/models/item.dart';
import 'package:grocery_go/models/shopping_list.dart';

import 'edit_item.dart';

class MainShoppingListArguments {
  final ShoppingList list;
  MainShoppingListArguments(this.list);
}

class MainShoppingList extends StatelessWidget {

  static const routeName = '/mainShoppingList';

  final DatabaseManager db = DatabaseManager();

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
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ItemListHeader(text: args.list.id), // getCrossedOffStream
                    ItemListStream(dbStream: db.getItemsStream(args.list.id, false), listType: 'item', onTap: _updateCrossedOffStatus, onInfoTap: _editItem, parentList: args.list),
                    ItemListHeader(text: "Crossed off"),
                    ItemListStream(dbStream: db.getItemsStream(args.list.id, true), listType: 'crossedOff', onTap: _updateCrossedOffStatus, onInfoTap: _editItem, parentList: args.list),
                  ],
                ),
              );
            }),
    );
  }
}