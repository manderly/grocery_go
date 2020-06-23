import 'package:flutter/material.dart';
import 'package:grocery_go/components/item_list_stream.dart';
import 'package:grocery_go/views/existing_list.dart';

import './components/item_list.dart';
import './components/item_list_header.dart';

import './models/shopping_list.dart';
import './models/store.dart';

import './views/existing_shopping_list.dart';
import './views/existing_store.dart';
import './views/new_item.dart';
import './views/new_shopping_list.dart';
import './views/new_store.dart';
import './views/existing_item.dart';

import './db/database_manager.dart';

void main() => runApp(GroceryGoApp());

class GroceryGoApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var routes = {
      ExistingList.routeName: (context) => ExistingList(),
      ExistingShoppingList.routeName: (context) => ExistingShoppingList(),
      NewShoppingList.routeName: (context) => NewShoppingList(),
      ExistingStore.routeName: (context) => ExistingStore(),
      NewStore.routeName: (context) => NewStore(),
      NewItem.routeName: (context) => NewItem(),
      ExistingItem.routeName: (context) => ExistingItem(),
    };

    return MaterialApp(
      routes: routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(title: 'Grocery Go!'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final DatabaseManager db = DatabaseManager();

  _goToList(ShoppingList list) {
    Navigator.pushNamed(context, ExistingShoppingList.routeName, arguments: ExistingShoppingListArguments(list));
  }

  _editStore(Store store) {
    Navigator.pushNamed(context, ExistingStore.routeName, arguments: ExistingStoreArguments(store));
  }

  _editList(ShoppingList list) {
    Navigator.pushNamed(context, ExistingList.routeName, arguments: ExistingListArguments(list));
  }

  @override
  Widget build(BuildContext context) {

    const headerShoppingLists = "Shopping Lists";
    const headerStores = "Stores";

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ItemListHeader(text: headerShoppingLists),
                ItemListStream(dbStream: db.getShoppingListStream(), listType: 'shopping list', onTap: _goToList, onInfoTap: _editList),
                ItemListHeader(text: headerStores),
                ItemListStream(dbStream: db.getStoresStream(), listType: 'store', onTap: _editStore, onInfoTap: _editStore),
              ],
            ),
          );
        }),
    );
  }
}

