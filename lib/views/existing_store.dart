import 'package:flutter/material.dart';
import 'package:grocery_go/models/store.dart';

class ExistingStoreArguments {
  final Store store;
  ExistingStoreArguments(this.store);
}

class ExistingStore extends StatelessWidget {

  static const routeName = '/existingStore';

  void updateStore (BuildContext context) {
    print("Updating store");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    final ExistingStoreArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit store: " + args.store.name),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TextFormField(
                autofocus: true,
                initialValue: args.store.name,
                decoration: InputDecoration(
                    labelText: 'Store name',
                    border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                autofocus: true,
                initialValue: args.store.address,
                decoration: InputDecoration(
                    labelText: 'Store location',
                    border: OutlineInputBorder()),
              ),
            ),
            RaisedButton(
              onPressed: () => updateStore(context),
              child: Text('Save store'),
            ),
          ],
        ),
      ),
    );
  }
}