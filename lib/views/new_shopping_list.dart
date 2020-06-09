import 'package:flutter/material.dart';

class NewShoppingList extends StatefulWidget {

  static const routeName = '/newShoppingList';

  NewShoppingList({Key key});

  @override
  _NewShoppingListState createState() => _NewShoppingListState();
}

class _NewShoppingListState extends State<NewShoppingList> {

  void saveList(BuildContext context) {
    print("Saving new list");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new shopping list"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                    labelText: 'Shopping list name',
                    border: OutlineInputBorder()),
              ),
              RaisedButton(
                onPressed: () => saveList(context),
                child: Text('Save'),
              ),
            ],
          ),
        ),
      )
    );
  }
}