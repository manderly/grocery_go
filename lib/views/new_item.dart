import 'package:flutter/material.dart';
import 'package:grocery_go/forms/new_item_form.dart';

class NewItemArguments {
  final String parentListID;
  final String parentListName;
  NewItemArguments(this.parentListID, this.parentListName);
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
            child: NewItemForm(args: args),
          ),
        ),
      ),
    );
  }
}