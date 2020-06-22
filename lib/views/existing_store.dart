import 'package:flutter/material.dart';
import 'package:grocery_go/models/store.dart';
import 'package:grocery_go/forms/store_form.dart';

class ExistingStoreArguments {
  final Store store;
  ExistingStoreArguments(this.store);
}

class ExistingStore extends StatefulWidget {
  static const routeName = '/existingStore';
  ExistingStore({Key key});

  @override
  _ExistingStoreState createState() => _ExistingStoreState();
}

class _ExistingStoreState extends State<ExistingStore> {

  @override
  Widget build(BuildContext context) {

    final ExistingStoreArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit saved store"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: StoreForm(args: args),
        ),
      ),
    );
  }
}

