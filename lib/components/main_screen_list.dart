import 'package:flutter/material.dart';
import 'package:grocery_go/models/shopping_list.dart';

class MainScreenList extends StatelessWidget {

  final list;

  MainScreenList({Key key, @required this.list});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true, // gives it a size
        primary: false, // so the shopping and store lists don't scroll independently
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == list.length) {
            return ListTile(
                title: Text("Add new...")
            );
          } else {
            return ListTile(
              title: Text(list[index].name),
              subtitle: Text(
                  list[index] is ShoppingList ? list.length.toString() +
                      ' items' : list[index].address),
            );
          }
        }
    );
  }
}