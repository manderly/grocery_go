import 'package:flutter/material.dart';
import 'package:grocery_go/views/existing_shopping_list.dart';

class ItemList extends StatelessWidget {

  final list;
  final String listType;

  ItemList({Key key, @required this.list, @required this.listType});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true, // gives it a size
        primary: false, // so the shopping and store lists don't scroll independently
        itemCount: list.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == list.length) {
            if (listType == 'crossedOff') {
              return DeleteAll();
            } else {
              return AddNew(listType: listType);
            }
          } else {
            return ListItem(item: list[index], listType: listType, count: list.length);
          }
        }
    );
  }
}

class ListItem extends StatelessWidget {

  final item;
  final listType;
  final count;

  ListItem({Key key, @required this.item, this.listType, this.count});

  buildTitleString() {
    if (listType == 'shopping list') {
      return item.name;
    } else if (listType == 'store') {
      return item.name;
    } else if (listType == 'item') {
      return item.name + ' (' + item.quantity.toString() + ')';
    } else if (listType == 'crossedOff') {
      return item.name;
    } else {
      return "cannot build title";
    }
  }

  buildSubtitleString() {
      if (listType == 'shopping list') {
        return this.count.toString() + ' items';
      } else if (listType == 'store') {
        return item.address;
      } else if (listType == 'item') {
        return 'Added by ' + item.addedBy + ' on ' + item.lastUpdated;
      } else if (listType == 'crossedOff') {
        return 'N days ago at storeName';
      } else {
        return "cannot build subtitle";
      }
  }

  crossOff(context) {
    if (listType == 'shopping list') {
      // todo: pass the list's real ID and name
      Navigator.pushNamed(context, ExistingShoppingList.routeName, arguments: ExistingShoppingListArguments('2abc', 'Test list'));
    } else if (listType == 'store') {
      Navigator.pushNamed(context, 'existingStore');
    } else {
      print("Error, unhandled listType in 'crossOff' method item_list.dart");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(buildTitleString()),
      subtitle: Text(buildSubtitleString()),
      onTap: () => crossOff(context),
    );
  }
}

class AddNew extends StatelessWidget {

  final listType;
  AddNew({Key key, @required this.listType});

  goToAddNew(context) {
    if (listType == 'shopping list') {
      Navigator.pushNamed(context, 'newShoppingList');
    } else if (listType == 'store') {
      Navigator.pushNamed(context, 'newStore');
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

class DeleteAll extends StatelessWidget {

  deleteAll() {
    print("Stub: deleting all the crossed-off items");
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Delete all crossed off items'),
      onTap: () => deleteAll()
    );
  }
}