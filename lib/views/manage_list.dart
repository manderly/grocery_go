import 'package:flutter/material.dart';
import 'package:grocery_go/components/reorderable_list.dart';

class ManageListArguments {
  final collection;
  ManageListArguments(this.collection);
}

class ManageList extends StatelessWidget {
  static const routeName = '/manageList';

  ManageList({Key key});

  @override
  Widget build(BuildContext context) {
    final ManageListArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Reorder"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ReorderableList(collection: args.collection),
        ),
      ),
    );
  }
}

