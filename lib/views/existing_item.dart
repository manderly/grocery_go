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

  _ExistingItemState();


  void _increaseQuantity(item) {
    setState(() {
      item.quantity = item.quantity+1;
    });
  }

  void _decreaseQuantity(item) {
    if (item.quantity > 1) {
      setState(() {
        item.quantity = item.quantity-1;
      });
    }
  }

  void changeCategory(item) {
    print("stub: open change item category page");
  }

  void _setSubsOk(item, value) {
    setState(() {
      item.setSubsOk(value);
    });
  }

  void _setUrgency(item, value) {
    setState(() {
      item.setUrgent(value);
    });
  }

  void _setPrivacy(item, value) {
    setState(() {
      item.setPrivate(value);
    });
  }

  void saveItem(BuildContext context) {
    print("Creating a new item and adding it to list ID");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    final ExistingItemArguments args = ModalRoute.of(context).settings.arguments;

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
                    initialValue: args.item.name,
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
                        onPressed: () => _decreaseQuantity(args.item),
                        child: Text('Fewer'),
                      ),
                      Spacer(flex:1),
                      RaisedButton(
                        onPressed: () => _increaseQuantity(args.item),
                        child: Text('More'),
                      ),
                      Spacer(flex: 4),
                      Text('Quantity: ' + args.item.quantity.toString()),
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
                        value: args.item.urgent,
                        onChanged: (bool value) => _setUrgency(args.item, value)
                    ),
                    Text("Urgent")
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        value: args.item.private,
                        onChanged: (bool value) => _setPrivacy(args.item, value)
                    ),
                    Text("Private"),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        value: args.item.subsOk,
                        onChanged: (bool value) => _setSubsOk(args.item, value)
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}