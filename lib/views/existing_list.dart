import 'package:flutter/material.dart';
import 'package:grocery_go/forms/shopping_list_form.dart';
import 'package:grocery_go/models/shopping_list.dart';

class ExistingListArguments {
  final ShoppingList list;
  ExistingListArguments(this.list);
}

class ExistingList extends StatefulWidget {
  static const routeName = '/existingList';
  ExistingList({Key key});

  @override
  _ExistingListState createState() => _ExistingListState();
}

class _ExistingListState extends State<ExistingList> {
  @override
  Widget build(BuildContext context) {

    final ExistingListArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit shopping list"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ShoppingListForm(args: args),
        ),
      ),
    );
  }
}