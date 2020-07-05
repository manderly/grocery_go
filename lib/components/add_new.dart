import 'package:flutter/material.dart';
import 'package:grocery_go/models/shopping_list.dart';
import 'package:grocery_go/views/new_item.dart';

class AddNew extends StatelessWidget {
  final listType;
  final listID;
  final ShoppingList parentList;

  AddNew({Key key, this.listType, this.listID, this.parentList});

  goToAddNew(context) async {
    if (listType == 'shopping list') {
      Navigator.pushNamed(context, '/newShoppingList');
    } else if (listType == 'store') {
      Navigator.pushNamed(context, '/newStore');
    } else if (listType == 'item') {
      final result = await Navigator.pushNamed(context, '/newItem', arguments: NewItemArguments(parentList.id, parentList.name));
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

