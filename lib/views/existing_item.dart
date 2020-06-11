import 'package:flutter/material.dart';
import 'package:grocery_go/models/item.dart';

class ExistingItemArguments {
  final Item item;
  ExistingItemArguments(this.item);
}

class ExistingItem extends StatefulWidget {

  static const routeName = '/existingItem';

  ExistingItem({Key key});

  @override
  _ExistingItemState createState() => _ExistingItemState();
}

class _ExistingItemState extends State<ExistingItem> {

  String _name = 'ERROR: ARGS NOT LOADED!';
  int _quantity = 0;
  bool _subsOk = false;
  bool _urgent = false;
  bool _private = false;
  ExistingItemArguments args;

  void _setStartingValues(item) {
    setState(() {
      _name = item.name;
      _quantity = item.quantity;
      _subsOk = item.subsOk;
      _urgent = item.urgent;
      _private = item.private;
    });
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void changeCategory(item) {
    print("stub: open change item category page");
  }

  void _setSubsOk(value) {
    setState(() {
      _subsOk = value;
    });
  }

  void _setUrgency(value) {
    setState(() {
      _urgent = value;
    });
  }

  void _setPrivacy(value) {
    setState(() {
      _private = value;
    });
  }

  void saveItem(BuildContext context) {
    print("Creating a new item and adding it to list ID");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (args == null) {
      args = ModalRoute.of(context).settings.arguments;
      _setStartingValues(args.item);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Item details"),
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
                    initialValue: _name,
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
                        onPressed: _decreaseQuantity,
                        child: Text('Fewer'),
                      ),
                      Spacer(flex:1),
                      RaisedButton(
                        onPressed: _increaseQuantity,
                        child: Text('More'),
                      ),
                      Spacer(flex: 4),
                      Text('$_quantity'),
                      Spacer(flex: 2),
                    ]
                ),
                RaisedButton(
                  onPressed: () => changeCategory(args.item),
                  child: Text('Category: Uncategorized'),
                ),
                Row(
                  children: [
                    Checkbox(
                        value: _urgent,
                        onChanged: (bool value) => _setUrgency(value)
                    ),
                    Text("Urgent")
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        value: _private,
                        onChanged: (bool value) => _setPrivacy(value)
                    ),
                    Text("Private"),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        value: _subsOk,
                        onChanged: (bool value) => _setSubsOk(value)
                    ),
                    Text("Ok to substitute"),
                    Spacer(flex:6),
                    Text("Manage substitutes..."),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                      onPressed: () => saveItem(context),
                      child: Text('Save item'),
                    ),
                  ],
                ),
                Text("Item ID: " + args.item.id),
                Text("Owner: " + args.item.addedBy),
              ],
            ),
          ),
        ),
      ),
    );
  }
}