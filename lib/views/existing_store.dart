import 'package:flutter/material.dart';

class ExistingStore extends StatefulWidget {

  static const routeName = 'existingStore';

  ExistingStore({Key key});

  @override
  _ExistingStoreState createState() => _ExistingStoreState();
}

class _ExistingStoreState extends State<ExistingStore> {

  void updateStore (BuildContext context) {
    print("Updating store");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit store"),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                    labelText: 'Store name',
                    border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                autofocus: true,
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