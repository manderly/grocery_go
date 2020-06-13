import 'package:flutter/material.dart';
import 'package:grocery_go/views/new_item.dart';

class AddNew extends StatelessWidget {

  final listType;
  AddNew({Key key, @required this.listType});

  goToAddNew(context) {
    if (listType == 'shopping list') {
      Navigator.pushNamed(context, '/newShoppingList');
    } else if (listType == 'store') {
      Navigator.pushNamed(context, '/newStore');
    } else if (listType == 'item') {
      Navigator.pushNamed(context, '/newItem', arguments: NewItemArguments('abc123'));
    } else {
      print('Error, unhandled listType in goToAddNew in item_list.dart');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Add new ' + listType + '...'),
      onTap: () => goToAddNew(context),
    );
  }
}

