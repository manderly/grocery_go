import 'package:flutter/material.dart';
import 'package:grocery_go/models/item.dart';
import 'package:grocery_go/forms/edit_item_form.dart';

class EditItemArguments {
  final Item item;
  final String parentListID;
  final String parentListName;
  EditItemArguments(this.item, this.parentListID, this.parentListName);
}

class ExistingItem extends StatefulWidget {

  static const routeName = '/existingItem';

  ExistingItem({Key key});

  @override
  _ExistingItemState createState() => _ExistingItemState();
}

class _ExistingItemState extends State<ExistingItem> {

  @override
  Widget build(BuildContext context) {

    final EditItemArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Item details"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: EditItemForm(args: args),
            ),
          ),
        ),
      );
    }
}