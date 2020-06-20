import 'package:flutter/material.dart';
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

import 'package:cloud_firestore/cloud_firestore.dart';

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

  final List<ShoppingList> shoppingLists = [
    ShoppingList(id: 'list123', name: "Groceries", itemIDs:['abc1', 'abc2', 'abc3', 'abc4']),
    ShoppingList(id: 'list124', name: "McLendon's / ACE / Home Depot", itemIDs:['abc8', 'abc9']),
    ShoppingList(id: 'list124', name: "Target", itemIDs:['abc8']),
  ];

  // stores mock data
  final List<Store> stores = [
    Store(id: 'store1', name: "Safeway", address: "Juanita"),
    Store(id: 'store2', name: "Safeway", address: "Bellevue"),
    Store(id: 'store3', name: "Home Depot", address: "Bellevue"),
    Store(id: 'store4', name: "Fred Meyer", address: "Kirkland"),
    Store(id: 'store5', name: "Fred Meyer", address: "Bellevue"),
    Store(id: 'store6', name: "Fred Meyer", address: "Ellensburg")
  ];

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
                _shoppingLists(context),
                //ItemList(list: shoppingLists, listType: 'shopping list', onItemTap: _goToList, onInfoTap: _editList),
                ItemListHeader(text: headerStores),
                ItemList(list: stores, listType: 'store', onItemTap: _editStore, onInfoTap: _editStore),
              ],
            ),
          );
        }),
    );
  }

  Widget _shoppingLists(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: db.getShoppingListStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return new Text('Loading...');
            default:
              return ItemList(list: QuerySnapshot, listType: 'shopping list', onItemTap: _goToList, onInfoTap: _editList);
          }
        }
    );
  }
}

