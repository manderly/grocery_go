import 'package:flutter/material.dart';
import 'package:grocery_go/forms/new_item_form.dart';
import 'package:grocery_go/models/shopping_list.dart';

class NewItemArguments {
  final ShoppingList parentList;
  NewItemArguments(this.parentList);
}

class NewItem extends StatefulWidget {

  static const routeName = '/newItem';

  NewItem({Key key});

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {

  @override
  Widget build(BuildContext context) {

    final NewItemArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add new item"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: NewItemForm(parentList: args.parentList),
          ),
        ),
      ),
    );
  }
}