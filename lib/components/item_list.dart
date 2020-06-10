import 'package:flutter/material.dart';
import 'package:grocery_go/views/existing_shopping_list.dart';
import 'package:grocery_go/views/existing_store.dart';
import 'package:grocery_go/views/new_item.dart';
import 'package:grocery_go/views/existing_item.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

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

  buildDateString(date) {
    return DateFormat.yMMMd().format(DateTime.parse(date));
  }

  buildCrossedOffDate(date) {
    var difference = new DateTime.now().difference(DateTime.parse(date));
    var howLongAgo = DateTime.now().subtract(difference);

    return (timeago.format(howLongAgo).toString());
  }

  buildTitleString() {
    if (listType == 'shopping list') {
      return item.name;
    } else if (listType == 'store') {
      return item.name;
    } else if (listType == 'item') {
      return item.name + (item.quantity > 1 ? ' (' + item.quantity.toString() + ')' : '');
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
        return 'Added by ' + item.addedBy + ' on ' + buildDateString(item.lastUpdated);
      } else if (listType == 'crossedOff') {
        return '' + buildCrossedOffDate(item.lastUpdated) + ' at storeName';
      } else {
        return "cannot build subtitle";
      }
  }

  handleTap(context) {
    if (listType == 'shopping list') {
      // todo: pass the list's real ID and name
      Navigator.pushNamed(context, ExistingShoppingList.routeName, arguments: ExistingShoppingListArguments('2abc', 'Test list'));
    } else if (listType == 'store') {
      Navigator.pushNamed(context, ExistingStore.routeName, arguments: ExistingStoreArguments(item));
    } else if (listType == 'item') {
      print("Crossing off item");
    } else {
      print("Error, unhandled listType in 'crossOff' method item_list.dart");
    }
  }

  gotoExistingItemManagement(context) {
    if (listType == 'shopping list') {
      print("opening page: manage existing shopping list");
    } else if (listType == 'store') {
      print("opening page: manage existing store page");
    } else if (listType == 'item') {
      Navigator.pushNamed(context, ExistingItem.routeName, arguments: ExistingItemArguments(item));
    } else {
      print("Error, unhandled listType in 'crossOff' method item_list.dart");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(buildTitleString(), style: (listType == 'crossedOff' ? TextStyle(decoration: TextDecoration.lineThrough) : TextStyle(decoration: TextDecoration.none))),
      subtitle: Text(buildSubtitleString()),
      leading: FlutterLogo(),
      trailing: IconButton(
        icon: Icon(Icons.info),
        onPressed: () => gotoExistingItemManagement(context),
      ),
      onTap: () => handleTap(context),
    );
  }
}

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