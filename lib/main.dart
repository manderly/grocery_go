import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grocery_go/components/item_list_stream.dart';
import 'package:grocery_go/views/existing_list.dart';
import 'package:grocery_go/views/manage_links.dart';
import 'package:grocery_go/views/manage_list.dart';
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
import 'components/add_new.dart';

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
      //ManageLinks.routeName: (context) => ManageLinks(),
      ManageList.routeName: (context) => ManageList(),
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        } else if (settings.name == ManageLinks.routeName) {
          final ManageLinksArguments args = settings.arguments;

          return MaterialPageRoute(
            builder: (context) {
              return ManageLinks(
                dbStream: args.dbStream,
                linkedEntities: args.linkedEntities,
                parentID: args.parentID,
                parentName: args.parentName,
                parentType: args.parentType,
              );
            }
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

  DocumentSnapshot userData;

  final DatabaseManager db = DatabaseManager();

  void getUserData() async {
    DocumentSnapshot _userData = await db.getUser('Nr2JtF4tqSTrD14gp5Sr');
    setState(() {
      userData = _userData;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  manageList(String listType) {
    if (listType == 'shopping list') {
      Navigator.pushNamed(context, ManageList.routeName, arguments: ManageListArguments(db.getShoppingListsCollection(), 'default'));
    } else if (listType == 'store') {
      Navigator.pushNamed(context, ManageList.routeName, arguments: ManageListArguments(db.getStoresCollection(), 'default'));
    } else {
      print("Unhandled list type in main.dart, line 126");
    }
  }

  _goToList(ShoppingList list, int index) {
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

  _settingsDrawer() {
    return Drawer(
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
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    const headerShoppingLists = "Shopping Lists";
    const headerStores = "Stores";

    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery Go'),
      ),
      drawer:_settingsDrawer(),
      body: SingleChildScrollView(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ItemListHeader(text: headerShoppingLists, listType: 'shopping list', onManageListTap: manageList),
          ItemListStream(dbStream: db.getShoppingListStream(), sortBy: 'default', listType: 'shopping list', onTap: _goToList, onInfoTap: _editList),
          AddNew(listType: 'shopping list'),
          ItemListHeader(text: headerStores, listType: 'store', onManageListTap: manageList),
          ItemListStream(dbStream: db.getStoresStream(), sortBy: 'default', listType: 'store', onTap: _editStore, onInfoTap: _editStore),
          AddNew(listType: 'store'),
        ],
      ),
      ),
    );
  }
}

