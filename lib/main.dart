import 'package:flutter/material.dart';

import './components/item_list.dart';
import './components/item_list_header.dart';

import './models/item.dart';
import './models/shopping_list.dart';
import './models/store.dart';

import './views/existing_shopping_list.dart';
import './views/existing_store.dart';
import './views/new_shopping_list.dart';
import './views/new_store.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var routes = {
      ExistingShoppingList.routeName: (context) => ExistingShoppingList(),
      NewShoppingList.routeName: (context) => NewShoppingList(),
      ExistingStore.routeName: (context) => ExistingStore(),
      NewStore.routeName: (context) => NewStore(),
    };

    return MaterialApp(
      routes: routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Grocery Go!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // Some placeholder data just so we can see things working
  final List<ShoppingList> shoppingLists = [
    ShoppingList(name: "Groceries"),
    ShoppingList(name: "House stuff"),
  ];

  final List<Store> stores = [
    Store(name: "Safeway", address: "Juanita"),
    Store(name: "Safeway", address: "Bellevue"),
    Store(name: "Home Depot", address: "Bellevue"),
    Store(name: "Fred Meyer", address: "Kirkland"),
    Store(name: "Fred Meyer", address: "Bellevue"),
    Store(name: "Fred Meyer", address: "Ellensburg")
  ];

  @override
  Widget build(BuildContext context) {

    const headerShoppingLists = "Shopping Lists";
    const headerStores = "Stores";

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
                ItemList(list: shoppingLists, listType: "shopping list"),
                ItemListHeader(text: headerStores),
                ItemList(list: stores, listType: "store"),
              ],
            ),
          );
        }),
    );
  }
}
