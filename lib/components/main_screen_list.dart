import 'package:flutter/material.dart';
import 'package:grocery_go/models/shopping_list.dart';

class MainScreenList extends StatelessWidget {

  final list;
  final String listType;

  MainScreenList({Key key, @required this.list, @required this.listType});

  goToNew(context, destination) {
    if (destination == 'shopping list') {
      Navigator.pushNamed(context, 'newShoppingList');
    } else if (destination == 'store') {
      Navigator.pushNamed(context, 'newStore');
    }
  }

  goToStub(destination) {
    print(destination);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true, // gives it a size
        primary: false, // so the shopping and store lists don't scroll independently
        itemCount: list.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == list.length) {
            return ListTile(
                title: Text("Add new " +  listType  + "..."),
                onTap: () => goToNew(context, listType),
            );
          } else {
            return ListTile(
              title: Text(list[index].name),
              subtitle: Text(
                  list[index] is ShoppingList ? list.length.toString() +
                      ' items' : list[index].address),
              onTap: () => goToStub("Going to: list " + list[index].name),
            );
          }
        }
    );
  }
}