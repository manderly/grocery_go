import 'package:flutter/material.dart';
import 'package:grocery_go/db/database_manager.dart';
import 'package:grocery_go/db/shopping_list_dto.dart';
import 'package:grocery_go/forms/shopping_list_form.dart';

class NewShoppingList extends StatefulWidget {

  static const routeName = '/newShoppingList';

  NewShoppingList({Key key});

  @override
  _NewShoppingListState createState() => _NewShoppingListState();
}

class _NewShoppingListState extends State<NewShoppingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new shopping list"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ShoppingListForm(),
        ),
      ),
    );
  }
}