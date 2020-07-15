import 'package:flutter/material.dart';
import 'package:grocery_go/components/item_list_stream.dart';
import 'package:grocery_go/views/existing_list.dart';
import 'package:grocery_go/views/manage_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './components/item_list_header.dart';

import './models/shopping_list.dart';
import './models/store.dart';

import './views/main_shopping_list.dart';
import './views/existing_store.dart';
import './views/new_item.dart';
import './views/new_shopping_list.dart';
import './views/new_store.dart';
import './views/edit_item.dart';
import './views/manage_links.dart';

import './db/database_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GroceryGoApp(preferences: await SharedPreferences.getInstance()));
}

class GroceryGoApp extends StatefulWidget {
  final SharedPreferences preferences;
  GroceryGoApp({Key key, @required this.preferences}) : super(key: key);

  @override
  _GroceryGoAppState createState() => _GroceryGoAppState();
}

class _GroceryGoAppState extends State<GroceryGoApp> {
  static const DARK_THEME_KEY = 'darkTheme';
  bool get darkTheme => widget.preferences.getBool(DARK_THEME_KEY) ?? false;

  void toggleTheme(bool value) {
    setState(() {
      widget.preferences.setBool(DARK_THEME_KEY, !darkTheme);
    });
  }

  @override
  Widget build(BuildContext context) {

    var routes = {
      ExistingList.routeName: (context) => ExistingList(),
      NewShoppingList.routeName: (context) => NewShoppingList(),
      ExistingStore.routeName: (context) => ExistingStore(),
      NewStore.routeName: (context) => NewStore(),
      NewItem.routeName: (context) => NewItem(),
      ExistingItem.routeName: (context) => ExistingItem(),
      ManageLinks.routeName: (context) => ManageLinks(),
    };

    return MaterialApp(
      routes: routes,
      // alternative method of passing args into a route
      onGenerateRoute: (settings) {
        if (settings.name == MainShoppingList.routeName) {
          final MainShoppingListArguments args = settings.arguments;

          return MaterialPageRoute(
            builder: (context) {
              return MainShoppingList(
                  list: args.list
              );
            },
          );
        }

        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
      theme: darkTheme ? ThemeData.dark() : ThemeData.light(),
      home: MainPage(darkTheme: darkTheme, toggleTheme: toggleTheme),
    );
  }
}

class MainPage extends StatefulWidget {
  final darkTheme;
  final toggleTheme;

  MainPage({Key key, this.darkTheme, this.toggleTheme}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  _MainPageState();

  final DatabaseManager db = DatabaseManager();

  _goToList(ShoppingList list, int index) {
    print("navigating to: " + list.name);
    Navigator.pushNamed(
        context,
        MainShoppingList.routeName,
        arguments: MainShoppingListArguments(list));
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
        title: Text('Grocery Go'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Grocery Go',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
            SwitchListTile(
              title: Text('Dark Mode'),
              value: widget.darkTheme,
              onChanged: widget.toggleTheme,
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Account management'),
              subtitle: Text('Logged in as TILCode')
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('App preferences'),
            ),
          ],
        ),
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

