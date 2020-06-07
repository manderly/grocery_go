import 'package:flutter/material.dart';

class NewStore extends StatefulWidget {

  static const routeName = 'newStore';

  NewStore({Key key});

  @override
  _NewStoreState createState() => _NewStoreState();
}

class _NewStoreState extends State<NewStore> {

  void saveList(BuildContext context) {
    print("Saving new store");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add new store"),
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
                  onPressed: () => saveList(context),
                  child: Text('Save store'),
                ),
              ],
            ),
          ),
    );
  }
}