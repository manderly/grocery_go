import 'package:flutter/material.dart';

class NewItemArguments {
  final String listID;
  NewItemArguments(this.listID);
}

class NewItem extends StatefulWidget {

  static const routeName = '/newItem';

  NewItem({Key key});

  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {

  String itemName = '';

  void saveItem(BuildContext context, listID) {
    print("Creating a new item and adding it to list ID " + listID);
    Navigator.of(context).pop();
  }

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
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'Item name (required)',
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                      onPressed: () => saveItem(context, args.listID),
                      child: Text('Save item'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}