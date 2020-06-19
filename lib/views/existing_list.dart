import 'package:flutter/material.dart';
import 'package:grocery_go/models/shopping_list.dart';

class ExistingListArguments {
  final ShoppingList list;
  ExistingListArguments(this.list);
}

class ExistingList extends StatelessWidget {

  static const routeName = '/existingList';

  void updateList (BuildContext context) {
    print("Updating list");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    final ExistingListArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit list: " + args.list.name),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TextFormField(
                autofocus: true,
                initialValue: args.list.name,
                decoration: InputDecoration(
                    labelText: 'List name',
                    border: OutlineInputBorder()),
              ),
            ),
            RaisedButton(
              onPressed: () => updateList(context),
              child: Text('Save list'),
            ),
          ],
        ),
      ),
    );
  }
}