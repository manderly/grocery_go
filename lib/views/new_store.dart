import 'package:flutter/material.dart';
import 'package:grocery_go/forms/store_form.dart';

class NewStore extends StatefulWidget {

  static const routeName = '/newStore';

  NewStore({Key key});

  @override
  _NewStoreState createState() => _NewStoreState();
}

class _NewStoreState extends State<NewStore> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new store"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: StoreForm(),
        ),
      ),
    );
  }
}

